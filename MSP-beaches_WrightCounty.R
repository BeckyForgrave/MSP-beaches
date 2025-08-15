# Cleaning raw data on beach closures from Wright County ------------------
## Code written by Julia D Grabow
## Started on 08 Aug 2025

# Purpose of code ---------------------------------------------------------
## Clean Wright County beach closure/E. coli data
## Prep the data to be used in master sheet of all beach data

# Packages to load --------------------------------------------------------

library(tidyverse)
library(googledrive)
library(readxl)
library(here)

# Data to import ----------------------------------------------------------
## import data from google drive

drive_download( # download spreadsheet from google drive
  file = as_id("https://docs.google.com/spreadsheets/d/1JZpjSb6ojK9O2ZMegs_-zrxhjMMvzu9f/edit?gid=14793420#gid=14793420"),
  path = here("MSP-beaches_WrightCounty_raw.xlsx")
)

path <- here("MSP-beaches_WrightCounty_raw.xlsx")

df <-
  read_xlsx(
    path = path
  )

# Looking at imported df --------------------------------------------------

str(df)
## 332 rows: corresponds to excel document
## all the rows look to be imported accurately

summary(df)
## MPN looks to have reasonable measurements
## There are 9 missing ecoli measurements--check in a bit
## Change date column to date class instead of POSIXct
## Lowest MPN measurement == 0.5; when looking more closely, these are only in
### the years of 2024 and 2025; keep <1 measurements at 1

unique(df$"Sample Location")
# Collinwood, Pleasant, Schroeder, Bertram, Beebe, Struges, and Griffing
sum(is.na(df$"Sample Location"))
# There are 8 columns without a location
## check later to determine if there are associated measurements

unique(df$Laboratory)
# Two labs used
unique(df$Qualifer)
# <, to indicate when a measurement was <1
unique(df$Action)
# This column denotes if the beach was closed, reopened, opened, or no action
# Also notes that there were three samples that were resampled
unique(df$Notes)
## notes how many samples were taken

# Standardize df ----------------------------------------------------------
## Rename col names----

str(df)

df <-
  df %>%
  rename(
    Date = "Sample Date",
    BeachName = "Sample Location",
    Meas = "MPN/100mL",
    Temp = "Notes",
    Notes = "Action"
  )

## Keep only needed cols----

df <-
  df %>%
  select(
    Date, BeachName, Meas, Notes
  )

## Drop rows without measurements----
### checking if there is ecoli data associated with missing lake names

df %>% filter(is.na(BeachName))
## no measurements; drop these rows

Expected <-
  nrow(df) - sum(is.na(df$BeachName))

df <-
  df %>%
  drop_na(BeachName)

nrow(df) == Expected # True

## Looking at rows missing measurements----

df %>% filter(is.na(Meas))
## not sure why measurement is missing, but will drop this row

Expected <-
  nrow(df) - sum(is.na(df$Meas))

df <-
  df %>%
  drop_na(Meas)

nrow(df) == Expected # True

## Convert Date column to date class from POSIXct----

df <-
  df %>%
  mutate(
    Date = as_date(Date)
  )

# Calculate geometric mean for sampling date----
## arrange df by date and beach----

df <-
  df %>%
  arrange(BeachName, Date)

## calculate product for each sampling date per site----

df <-
  df %>%
  mutate(
    product = prod(Meas),
    .by = c(BeachName, Date),
    .after = Meas
  )

## determine how many sample size for each date per site----

df <-
  df %>%
  mutate(
    n = n(),
    .by = c(BeachName, Date),
    .after = product
  )

## find the exponent of 1/n of the products----

df <-
  df %>%
  mutate(
    Ecoli_1dGM = product^(1/n),
    .by = c(BeachName, Date),
    .after = n
  )

# Find 30 day geometric mean----
## create separate df for 30 day calculations----

x <- df

## keep only needed cols----

x <-
  x %>%
  select(
    BeachName, Date, Meas
  )

## create df with all time intervals for each site----

y <-
  x %>%
  mutate(
    date_30d = interval(
      start = Date - 30,
      end = Date
    )
  )

y <-
  y %>%
  distinct(BeachName, Date, date_30d)

## Cross join both df's----

Expected <- nrow(x) * nrow(y)

z <-
  cross_join(
    x, y
  )

nrow(z) == Expected # True

## Keep only rows where beach name is the same and date within interval----

