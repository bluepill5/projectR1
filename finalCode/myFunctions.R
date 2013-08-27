######
#  
#  myFunctions
#  
#  autor: Alexandro Mayoral <bluepills89@gmail.com>
#  creado: Abril 30, 2013
#  ultima modificación: Abril 30, 2013
#
#############
# A bunch of settings:
#############
# Format of the digits.
# options(digits=4, width=70, showWarnCalls = FALSE, showErrorCalls = FALSE, show.error.messages = FALSE)
options(digits = 4, width = 70, showWarnCalls = FALSE, showErrorCalls = FALSE, show.error.messages = TRUE)
options("getSymbols.warning4.0" = FALSE)

# Format of the plots.
require("ggplot2")
my.theme <- theme_grey(base_family = "mono") + # Font of the tittle
            theme(text = element_text(face = "bold", size = 11, colour = "Black")) + # Font of the axes
            theme(legend.position = "bottom", legend.background = element_rect(colour = "black"))# Position of the legend 

my.theme2 <- theme_grey(base_family = "mono") + # Font of the tittle
             theme(text = element_text(face = "bold", size = 11, colour = "Black")) + # Font of the axes
             theme(legend.position = "bottom", legend.background = element_rect(colour = "black")) + # Position of the legend 
             theme(axis.text.x = element_text(angle = 90, hjust = 0.5, vjust = 0.5, face = "plain"))

#############
# A bunch of functions:
#############
# Function that check if a package is already installed
is.installed <- function(package){
    is.element(package, installed.packages()[,1])}

# Function that check if a package is already installed
# if not install it.
install <- function(packages){
    for (package in packages){
        if (is.installed(package)){
            require(package, character.only = TRUE)}
        else{
            install.packages(c(package), type = TRUE)
            require(package, character.only = TRUE)}
    }
}

# Function that extract the principal diagonal of a matrix
extractDiag <- function(matrix){
    # Precond: The matrix is square.
    n <- sqrt(length(matrix))
    vect <- vector(length = n)
    for (i in 1:n){
       vect[i] = matrix[i, i]}
    vect  
}































