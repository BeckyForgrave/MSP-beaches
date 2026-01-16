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

# Functions ---------------------------------------------------------------
## Calculate geometric mean----
geomean <- function(df, window) {
               # df contains the following cols: Date (contains date info),
               # Meas_value (contains values to be used for calculating
               # geometric mean)
               # window is numeric to indicate how many days prior to date of
               # interest to include when calculating geometric mean
  row_count <- nrow(df)                   # Create variable with length of df
  output_geomean <- numeric(row_count)    # Create vector to store calculations
  output_n <- numeric(row_count)          # Create vector to store sample size
  col_geomean <- paste(                   # Create col name for geometric mean
    "Ecoli_",
    as.character(window), 
    "dGM", 
    sep = ""
    )
  col_n <- paste(                         # Create col name for sample size
    "Ecoli_",
    as.character(window), 
    "dGM_n", 
    sep = ""
    )
  
  for (i in seq_len(row_count)) {        # Compute following for each row in df
    index_match <-                       # Find indices in desired date range
      df$Date >= as_date(df$Date[i]) - window &
      df$Date <= as_date(df$Date[i])
    
    n_count <- length(                   # Find sample size
      which(index_match == TRUE)
      )
    
    calc_prod <- prod(                   # Find the product of values
      df$Meas_value[index_match],
      na.rm = TRUE                       # Do not include missing values
    )
    calc_base <- calc_prod^(1/n_count)   # Find product to power of 1/n
    
    output_geomean[i] <- calc_base       # add geometric mean to vector
    output_n[i] <- n_count               # add sample size to vector
  }                                      # end "for" loop
  
  if(any(df$Meas_value == 0)) {          # Check for any 0's in data
    print("At least one 0 present in data")
  } else {
    print("Calculations complete")
  }                                      # end "if" loop
  
  df[[col_geomean]] <- with(             # add geometric mean vector to df
    df, output_geomean
    )
  df[[col_n]] <- with(                   # add sample size vector to df
    df, output_n
    )
  return(df)                             # output = updated df
}                                        # end function

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

# Filter for ecoli data and year >= 2007 ----------------------------------
ecoli <- bloomington_long %>%
  filter(
    Meas_type == "ecoli" &
      Date >= "2007-01-01"
  )

# Calculate geometric means -----------------------------------------------
ecoli_geomean <- geomean(    # calculate 1 day mean
  ecoli, 1
)

ecoli_geomean <- geomean(    # calculate 30 day mean
  ecoli_geomean, 30
)

# Find beach closures -----------------------------------------------------
## Priority 1: 1 day geometric mean > 235
## Priority 2: 30 geometric mean > 126
ecoli_geomean <- ecoli_geomean %>%
  mutate(
    ClosureYN = if_else(        # closures for 1 day geomean > 235
      Ecoli_1dGM > 235,
      true = "Y",
      false = "N"
    ),
    ClosureReason = if_else(   # closure reason for 1 day geomean > 235
      Ecoli_1dGM > 235,
      true = "ecoli_1dayGM",
      false = NA
    ),
    ClosureYN = if_else(        # closures for 30 day geomean > 126
      Ecoli_30dGM > 126 &
        is.na(ClosureReason),
      true = "Y",
      false = ClosureYN
    ),
    ClosureReason = if_else(   # closure reason for 30 day geomean > 126
      Ecoli_30dGM > 126 &
        is.na(ClosureReason),
      true = "ecoli_30dayGM",
      false = ClosureReason
    )
  )

# Finish standardizing df for analysis ------------------------------------
str(ecoli_geomean)

ecoli_geomean <- ecoli_geomean %>%
  rename(                              # rename units col
    Ecoli_units = Meas_unit
  ) %>%
  select(                              # keep needed cols
    DOW, Date, Ecoli_1dGM, Ecoli_30dGM, Ecoli_units, ClosureYN, ClosureReason, 
    MonitoringOrg
  ) %>%
  mutate(                              # add beach name to df
    BeachName = "Bush Lake Beach",
    .before = DOW
  )

# Save as csv -------------------------------------------------------------
write_csv(
  ecoli_geomean,
  file = here("MSP-beaches_Bloomington_clean.csv")
)


  
