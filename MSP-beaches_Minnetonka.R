# Cleaning raw data on beach closures from Minnetonka ---------------------
## Code written by Julia D Grabow
## Started on 07 July 2025

## BF edits 12 August 2025

# Purpose of code ---------------------------------------------------------
## Clean Minnetonka beach closure/E. coli data
## Prep the data to be used in master sheet of all beach data

# Packages to load --------------------------------------------------------

library(tidyverse)
library(googledrive)
library(readxl)
library(here)
library(FSA) # for geomean() function




# Data to import ----------------------------------------------------------
## import data from google drive

drive_download( # download spreadsheet from google drive
  file = as_id("https://docs.google.com/spreadsheets/d/13-xpPApZdTUHl4wTFUecicuZW5CA3ElR/edit?gid=1897849526#gid=1897849526"),
  path = here("MSP-beaches_Minnetonka_raw.xlsx"),
  overwrite = TRUE   # this is helpful to make sure folks don't accidentally use a modified local version of the file
)

path <- here("MSP-beaches_Minnetonka_raw.xlsx")

sheetnames <- excel_sheets(path = path) # import sheet names 

# I did have to manually change the format a single value in the Libbs lake sheet in Excel from 2016 to 1/1/2106 so the loop worked


## loop through each sheet in excel doc, manipulating data in same way

minnetonka_raw <- data.frame()  # initiate an empty df to put all compiled sheets in

for (i in 1:length(sheetnames)) {

  sheet <- read_xlsx(
      path = path,
      sheet = sheetnames[i],
      skip = 1 # skip first row so column names and formats map correctly
    )
  
  colnames(sheet)[11] <- "Temporary1" # name unnamed col
  colnames(sheet)[12] <- "Temporary2" # name unnamed col
  
  sheet <- sheet %>% 
    mutate(BeachName = sheetnames[i], .before = Date) %>% # add beach name column from list of beach names 
    mutate(Date = as.Date(Date)) %>% # format date
    rename(sample1 = !!3, sample2 = !!4, sample3 = !!5, sample4 = !!6, sample5 = !!7) # rename columns 3-7 by index to standardize names
  
    # join to combined df
    minnetonka_raw <- rbind(minnetonka_raw, sheet)
}
  
rm(sheet) # remove intermediary variables no longer needed


# NO LONGER NEEDED --> saving for you to reference the intermediary step between your code and the loop above now but will delete later
# 
# ## import first sheet
# sheet1 <- 
#   read_xlsx(
#     path = path,
#     sheet = sheetnames[1],
#     skip = 1 # skip first row so column names and formats map correctly
#   )
# 
# colnames(sheet1)[11] <- "Temporary1" # name unnamed col
# colnames(sheet1)[12] <- "Temporary2" # name unnamed col
# 
# 
# sheet1 <- # add beach name column from list of beach names
#   sheet1 %>%
#   mutate(
#     BeachName = beachlist[1],
#     .before = Date
#   )
# 
# str(sheet1)
# 
# sheet1 <- # standardize col names 
#   sheet1 %>%
#   rename(
#     "sample1" = ES,
#     "sample2" = ED,
#     "sample3" = WS,
#     "sample4" = WD,
#     "sample5" = C
#     )
# 
# 
# 
# ## import second sheet
# sheet2 <- 
#   read_xlsx(
#     path = path,
#     sheet = 2,
#     skip = 1 # skip first row so column names and formats map correctly
#   )
# 
# colnames(sheet2)[11] <- "Temporary1" # name unnamed col
# colnames(sheet2)[12] <- "Temporary2" # name unnamed col
# 
# sheet2 <- # add lake name
#   sheet2 %>%
#   mutate(
#     BeachName = beachlist[1],
#     .before = Date
#   )
# 
# str(sheet2)
# 
# sheet2 <- # standardize col names
#   sheet2 %>%
#   rename(
#     "sample1" = SS,
#     "sample1" = SD,
#     "sample3" = NS,
#     "sample4" = ND,
#     "sample5" = C
#   )
# 
# 
# ## rename select columns by index
# # this allows us to loop the whole thing because this renaming is the only thing different across sheets
# # I found out how here: https://www.geeksforgeeks.org/r-language/how-to-rename-multiple-columns-in-r/#
# sheet2 <-
#   sheet2 %>% 
#   rename(sample1 = !!3, sample2 = !!4, sample3 = !!5, sample4 = !!6, sample5 = !!7)
# 
# str(sheet2)
# 
# 
# 
# 
# ## bind the df's into one
# minnetonka_raw <- 
#   rbind(sheet1, sheet2)

minnetonka <- minnetonka_raw # create df to manipulate



# Look at format of dfs----

str(minnetonka)
summary(minnetonka)

# Change values that are "<1" to 1----

Expected <- length(which(minnetonka[,3:9] == "<1")) +  length(which(minnetonka[,3:9] == "1")) # number of <1 and 1 in all data columns

