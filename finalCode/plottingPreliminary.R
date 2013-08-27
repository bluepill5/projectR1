	###############################
# Plotting a ficticie CML
# r = r_f + slope * sig.r
rf = 0.06
rM = 0.15
sig.M = 0.22
slope = (0.15 - 0.06) / 0.22
rp = rf + slope * (seq(0.0, 0.25, 0.001))
x = seq(0.0, 0.25, 0.001)
clm = cbind(rp, x)
colnames(clm) = c("Rendimiento", "sigma")
clm = as.data.frame(clm)

graf.cml <- ggplot(clm, aes(x = sigma, y = Rendimiento)) +
   geom_line(size = 0.89) +
   geom_vline(xintercept = c(0.0, 0.0)) + 
   geom_hline(xintercept = c(0.0, 0.0)) + 
   geom_segment(aes(x = 0.125, xend = 0.15, y = 0.149, yend = 0.125), arrow = arrow(length = unit(0.5, "cm")), size = 1) +
   annotate("text", x = 0.125	, y = 0.155, label = "CML", family = "mono", face = "bold", size = 7, colour = "Black", parse = T) +
   annotate("text", x = 0.009	, y = 0.057, label = "paste(bolditalic(r)[italic(f)])", family = "mono", face = "bold", size = 5, colour = "Black", parse = T) +
   my.theme +
   ggtitle("Línea del Mercado de Capitales") +
   labs(x = "Desviación Estándar") +
   labs(y = "Rendimiento Esperado")

# Saving the plot
ggsave(graf.cml, file="0a_clm.pdf", path = directoryForImages) 

###############################
# Plotting the SML
# mu_j - r_f = beta_j * (mu_M - mu_f)
# exc.asset = 0.0370101 * 100
# beta.asset = 1.218195
exc.M = 0.0096420
risk.premium.range = (seq(0.0, 2.35, 0.001)) * exc.M * 100
betas.range = seq(0.0, 2.35, 0.001)
slm = cbind(risk.premium.range, betas.range)
colnames(slm) = c("prima.riesgo", "beta")
slm = as.data.frame(slm)

graf.sml <- ggplot(slm, aes(x = beta, y = prima.riesgo)) +
   geom_line(size = 0.89) +
   geom_vline(xintercept = c(0.0, 0.0)) + 
   geom_hline(xintercept = c(0.0, 0.0)) + 
   geom_vline(xintercept = c(1.0, 0.0), lty = "dashed") + 
   annotate("text", x = 0.50	, y = 0.10, label = "No agresiva", family = "mono", face = "bold", size = 5, colour = "Black") +
   annotate("text", x = 1.50	, y = 0.10, label = "Agresiva", family = "mono", face = "bold", size = 5, colour = "Black") +
   geom_segment(aes(x = 1.5, xend = 1.75, y = 1.85, yend = 1.75), arrow = arrow(length = unit(0.5, "cm")), size = 1) +
   annotate("text", x = 1.40	, y = 1.85, label = "SML", family = "mono", face = "bold", size = 5, colour = "Black") +
   geom_segment(aes(x = 1.25, xend = 1.01, y = 0.75, yend = 0.95), arrow = arrow(length = unit(0.5, "cm")), size = 1) +
   annotate("text", x = 1.30	, y = 0.70, label = "Portafolio", family = "mono", face = "bold", size = 5, colour = "Black") +
   annotate("text", x = 1.40	, y = 0.60, label = "del Mercado", family = "mono", face = "bold", size = 5, colour = "Black") +
   my.theme +
   ggtitle("Línea del Mercado de Títulos") +
   labs(x = "Beta") +
   labs(y = "Prima de Riesgo")

# Saving the plot
ggsave(graf.sml, file="0a_slm.pdf", path = directoryForImages)

###############################
# Plotting the normalizing prices
#
norm.equity.precios.diarios = equity.precios.diarios / as.numeric(equity.precios.diarios[1])
norm.market.precios.diarios = market.precios.diarios / as.numeric(market.precios.diarios[1])
norm.precios = merge(norm.market.precios.diarios, norm.equity.precios.diarios)
colnames(norm.precios) <- c("market", "equity")

graf.norm.precios <- ggplot(norm.precios, aes(x = dates, y = market, colour = "Mercado", group = 1)) +
   geom_line(size = 0.89) +
   geom_line(aes(y = equity, colour = "Acción", group = 2), size = 0.89, lty = "longdash") +
   geom_smooth(data = norm.precios, aes(x = dates, y = market, group = 1), method="loess") +
   geom_smooth(data = norm.precios, aes(x = dates, y = equity, group = 2), method="loess") +
   my.theme +
   scale_colour_manual("", values = c("gray18", "gray70")) +  
   ggtitle("Precios Normalizados") +
   labs(x = "Fecha") +
   labs(y = "Precio")

# Saving the plot
ggsave(graf.norm.precios, file="1a_pricesNorm.pdf", path = directoryForImages)

dev.off()
