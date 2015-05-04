## Code for creating plot 2 ##

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
png(file = "plot1.png", width=504, height=504 )

with(data, hist(Global_active_power,
                col = "red",
                main = "Global Active Power",
                xlab = "Global Active Power (kilowatts)"))

dev.off()