minnetonka <- minnetonka %>%
  mutate(
    across(
      .cols = 3:9,
      .fns = ~ str_replace(
        string = .x,
        pattern = "<1",
        replacement = "1"
      )
    )
  )

# check that all converted correct
length(which(minnetonka[,3:9] == "1"))  == Expected # True




# Convert numeric columns from character to numeric----

minnetonka <- minnetonka %>%
  mutate(
    across(
      .cols = 3:10,
      .fns = as.numeric
    )
  )


str(minnetonka)
summary(minnetonka)



## To notes column, use language provided by BF for contamination and retesting


# I think we can just ignore the notes columns --> too hard to parse, and we will always have th original files to reference if needed

# unique(minnetonka$Notes)
# 
# minnetonka <- # create new notes col using a temporary col, rename original notes col
#   minnetonka %>%
#   rename(
#     Temporary3 = Notes,
#     Notes = Temporary2
#   )
# 
# minnetonka <- # make Notes col only NA values
#   minnetonka %>%
#   mutate(
#     Notes = NA
#   )
# 
# minnetonka <- # note that contaminated and retested data as suspicioius
#   minnetonka %>%
#   mutate(
#     Notes = if_else(
#       condition = Temporary3 == "**Possible contamination",
#       true = "potential sample contamination",
#       false = Notes
#     ),
#     Notes = if_else(
#       condition = Temporary3 == "Retest of WS was 6.3",
#       true = "used retested water sample for geometric mean",
#       false = Notes
#     )
#   )

# Remove unneeded cols (clearing clutter)
# select ones you do want rather than what you don in case something weird is hanging on 

minnetonka <- minnetonka %>%
  select(
      BeachName, 
      Date,
      sample1,
      sample2,
      sample3, 
      sample4,
      sample5
    )




# Calculate geometric mean for sampling date----
## pivot longer----

Expected <-
  nrow(minnetonka) * 5

minnetonka_long <- minnetonka %>%
  pivot_longer(
    cols = c(sample1, sample2, sample3, sample4, sample5),
    names_to = "SampleID",
    values_to = "Meas"
  )

nrow(minnetonka_long) == Expected # True


# no longer needed
# # group by date and beach to calculate 1-day geometric mean
# minnetonka_summary <- minnetonka_long  %>%
#   group_by(BeachName, Date) %>%
#   summarise(Ecoli_1dGM = round(geomean(Meas, na.rm = TRUE), digits = 1)) # keeps same sumber of sig figs as original data
# 
# # downloading a whole package to use one function one can seem excessive but it gives other fucntionality such as na.rm
# 




# Find 30 day geometric mean----
## create separate df for 30 day calculations----



 
# for each sampling date, select all data in 30-day interval, calc geometeric mean

# create new column to hold calculated values
minnetonka_long$Ecoli_1dGM <- 0
minnetonka_long$Ecoli_30dGM <- 0


# separate by beach for calculations
libbs <- minnetonka_long %>%
  filter(BeachName == "Libbs Lake Beach")

  
for (i in 1:length(libbs$Date)) {
  
  intervalstart <- as.POSIXct(libbs$Date[i] - 30) # start 30 days before sampling date
  intervalend <-  as.POSIXct(libbs$Date[i])

  # select all E coli measurements for one day
  oneday <-  libbs %>%
    filter(Date == intervalend)
  
  # calculate 1 day geometric mean and add it to column in df
  libbs$Ecoli_1dGM[i] <- round(geomean(oneday$Meas, na.rm = TRUE), digits = 1)
  
  
  # select all E coli measurements in range
  span30d <-  libbs %>%
    filter(Date >= intervalstart & Date <= intervalend)
  
  # calculate 30-day geometric mean and add it to column in df
  libbs$Ecoli_30dGM[i] <- round(geomean(span30d$Meas, na.rm = TRUE), digits = 1)
  
}

libbs <- libbs %>%
  select(BeachName, Date, Ecoli_1dGM, Ecoli_30dGM) %>%
  distinct()


# there is definitely a way to do this in a loop through all beaches....but i can't think of it now
# so we will just separate and recombine


# separate by beach for calculations
shady <- minnetonka_long %>%
  filter(BeachName == "Shady Oak Beach")


for (i in 1:length(shady$Date)) {
  
  intervalstart <- as.POSIXct(shady$Date[i] - 30) # start 30 days before sampling date
  intervalend <-  as.POSIXct(shady$Date[i])
  
  # select all E coli measurements for one day
  oneday <-  shady %>%
    filter(Date == intervalend)
  
  # calculate 1 day geometric mean and add it to column in df
  shady$Ecoli_1dGM[i] <- round(geomean(oneday$Meas, na.rm = TRUE), digits = 1)
  
  
  # select all E coli measurements in range
  span30d <-  shady %>%
    filter(Date >= intervalstart & Date <= intervalend)
  
  # calculate 30-day geometric mean and add it to column in df
  shady$Ecoli_30dGM[i] <- round(geomean(span30d$Meas, na.rm = TRUE), digits = 1)
  
}

