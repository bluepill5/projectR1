########################################################
## Rolling Betas:
########################################################
require("grid")
roll.asset <- equity.exc.retornos.diarios[0:end.date.index]
roll.market <- market.exc.retornos.diarios[0:end.date.index]
rolls <- merge(roll.asset, roll.market)
colnames(rolls) = c("roll.asset", "roll.market")

# Function to apply
f <- function (z) {
  coef(lm(roll.asset ~ roll.market, data = as.data.frame(z)))
}

rolling.alpha.beta <- rollapplyr(rolls, width = 60, FUN = f, by.column = FALSE, align = "right")
colnames(rolling.alpha.beta) = c("rolling.alpha", "rolling.beta")

coord.beta = 1.6

graf.rolling.beta <- ggplot(rolling.alpha.beta, aes(x = dates, y = rolling.beta)) +
   geom_line(size = 0.89) +
   annotate("text", x = dates[48], y = coord.beta + 0.05, label = "Muestra completa", family = "mono", face = "bold", size = 5, colour = "Black") +
   annotate("text", x = dates[30], y = coord.beta, label = paste("beta ==", beta.slr), family = "mono", face = "bold", size = 5, colour = "Black", parse = T) +
   geom_hline(yintercept = round(outLM$coef[2], digits = 3)) + 
   geom_segment(aes(x = dates[30], xend = dates[30], y = coord.beta - 0.05, yend = outLM$coef[2] + .01), arrow = arrow(length = unit(0.5, "cm")), size = 0.6) +
   my.theme +
   ggtitle("Betas Móviles") +
   labs(x = "Fecha") +
   labs(y = "Valores")

ggsave(graf.rolling.beta, file="6a_rollingBeta.pdf", path = directoryForImages) 



########################################################
## QQ-Plot: Simple Linear Regression and Jarque-Bera statistic
########################################################

# slope = (quantile(outLM$residuals, p = .75) - quantile(outLM$residuals, 0.25))/(qnorm(0.75)-qnorm(0.25))
# intercept = quantile(outLM$residuals, 0.25) - slope*qnorm(0.25)
# qq_line = data.frame(intercept = intercept, slope = slope)

# qqplot.reg.line <- qplot(sample = outLM$residuals, stat="qq") +
   # geom_abline(data = qq_line, aes(intercept = intercept, slope = slope)) +
   # ggtitle("Normal Q-Q Plot (Modelo de Regresión Simple") +
   # labs(x = "Cuantiles Teóricos") +
   # labs(y = "Cuantiles Muestrales")

# # jarque.bera.test(outLM$residuals)

# ggsave(qqplot.reg.line, file="6a_qqplotRegLine.pdf", path = directoryForImages) 

########################################################
## QQ-Plot: DLM and Jarque-Bera statistic
########################################################

slope = (quantile(residuals(coef.Filt, sd = FALSE)[0:end.date.index], p = .75) - quantile(residuals(coef.Filt, sd = FALSE)[0:end.date.index], 0.25))/(qnorm(0.75)-qnorm(0.25))
intercept = quantile(residuals(coef.Filt, sd = FALSE)[0:end.date.index], 0.25) - slope*qnorm(0.25)
qq_line = data.frame(intercept = intercept, slope = slope)

qqplot.dlm <- qplot(sample = residuals(coef.Filt, sd = FALSE)[0:end.date.index], stat="qq") +
   geom_abline(data = qq_line, aes(intercept = intercept, slope = slope)) +
   ggtitle("Normal Q-Q Plot (DLM)") +
   labs(x = "Cuantiles Teóricos") +
   labs(y = "Cuantiles Muestrales")

# # jarque.bera.test(residuals(coef.Filt, sd = FALSE)[0:end.date.index])

ggsave(qqplot.dlm, file="6a_qqplotDLM.pdf", path = directoryForImages) 

# Saving the plot
tsdiag(coef.Filt, gof.lag = 10)
file = paste(directoryForImages, "/tsdiag.pdf", sep = "")
dev.copy2pdf(file = file)

# Closing device
dev.off()

