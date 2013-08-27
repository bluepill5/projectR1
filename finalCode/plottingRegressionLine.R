###############################
# Plot of the regression line
alpha.slr <- as.character(round(outLM$coef[1], digits = 3))
beta.slr <- as.character(round(outLM$coef[2], digits = 3))
returns <- data.frame(market.exc.retornos.diarios[1:end.date.index], equity.exc.retornos.diarios[1:end.date.index])
colnames(returns) = c("market", "equity")

graf.reg.line <- ggplot(returns, aes(x = market, y = equity)) +
   geom_point(size = 1.66) +
   geom_smooth(method = "lm", color = "black", formula = y ~ x) +
   annotate("text", x = -0.022, y = 0.08, label = paste("alpha ==", alpha.slr), family = "mono", face = "bold", size = 5, colour = "Black", parse = T) +
   annotate("text", x = -0.022, y = 0.072, label = paste("beta ==", beta.slr), family = "mono", face = "bold", size = 5, colour = "Black", parse = T) +
   my.theme +
   ggtitle("Ajuste con un Modelo de Regresión Simple") +
   labs(x = "Índice del Mercado") +
   labs(y = "Acción")

# Saving the plot
ggsave(graf.reg.line, file="2a_regLine.pdf", path = directoryForImages) 

dev.off()