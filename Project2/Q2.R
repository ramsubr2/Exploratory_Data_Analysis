library(dplyr)
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#create a dplyr data frame
NEI_dp <- tbl_df(NEI)
rm("NEI")

#open a png file to plot to

png(file = "plot2.png", width=480, height=480)
par(mar=c(4,4,2,2))
#select rows corresponding to Baltimore
Baltimore_emissions <- filter(NEI_dp, fips == "24510")
# group by year
by_year_totals <- group_by(Baltimore_emissions, year)
# summarise and convert emission totals to Millions
Baltimore_totals <- summarise(by_year_totals,Total_Emissions = sum(Emissions)/10^3)
#plot Total Emmissions vs year
with (Baltimore_totals, 
      plot(Total_Emissions ~ year, 
           xaxt = "n",
           main = "Total PM2.5 Emissions from all sources for Baltimore",
           col.main = "blue",
           ylab = "Total PM2.5 Emissions (Thousand Tons)"))
#set up x-axis labels correctly
axis(1, xaxp = c(1999,2008,3), las = 2)
#fit a regression line through the data points
fit <- lm(Baltimore_totals$Total_Emissions ~ Baltimore_totals$year)
abline(fit,lwd = 2)

#close the connection!
dev.off()

  
  