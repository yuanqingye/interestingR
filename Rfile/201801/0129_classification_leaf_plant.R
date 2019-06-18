suppressPackageStartupMessages(library(caret))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(corrplot))
suppressPackageStartupMessages(library(Hmisc))

url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00241/100%20leaves%20plant%20species.zip"
temp_file <- tempfile()
download.file(url, temp_file)


margin_file <- "100 leaves plant species/data_Mar_64.txt"
shape_file <- "100 leaves plant species/data_Sha_64.txt"
texture_file <- "100 leaves plant species/data_Tex_64.txt"
files_to_unzip <- c(margin_file, shape_file, texture_file)
unzip(temp_file, files = files_to_unzip, exdir=".", overwrite = TRUE)

margin_data <- read.csv(margin_file, header=FALSE, sep=",", stringsAsFactors = TRUE)
shape_data <- read.csv(shape_file, header=FALSE, sep=",", stringsAsFactors = TRUE)
texture_data <- read.csv(texture_file, header=FALSE, sep=",", stringsAsFactors = TRUE)

sum(complete.cases(margin_data)) == nrow(margin_data)
sum(complete.cases(shape_data)) == nrow(shape_data)
sum(complete.cases(texture_data)) == nrow(texture_data)

n_features <- ncol(margin_data) - 1
colnames(margin_data) <- c("species", paste("margin", as.character(1:n_features), sep=""))
margin_data$species <- factor(margin_data$species)

n_features <- ncol(shape_data) - 1
colnames(shape_data) <- c("species", paste("shape", as.character(1:n_features), sep=""))
shape_data$species <- factor(shape_data$species)

n_features <- ncol(texture_data) - 1
colnames(texture_data) <- c("species", paste("texture", as.character(1:n_features), sep=""))
texture_data$species <- factor(texture_data$species)

margin_count <- sapply(base::split(margin_data, margin_data$species), nrow)
shape_count <- sapply(base::split(shape_data, shape_data$species), nrow)
texture_count <- sapply(base::split(texture_data, texture_data$species), nrow)

which(margin_count != texture_count)
which(shape_count != texture_count)

margin_data <- mutate(margin_data, id = 1:nrow(margin_data))
shape_data <- mutate(shape_data, id = 1:nrow(shape_data))
texture_data <- mutate(texture_data, id = 1:nrow(texture_data))

dd <- data.frame(matrix(nrow=1, ncol = 66))
colnames(dd) <- colnames(texture_data)
dd$species <- "Acer Campestre"
dd$id <- 16

temp_texture_data <- rbind(texture_data[1:15,], dd)
features <- setdiff(colnames(temp_texture_data), c("species", "id"))
imputed <- sapply(features, function(x) { as.numeric(impute(temp_texture_data[, x], median)[16])})
temp_texture_data[16, names(imputed)] <- imputed

texture_data <- rbind(temp_texture_data, texture_data[-(1:15),])
texture_data <- mutate(texture_data, id = 1:nrow(texture_data))
dim(texture_data)

m_l <- split(margin_data, margin_data$species)

extract_feature <- function(m_l, feature) {
  f <- lapply(m_l, function(x) { x[,feature] })
  do.call(cbind, f)
}

thefeature <- "margin1"
m <- extract_feature(m_l, thefeature)
cor_mat <- cor(m)
corrplot(cor_mat, method = "circle", type="upper", tl.cex=0.3)

flattenCorrMatrix <- function(cormat, pmat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut],
    p = pmat[ut]
  )
}
# debug(flattenCorrMatrix)
# undebug(flattenCorrMatrix)

most_correlated <- function(dataset, feature, threshold) {
  m_l <- split(dataset, dataset$species)
  m <- extract_feature(m_l, feature)
  rcorr_m <- rcorr(m)
  flat_cor <- flattenCorrMatrix(rcorr_m$r, rcorr_m$P)
  attr(flat_cor, "variable") <- feature
  flat_cor <- flat_cor %>% filter(p < 0.05) %>% filter(abs(cor) > threshold)
  flat_cor[,-4] # getting rid of the p-value column
}

# debug(most_correlated)
# undebug(most_correlated)
corr_margin2 <- most_correlated(margin_data, "margin2", 0.7)

margin_names <- setdiff(colnames(margin_data), c("species", "id"))
margin_corr_l <- lapply(margin_names, function(x) {most_correlated(margin_data, x, 0.7)})
names(margin_corr_l) <- margin_names

shape_names <- setdiff(colnames(shape_data), c("species", "id"))
shape_corr_l <- lapply(shape_names, function(x) {most_correlated(shape_data, x, 0.7)})
names(shape_corr_l) <- shape_names

texture_names <- setdiff(colnames(texture_data), c("species", "id"))
texture_corr_l <- lapply(texture_names, function(x) {most_correlated(texture_data, x, 0.7)})
names(texture_corr_l) <- texture_names

t <- sapply(margin_corr_l, nrow)
margin_c <- data.frame(feature = names(t), value = t)

t <- sapply(shape_corr_l, nrow)
shape_c <- data.frame(feature = names(t), value = t)

t <- sapply(texture_corr_l, nrow)
texture_c <- data.frame(feature = names(t), value = t)

ggplot(data = margin_c, aes(x=feature, y=value, fill = feature)) + theme_bw() + theme(legend.position = "none") + geom_histogram(stat='identity') + coord_flip()
ggplot(data = shape_c, aes(x=feature, y=value, fill = feature)) + theme_bw() + theme(legend.position = "none") + geom_histogram(stat='identity') + coord_flip()
ggplot(data = texture_c, aes(x=feature, y=value, fill = feature)) + theme_bw() + theme(legend.position = "none") + geom_histogram(stat='identity') + coord_flip()

species_boxplot <- function(dataset, variable) {
  p <- ggplot(data = dataset, aes(x = species, y = eval(parse(text=variable)), fill= species)) + theme_bw() + theme(legend.position = "none") + geom_boxplot() + ylab(parse(text=variable))
  p <- p + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + ggtitle(paste(variable, "among species", sep = " "))
  p
}

species_boxplot(margin_data, "margin1")

with(margin_data, tapply(margin1, species, summary))

