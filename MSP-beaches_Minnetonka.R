# Cleaning raw data on beach closures from Minnetonka ---------------------
## Code written by Julia D Grabow
## Started on 07 July 20256

# Purpose of code ---------------------------------------------------------
## Clean Minnetonka beach closure/E. coli data
## Prep the data to be used in master sheet of all beach data

# Packages to load --------------------------------------------------------

library(tidyverse)
library(googledrive)
library(readxl)
library(here)

# Data to import ----------------------------------------------------------
## import data from google drive

drive_download( # download spreadsheet from google drive
  file = as_id("https://docs.google.com/spreadsheets/d/13-xpPApZdTUHl4wTFUecicuZW5CA3ElR/edit?gid=1897849526#gid=1897849526"),
  path = here("MSP-beaches_Minnetonka_raw.xlsx")
)

path <- here("MSP-beaches_Minnetonka_raw.xlsx")

x <- # import first sheet
  read_xlsx(
    path = path,
    sheet = 1
  )

name <- names(x)[1] # grab lake name

names(x) <- x[1, ] # Make first row into column names
x <- x[-1, ] # Remove first row

colnames(x)[11] <- "Temporary1" # name unnamed col
colnames(x)[12] <- "Temporary2" # name unnamed col

x <- # add lake name column
  x %>%
  mutate(
    BeachName = str_remove(
      string = name,
      pattern = " Beach"
    ),
    .before = Date
  )

## standardize col names

str(x)

x <- # standardize col names
  x %>%
  rename(
    "sample1" = ES,
    "sample2" = ED,
    "sample3" = WS,
    "sample4" = WD,
    "sample5" = C
    )

y <- # import second sheet
  read_xlsx(
    path = path,
    sheet = 2
  )

name <- names(y)[1] # grab lake name

names(y) <- y[1, ] # Make first row into column names
y <- y[-1, ] # Remove first row

colnames(y)[11] <- "Temporary1" # name unnamed col
colnames(y)[12] <- "Temporary2" # name unnamed col

y <- # add lake name
  y %>%
  mutate(
    BeachName = str_remove(
      string = name,
      pattern = " Beach"
    ),
    .before = Date
  )

## standardize col names

str(y)

y <- # standardize col names
  y %>%
  rename(
    "sample1" = SS,
    "sample2" = SD,
    "sample3" = NS,
    "sample4" = ND,
    "sample5" = C
  )

minnetonka_raw <- # bind the df's into one
  rbind(x, y)

minnetonka <- minnetonka_raw # create df to manipulate

# Look at format of df's----

str(minnetonka)
summary(minnetonka)

# Change values that are "<1" to 1----

Expected <-
  length(which(minnetonka$sample1 == "<1")) +
  length(which(minnetonka$sample1 == "1")) +
  length(which(minnetonka$sample2 == "<1")) +
  length(which(minnetonka$sample2 == "1")) +
  length(which(minnetonka$sample3 == "<1")) +
  length(which(minnetonka$sample3 == "1")) +
  length(which(minnetonka$sample4 == "<1")) +
  length(which(minnetonka$sample4 == "1")) +
  length(which(minnetonka$sample5 == "<1")) +
  length(which(minnetonka$sample5 == "1"))

minnetonka <-
  minnetonka %>%
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

length(which(minnetonka$sample1 == "1")) +
  length(which(minnetonka$sample2 == "1")) +
  length(which(minnetonka$sample3 == "1")) +
  length(which(minnetonka$sample4 == "1")) +
  length(which(minnetonka$sample5 == "1")) == Expected # True


# Convert numeric rows from character to numeric----

minnetonka <-
  minnetonka %>%
  mutate(
    across(
      .cols = 2:7,
      .fns = as.numeric
    )
  )

# Convert numeric to date----

minnetonka <- # convert numeric date to date format
  minnetonka %>%
  mutate(
    Date = as_date(
      Date,
      origin = "1899-12-30"
    )
  )
   
str(minnetonka)
summary(minnetonka)

## One row did not convert correctly -> this is Libbs Lake during 2016
## No data, remove this row

Expected <- nrow(minnetonka) - 1

minnetonka <-
  minnetonka %>%
  drop_na(
    "sample1"
  )

nrow(minnetonka) == Expected

# To notes column, use language provided by BF for contamination and retesting

unique(minnetonka$Notes)

