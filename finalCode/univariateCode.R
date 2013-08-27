###############################
# UNIVARIATE CASE:
###############################
# Cleaning data
source(paste(directoryForCodes, "/cleaningData.r", sep = ""), chdir = T)

###############################
# Compute excess returns
equity.exc.retornos.diarios <- equity.retornos.diarios.prediction - riskfree.retornos.diarios.prediction
market.exc.retornos.diarios <- market.retornos.diarios.prediction - riskfree.retornos.diarios.prediction

###############################
# Period of analysis
dates <- index(riskfree.retornos.diarios)
dates.prediction <- index(riskfree.retornos.diarios.prediction)

###############################
# Preliminary Plots: CML, SML, and Normalizing Plots
source(paste(directoryForCodes, "/plottingPreliminary.r", sep = ""), chdir = T)

##############################################################
# Anlysis: 
##############################################################
# Static CAPM
##############################################################
outLM <- lm(equity.exc.retornos.diarios ~ market.exc.retornos.diarios)
# summary(outLM)
# Saving the output
# file = paste(directoryForCodes, "/lmOut.rds", sep = "")
# saveRDS(outLM, file = file)

###############################
# Plot of the regression line
source(paste(directoryForCodes, "/plottingRegressionLine.r", sep = ""), chdir = T) 

##############################################################
# Dynamic CAPM
##############################################################
# With MLE:
##############################################################
if (type.est == "mle") {
# Estimating the variances of the model
# Function that we use for the MLE
buildCapm <- function(u){
  dlmModReg(market.exc.retornos.diarios, dV = exp(u[1]), dW = exp(u[2 : 3]))
}
# Estimators (MLE)
Est.MLE <- dlmMLE(equity.exc.retornos.diarios, parm = rep(0, 3), buildCapm)
# Est.MLE$conv # A weak form of check convergence
# unlist(buildCapm(Est.MLE$par)[c("V", "W")])
# buildCapm(Est.MLE$par)

#############
# Implementing the model
mod.mle <- buildCapm(Est.MLE$par)
coef.Filt <- dlmFilter(equity.exc.retornos.diarios, mod.mle)
coef.Smooth <- dlmSmooth(equity.exc.retornos.diarios, mod.mle)
detach()

# Tag for the file
tag = "Mle"
# Importing plots of smoothing
source(paste(directoryForCodes, "/plottingSmoothing.r", sep = ""), chdir = T)

# Importing plots of filtering
source(paste(directoryForCodes, "/plottingFiltering.r", sep = ""), chdir = T)

# Importing plots of forecasting(?)
source(paste(directoryForCodes, "/plottingForecasting.r", sep = ""), chdir = T)

# Assumptions: Rolling Beta, ...
source(paste(directoryForCodes, "/assumptions.r", sep = ""), chdir = T) 

##############################################################
# With MCMC:
##############################################################
} else {
###############################
# With Bayesian inference:
# d-Inverse-Gamma: With a.y = 4405, b.y = 10, a.theta = c(1.393e+10, 186.8), b.theta = 10,
# to express a large uncertainty in the prior estimate of the prexisions (?)
###############################

burn <- 8500
iterations <- 4000
MCMC <- burn + iterations

# Simulation MCMC: Example of 1 chain
# gibbsOut <- dlmGibbsDIG(equity.exc.retornos.diarios[1:end.date.index], mod = dlmModReg(market.exc.retornos.diarios[1:end.date.index], m0 = c(0, outLM$coef[2]), C0 = diag(c(1e+07, 1))), a.y = 4405, b.y = 10, a.theta = c(1.393e+10, 186.8), b.theta = 10, n.sample = MCMC, thin = 5, save.states = FALSE)
# Saving the output
# file = paste(directoryForCodes, "/gibbsOut.rds", sep = "")
# saveRDS(gibbsOut.1, file = file)
# Loading the output
# gibbsOut <- readRDS(file)
# mcmcMean(gibbsOut$dV[-(1 : burn)])
# mcmcMean(gibbsOut$dW[-(1 : burn), ])
# Output: v = 3.34e-04 (2.34e-07), w1 = 7.18e-11 (1.69e-22), w2 = 5.35e-03 (9.42e-07)

# Override functions of ggmcmc
source(paste(directoryForCodes, "/ggmcmcOverrideFunctions.r", sep = ""), chdir = T)

# Evaluation of outputs
source(paste(directoryForCodes, "/analysisMCMC.r", sep = ""), chdir = T)

#############
# Implementing the model
# Bayesian inference:
est.bayes.V <- 3.34e-04
est.bayes.W <- c(7.18e-11, 5.35e-03)
mod.bayes <- dlmModReg(market.exc.retornos.diarios, dV = est.bayes.V, dW = est.bayes.W)
coef.Filt <- dlmFilter(equity.exc.retornos.diarios, mod.bayes)
coef.Smooth <- dlmSmooth(equity.exc.retornos.diarios, mod.bayes)
detach()

# Tag for the file
tag = "Bayes"
# Importing plots of smoothing
source(paste(directoryForCodes, "/plottingSmoothing.r", sep = ""), chdir = T)

# Importing plots of filtering
source(paste(directoryForCodes, "/plottingFiltering.r", sep = ""), chdir = T)

# Importing plots of forecasting(?)
source(paste(directoryForCodes, "/plottingForecasting.r", sep = ""), chdir = T)

}

