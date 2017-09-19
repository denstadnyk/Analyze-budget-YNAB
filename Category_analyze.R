source("~/R/Home/Money/import.Budget.R")
library(RColorBrewer)
library(dplyr)
library(data.table)

budgeted <- budget %>% data.table()

# Define date range
dateRange <- as.Date("2017-02-01"):as.Date("2017-06-08")

# Subset by date and categories
data <- filter(budgeted, Date %in% dateRange) %>%
        filter(Master.Category %in% c("Food")) %>%
        select(Date, Payee, Sub.Category, Outflow) %>% data.table()

# Formatting column classes
data$Payee <- as.factor(data$Payee)
data$Sub.Category <- as.factor(data$Sub.Category)

# Filtering data by frequency of purchasing and sum of outflows
data <- data[, .(Outflow = sum(Outflow)), by= .(Date, Payee, Sub.Category)]
data <- data[(data[, count := .N, by=Payee]$count > 5) | (Outflow > 300)]
data[, big := Outflow > 300]

# Months and sum on every month
data <- data[, month := month(data$Date)]
data[, sum_month := sum(Outflow), by= .(month, Payee)]

# Sorting by sum of purchasings
levels <- data[, (.sum = sum(Outflow)), by = .(Payee)] %>% arrange(V1) %>% select(Payee)
levels <- as.character(levels$Payee)
data$Payee <- as.character(data$Payee) %>% factor(levels = levels)

# Some anomalies detection for plot
anomalies <- data[data[,big]] %>% select(Date, Payee, Sub.Category, Outflow, month) %>% filter(Outflow > 300)


## Plot research
cols <- brewer.pal(5,"Set3")
pal <- colorRampPalette(cols)

g <- ggplot(data, aes(Date, Payee, Sub.Category, Outflow))
g + geom_point() + aes(col = Payee, size = Outflow)
g + geom_point() + aes(col = Payee, size = Outflow) + scale_color_manual(values = pal(15))

g + geom_point(aes(x = Date, y = Sub.Category, col = Payee, size = Outflow))

g2 <- ggplot(data, aes(month, Outflow, Payee))
g2 + geom_point(aes(col = Payee, size = Outflow)) +
        geom_text(data = anomalies, aes(x = month, y = Outflow, label = Payee), vjust=2)
