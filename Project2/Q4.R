library(dplyr)
library(ggplot2)
library(grid)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#create dplyr data frames
NEI_dp <- tbl_df(NEI)
rm("NEI")
SCC_dp <-tbl_df(SCC)
rm("SCC")

# merge the data frames on SCC
m1 <- merge(NEI_dp, SCC_dp, by = "SCC")

#pick out only rows that have some form of coal as a source
from_coal <- subset(m1, grepl("coal", Short.Name))

# group by year
by_year <- group_by(from_coal, year)

# summarise and convert emission totals to Thousands
sum_by_year <- summarise(by_year, Total_Emissions = sum(Emissions/10^3))

#convert year to factors to make it easy to plot
sum_by_year$year = factor(sum_by_year$year, 
                          levels = c('1999','2002','2005','2008'))

#create base layer of gglpot for Total Emmissions vs year for each type
g <- ggplot(sum_by_year,aes(year,Total_Emissions, group=1))
p <- g + geom_point() + geom_smooth(method="lm") + labs(title = "PM2.5 Emissions from Coal combustion sources across the United States") + 
  theme(panel.grid=element_blank(),axis.text.x = element_text(angle = 90, hjust = 1))
#open a png file to plot to
png(file = "plot4.png", width=480, height=480)

#print the plot
print(p)

#close the connection!
dev.off()

  
  