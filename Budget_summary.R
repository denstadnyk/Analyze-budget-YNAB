source("~/R/Home/Money/import.Budget.R")

qplot(Date, Running.Balance, data = budget, color = Account)

## For budgeted account
budgeted <- data.table(budget)

qplot(Date, Running.Balance, data = budgeted, color = Account)

Inflows <- budget[, .(Inflow = sum(Inflow)), by=Date]
Outflows <- budget[, .(Outflow = sum(Outflow)), by=Date]
dataSummary <- merge(Inflows, Outflows, by = "Date", all = TRUE)

dataSummary$summary <- dataSummary$Inflow - dataSummary$Outflow


dataSummary$running[1] <- dataSummary$summary[1]
i <- 2
for (i in i:length(dataSummary$Date)) {
        dataSummary$running[i] <- dataSummary$running[i-1] + dataSummary$summary[i]
}

qplot(Date, log2(running), data = dataSummary) + geom_line() + ylim(0, 20) + geom_smooth()
qplot(Date, running, data = dataSummary) + geom_line() + ylim(0, 80000) + geom_smooth()


