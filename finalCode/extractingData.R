###############################
# The queries consist of:
# Series de tiempo diarias de los rendimientos diarios de las acciones al 
# cierre, de alguna(s) accion(es) y un índice del mercado (como SP&500 (^GSPC) 
# o Russell 2000 (^RUT)), además de una acción libre de riesgo, la fuente de 
# la información es Yahoo Finance.
# Nota: Op, Hi, Lo, Cl, Vo, Ad - extraen las columnas Open, High, Low, Close, 
# Volume, y Adjusted respectivamente.
###############################
# Function that extract a list of equities startinf from start.date to 
# end.date, and store the prices, returns, and a "list" of returns with a 
# horizont to predict, using getSymbols of the package quantmod
extract <- function(equities, start.date, end.date, horizont) {
  symbols <- getSymbols(equities, from = start.date, to = horizont)
  myList = list()

  list.returns = list()
  list.prices = list()
  list.returns.predict = list()

  for (symbol in symbols) {
    end.date.index <- which(index(dailyReturn(get(symbol))) == end.date, arr.ind = FALSE)
    # Retornos diarios
    name.var <- paste(tolower(symbol), "retornos.diarios", sep = ".")
    tmp <- dailyReturn(get(symbol))[1:end.date.index]
    colnames(tmp) = tolower(symbol)
    assign(name.var, tmp)
    list.returns[[name.var]]<- get(name.var)
    # Precios
    name.var <- paste(tolower(symbol), "precios.diarios", sep = ".")
    tmp <- Ad(get(symbol))[1:end.date.index]
    colnames(tmp) = tolower(symbol)
    assign(name.var, tmp)
    list.prices[[name.var]]<- get(name.var)
    # Adjusting for the prediction
    name.var <- paste(tolower(symbol), "retornos.diarios.prediction", sep = ".")
    n <- length(dailyReturn(get(symbol)))
    tmp <- dailyReturn(get(symbol))
    tmp[n:(end.date.index + 1)] <- NA
    colnames(tmp) = tolower(symbol)
    assign(name.var, tmp)
    list.returns.predict[[name.var]]<- get(name.var)
  }
  myList = list(returns = list.returns, prices = list.prices, returns.predict = list.returns.predict)
  myList
}

###############################
# Function that extract the elements of a list(list(elements)), and copy into
# the global environment
toGlobEnv <- function(List) {
  for (sublist in names(List)) {
    for (obj in names(List[[sublist]])) {
      assign(obj, List[[sublist]][[obj]], envir = .GlobalEnv)
    }
  }
}

# Activo Libre de Riesgo: TreasuryYield5Years (^FVX) // or (^TNX) 10 years
###############################
getSymbols("^TNX", from = start.date, to = horizont)
end.date.index <- which(index(Ad(TNX)) == end.date, arr.ind = FALSE)
# Retornos diarios
riskfree.retornos.diarios <- (Ad(TNX)[1 : end.date.index])/100
colnames(riskfree.retornos.diarios) = "RKFREE"
# Adjusting for the prediction
n <- length(Ad(TNX))
riskfree.retornos.diarios.prediction <- Ad(TNX)/100
riskfree.retornos.diarios.prediction[n:(end.date.index + 1)]  <- NA
colnames(riskfree.retornos.diarios.prediction) = "RKFREE"

data <- extract(symbols.equities, start.date, end.date, horizont)

# Indentify if is the univariate case or multivariate case
if (length(symbols.equities) == 2) {
  names(data[["returns"]]) <- c("market.retornos.diarios", "equity.retornos.diarios")
  names(data[["prices"]]) <- c("market.precios.diarios", "equity.precios.diarios")
  names(data[["returns.predict"]]) <- c("market.retornos.diarios.prediction", "equity.retornos.diarios.prediction")
  toGlobEnv(data)
} else { 
  # Indexes
  dates <- index(riskfree.retornos.diarios)
  # Equities
  # all.equities.df <- data.frame(matrix(unlist(data[["returns"]]), nrow = length(dates), byrow = T))
  all.equities.df <- data.frame(data[["returns"]])
  all.equities <- xts(all.equities.df, order.by = dates)
  all.equities <- all.equities[,] - as.data.frame(riskfree.retornos.diarios)[,]
  ###############################
  # Compute excess returns
  market.exc.retornos.diarios <- all.equities[, 1]
  colnames(market.exc.retornos.diarios) <- "MARKET"
  equities.exc.retornos.diarios <- all.equities[, 2:ncol(all.equities)]
  colnames(equities.exc.retornos.diarios) <- symbols.equities[2:length(symbols.equities)]
}

# Save the data in the univariate case
if (length(symbols.equities) == 2) {
  file = paste("dataQuery_", format(Sys.time(), "%b-%d-%Y-%H_%M"), ".csv", sep = "")
  queryToCSV <- data.frame(equity.precios.diarios, equity.retornos.diarios, 
				   market.precios.diarios, market.retornos.diarios, 
			  	   riskfree.retornos.diarios)
  names(queryToCSV) <- c("equity.precios.diarios", "equity.retornos.diarios", "market.precios.diarios", "market.retornos.diarios", "riskfree.retornos.diarios")
  setwd(directoryForCodes)
  write.csv(queryToCSV, file)
}

# Remove the unnecessary variables
rm(extract, toGlobEnv, data, n, TNX)


