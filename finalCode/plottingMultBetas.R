#############
# Plot of the estimators of betas in the multivariate case
betas.smooth.xts <- xts(dropFirst(CAPMsmooth$s[, m + 1 : m]), order.by = dates)
colnames(betas.smooth.xts) <- symbols.equities[2:length(symbols.equities)]
betas.filtering.xts <- xts(dropFirst(CAPMfiltering$m[, m + 1 : m]), order.by = dates)
colnames(betas.filtering.xts) <- symbols.equities[2:length(symbols.equities)]

betas.smooth <- melt(data.frame(dates, betas.smooth.xts), id.vars = "dates", measure.vars = symbols.equities[2:length(symbols.equities)])
betas.filtering <- melt(data.frame(dates, betas.filtering.xts), id.vars = "dates", measure.vars = symbols.equities[2:length(symbols.equities)])

graf.betas.smooth <- ggplot(betas.smooth, aes(x = dates, y = value, linetype=variable)) + 
   geom_line(size = I(1)) + 
   my.theme + 
   ggtitle("Betas (Smoothing)") +
   labs(x = "Fecha") + 
   labs(y = "Valores")

file = "1b_betasSmooth.pdf"
ggsave(graf.betas.smooth, file = file, path = directoryForImages) 


graf.betas.filtering <- ggplot(betas.filtering, aes(x = dates, y = value, linetype=variable)) + 
   geom_line(size = I(1)) + 
   my.theme + 
   ggtitle("Betas (Filtering)") +
   labs(x = "Fecha") + 
   labs(y = "Valores")

file = "1b_betasFiltering.pdf"
ggsave(graf.betas.filtering, file = file, path = directoryForImages) 

# Closing device
dev.off()

