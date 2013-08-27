########################################################
## "Assessment" output in the MCMC
########################################################
# require(ggmcmc)
# require(coda)

# directoryForCodes <- "D:/__repositories__/projectR1/finalCode"
# directoryForImages <- "D:/__repositories__/projectR1/images"

file1 = paste(directoryForCodes, "/chain_1.rds", sep = "")
file2 = paste(directoryForCodes, "/chain_2.rds", sep = "")
file3 = paste(directoryForCodes, "/chain_3.rds", sep = "")
file4 = paste(directoryForCodes, "/chain_4.rds", sep = "")

# burn = 8500
# iterations = 4000

chain1.output <- readRDS(file1)
chain2.output <- readRDS(file2)
chain3.output <- readRDS(file3)
chain4.output <- readRDS(file4)

n1 <- length(chain1.output$dV)
n2 <- length(chain2.output$dV)
n3 <- length(chain3.output$dV)
n4 <- length(chain4.output$dV)

mcmc.chain1.dV <- mcmc(chain1.output$dV[burn:(burn + iterations - 1)])
mcmc.chain1.dW <- mcmc(chain1.output$dW[burn:(burn + iterations - 1),])
mcmc.chain2.dV <- mcmc(chain2.output$dV[burn:(burn + iterations - 1)])
mcmc.chain2.dW <- mcmc(chain2.output$dW[burn:(burn + iterations - 1),])
mcmc.chain3.dV <- mcmc(chain3.output$dV[burn:(burn + iterations - 1)])
mcmc.chain3.dW <- mcmc(chain3.output$dW[burn:(burn + iterations - 1),])
mcmc.chain4.dV <- mcmc(chain4.output$dV[burn:(burn + iterations - 1)])
mcmc.chain4.dW <- mcmc(chain4.output$dW[burn:(burn + iterations - 1),])

# Analysis with coda package:

# plot(chain)

gelman.plot(mcmc.list(mcmc.chain1.dV, mcmc.chain2.dV, mcmc.chain3.dV, mcmc.chain4.dV), xlab = "Iteración", ylab = "Shrink Factor", main = "V")
# Saving the plot
file = paste(directoryForImages, "/dV_GelmanRubin.pdf", sep = "")
dev.copy2pdf(file = file)

gelman.dW <- gelman.plot(mcmc.list(mcmc.chain1.dW, mcmc.chain2.dW, mcmc.chain3.dW, mcmc.chain4.dW), xlab = "Iteración", ylab = "Shrink Factor")
# Saving the plot
file = paste(directoryForImages, "/dW_GelmanRubin.pdf", sep = "")
dev.copy2pdf(file = file)

# cumuplot(mcmc.list(mcmc.chain1.dV, mcmc.chain2.dV, mcmc.chain3.dV, mcmc.chain4.dV))
# cumuplot(mcmc.list(mcmc.chain1.dW, mcmc.chain2.dW, mcmc.chain3.dW, mcmc.chain4.dW))
# effectiveSize(mcmc.list(mcmc.chain1.dV, mcmc.chain2.dV, mcmc.chain3.dV, mcmc.chain4.dV))
# effectiveSize(mcmc.list(mcmc.chain1.dW, mcmc.chain2.dW, mcmc.chain3.dW, mcmc.chain4.dW))

# Using ggmcmc package:

# Parameter dV
ggmcmc.chain1.dV <- data.frame(Iteration = 1:iterations, Parameter = rep("V", iterations), value = mcmc.chain1.dV, Chain = rep(as.integer(1), iterations))
ggmcmc.chain2.dV <- data.frame(Iteration = 1:iterations, Parameter = rep("V", iterations), value = mcmc.chain2.dV, Chain = rep(as.integer(2), iterations))
ggmcmc.chain3.dV <- data.frame(Iteration = 1:iterations, Parameter = rep("V", iterations), value = mcmc.chain3.dV, Chain = rep(as.integer(3), iterations))
ggmcmc.chain4.dV <- data.frame(Iteration = 1:iterations, Parameter = rep("V", iterations), value = mcmc.chain4.dV, Chain = rep(as.integer(4), iterations))

ggmcmc.chain.dV <- rbind(ggmcmc.chain1.dV, ggmcmc.chain2.dV, ggmcmc.chain3.dV, ggmcmc.chain4.dV)
colnames(ggmcmc.chain.dV) <- c("Iteration", "Parameter", "value", "Chain")

# attributes(ggmcmc.chain.dV)
attr(ggmcmc.chain.dV,"nChains") = 4
attr(ggmcmc.chain.dV,"nParameters") = 1
attr(ggmcmc.chain.dV,"nIterations") = iterations
attr(ggmcmc.chain.dV,"nBurnin") = 1000
attr(ggmcmc.chain.dV,"nThin") = 1
attr(ggmcmc.chain.dV,"description") = "Simulación"
attr(ggmcmc.chain.dV,"parallel") = FALSE

graf.mcmc.histogram.dV <- ggs_histogram(ggmcmc.chain.dV) + 
   my.theme +
   ggtitle("Histograma") +
   labs(x = "Valores") + 
   labs(y = "Cantidad")

graf.mcmc.running.means.dV <- ggs_running(ggmcmc.chain.dV) +
   my.theme2 +
   ggtitle("Medias Móviles del parámetro V") +
   labs(x = "Iteración") + 
   labs(y = "Media Móvil")

graf.mcmc.density.dV <- ggs_density(ggmcmc.chain.dV) + 
   my.theme +
   ggtitle("Densidad Posterior") +
   labs(x = "Valores") + 
   labs(y = "Densidad")

