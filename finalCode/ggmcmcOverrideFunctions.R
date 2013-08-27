########################################################
## Overriding functions
########################################################
# where is it defined?
# getAnywhere("function")
# in package and in namespace
#############
# ggs_running:
#############
my.ggs_running <- function (D, family = NA, original.burnin = TRUE, original.thin = TRUE) 
{
    if (!is.na(family)) {
        D <- get_family(D, family = family)
    }
    dm.m <- ddply(D, .(Parameter, Chain), summarize, m = mean(value), 
        .parallel = attributes(D)$parallel)
    D.sorted <- D[order(D$Parameter, D$Iteration), ]
    dm.rm <- ddply(D.sorted, .(Parameter, Chain), transform, 
        rm = cumsum(value)/Iteration, .parallel = attributes(D)$parallel)
    f <- ggplot(dm.rm, aes(x = Iteration, y = rm, colour = as.factor(Chain))) + 
        geom_line() + geom_hline(aes(yintercept = m), dm.m, colour = "black", 
        alpha = 0.5) + ylab("Running Mean")
    if (attributes(D)$nChains <= 1) {
        f <- f + facet_wrap(~Parameter, ncol = 1, scales = "free")
    }
    else {
        f <- f + facet_grid(Parameter ~ Chain, scales = "free")
    }
    f <- f + scale_colour_discrete(name = "Cadena")
    t_format <- function(x) {
        return(((x - 1) * attributes(D)$nThin) + attributes(D)$nThin)
    }
    b_format <- function(x) {
        return(x + attributes(D)$nBurnin)
    }
    bt_format <- function(x) {
        return(attributes(D)$nBurnin + (((x - 1) * attributes(D)$nThin) + 
            attributes(D)$nThin))
    }
    if (original.burnin & !original.thin) {
        f <- f + scale_x_continuous(labels = b_format)
    }
    else if (!original.burnin & original.thin) {
        f <- f + scale_x_continuous(labels = t_format)
    }
    else if (original.burnin & original.thin) {
        f <- f + scale_x_continuous(labels = bt_format)
    }
    else {
        f <- f
    }
    return(f)
}

unlockBinding("ggs_running", as.environment("package:ggmcmc"))
assign("ggs_running", my.ggs_running, "package:ggmcmc")

unlockBinding("ggs_running", getNamespace("ggmcmc"))
assign("ggs_running", my.ggs_running, getNamespace("ggmcmc"))

#############
# ggs_density:
#############

my.ggs_density <- function (D, family = NA) 
{
    if (!is.na(family)) {
        D <- get_family(D, family = family)
    }
    if (attributes(D)$nChains <= 1) {
        f <- ggplot(D, aes(x = value))
    }
    else {
        f <- ggplot(D, aes(x = value, colour = as.factor(Chain), 
            fill = as.factor(Chain)))
    }
    f <- f + geom_density(alpha = 0.3) + facet_wrap(~Parameter, 
        ncol = 1, scales = "free") + geom_rug(alpha = 0.1) + 
        scale_fill_discrete(name = "Cadena") + scale_colour_discrete(name = "Cadena")
    return(f)
}

unlockBinding("ggs_density", as.environment("package:ggmcmc"))
assign("ggs_density", my.ggs_density, "package:ggmcmc")

unlockBinding("ggs_density", getNamespace("ggmcmc"))
assign("ggs_density", my.ggs_density, getNamespace("ggmcmc"))

#############
# ggs_traceplot:
#############

my.ggs_traceplot <- function (D, family = NA, original.burnin = TRUE, original.thin = TRUE) 
{
    if (!is.na(family)) {
        D <- get_family(D, family = family)
    }
    if (attributes(D)$nChains <= 1) {
        f <- ggplot(D, aes(x = Iteration, y = value))
    }
    else {
        f <- ggplot(D, aes(x = Iteration, y = value, colour = as.factor(Chain)))
    }
    f <- f + geom_line(alpha = 0.7) + facet_wrap(~Parameter, 
        ncol = 1, scales = "free") + scale_colour_discrete(name = "Cadena")
    t_format <- function(x) {
        return(((x - 1) * attributes(D)$nThin) + attributes(D)$nThin)
    }
    b_format <- function(x) {
        return(x + attributes(D)$nBurnin)
    }
    bt_format <- function(x) {
        return(attributes(D)$nBurnin + (((x - 1) * attributes(D)$nThin) + 
            attributes(D)$nThin))
    }
    if (original.burnin & !original.thin) {
        f <- f + scale_x_continuous(labels = b_format)
    }
    else if (!original.burnin & original.thin) {
        f <- f + scale_x_continuous(labels = t_format)
    }
    else if (original.burnin & original.thin) {
        f <- f + scale_x_continuous(labels = bt_format)
    }
    else {
        f <- f
    }
    return(f)
}

unlockBinding("ggs_traceplot", as.environment("package:ggmcmc"))
assign("ggs_traceplot", my.ggs_traceplot, "package:ggmcmc")

unlockBinding("ggs_traceplot", getNamespace("ggmcmc"))
assign("ggs_traceplot", my.ggs_traceplot, getNamespace("ggmcmc"))

#############
# ggs_autocorrelation:
#############

my.ggs_autocorrelation <- function (D, family = NA, nLags = 50) 
{
    if (!is.na(family)) {
        D <- get_family(D, family = family)
    }
    D.lags <- cbind(D, nLags = nLags)
    wc.ac <- ddply(D.lags, c("Parameter", "Chain"), summarise, 
        Autocorrelation = ac(value, nLags), Lag = 1:nLags, .parallel = attributes(D)$parallel)
    if (attributes(D)$nChains <= 1) {
        f <- ggplot(wc.ac, aes(x = Lag, y = Autocorrelation)) + 
            geom_bar(stat = "identity", position = "identity") + 
            facet_wrap(~Parameter) + ylim(-1, 1)
    }
    else {
        f <- ggplot(wc.ac, aes(x = Lag, y = Autocorrelation, 
            colour = as.factor(Chain), fill = as.factor(Chain))) + 
            geom_bar(stat = "identity", position = "identity") + 
            facet_grid(Parameter ~ Chain) + ylim(-1, 1) + scale_fill_discrete(name = "Cadena") + 
            scale_colour_discrete(name = "Cadena")
    }
    return(f)
}

unlockBinding("ggs_autocorrelation", as.environment("package:ggmcmc"))
assign("ggs_autocorrelation", my.ggs_autocorrelation, "package:ggmcmc")

unlockBinding("ggs_autocorrelation", getNamespace("ggmcmc"))
assign("ggs_autocorrelation", my.ggs_autocorrelation, getNamespace("ggmcmc"))



