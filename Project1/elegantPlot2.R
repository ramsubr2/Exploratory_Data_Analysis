## Code for creating plot 2 ##

Sys.setlocale("LC_TIME","English")

# reading data
library(data.table)
filename <- "household_power_consumption.txt"
data <- fread(filename,
              header = FALSE,
              sep = ";",
              na.strings = "?",
              nrows = 2*24*60,
              skip = "1/2/2007")
setnames(data, as.character(fread(filename, nrows=1, header=FALSE)))


# binding the date/time column
data[, Datetime:=as.POSIXct(strptime(paste(Date, Time),"%d/%m/%Y %H:%M:%S"))]


# creating the png file
png(file = "plot2.png", width=504, height=504 )

with(data, plot(Datetime, Global_active_power,
                type = "l",
                main = "Global Active Power",
                xlab = "",
                ylab = "Global Active Power (kilowatts)"))

dev.off()