graf.mcmc.traceplot.dV <- ggs_traceplot(ggmcmc.chain.dV) + 
   my.theme +
   scale_linetype_manual(values = c(rep("solid", 11), rep("dashed", 1))) +
   ggtitle("Valores de la Simulación") +
   labs(x = "Iteración") + 
   labs(y = "Valores")

graf.mcmc.autocorrelation.dV <- ggs_autocorrelation(ggmcmc.chain.dV) + 
   my.theme +
   ggtitle("Autocorrelaciones") +
   labs(x = "Retraso") + 
   labs(y = "Autocorrelación")
   
# ggs_compare_partial(chain)

# Saving the plot
ggsave(graf.mcmc.density.dV, file="dV_Densities.pdf", path = directoryForImages) 
ggsave(graf.mcmc.running.means.dV, file="dV_RunningMeans.pdf", path = directoryForImages) 
ggsave(graf.mcmc.traceplot.dV, file="dV_Traceplot.pdf", path = directoryForImages) 
ggsave(graf.mcmc.autocorrelation.dV, file="dV_Autocorrelation.pdf", path = directoryForImages) 



# Parameter dW
ggmcmc.chain1.dW1 <- data.frame(Iteration = 1:iterations, Parameter = rep("W1", iterations), value = mcmc.chain1.dW[, 1], Chain = rep(as.integer(1), iterations))
ggmcmc.chain1.dW2 <- data.frame(Iteration = 1:iterations, Parameter = rep("W2", iterations), value = mcmc.chain1.dW[, 2], Chain = rep(as.integer(1), iterations))
ggmcmc.chain2.dW1 <- data.frame(Iteration = 1:iterations, Parameter = rep("W1", iterations), value = mcmc.chain2.dW[, 1], Chain = rep(as.integer(2), iterations))
ggmcmc.chain2.dW2 <- data.frame(Iteration = 1:iterations, Parameter = rep("W2", iterations), value = mcmc.chain2.dW[, 2], Chain = rep(as.integer(2), iterations))
ggmcmc.chain3.dW1 <- data.frame(Iteration = 1:iterations, Parameter = rep("W1", iterations), value = mcmc.chain3.dW[, 1], Chain = rep(as.integer(3), iterations))
ggmcmc.chain3.dW2 <- data.frame(Iteration = 1:iterations, Parameter = rep("W2", iterations), value = mcmc.chain3.dW[, 2], Chain = rep(as.integer(3), iterations))
ggmcmc.chain4.dW1 <- data.frame(Iteration = 1:iterations, Parameter = rep("W1", iterations), value = mcmc.chain4.dW[, 1], Chain = rep(as.integer(4), iterations))
ggmcmc.chain4.dW2 <- data.frame(Iteration = 1:iterations, Parameter = rep("W2", iterations), value = mcmc.chain4.dW[, 2], Chain = rep(as.integer(4), iterations))

ggmcmc.chain.dW <- rbind(ggmcmc.chain1.dW1, ggmcmc.chain1.dW2, ggmcmc.chain2.dW1, ggmcmc.chain2.dW2, ggmcmc.chain3.dW1, ggmcmc.chain3.dW2, ggmcmc.chain4.dW1, ggmcmc.chain4.dW2)
colnames(ggmcmc.chain.dW) <- c("Iteration", "Parameter", "value", "Chain")

# attributes(ggmcmc.chain.dW)
attr(ggmcmc.chain.dW,"nChains") = 4
attr(ggmcmc.chain.dW,"nParameters") = 2
attr(ggmcmc.chain.dW,"nIterations") = iterations
attr(ggmcmc.chain.dW,"nBurnin") = 1000
attr(ggmcmc.chain.dW,"nThin") = 1
attr(ggmcmc.chain.dW,"description") = "Simulación"
attr(ggmcmc.chain.dW,"parallel") = FALSE

graf.mcmc.histogram.dW <- ggs_histogram(ggmcmc.chain.dW) + 
   my.theme +
   ggtitle("Histogramas") +
   labs(x = "Valores") + 
   labs(y = "Cantidad")

graf.mcmc.running.means.dW <- ggs_running(ggmcmc.chain.dW) +
   my.theme2 +
   ggtitle("Medias Móviles del parámetro W") +
   labs(x = "Iteración") + 
   labs(y = "Media Móvil")

graf.mcmc.density.dW <- ggs_density(ggmcmc.chain.dW) + 
   my.theme +
   ggtitle("Densidades Posteriores") +
   labs(x = "Valores") + 
   labs(y = "Densidad")

graf.mcmc.traceplot.dW <- ggs_traceplot(ggmcmc.chain.dW) + 
   my.theme +
   ggtitle("Valores de la Simulación") +
   labs(x = "Iteración") + 
   labs(y = "Valor")

graf.mcmc.autocorrelation.dW <- ggs_autocorrelation(ggmcmc.chain.dW) + 
   my.theme +
   ggtitle("Recorrido de alfa y beta (Filtering)") +
   labs(x = "Autocorrelación") + 
   labs(y = "Retraso")

# ggs_compare_partial(chain)
# scale_colour_brewer(palette="Set1")

# Saving the plot
ggsave(graf.mcmc.density.dW, file="dW_Densities.pdf", path = directoryForImages) 
ggsave(graf.mcmc.running.means.dW, file="dW_RunningMeans.pdf", path = directoryForImages) 
ggsave(graf.mcmc.traceplot.dW, file="dW_Traceplot.pdf", path = directoryForImages) 
ggsave(graf.mcmc.autocorrelation.dW, file="dW_Autocorrelation.pdf", path = directoryForImages) 

# closing device
dev.off()



