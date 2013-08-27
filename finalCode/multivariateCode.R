###############################
# MULTIVARIATE CASE:
###############################

# Install (using install.packages(...,repos=NULL))
# If the package has no binary component (i.e. no src directory with C, C++, 
# or Fortran code that needs to be compiled during installation then simply 
# specifying type = "source" within the install.packages call (whether from a 
# repository or a local copy of the source tarball (.tar.gz file)) will 
# install the source package, even on Windows.

# install.packages("KFAS_0.6.1.tar.gz", type="source")
library(KFAS)
### Dynamic CAPM - SUTSE
m <- ncol(equities.exc.retornos.diarios)
k <- m * (m + 1) / 2

# 'k' is the number of independent parameters in an m-by-m covariance
# matrix, and two such matrices are estimated (Vt and Wt, both time
# invariant). Hence the unknown parameter theta has length 2k. 

# In the package KFAS ver. 0.6.1, the state space model is given by:
# y_t = Z_t * alpha_t + eps_t (observation equation)
# alpha_t+1 = T_t * alpha_t + R_t * eta_t(transition equation)
# where eps_t ~ N(0,H_t) and eta_t ~ N(0,Q_t). Note that error terms eps_t
# and eta_t are assumed to be uncorrelated. 

Ft <- sapply(seq_along(market.exc.retornos.diarios), function(i) market.exc.retornos.diarios[i] %x% diag(m)) # More specifically: Ft %x% Im
dim(Ft) <- c(m, m, length(market.exc.retornos.diarios))
Im <- diag(nr = m)

logLik <- function(theta) {
  aux <- diag(exp(0.5 * theta[1:m]), nr = m)
  aux[upper.tri(aux)] <- theta[(m + 1):k]
  Vt <- crossprod(aux)
  aux <- diag(exp(0.5 * theta[1:m + k]), nr = m)
  aux[upper.tri(aux)] <- theta[-(1:(k + m))]
  Wt <- crossprod(aux)
  lik <- kf(yt = t(equities.exc.retornos.diarios), Zt = Ft, Tt = diag(nr = m), Rt = Im, Ht = Vt,
    Qt = Wt, a1 = rep(0, m), P1 = matrix(0, m, m),
    P1inf = diag(rep(1, m)), optcal = c(FALSE, FALSE, FALSE, FALSE))
  return(-lik$lik)
}
fit <- optim(par = rep(0, 2 * k), fn = logLik, method = "BFGS", control = list(maxit = 500))
# fit$conv # A weak form of check convergence

# Estimators:
theta <- fit$par
aux <- diag(exp(0.5 * theta[1:m]), nr = m)
aux[upper.tri(aux)] <- theta[(m+1):k]
Vt <- crossprod(aux)
aux <- diag(exp(0.5 * theta[1:m + k]), nr = m)
aux[upper.tri(aux)] <- theta[-(1:(k + m))]
Wt <- crossprod(aux)

# Set up the model
CAPM <- dlmModReg(market.exc.retornos.diarios)
CAPM$FF <- CAPM$FF %x% diag(m)
CAPM$GG <- CAPM$GG %x% diag(m)
CAPM$JFF <- CAPM$JFF %x% diag(m)
CAPM$W <- CAPM$W %x% matrix(0, m, m)
CAPM$W[-(1 : m), -(1 : m)] <- Wt
CAPM$V <- CAPM$V %x% matrix(0, m, m)
CAPM$V[] <- Vt
CAPM$m0 <- rep(0, 2 * m)
CAPM$C0 <- diag(1e7, nr = 2 * m)

#############
# Implementing the model
CAPMsmooth <- dlmSmooth(equities.exc.retornos.diarios, CAPM)
CAPMfiltering <- dlmFilter(equities.exc.retornos.diarios, CAPM)

# Importing plots of smoothing and filtering betas
source(paste(directoryForCodes, "/plottingMultBetas.r", sep = ""), chdir = T)



