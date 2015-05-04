library(sqldf)

fn <- "household_power_consumption.txt"
# Read only data for the first two days in February 2007
# this should be 60*24*2 = 2880 observations
req_data <- req_data <- read.csv.sql(fn, sep = ';', header = TRUE, 
                                     sql = 'select * from file where Date = "1/2/2007" OR Date = "2/2/2007"')
#plot a histogram of the variable Global Active Power
hist(req_data$Global_active_power, main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red")

#Store the plot in a png file with 480x480 resolution
dev.copy(png, file="plot1.png", height=480, width=480)
# Be sure to turn off the connection!
dev.off()