z <-
  z %>%
  filter(
    BeachName.x == BeachName.y
  )

## Keep only rows where Date is within date interval----

z <-
  z %>%
  filter(
    Date.x %within% date_30d
  )

## determine sample size for each date per site----

z <-
  z %>%
  mutate(
    n = n(),
    .by = c("BeachName.x", "date_30d")
  )

## calculate product for each sampling date per site----

z <-
  z %>%
  mutate(
    product = prod(Meas),
    .by = c("BeachName.x", "date_30d")
  )

## find the nth log of the products----
### find the nth log

z <-
  z %>%
  mutate(
    Ecoli_30dGM = product^(1/n),
    .by = c("BeachName.x", "date_30d")
  )

## Remove rows where Date.x does not match with Date.y to reduce to one meas----
### per date per site

z <-
  z %>%
  filter(
    Date.x == Date.y
  )

## keep only BeachName.x, Date.x, and Ecoli_30d----

z <-
  z %>%
  select(
    BeachName.x, Date.x, Ecoli_30dGM
  )

## Keep only one measurement per date and arrange df by date----

z <-
  z %>%
  distinct()%>%
  arrange(BeachName.x, Date.x)

## Rename cols----

z <-
  z %>%
  rename(
    BeachName = BeachName.x,
    Date = Date.x
  )

## add to df----
### drop unneeded cols df

df <-
  df %>%
  select( # remove unneeded cols
    !c(Meas, product, n)
  )

### reduce df to only one measurement per day and arrange by date

df <-
  df %>%
  distinct(
    Date, BeachName, Ecoli_1dGM,
    .keep_all = TRUE
  ) %>%
  arrange()

### merge both df's into one

df <-
  left_join(
    x = df,
    y = z,
    by = c("BeachName", "Date")
  )

# arrange by date

df <-
  df %>%
  arrange(BeachName, Date)


# Note when beach closed due to high ecoli levels----
## are there days when 1 day gm > 1260?

df$Ecoli_1dGM > 1260 # none over 1260

# are there days when 30 day gm > 126

df$Ecoli_30dGM > 126 # none over 126

## Create a column to denote when 30 day geometric mean > 126----

df <-
  df %>%
  mutate(
    Threshold = Ecoli_30dGM > 126
  )

## Add column to note that threshold over and that it was due to 30 day----

df <-
  df %>%
  mutate(
    ClosureYN = if_else(
      condition = Threshold == TRUE,
      true = "Y",
      false = "N"
    ),
    ClosureReason = if_else(
      condition = Threshold == TRUE,
      true = "Ecoli_30dGM",
      false = NA
    )
  )

## Remove threshold col----

df <-
  df %>%
  select(!Threshold)

# Standardize df to match master df----
## Add missing cols with single value----

df <-
  df %>%
  mutate(
    Ecoli_units = "mpn",
    Entero_avg_cfu = NA,
    Microcystin_ugL = NA,
    Cylindro_ugL = NA,
    Anatoxin_ugL = NA,
    MonitoringOrg = "Wright County",
    DNRID = NA
  )

## add cols with values based on another col----
## DNRID for Beebe = 86002300
## DNRID for Bertram = 86007000
## DNRID for Collinwood = 86029300
## DNRID for Griffing = NA
## DNRID for Pleasant = 86025100
## DNRID for Schroeder = NA
## DNRID for Struges = NA

df <- # add DNRID for Beebe
  df %>%
  mutate(
    DNRID = if_else(
      condition = BeachName == "Beebe",
      true = 86002300,
      false = DNRID
    )
  )

df <- # add DNRID for Bertram
  df %>%
  mutate(
    DNRID = if_else(
      condition = BeachName == "Bertram",
      true = 86007000,
      false = DNRID
    )
  )

df <- # add DNRID for Collinwood
  df %>%
  mutate(
    DNRID = if_else(
      condition = BeachName == "Collinwood",
      true = 86029300,
      false = DNRID
    )
  )

df <- # add DNRID for Pleasant
  df %>%
  mutate(
    DNRID = if_else(
      condition = BeachName == "Pleasant",
      true = 86025100,
      false = DNRID
    )
  )

## Convert POSIXct to m/d/yyyy----

df <-
  df %>%
  mutate(
    Date = format(
      Date,
      "%m/%d/%Y"
    )
  )

# Save csv----

write_csv(
  x = df,
  file = here("MSP-beaches_WrightCounty_clean.csv")
)


