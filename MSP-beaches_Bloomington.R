# MSP-beaches_Bloomington -------------------------------------------------
## Code written by Julia Dawn Grabow
## Code written on 07 January 2026

# Purpose -----------------------------------------------------------------
## Prep ecoli data for Bush Beach from Bloomington to be used in beach analysis
## Using spreadsheet with all compiled raw data rather than cleaning each
## spreadsheet separately in R (variation in how data was kept over the years
## makes it less efficient to clean in R)

# Packages ----------------------------------------------------------------
library(tidyverse)
library(readxl)
library(googledrive)
library(here)

# Files -------------------------------------------------------------------
## Download file from Drive
drive_download(
  file = "https://docs.google.com/spreadsheets/d/18D1RAQ3k0lGTkIaANcopXyoh-aCawi7p6Lb_eEzE8pk/edit?gid=0#gid=0",
  path = here("MSP-beaches_Bloomington_raw.xlsx"),
  overwrite = TRUE
)

## Read file into R
bloomington_raw <- read_excel(
  path = "MSP-beaches_Bloomington_raw.xlsx"
)

# Check data --------------------------------------------------------------
## Create copy to manipulate
bloomington_wide <- bloomington_raw

## Look at how it imported in
str(bloomington_wide)
## Date imported as POSIXct (yay!)
## SheetNumber imported as numeric, all other cols are character
## NA is a character string, and there are relational operators in some of the
## columns with measurements

# Clean -------------------------------------------------------------------
## Note: measurements with two values (e.g. xxx (xxx)) will be converted to
## NA until it is decided how to handle these values
bloomington_long <- bloomington_wide %>%
  pivot_longer(                          # pivot df longer
    cols = 5:18,
    names_to = "Meas_type",
    values_to = "Meas_value"
  ) %>%
  separate_wider_delim(                  # create cols with meas type, unit, 
                                         # and lab
    cols = Meas_type,
    delim = "_",
    names = c("Meas_type", "Meas_unit", "Lab")
  ) %>%
  mutate(
    across(                              # change "NA" to NA
      .cols = c(3:4, 12:15),
      .fns = ~ if_else(
        .x == "NA",
        true = NA,
        false = .x
      )
    ),
    Meas_value = if_else(                # Change values below detection limit 
                                         # to 1
      str_detect(Meas_value, "<"),
      true = "1",
      false = Meas_value
    ),
    Meas_value = str_remove(             # Remove > from any values
      Meas_value, ">"
    ),
    Meas_value = as.numeric(Meas_value)  # Change Meas_value to numeric class
  ) %>%
  drop_na(Meas_value)                    # Drop rows with missing values

# Look at composition of data ---------------------------------------------
str(bloomington_long)
summary(bloomington_long)

ecoli <- bloomington_long %>%
  filter(
    Meas_type == "ecoli" |
      str_detect(NotesJDG, "ecoli")
    )
nrow(ecoli)
## There are 1152 data points for ecoli measurements (most likely)

unique(ecoli$SiteID)
check <- ecoli %>%
  filter(
    str_detect(
      SiteID, "A"
    ) |
      str_detect(
        SiteID, "B"
      )
  )
nrow(check)
## There are 225 rows with information based on depth of lake (shallow or deep)

check <- ecoli %>%
  filter(
    str_detect(
      SiteID, '\\+'
    )
  )
nrow(check)
## There are 100 rows that combine shallow and deep samples

summary(ecoli)
## Dates range from 2003 to 2024

check <- ecoli %>%
  filter(
    Date >= "2000-01-01" & Date <= "2024-12-31"
  )
unique(check$SiteID)
unique(check$SiteType)
unique(check$Lab)

length(which(check$Lab == "wl"))
length(which(check$Lab == "mpls"))
sum(is.na(check$Lab))
