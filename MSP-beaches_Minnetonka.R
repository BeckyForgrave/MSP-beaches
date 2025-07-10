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

# Change values that are "<1" to 0

minnetonka <-
  minnetonka %>%
  mutate(
    across(
      .cols = 3:9,
      .fns = ~ str_replace(
        string = .x,
        pattern = "<1",
        replacement = "0"
      )
    )
  )

# Convert numeric rows from character to numeric----

minnetonka <-
  minnetonka %>%
  mutate(
    across(
      .cols = 2:10,
      .fns = as.numeric
    )
  )

# Convert numeric to POSIXct----

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

minnetonka <-
  minnetonka %>%
  drop_na(
    "sample1"
  )

# Denote when beaches were closed----
## Look at values in non-numeric cols

str(minnetonka)
unique(minnetonka$Notes)
### retesting value = 6.3, possible contamination, CLOSED
unique(minnetonka$Temporary1)
### closed, CLOSED
unique(minnetonka$Temporary2)
### No notes that need recording

## Make changes to note beach closures and other notes----
### create beach closure col

minnetonka <-
  minnetonka %>%
  mutate( # replace value with retested value
    sample3 = if_else(
      condition = sample3 == 200.5,
      true = 6.3,
      false = sample3
    )
  )

x <- # create vector that identifies presence of closed in Notes col
  str_detect(
    string = minnetonka$Notes,
    pattern = "CLOSED"
  )

y <- # create vector that identifies presence of closed in Temporary1 col
  str_detect(
    string = minnetonka$Temporary1,
    pattern = "CLOSED | closed"
  )

minnetonka <- # add x and y as new cols to minnetonka
  minnetonka %>%
  mutate(
    Temporary3 = x,
    Temporary4 = y
  )

minnetonka <- # combine x and y cols into ClosureYN
  minnetonka %>%
  unite(
    col = "ClosureYN",
    Temporary3, Temporary4,
    sep = ""
  )

minnetonka <- # change true and false to Y and N
  minnetonka %>%
  mutate(
    ClosureYN = if_else(
      condition = str_detect(
        string = ClosureYN,
        pattern = "TRUE"
      ),
      true = "Y",
      false = "N"
    )
  )

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

# Create missing cols----
## cols with consistent values----

minnetonka <-
  minnetonka %>%
  mutate(
    Ecoli_30dGM = NA,
    Ecoli_units = "cfu",
    Entero_avg_cfu = NA,
    Microcystin_ugL = NA,
    Cylindro_ugL = NA,
    Anatoxin_ugL = NA,
    ClosureReason = NA,
    MonitoringOrg = "Minnetonka"
  )

## cols with values based on another col
## DNRID for shady oak = 27-0089
## DNRID for libbs lake = 27-0085

minnetonka <- # add DNRID for shady oak
  minnetonka %>%
  mutate(
    DNRID = if_else(
      condition = BeachName == "Shady Oak",
      true = "27-0089",
      false = NA
    )
  )

minnetonka <- # add DNRID for shady oak
  minnetonka %>%
  mutate(
    DNRID = if_else(
      condition = BeachName == "Libbs Lake",
      true = "27-0085",
      false = DNRID
    )
  )

# Rename temp col----

minnetonka <-
  minnetonka %>%
  rename(
    Temp_F = "Ambient Water Temp. oF"
  )

# Remove unneeded cols (clearing clutter)

minnetonka <-
  minnetonka %>%
  select(
    !c(
      "Composite E. coli (CFU/100ml)",
      "5-Sample Geo. Mean E. coli (CFU/100ml)",
      Temporary3,
      Temporary1
    )
  )

# Calculate geometric means----
## playing--how to calculate mean in current form of df
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

## calculate geometric mean----

minnetonka <-
  minnetonka %>%
  mutate(
    Ecoli_1dGM = exp(mean(log(Meas[Meas>0]))),
    .by = c(BeachName, Date),
    .after = Date
  ) %>%
  select(
    !c(SampleID, Meas)
  ) %>%
  distinct() 

# Note when beach closed due to high ecoli levels----

minnetonka <-
  minnetonka %>%
  mutate(
    ClosureReason = if_else(
      condition = Ecoli_1dGM > 126,
      true = "Ecoli_1dGM",
      false = ClosureReason
    )
  )

# Convert POSIXct to m/d/yyyy----

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
