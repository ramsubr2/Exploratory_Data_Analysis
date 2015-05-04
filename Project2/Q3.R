library(dplyr)
library(ggplot2)
library(grid)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#create a dplyr data frame
NEI_dp <- tbl_df(NEI)
rm("NEI")

#open a png file to plot to

png(file = "plot3.png", width=480, height=480)

#select rows corresponding to Baltimore
Baltimore_emissions <- filter(NEI_dp, fips == "24510")
# group by year
by_year_and_type <- group_by(Baltimore_emissions, year, type)

# summarise and convert emission totals to Thousands
sum_by_year_and_type <- summarise(by_year_and_type,Total_Emissions = sum(Emissions)/10^3)
sum_by_year_and_type$year = factor(sum_by_year_and_type$year, 
                                   levels = c('1999','2002','2005','2008'))
#create base layer of gglpot for Total Emmissions vs year for each type 
g <- ggplot(sum_by_year_and_type,aes(year,Total_Emissions, group=1))
# add facets and regression lines
p <- g + geom_point() + facet_grid(.~type) + geom_smooth(method="lm") + 
  labs(title = "PM2.5 Emissions for Baltimore by Source Type") +
  theme(panel.grid=element_blank(), 
        axis.text.x = element_text(angle = 90, hjust = 1))
#print the plot
print(p)
#close the connection!
dev.off()

  
  