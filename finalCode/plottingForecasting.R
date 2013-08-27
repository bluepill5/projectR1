###############################
# Calculate teh variances of beta and alpha (filtering)
attach(coef.Filt)
vars.predict = dropFirst(lapply(dlmSvd2var(U.C, D.C), extractDiag)) 
sd.alpha.predict = vector(length = length(vars.predict))
sd.beta.predict = vector(length = length(vars.predict))
# Extract the standard deviations of vars.filt.
for(i in 1:length(vars.predict)){
   sd.alpha.predict[i] = sqrt(vars.predict[[i]][1])
   sd.beta.predict[i] = sqrt(vars.predict[[i]][2])}
detach(coef.Filt)

#############
# Plot of beta with limits of probability of the 95%
beta.predict <- as.zoo(dropFirst(coef.Filt$m[, 2]))
index(beta.predict) <- index(riskfree.retornos.diarios.prediction)
upper.beta.predict <- beta.predict + (qnorm(0.975) * sd.beta.predict)
lower.beta.predict <- beta.predict - (qnorm(0.975) * sd.beta.predict)

beta.predict <- merge(beta.predict, upper.beta.predict, lower.beta.predict)
y.start <- min(beta.predict[-1,])
y.end <- max(beta.predict[-1,])

graf.beta.mle.predict <- ggplot(beta.predict[-1,], aes(x = dates.prediction[2:length(dates.prediction)], y = beta.predict, colour = "Beta")) +
   geom_line(size = 0.89) +
   geom_line(aes(y = upper.beta.predict, colour = "intervalos de confianza del 95%"), size = 0.89, lty = "longdash") +
   geom_line(aes(y = lower.beta.predict, colour = "intervalos de confianza del 95%"), size = 0.89, lty = "longdash") +
   geom_segment(aes(x = as.Date(end.date), xend = as.Date(end.date), y = y.start, yend = y.end) , size = 0.5, lty = "longdash") +
   my.theme +
   scale_colour_manual("", values = c("gray18", "gray70")) +  
   ggtitle("Recorrido de beta (Filtración)") +
   labs(x = "Fecha") + 
   labs(y = "Valores")

# Saving the plot
file = paste("4a_beta", tag, "Predict.pdf", sep = "")
ggsave(graf.beta.mle.predict, file = file, path = directoryForImages) 

#############
# Plot of alpha with limits of probability of the 95%
alpha.predict <- as.zoo(dropFirst(coef.Filt$m[, 1]))
index(alpha.predict) <- index(riskfree.retornos.diarios.prediction)
upper.alpha.predict <- alpha.predict + (qnorm(0.975) * sd.alpha.predict)
lower.alpha.predict <- alpha.predict - (qnorm(0.975) * sd.alpha.predict)

alpha.predict <- merge(alpha.predict, upper.alpha.predict, lower.alpha.predict)
y.start <- min(alpha.predict[-1,])
y.end <- max(alpha.predict[-1,])

graf.alfa.mle.predict <- ggplot(alpha.predict[-1,], aes(x = dates.prediction[2:length(dates.prediction)], y = alpha.predict, colour = "Alfa")) +
   geom_line(size = 0.89) +
   geom_line(aes(y = upper.alpha.predict, colour = "intervalos de confianza del 95%"), size = 0.89, lty = "longdash") +
   geom_line(aes(y = lower.alpha.predict, colour = "intervalos de confianza del 95%"), size = 0.89, lty = "longdash") +
   geom_segment(aes(x = as.Date(end.date), xend = as.Date(end.date), y = y.start, yend = y.end) , size = 0.5, lty = "longdash") +
   my.theme +
   scale_colour_manual("", values = c("gray18", "gray70")) +  
   ggtitle("Recorrido de alfa (con Predicciones)") +
   labs(x = "Fecha") + 
   labs(y = "Valores")

# Saving the plot
file = paste("4a_alfa", tag, "Predict.pdf", sep = "")
ggsave(graf.alfa.mle.predict, file = file, path = directoryForImages) 

# Closing device
dev.off()

