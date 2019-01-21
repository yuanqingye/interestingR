# A factor's special occasion
iris_copy = iris
iris_copy$Species <- ifelse(iris_copy$Species == "versicolor","versi",iris_copy$Species)

iris_copy = iris
#this keep the strings, but the factor attributes has been removed
iris_copy$Species <- ifelse(iris_copy$Species == "versicolor","versi",as.character(iris_copy$Species))


# B keep data type
# when we refer to a dataframe using the matrix notation, the output is simplified to the lowest possible dimensionality. 
mean_func <- function(df,var_list) {
  # Extract out the selected columns as per the supplied vector of indices
  df_selected <- df[,var_list]
  # df_selected <- df[,var_list, drop=F] if we want NOT to reduce dimension, using drop = F
  # df_selected <- df[var_list]
  #Loop thru each column in the dataset 
  sapply(df_selected,mean)
}

mean_func(iris,c(1:2))
mean_func(iris,1)
str(iris[,c(1,2)])
str(iris[,1])
str(iris[1])
# 
# WAY TO SOLVE :
# 1.USING DROP = F FOR DATA FRAME
# 2.USING LIST MODE OF DATA FRAME DF[1](SINCE DATA FRAME IS ACTUALLY A LIST)

# C OOP
predict(glm_model, newdata = test_df, type="response")
#would fail if model is a rpart tree, unless you specify the type to 'prob'

# S4 Versus S3 (package ROCR)
#' Fortunately, there isn’t a whole lot that you need to know about S4 objects for most of your tasks. 
#' Be aware of these minimal facts (1) Similar to the names function that you use to investigate the 
#' components of a S3 object (if they are named), in S4 you will use slotNames (2) To extract out specific 
#' components from an object rather than using the $ operator like we do for S3, you would need to use the 
#' @ operator.