###################################################################################################
#  
#  Raw Modelos Dinámicos Lineales
#  
#  autor: Alexandro Mayoral <bluepills89@gmail.com>
#  creado: Febrero 25, 2013
#  ultima modificación: Agosto 27, 2013
#
###################################################################################################

###############################
# Cleaning the workspace
rm(list=ls())

###############################
# Helper Function: source_https
source_https <- function(url, ...) {
  # load package
  require(RCurl)
  
  # parse and evaluate each .R script
  sapply(c(url, ...), function(u) {
    eval(parse(text = getURL(u, followlocation = TRUE, cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))), envir = .GlobalEnv)
  })
}

# Alternative if you wanna load a .R script from github
# source_https("https://raw.github.com/bluepill5/projectR1/master/finalCode/myFunctions.R")

###############################
# Setting directory
directoryForImages <- "D:/__repositories__/projectR1/images"
directoryForCodes <- "D:/__repositories__/projectR1/finalCode"

###############################
# Import the functions, settings needed in the code and packages
source(paste(directoryForCodes, "/myFunctions.r", sep = ""), chdir = T)
# Load the needed libraries, if not are installed, install it and load it
install(c("PerformanceAnalytics", "quantmod", "dlm", "tseries", "grid", "reshape2", "scales", "ggmcmc", "coda"))

###############################
# Selecting the period of analysis and the horizont of time for the 
# forecasting, and the type of method for the estimators ("mle" or "mcmc")
type.est = "mle"
start.date = "2012-01-01"
end.date = "2012-12-31"
horizont = "2013-03-31"

###############################
# Query of the data that we wanna use
# Conditions: 
# - We need to pass at least two symbols
# - The first symbol will be considered like the market index
# symbols.equities <- c('^GSPC','AAPL', 'MSFT', 'YHOO')
symbols.equities <- c('^GSPC','AAPL')
source(paste(directoryForCodes, "/extractingData.r", sep = ""), chdir = T)

# Execute the univariate or multivariate case
if (length(symbols.equities) == 2) { 
  source(paste(directoryForCodes, "/univariateCode.r", sep = ""), chdir = T) 
} else {
  source(paste(directoryForCodes, "/multivariateCode.r", sep = ""), chdir = T) 
}

###############################
# Alternative: cleaning the workspace
# rm(list=ls())

