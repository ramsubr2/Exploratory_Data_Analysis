library(dplyr)
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#create a dplyr data frame
NEI_dp <- tbl_df(NEI)
rm("NEI")

#open a png file to plot to

png(file = "plot1.png", width=480, height=480)
par(mar=c(4,4,2,2))
# group by year
by_year_totals <- group_by(NEI_dp, year)
# summarise and convert emission totals to Millions
summary_totals_millions <- summarise(by_year_totals,Total_Emissions = sum(Emissions)/10^6)
#plot Total Emmissions vs year
with (summary_totals_millions, 
      plot(Total_Emissions ~ year, 
           xaxt = "n",
           main = "Total PM2.5 Emissions from all sources",
           col.main = "blue",
           ylab = "Total PM2.5 Emissions (Million Tons)"))
#set up x-axis labels correctly
axis(1, xaxp = c(1999,2008,3), las = 2)
#fit a regression line through the data points
fit <- lm(summary_totals_millions$Total_Emissions ~ summary_totals_millions$year)
abline(fit,lwd = 2)

#close the connection!
dev.off()

  
  