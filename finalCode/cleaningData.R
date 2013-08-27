###############################
# Cleaning data
# Check if contains the same dates, if not "adjust" !!! NEED TO DO IT MANUALLY :(
if(length(market.retornos.diarios)!= length(equity.retornos.diarios) | length(equity.retornos.diarios)!= length(riskfree.retornos.diarios) | length(market.retornos.diarios)!= length(riskfree.retornos.diarios))
{
    # ipc vs. televisa vs. t-bill
    # Low to High
    riskfree.retornos.diarios = riskfree.retornos.diarios[index(riskfree.retornos.diarios) %in% index(equity.retornos.diarios)]
    riskfree.retornos.diarios = riskfree.retornos.diarios[index(riskfree.retornos.diarios) %in% index(market.retornos.diarios)]

    equity.retornos.diarios = equity.retornos.diarios[index(equity.retornos.diarios) %in% index(market.retornos.diarios)]
    equity.retornos.diarios = equity.retornos.diarios[index(equity.retornos.diarios) %in% index(riskfree.retornos.diarios)]

    market.retornos.diarios = market.retornos.diarios[index(market.retornos.diarios) %in% index(riskfree.retornos.diarios)]
    equity.retornos.diarios = equity.retornos.diarios[index(equity.retornos.diarios) %in% index(riskfree.retornos.diarios)]
}
# Check if all is right
length(market.retornos.diarios);length(equity.retornos.diarios);length(riskfree.retornos.diarios)
sum(index(riskfree.retornos.diarios) %in% index(equity.retornos.diarios))
sum(index(riskfree.retornos.diarios) %in% index(market.retornos.diarios))