library(tidyverse)
library(mnsentinellakes)


setwd("C:/Users/forgr001/Documents/MSP-LTER/Data/beaches/ramsey county")

data <- read.csv("RamseyCo_beaches_archiveddatathru2024.csv")

# rename columns
colnames(data) <- c("beach", "DOW", "siteID", "sampleDate", "TC_mpn100mL",
                    "FC_mpn100mL", "Ecoli_mpn100mL",  "shallow_or_deep",
                    "beachClosure", "Ecoli_GM30day_mpn100mL", "Ecoli_GM1day_mpn100mL", 
                    "Eoli_GM3week_mpn100mL", "TC_GM1day", "FC_GM1day")
# GM = geometric mean
# FC = fecal coliform
# TC = total coliform

# convert date format
data <- data %>%
  mutate(sampleDate = as.POSIXct(sampleDate, format = "%m/%d/%Y")) %>%
  mutate(sampleYear = year(sampleDate)) %>%
  mutate(sampleMonth = month(sampleDate)) %>%
  mutate(jday = yday(sampleDate)) %>%
  mutate(Ecoli_GM1day_mpn100mL = as.numeric(Ecoli_GM1day_mpn100mL))

# find out where method changes
ggplot(data, aes(x = sampleDate, y = Ecoli_mpn100mL)) + 
  geom_point(color = "maroon") + 
  geom_point(aes(x = sampleDate, y = FC_mpn100mL), color = "blue")


# method change from TC/FC to Ecoli in 2004

ecoli <- data %>%
  filter(!is.na(Ecoli_mpn100mL)) 


min(Ecoli$Date) # 2004


# separate by beach closure?
ggplot(ecoli, aes(x = sampleDate, y = Ecoli_mpn100mL, color = beachClosure)) + 
  geom_point()  +
  geom_hline(yintercept = 1260) + 
  scale_color_manual(values=c("blue", "red")) 

ggplot(ecoli, aes(x = sampleDate, y = Ecoli_GM1day_mpn100mL, color = beachClosure)) + 
  geom_point() +
  geom_hline(yintercept = 1260) + 
  scale_color_manual(values=c("blue", "red")) 
# gaps in geometric mean data??

ggplot(ecoli, aes(x = sampleDate, y = Ecoli_GM30day_mpn100mL, color = beachClosure)) + 
  geom_point() +
  geom_hline(yintercept = 126) + 
  scale_color_manual(values=c("blue", "red")) 


ecoli$sampleYear <- ordered(ecoli$sampleYear)
# compile all by year
ggplot(ecoli, aes(x = jday, y = Ecoli_mpn100mL, color = sampleYear)) + 
  geom_point()  + 
  geom_line() +
  geom_hline(yintercept = 1260) +
  xlab("Julian Day")
 
