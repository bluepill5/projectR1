###############################
# Calculate teh variances of beta and alpha (filtering)
attach(coef.Filt)
vars.filt = dropFirst(lapply(dlmSvd2var(U.C, D.C), extractDiag)[0:end.date.index + 1]) 
sd.alpha.filt = vector(length = length(vars.filt))
sd.beta.filt = vector(length = length(vars.filt))
# Extract the standard deviations of vars.filt.
for(i in 1:length(vars.filt)){
   sd.alpha.filt[i] = sqrt(vars.filt[[i]][1])
   sd.beta.filt[i] = sqrt(vars.filt[[i]][2])}
detach(coef.Filt)

#############
# Plot of the estimators of the DLM with MLE
beta.est.filt <- merge(dropFirst(coef.Filt$m[, 2][0:end.date.index + 1]), rep("beta", length(coef.Filt$m[, 2][0:end.date.index + 1])))
alpha.est.filt <- merge(dropFirst(coef.Filt$m[, 1][0:end.date.index + 1]), rep("alfa", length(coef.Filt$m[, 1][0:end.date.index + 1])))
beta.alpha.est.filt <- rbind(alpha.est.filt, beta.est.filt)
beta.alpha.est.filt <- cbind(beta.alpha.est.filt, c(dates, dates))
colnames(beta.alpha.est.filt) = c("values", "estimator", "date")

alpha.est.filt[length(alpha.est.filt[, 1]), 1]
beta.est.filt[length(beta.est.filt[, 1]), 1]

graf.beta.alpha.est.filt <- ggplot(beta.alpha.est.filt, aes(x = date, y = values)) +
   geom_line(size = 0.89) +
   facet_grid(estimator~., scales="free_y") +
   my.theme +
   ggtitle("Recorrido de alfa y beta (Filtración)") +
   labs(x = "Fecha") + 
   labs(y = "Valores")

# Saving the plot
file = paste("3a_alphaBeta", tag, "Filt.pdf", sep = "")
ggsave(graf.beta.alpha.est.filt, file = file, path = directoryForImages) 

#############
# Plot of beta with limits of probability of the 95%
beta.filt <- as.zoo(dropFirst(coef.Filt$m[, 2][0:end.date.index + 1]))
index(beta.filt) <- index(riskfree.retornos.diarios)
upper.beta.filt <- beta.filt + (qnorm(0.975) * sd.beta.filt)
lower.beta.filt <- beta.filt - (qnorm(0.975) * sd.beta.filt)

beta.filt <- merge(beta.filt, upper.beta.filt, lower.beta.filt)
graf.beta.mle.filt <- ggplot(beta.filt[-1,], aes(x = dates[2:length(dates)], y = beta.filt, colour = "Beta")) +
   geom_line(size = 0.89) +
   geom_line(aes(y = upper.beta.filt, colour = "intervalos de confianza del 95%"), size = 0.89, lty = "longdash") +
   geom_line(aes(y = lower.beta.filt, colour = "intervalos de confianza del 95%"), size = 0.89, lty = "longdash") +
   my.theme +
   scale_colour_manual("", values = c("gray18", "gray70")) +  
   ggtitle("Recorrido de beta (Filtración)") +
   labs(x = "Fecha") + 
   labs(y = "Valores")

# Saving the plot
file = paste("4a_beta", tag, "Filt.pdf", sep = "")
ggsave(graf.beta.mle.filt, file = file, path = directoryForImages) 

#############
# Plot of alpha with limits of probability of the 95%
alpha.filt <- as.zoo(dropFirst(coef.Filt$m[, 1][0:end.date.index + 1]))
index(alpha.filt) <- index(riskfree.retornos.diarios)
upper.alpha.filt <- alpha.filt + (qnorm(0.975) * sd.alpha.filt)
lower.alpha.filt <- alpha.filt - (qnorm(0.975) * sd.alpha.filt)

alpha.filt <- merge(alpha.filt, upper.alpha.filt, lower.alpha.filt)
graf.alfa.mle.filt <- ggplot(alpha.filt[-1,], aes(x = dates[2:length(dates)], y = alpha.filt, colour = "Alfa")) +
   geom_line(size = 0.89) +
   geom_line(aes(y = upper.alpha.filt, colour = "intervalos de confianza del 95%"), size = 0.89, lty = "longdash") +
   geom_line(aes(y = lower.alpha.filt, colour = "intervalos de confianza del 95%"), size = 0.89, lty = "longdash") +
   my.theme +
   scale_colour_manual("", values = c("gray18", "gray70")) +  
   ggtitle("Recorrido de alfa (Filtración)") +
   labs(x = "Fecha") + 
   labs(y = "Valores")

# Saving the plot
file = paste("4a_alfa", tag, "Filt.pdf", sep = "")
ggsave(graf.alfa.mle.filt, file = file, path = directoryForImages) 

#############
# Plot of the returns with the DLM with MLE
# r_i = r_f + (r_m - r_f) * beta_i
returns.equity.mle.filt = dropFirst(coef.Filt$m[, 1][0:end.date.index + 1]) + riskfree.retornos.diarios + ((market.retornos.diarios - riskfree.retornos.diarios) * dropFirst(coef.Filt$m[, 2][0:end.date.index + 1]))
#colnames(returns.equity.mle.filt) = "equity.f"

returns.equity.mle.upper.filt = (dropFirst(coef.Filt$m[, 1][0:end.date.index + 1]) + qnorm(0.25) * sd.alpha.filt) + riskfree.retornos.diarios + ((market.retornos.diarios - riskfree.retornos.diarios) * (dropFirst(coef.Filt$m[, 2][0:end.date.index + 1]) + qnorm(0.25) * sd.beta.filt))
#colnames(returns.equity.mle.upper.filt) = "upper"
returns.equity.mle.lower.filt = (dropFirst(coef.Filt$m[, 1][0:end.date.index + 1]) - qnorm(0.25) * sd.alpha.filt) + riskfree.retornos.diarios + ((market.retornos.diarios - riskfree.retornos.diarios) * (dropFirst(coef.Filt$m[, 2][0:end.date.index + 1]) - qnorm(0.25) * sd.beta.filt))
#colnames(returns.equity.mle.lower.filt) = "lower"
returns.filt.all <- merge(equity.retornos.diarios, returns.equity.mle.filt, returns.equity.mle.upper.filt, returns.equity.mle.lower.filt)
colnames(returns.filt.all) = c("equity", "equity.f", "upper", "lower")

graf.rets.dlm.mle.filt <- ggplot(returns.filt.all[-1,], aes(x = dates[2:length(dates)], y = equity, colour = "Datos")) +
   geom_line(size = 0.055) +
   geom_line(aes(y = equity.f, colour = "The Filtering"), size = 0.05, lty = "longdash") +
   geom_line(aes(y = upper, colour = "Upper"), size = 0.1, lty = "longdash") +
   geom_line(aes(y = lower, colour = "Lower"), size = 0.1, lty = "longdash") +
   my.theme +
   scale_colour_manual("", values = c("gray70", "firebrick", "gray18", "firebrick")) +  
   ggtitle("Rendimientos y niveles con Filtración") +
   labs(x = "Fecha") +
   labs(y = "")

# Saving the plot
file = paste("5a_retsDlm", tag, "Filt.pdf", sep = "")
ggsave(graf.rets.dlm.mle.filt, file = file, path = directoryForImages) 

# Closing device
dev.off()


