library(sqldf)

fn <- "household_power_consumption.txt"
# Read only data for the first two days in February 2007
# this should be 60*24*2 = 2880 observations
req_data <- req_data <- read.csv.sql(fn, sep = ';', header = TRUE, 
                                     sql = 'select * from file where Date = "1/2/2007" OR Date = "2/2/2007"')

#concat date and time and convert to Date and Time class in POSIXct format
date_and_time_combined <- paste(as.Date(req_data$Date,"%d/%m/%Y"),req_data$Time)
req_data$Date_and_Time_combined <- as.POSIXct(date_and_time_combined)

#plot Global Active Power versus Date and Time combined
plot(req_data$Global_active_power ~ req_data$Date_and_Time_combined, type = "l", 
     ylab="Global Active Power (kilowatts)", xlab="")

#Store the plot in a png file with 480x480 resolution
dev.copy(png, file="plot2.png", height=480, width=480)
#Be sure to turn off the connection!
dev.off()
