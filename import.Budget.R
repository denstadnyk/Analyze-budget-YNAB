#source("~/R/Home/Money/import.Budget.R")
library(dplyr)
library(lubridate)
library(ggplot2)
library(data.table)

dirExport <- "~/Dropbox/YNAB/Exports/"
lastPath <- paste0(dirExport, dir(dirExport)[length(dir(dirExport))])
budget <- read.delim(lastPath, stringsAsFactors=FALSE) %>% data.table()
rm(dirExport,lastPath)

budget$Running.Balance <- gsub("грн.", "", budget$Running.Balance)
budget$Running.Balance <- gsub(",", ".", budget$Running.Balance)
budget$Running.Balance <- as.numeric(budget$Running.Balance)

budget$Outflow <- gsub("грн.", "", budget$Outflow)
budget$Outflow <- gsub(",", ".", budget$Outflow)
budget$Outflow <- as.numeric(budget$Outflow)

budget$Inflow <- gsub("грн.", "", budget$Inflow)
budget$Inflow <- gsub(",", ".", budget$Inflow)
budget$Inflow <- as.numeric(budget$Inflow)

budget$Date <- dmy(budget$Date)
