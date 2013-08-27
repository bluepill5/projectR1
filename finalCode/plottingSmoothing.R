###############################
# Calculate teh variances of beta and alpha (smoothing)
attach(coef.Smooth)
vars.smooth = dropFirst(lapply(dlmSvd2var(U.S, D.S), extractDiag)[0:end.date.index + 1]) 
sd.alpha.smooth = vector(length = length(vars.smooth))
sd.beta.smooth = vector(length = length(vars.smooth))
# Extract the standard deviations of vars.smooth.
for(i in 1:length(vars.smooth)){
   sd.alpha.smooth[i] = sqrt(vars.smooth[[i]][1])
   sd.beta.smooth[i] = sqrt(vars.smooth[[i]][2])}
detach(coef.Smooth)

#############
# Plot of the estimators of the DLM with MLE
beta.est.smooth <- merge(dropFirst(coef.Smooth$s[, 2][0:end.date.index + 1]), rep("beta", length(coef.Smooth$s[, 2][0:end.date.index + 1])))
alpha.est.smooth <- merge(dropFirst(coef.Smooth$s[, 1][0:end.date.index + 1]), rep("alfa", length(coef.Smooth$s[, 1][0:end.date.index + 1])))
beta.alpha.est.smooth <- rbind(alpha.est.smooth, beta.est.smooth)
beta.alpha.est.smooth <- cbind(beta.alpha.est.smooth, c(dates, dates))
colnames(beta.alpha.est.smooth) = c("values", "estimator", "date")

alpha.est.smooth[length(alpha.est.smooth[, 1]), 1]
beta.est.smooth[length(beta.est.smooth[, 1]), 1]

graf.beta.alpha.est.smooth <- ggplot(beta.alpha.est.smooth, aes(x = date, y = values)) +
   geom_line(size = 0.89) +
   facet_grid(estimator~., scales="free_y") +
   my.theme +
   ggtitle("Recorrido de alfa y beta (Suavizamiento)") +
   labs(x = "Fecha") + 
   labs(y = "Valores")

# Saving the plot
file = paste("3a_alphaBeta", tag, "Smooth.pdf", sep = "")
ggsave(graf.beta.alpha.est.smooth, file = file, path = directoryForImages) 

#############
# Plot of beta with limits of probability of the 95%
beta.smooth <- as.zoo(dropFirst(coef.Smooth$s[, 2][0:end.date.index + 1]))
index(beta.smooth) <- index(riskfree.retornos.diarios)
upper.beta.smooth <- beta.smooth + (qnorm(0.975) * sd.beta.smooth)
lower.beta.smooth <- beta.smooth - (qnorm(0.975) * sd.beta.smooth)

beta.smooth <- merge(beta.smooth, upper.beta.smooth, lower.beta.smooth)
graf.beta.mle.smooth <- ggplot(beta.smooth, aes(x = dates, y = beta.smooth, colour = "Beta")) +
   geom_line(size = 0.89) +
   geom_line(aes(y = upper.beta.smooth, colour = "intervalos de confianza del 95%"), size = 0.89, lty = "longdash") +
   geom_line(aes(y = lower.beta.smooth, colour = "intervalos de confianza del 95%"), size = 0.89, lty = "longdash") +
   my.theme +
   scale_colour_manual("", values = c("gray18", "gray70")) +  
   ggtitle("Recorrido de beta (Suavizamiento)") +
   labs(x = "Fecha") + 
   labs(y = "Valores")

# Saving the plot
file = paste("4a_beta", tag, "Smooth.pdf", sep = "")
ggsave(graf.beta.mle.smooth, file = file, path = directoryForImages) 

#############
# Plot of alpha with limits of probability of the 95%
alpha.smooth <- as.zoo(dropFirst(coef.Smooth$s[, 1][0:end.date.index + 1]))
index(alpha.smooth) <- index(riskfree.retornos.diarios)
upper.alpha.smooth <- alpha.smooth + (qnorm(0.975) * sd.alpha.smooth)
lower.alpha.smooth <- alpha.smooth - (qnorm(0.975) * sd.alpha.smooth)

