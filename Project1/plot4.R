library(sqldf)

fn <- "household_power_consumption.txt"
# Read only data for the first two days in February 2007
# this should be 60*24*2 = 2880 observations
req_data <- req_data <- read.csv.sql(fn, sep = ';', header = TRUE, 
                                     sql = 'select * from file where Date = "1/2/2007" OR Date = "2/2/2007"')

#concat date and time and convert to Date and Time class in POSIXct format
date_and_time_combined <- paste(as.Date(req_data$Date,"%d/%m/%Y"),req_data$Time)
req_data$Date_and_Time_combined <- as.POSIXct(date_and_time_combined)

#create the plot directly in the png file instead of the screen and then exporting it
#this will make sure that the legend is displayed correctly
png("plot4.png", height=480, width=480)
#set up for two columns and two rows
par(mfrow=c(2,2))
#set up margins
par(mar=c(4,4,2,2))

#plot all 4 plots
#plot 1 Global Active Power versus Date and Time combined
plot(req_data$Global_active_power ~ req_data$Date_and_Time_combined, type = "l", 
     ylab="Global Active Power (kilowatts)", xlab="")

#plot 2 Voltage versus Date and Time combined
plot(req_data$Voltage ~ req_data$Date_and_Time_combined, type = "l", 
     ylab="Voltage", xlab="datetime")

#plot 3 Energy Sub Metering (all three) versus Date and Time combined
#add the legend
with(req_data,{
    plot(req_data$Sub_metering_1 ~ req_data$Date_and_Time_combined, type = "l", 
     ylab="Energy sub metering", xlab="")
    lines(req_data$Sub_metering_2 ~ req_data$Date_and_Time_combined, col='Red')
    lines(req_data$Sub_metering_3 ~ req_data$Date_and_Time_combined, col='Blue')
    legend("topright", lty = 1, lwd = 2, col = c("black", "red", "blue"), 
           legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
    })

#plot 4 Global_reactive_power versus Date and Time combined
plot(req_data$Global_reactive_power ~ req_data$Date_and_Time_combined, type = "l", 
     ylab="Global_reactive_power", xlab="datetime")

#Store the plot in a png file with 480x480 resolution
#dev.copy(png, file="plot3.png", height=480, width=480)
#
dev.off()