minnetonka <- # create new notes col using a temporary col, rename original notes col
  minnetonka %>%
  rename(
    Temporary3 = Notes,
    Notes = Temporary2
  )

minnetonka <- # make Notes col only NA values
  minnetonka %>%
  mutate(
    Notes = NA
  )

minnetonka <- # note that contaminated and retested data as suspicioius
  minnetonka %>%
  mutate(
    Notes = if_else(
      condition = Temporary3 == "**Possible contamination",
      true = "potential sample contamination",
      false = Notes
    ),
    Notes = if_else(
      condition = Temporary3 == "Retest of WS was 6.3",
      true = "used retested water sample for geometric mean",
      false = Notes
    )
  )

# Remove unneeded cols (clearing clutter)

minnetonka <-
  minnetonka %>%
  select(
    !c(
      "Composite E. coli (CFU/100ml)",
      "5-Sample Geo. Mean E. coli (CFU/100ml)",
      "Ambient Water Temp. oF",
      Temporary3,
      Temporary1
    )
  )

# Calculate geometric mean for sampling date----
## pivot longer----

Expected <-
  nrow(minnetonka) * 5

minnetonka <-
  minnetonka %>%
  pivot_longer(
    cols = c(sample1, sample2, sample3, sample4, sample5),
    names_to = "SampleID",
    values_to = "Meas"
  )

nrow(minnetonka) == Expected # True

## calculate product for each sampling date per site----

minnetonka <-
  minnetonka %>%
  mutate(
    product = prod(Meas),
    .by = c(BeachName, Date)
  )

## determine how many sample size for each date per site----

minnetonka <-
  minnetonka %>%
  mutate(
    n = n(),
    .by = c(BeachName, Date)
  )

## find the nth log of the products----

minnetonka <-
  minnetonka %>%
  mutate(
    Ecoli_1dGM = product^(1/n),
    .by = c(BeachName, Date)
  )

# Find 30 day geometric mean----
## create separate df for 30 day calculations----

x <- minnetonka

## keep only needed cols----

x <-
  x %>%
  select(
    BeachName, Date, SampleID, Meas
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

## determine how many sample size for each date per site----

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
  ) %>%
  unique() %>%
  arrange(BeachName.x, Date.x)

## Rename cols----

z <-
  z %>%
  rename(
    BeachName = BeachName.x,
    Date = Date.x
  )

## add to minnetonka df----
### drop unneeded cols from z and minnetonka dfs

minnetonka <-
  minnetonka %>%
  select( # remove unneeded cols
    !c(SampleID, Meas, product, n)
  ) %>%
  distinct() # keep only unique rows

### merge both df's into one

minnetonka <-
  left_join(
    x = minnetonka,
    y = z,
    by = c("BeachName", "Date")
  )

# Note when beach closed due to high ecoli levels----

minnetonka %>% filter(Ecoli_1dGM > 1260) %>% nrow
# There are 0 days when 1 day gm > 1260

minnetonka %>% filter(Ecoli_30dGM > 126) %>% nrow()
# There are 5 days when 30 day gm > 126

## Do not need to note when beach closed due to E. coli levels

# Standardize df to match master df----
## Add missing cols with single value----

minnetonka <-
  minnetonka %>%
  mutate(
    Ecoli_units = "cfu",
    Entero_avg_cfu = NA,
    Microcystin_ugL = NA,
    Cylindro_ugL = NA,
    Anatoxin_ugL = NA,
    ClosureYN = "N",
    ClosureReason = NA,
    MonitoringOrg = "Minnetonka"
  )

## add cols with values based on another col----
## DNRID for shady oak = 27008900
## DNRID for libbs lake = 27008500

minnetonka <- # add DNRID for shady oak
  minnetonka %>%
  mutate(
    DNRID = if_else(
      condition = BeachName == "Shady Oak",
      true = 27008900,
      false = NA
    )
  )

minnetonka <- # add DNRID for Libbs Lake
  minnetonka %>%
  mutate(
    DNRID = if_else(
      condition = BeachName == "Libbs Lake",
      true = 27008500,
      false = DNRID
    )
  )

## Convert POSIXct to m/d/yyyy----

minnetonka <-
  minnetonka %>%
  mutate(
    Date = format(
      Date,
      "%m/%d/%Y"
    )
  )

# Save csv----

write_csv(
  x = minnetonka,
  file = here("MSP-beaches_Minnetonka_clean.csv")
)

# Upload to Google Drive
