library(dplyr)
library(ggplot2)
library(grid)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#create dplyr data frames
NEI_dp <- tbl_df(NEI)
rm("NEI")

#select rows corresponding to Baltimore and Los Angeles and type ONROAD
city_mv_emissions <- filter(NEI_dp, fips == "06037" | fips == "24510", type == "ON-ROAD")

# group by year
by_fips_and_year <- group_by(city_mv_emissions, fips, year)

# summarise and convert emission totals to Thousands
sum_by_fips_and_year <- summarise(by_fips_and_year, Total_Emissions = sum(Emissions))

#convert year to factors to make it easy to plot
sum_by_fips_and_year$year = factor(sum_by_fips_and_year$year, 
                          levels = c('1999','2002','2005','2008'))

#calculate % change in Emissions in each city between 1999-2008
percent_change_LA <- pla <- (sum_by_fips_and_year$Total_Emissions[4]-sum_by_fips_and_year$Total_Emissions[1])/
  sum_by_fips_and_year$Total_Emissions[4]*100
percent_change_BM <- pla <- (sum_by_fips_and_year$Total_Emissions[8]-sum_by_fips_and_year$Total_Emissions[5])/
  sum_by_fips_and_year$Total_Emissions[5]*100

#create a text label for each facet to show % change in Emissions
if(percent_change_LA > 0) {
  summary_text_LA <- sprintf("LA Increased By %0.2f%%",percent_change_LA)
}
if (percent_change_LA < 0) {
  summary_text_LA <- sprintf("LA Decreased By %0.2f%%",percent_change_LA)
}
if(percent_change_BM > 0) {
  summary_text_BM <- sprintf("BM Increased By %0.2f%%",percent_change_BM)
} 
if (percent_change_BM < 0) {
  summary_text_BM <- sprintf("BM Decreased By %0.2f%%",percent_change_BM)
}

#function to return the right label for each facet
mf_labeller <- function(var, value){
  value <- as.character(value)
  if (var=="fips") { 
    value[value=="06037"] <- summary_text_LA
    value[value=="24510"]   <- summary_text_BM
  }
  return(value)
}

#create base layer of gglpot for Total Emmissions vs year for each type
g <- ggplot(sum_by_fips_and_year,aes(year,Total_Emissions, group=1))
p <- g + geom_point(aes(colour = factor(fips))) + geom_smooth(method="lm") + 
  facet_grid(fips~., scales = "free",labeller=mf_labeller) + 
  labs(title = "Emissions from Motor Vehicle sources for LA and Baltimore") + 
  theme(panel.grid=element_blank(),
        axis.text.x = element_text(angle = 90, hjust = 1),
        plot.title = element_text(size=14, face="bold", vjust=2))
#open a png file to plot to
png(file = "plot6.png", width=504, height=504)

#print the plot
print(p)

#close the connection!
dev.off()

  
  