alpha.smooth <- merge(alpha.smooth, upper.alpha.smooth, lower.alpha.smooth)
graf.alfa.mle.smooth <- ggplot(alpha.smooth, aes(x = dates, y = alpha.smooth, colour = "Alfa")) +
   geom_line(size = 0.89) +
   geom_line(aes(y = upper.alpha.smooth, colour = "intervalos de confianza del 95%"), size = 0.89, lty = "longdash") +
   geom_line(aes(y = lower.alpha.smooth, colour = "intervalos de confianza del 95%"), size = 0.89, lty = "longdash") +
   my.theme +
   scale_colour_manual("", values = c("gray18", "gray70")) +  
   ggtitle("Recorrido de alfa (Suavizamiento)") +
   labs(x = "Fecha") + 
   labs(y = "Valores")

# Saving the plot
file = paste("4a_alfa", tag, "Smooth.pdf", sep = "")
ggsave(graf.alfa.mle.smooth, file = file, path = directoryForImages) 

#############
# Plot of the returns with the DLM with MLE
# r_i = r_f + (r_m - r_f) * beta_i
returns.equity.mle.smooth = dropFirst(coef.Smooth$s[, 1][0:end.date.index + 1]) + riskfree.retornos.diarios + ((market.retornos.diarios - riskfree.retornos.diarios) * dropFirst(coef.Smooth$s[, 2][0:end.date.index + 1]))
#colnames(returns.equity.mle.smooth) = "equity.s"

returns.equity.mle.upper.smooth = (dropFirst(coef.Smooth$s[, 1][0:end.date.index + 1]) + qnorm(0.25) * sd.alpha.smooth) + riskfree.retornos.diarios + ((market.retornos.diarios - riskfree.retornos.diarios) * (dropFirst(coef.Smooth$s[, 2][0:end.date.index + 1]) + qnorm(0.25) * sd.beta.smooth))
#colnames(returns.equity.mle.upper.smooth) = "upper"
returns.equity.mle.lower.smooth = (dropFirst(coef.Smooth$s[, 1][0:end.date.index + 1]) - qnorm(0.25) * sd.alpha.smooth) + riskfree.retornos.diarios + ((market.retornos.diarios - riskfree.retornos.diarios) * (dropFirst(coef.Smooth$s[, 2][0:end.date.index + 1]) - qnorm(0.25) * sd.beta.smooth))
#colnames(returns.equity.mle.lower.smooth) = "lower"
returns.smooth.all <- merge(equity.retornos.diarios, returns.equity.mle.smooth, returns.equity.mle.upper.smooth, returns.equity.mle.lower.smooth)
colnames(returns.smooth.all) = c("equity", "equity.s", "upper", "lower")

graf.rets.dlm.mle.smooth <- ggplot(returns.smooth.all, aes(x = dates, y = equity, colour = "Datos")) +
   geom_line(size = 0.055) +
   geom_line(aes(y = equity.s, colour = "Smoothing"), size = 0.05, lty = "longdash") +
   geom_line(aes(y = upper, colour = "Upper"), size = 0.1, lty = "longdash") +
   geom_line(aes(y = lower, colour = "Lower"), size = 0.1, lty = "longdash") +
   my.theme +
   scale_colour_manual("", values = c("gray70", "firebrick", "gray18", "firebrick")) +  
   ggtitle("Rendimientos y niveles con Suavizamiento") +
   labs(x = "Fecha") +
   labs(y = "")

# Saving the plot
file = paste("5a_retsDlm", tag, "Smooth.pdf", sep = "")
ggsave(graf.rets.dlm.mle.smooth, file = file, path = directoryForImages) 

# Closing device
dev.off()


