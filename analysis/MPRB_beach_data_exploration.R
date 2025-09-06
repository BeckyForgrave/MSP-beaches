library(tidyverse)
library(ggplot2)
data = read.csv("MPRB_beaches_compiled.xlsx - all_years-beach_season_only.csv")

#Convert Date format
data <- data %>%
  mutate(Date = as.POSIXct(Date, format = "%m/%d/%Y")) %>%
  mutate(Year = year(Date)) %>%
  mutate(Month = month(Date)) %>%
  mutate(jday = yday(Date))

# same graphs as Ramsey County
ggplot(data, aes(x = Date, y = Ecoli_avg_cfu, color = beach_closure)) + 
  geom_point()  +
  geom_hline(yintercept = 1260) + 
  scale_color_manual(values=c("blue", "red")) 


ggplot(data, aes(x = Date, y = Ecoli_avg_cfu, color = beach_closure)) + 
  geom_point() +
  geom_hline(yintercept = 126) + 
  scale_color_manual(values=c("blue", "red")) 

ggplot(data, aes(x = jday, y = Ecoli_avg_cfu, color = Year)) + 
  geom_point()  + 
  geom_line() +
  geom_hline(yintercept = 1260) +
  xlab("Julian Day")


#Histograms
#Subsetting Closure Dates
closure = data[data$beach_closure == "Y",]

#Year
ggplot(closure, aes(x = Year)) + 
  geom_histogram() +
  ylab("Beach Closures")

#Julian Day
ggplot(data, aes(x = jday)) + 
  geom_histogram(bins=24) +
  ylab("Beach Closures")
