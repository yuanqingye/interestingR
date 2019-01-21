if (!require("pacman")) 
  install.packages("https://cran.r-project.org/src/contrib/Archive/pacman/pacman_0.4.6.tar.gz",repo = NULL,type = "source") 
#https://cran.r-project.org/src/contrib/Archive/pacman/pacman_0.4.6.tar.gz
# install.packages("https://cran.r-project.org/src/contrib/Archive/neuropsychology/neuropsychology_0.3.0.tar.gz",repo = NULL,type = "source")
# pacman::p_load(jpeg, png, ggplot2, grid, neuropsychology)
pacman::p_load(jpeg, png, ggplot2, grid)

mydata <- data.frame(price = tapply(diamonds$price, diamonds$cut, max))
mydata$cut <- rownames(mydata)
# imgage <- jpeg::readJPEG("images/blackboard.jpg")
image = png::readPNG("images/blackboard.png")

ggplot(mydata, aes(cut, price, fill = -price)) +
  ggtitle("Bar chart with background image") +
  scale_fill_continuous(guide = FALSE) +
  annotation_custom(rasterGrob(image, 
                               width = unit(1,"npc"), 
                               height = unit(1,"npc")), 
                    -Inf, Inf, -Inf, Inf) +
  geom_bar(stat="identity", position = "dodge", width = .75, colour = 'white') +
  scale_y_continuous('Price in $', limits = c(0, max(mydata$price) + max(mydata$price) / 4)) +
  scale_x_discrete('Cut') +
  geom_text(aes(label = round(price), ymax = 0), size = 7, fontface = 2, 
            colour = 'white', hjust = 0.5, vjust = -1)

ggplot(mydata, aes(cut, price, fill = -price)) +
  theme_neuropsychology() +
  ggtitle("Bar chart with background image") +
  scale_fill_continuous(guide = FALSE) +
  annotation_custom(rasterGrob(image, 
                               width = unit(1,"npc"), 
                               height = unit(1,"npc")), 
                    -Inf, Inf, -Inf, Inf) +
  geom_bar(stat="identity", position = "dodge", width = .75, colour = 'white', alpha = 0.5) +
  scale_y_continuous('Price in $', limits = c(0, max(mydata$price) + max(mydata$price) / 4)) +
  scale_x_discrete('Cut') +
  geom_text(aes(label = round(price), ymax = 0), size = 7, fontface = 2, 
            colour = 'white', hjust = 0.5, vjust = -1)