shady <- shady %>%
  select(BeachName, Date, Ecoli_1dGM, Ecoli_30dGM) %>%
  distinct()




minnetonka <- rbind(shady, libbs) # rewrites minntonka df

minnetonka <- minnetonka[!is.na(minnetonka$Ecoli_1dGM),] # remove any NAs in data


# x <- minnetonka_long
# 
# ## keep only needed cols----
# 
# x <-
#   x %>%
#   select(
#     BeachName, Date, SampleID, Meas
#   )
# 
# ## create df with all time intervals for each site----
# 
# y <-
#   x %>%
#   mutate(
#     date_30d = interval(
#       start = Date - 30,
#       end = Date
#     )
#   )
# 
# y <-
#   y %>%
#   distinct(BeachName, Date, date_30d)
# 
# ## Cross join both df's----
# 
# Expected <- nrow(x) * nrow(y)
# 
# z <-
#   cross_join(
#     x, y
#   )
# 
# nrow(z) == Expected # True
# 
# ## Keep only rows where beach name is the same and date within interval----
# 
# z <-
#   z %>%
#   filter(
#     BeachName.x == BeachName.y
#   )
# 
# ## Keep only rows where Date is within date interval----
# 
# z <-
#   z %>%
#   filter(
#     Date.x %within% date_30d
#   )
# 
# ## determine how many sample size for each date per site----
# 
# z <-
#   z %>%
#   mutate(
#     n = n(),
#     .by = c("BeachName.x", "date_30d")
#   )
# 
# ## calculate product for each sampling date per site----
# 
# z <-
#   z %>%
#   mutate(
#     product = prod(Meas),
#     .by = c("BeachName.x", "date_30d")
#   )
# 
# ## find the nth log of the products----
# ### find the nth log
# 
# z <-
#   z %>%
#   mutate(
#     Ecoli_30dGM = log(
#       x = product,
#       base = n
#     ),
#     .by = c("BeachName.x", "date_30d")
#   )
# 
# ## Remove rows where Date.x does not match with Date.y to reduce to one meas----
# ### per date per site
# 
# z <-
#   z %>%
#   filter(
#     Date.x == Date.y
#   )
# 
# ## keep only BeachName.x, Date.x, and Ecoli_30d----
# 
# z <-
#   z %>%
#   select(
#     BeachName.x, Date.x, Ecoli_30dGM
#   ) %>%
#   unique() %>%
#   arrange(BeachName.x, Date.x)
# 
# ## Rename cols----
# 
# z <-
#   z %>%
#   rename(
#     BeachName = BeachName.x,
#     Date = Date.x
#   )
# 
# ## add to minnetonka df----
# ### drop unneeded cols from z and minnetonka dfs
# 
# minnetonka_long <-
#   minnetonka_long %>%
#   select( # remove unneeded cols
#     !c(SampleID, Meas, product, n)
#   ) %>%
#   distinct() # keep only unique rows
# 
# ### merge both df's into one
# 
# minnetonka_ong <-
#   left_join(
#     x = minnetonka,
#     y = z,
#     by = c("BeachName", "Date")
#   )
# 





# Standardize df to match master df----
## Add missing cols with single value----

minnetonka <- minnetonka %>%
  mutate(
    Ecoli_units = "cfu",
    ClosureYN = "N",
    ClosureReason = NA,
    MonitoringOrg = "Minnetonka"
  )




## find and label closures
minnetonka <- minnetonka %>%  
  mutate(
    ClosureYN = if_else(
      condition = Ecoli_1dGM > 1260,
      true = "Y",
      false = "N")
  ) %>%
  mutate(
    ClosureReason = if_else(
      condition = Ecoli_1dGM > 1260,
      true = "ecoli_1dayGM",
      false = NA)
  ) %>% 
  mutate(
    ClosureYN = if_else(
      condition = Ecoli_30dGM > 126,
      true = "Y",
      false = "N")
  ) %>%
  mutate(
    ClosureReason = if_else(
      condition = Ecoli_30dGM > 126,
      true = "ecoli_30dayGM",
      false = NA)
  ) 
    

## add cols with values based on another col----
## DOW for shady oak = 27008900
## DOWfor libbs lake = 27008500

minnetonka <- minnetonka %>%  # add DNRID for shady oak
  mutate(
    DOW = if_else(
      condition = BeachName == "Shady Oak",
      true = 27008900,
      false = NA
    )
  )

minnetonka <- minnetonka %>%  # add DNRID for Libbs Lake
  mutate(
    DOW = if_else(
      condition = BeachName == "Libbs Lake",
      true = 27008500,
      false = DOW
    )
  )



# Save csv----

write_csv(
  x = minnetonka,
  file = here("MSP-beaches_Minnetonka_clean.csv")
)

# Upload to Google Drive 

# yes --> do you know how to do this?