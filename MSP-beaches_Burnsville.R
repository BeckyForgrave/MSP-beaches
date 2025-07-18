# Cleaning raw data on beach closures from Burnsville ---------------------
## Code written by Julia D Grabow
## Started on 10 July 20256

# Purpose of code ---------------------------------------------------------
## Clean Burnsville beach closure/E. coli data
## Prep the data to be used in master sheet of all beach data

# Packages to load --------------------------------------------------------

library(tidyverse)
library(googledrive)
library(readxl)
library(here)

# Data to import ----------------------------------------------------------
## import data from google drive----

drive_download( # download spreadsheet from google drive
  file = as_id("https://docs.google.com/spreadsheets/d/1cn1F6_WxtGAn6vmrKq85R_nspRqUmiWH/edit?gid=1055589727#gid=1055589727"),
  path = here("MSP-beaches_Burnsville_raw.xlsx")
)

## import file into R----
### create path to spreadsheet:
path <- here("MSP-beaches_Burnsville_raw.xlsx")
### create object that lists all sheet names in spreadsheet
sheet_names <- excel_sheets(path)

burnsville <- # import all sheets as df's in a list
  map(
    .x = sheet_names,
    .f = ~ read_xlsx(
      path = path,
      sheet = .x
    )
  )

names(burnsville) <- sheet_names # give each element the sheet name

# Clean "2024" element----

x <-
  burnsville[[1]]

str(x)

## Rename cols----
### col2 = Sample1
### col3 = Sample2
### col4 = Sample3
### col5 = Date

x <-
  x %>%
  rename(
    "Sample1" = 2,
    "Sample2" = 3,
    "Sample3" = 4,
    "Date" = 5
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "Sample1", "Sample2", "Sample3", "Date"
  )

## Keep only numeric data----
### There are fifteen weeks with measurements, final df should have 15 rows

Expected = 15

x <-
  x %>%
  mutate(
    across(
      .cols = 1:4,
      .fns = as.numeric
    )
  ) %>%
  drop_na()

nrow(y) == Expected # True

## Create df for all data----

df <- x

# Clean "2023" element----

x <-
  burnsville[[2]]

## Rename cols----
### col2 = Sample1
### col3 = Sample2
### col4 = Sample3
### col5 = Date

x <-
  x %>%
  rename(
    "Sample1" = 2,
    "Sample2" = 3,
    "Sample3" = 4,
    "Date" = 5
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "Sample1", "Sample2", "Sample3", "Date"
  )

## Keep only numeric data----
### There are 14 weeks with measurements, final df should have 14 rows

Expected = 14

x <-
  x %>%
  mutate(
    across(
      .cols = 1:4,
      .fns = as.numeric
    )
  ) %>%
  drop_na()

nrow(x) == Expected # True

## Add to df----

Expected <- nrow(df) + nrow(x)

df <-
  rbind(
    df, x
  )

nrow(df) == Expected # True

# Clean "2022" element----

x <-
  burnsville[[3]]

## Rename cols----
### col2 = Sample1
### col3 = Sample2
### col4 = Sample3
### col5 = Date

x <-
  x %>%
  rename(
    "Sample1" = 2,
    "Sample2" = 3,
    "Sample3" = 4,
    "Date" = 5
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "Sample1", "Sample2", "Sample3", "Date"
  )

## Keep only numeric data----
### There are 14 weeks with measurements, final df should have 14 rows

Expected = 14

x <-
  x %>%
  mutate(
    across(
      .cols = 1:4,
      .fns = as.numeric
    )
  ) %>%
  drop_na()

nrow(x) == Expected # True

## Add to df----

Expected <- nrow(df) + nrow(x)

df <-
  rbind(
    df, x
  )

nrow(df) == Expected # True

# Clean "2021" element----

x <-
  burnsville[[4]]

## 15 sampling dates
## sample unit = mpn

## Rename cols----
### col2 = Sample1
### col3 = Sample2
### col4 = Sample3
### col5 = Date

x <-
  x %>%
  rename(
    "Sample1" = 2,
    "Sample2" = 3,
    "Sample3" = 4,
    "Date" = 5
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "Sample1", "Sample2", "Sample3", "Date"
  )

## Keep only numeric data----
### There are 15 weeks with measurements, final df should have 15 rows

Expected = 15

x <-
  x %>%
  mutate(
    across(
      .cols = 1:4,
      .fns = as.numeric
    )
  ) %>%
  drop_na()

nrow(x) == Expected # True

## Add to df----

Expected <- nrow(df) + nrow(x)

df <-
  rbind(
    df, x
  )

nrow(df) == Expected # True

# Clean "2020" element----

x <-
  burnsville[[5]]

## 15 sampling dates
## sample unit = mpn

## Rename cols----
### col2 = Sample1
### col3 = Sample2
### col4 = Sample3
### col5 = Date

x <-
  x %>%
  rename(
    "Sample1" = 2,
    "Sample2" = 3,
    "Sample3" = 4,
    "Date" = 5
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "Sample1", "Sample2", "Sample3", "Date"
  )

## Keep only numeric data----
### df will have 15 rows

Expected = 15

x <-
  x %>%
  mutate(
    across(
      .cols = 1:4,
      .fns = as.numeric
    )
  ) %>%
  drop_na()

nrow(x) == Expected # True

## Add to df----

Expected <- nrow(df) + nrow(x)

df <-
  rbind(
    df, x
  )

nrow(df) == Expected # True

# Clean "2019" element----

x <-
  burnsville[[6]]

## 15 sampling dates
## sample unit = mpn

## Rename cols----
### col2 = Sample1
### col3 = Sample2
### col4 = Sample3
### col5 = Date

x <-
  x %>%
  rename(
    "Sample1" = 2,
    "Sample2" = 3,
    "Sample3" = 4,
    "Date" = 5
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "Sample1", "Sample2", "Sample3", "Date"
  )

## Keep only numeric data----
### df will have 15 rows

Expected = 15

x <-
  x %>%
  mutate(
    across(
      .cols = 1:4,
      .fns = as.numeric
    )
  ) %>%
  drop_na()

nrow(x) == Expected # True

## Add to df----

Expected <- nrow(df) + nrow(x)

df <-
  rbind(
    df, x
  )

nrow(df) == Expected # True

# Clean "2018" element----

x <-
  burnsville[[7]]

## 14 sampling dates
## sample unit = mpn

## Rename cols----
### will not use site AL
### col2 = Sample1
### col3 = Sample2
### col4 = Sample3
### col7 = Date

x <-
  x %>%
  rename(
    "Sample1" = 2,
    "Sample2" = 3,
    "Sample3" = 4,
    "Date" = 7
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "Sample1", "Sample2", "Sample3", "Date"
  )

## Keep only numeric data----
### df will have 14 rows

Expected = 14

x <-
  x %>%
  mutate(
    across(
      .cols = 1:4,
      .fns = as.numeric
    )
  ) %>%
  drop_na()

nrow(x) == Expected # True

## Add to df----

Expected <- nrow(df) + nrow(x)

df <-
  rbind(
    df, x
  )

nrow(df) == Expected # True

# Clean "2017" element----

x <-
  burnsville[[8]]

## 14 sampling dates
## sample unit = mpn

## Rename cols----
### will not use site AL
### col2 = Sample1
### col3 = Sample2
### col4 = Sample3
### col7 = Date

x <-
  x %>%
  rename(
    "Sample1" = 2,
    "Sample2" = 3,
    "Sample3" = 4,
    "Date" = 7
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "Sample1", "Sample2", "Sample3", "Date"
  )

## last row has different date entry----
### remove * from date

x <-
  x %>%
  mutate(
    Date = str_remove(
      string = Date,
      pattern = "\\*"
    )
  )

### extract row with odd date
#### locate row in which this date occurs

row_remove <- which(x$Date == "8/28/2017") # create object with row #
y <- x[row_remove, ] # put row in a new df
x <- x[-(row_remove), ] # remove row from main df

### create a df_alternate and add this to it
### will add this to main df when it has date format

df_alt <- y

## Keep only numeric data----
### df will have 13 rows
##

Expected = 13

x <-
  x %>%
  mutate(
    across(
      .cols = 1:4,
      .fns = as.numeric
    )
  ) %>%
  drop_na()

nrow(x) == Expected # True

## Add to df----

Expected <- nrow(df) + nrow(x)

df <-
  rbind(
    df, x
  )

nrow(df) == Expected # True

# Clean "2016" element----

x <-
  burnsville[[9]]

## 14 sampling dates
## sample unit = mpn

## Rename cols----
### will not use site AL
### col2 = Sample1
### col3 = Sample2
### col4 = Sample3
### col7 = Date

x <-
  x %>%
  rename(
    "Sample1" = 2,
    "Sample2" = 3,
    "Sample3" = 4,
    "Date" = 7
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "Sample1", "Sample2", "Sample3", "Date"
  )

## Keep only numeric data----
### df will have 14 rows
##

Expected = 14

x <-
  x %>%
  mutate(
    across(
      .cols = 1:4,
      .fns = as.numeric
    )
  ) %>%
  drop_na()

nrow(x) == Expected # True

## Add to df----

Expected <- nrow(df) + nrow(x)

df <-
  rbind(
    df, x
  )

nrow(df) == Expected # True

# Clean "2015" element----

x <-
  burnsville[[10]]

## 15 sampling dates
## sample unit = mpn

## Rename cols----
### will not use site AL
### col2 = Sample1
### col3 = Sample2
### col4 = Sample3
### col7 = Date

x <-
  x %>%
  rename(
    "Sample1" = 2,
    "Sample2" = 3,
    "Sample3" = 4,
    "Date" = 7
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "Sample1", "Sample2", "Sample3", "Date"
  )

## drop unneeded rows (that also contain numeric data that is a summary from
### the sampling data)

x <-
  x[1:18, ]

## Keep only numeric data----
### df will have 15 rows
##

Expected = 15

x <-
  x %>%
  mutate(
    across(
      .cols = 1:4,
      .fns = as.numeric
    )
  ) %>%
  drop_na()

nrow(x) == Expected # True

## Add to df----

Expected <- nrow(df) + nrow(x)

df <-
  rbind(
    df, x
  )

nrow(df) == Expected # True

# Clean "2014" element----

x <-
  burnsville[[11]]

## 14 sampling dates
## sample unit = mpn

## Rename cols----
### will not use site AL
### col2 = Sample1
### col3 = Sample2
### col4 = Sample3
### col7 = Date

x <-
  x %>%
  rename(
    "Sample1" = 2,
    "Sample2" = 3,
    "Sample3" = 4,
    "Date" = 7
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "Sample1", "Sample2", "Sample3", "Date"
  )

## Keep only numeric data----
### df will have 14 rows
##

Expected = 14

x <-
  x %>%
  mutate(
    across(
      .cols = 1:4,
      .fns = as.numeric
    )
  ) %>%
  drop_na()

nrow(x) == Expected # True

## Add to df----

Expected <- nrow(df) + nrow(x)

df <-
  rbind(
    df, x
  )

nrow(df) == Expected # True

# Clean "2013" element----

x <-
  burnsville[[12]]

## 14 sampling dates
## sample unit = mpn

## Rename cols----
### will not use site AL
### col2 = Sample1
### col3 = Sample2
### col4 = Sample3
### col7 = Date

x <-
  x %>%
  rename(
    "Sample1" = 2,
    "Sample2" = 3,
    "Sample3" = 4,
    "Date" = 7
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "Sample1", "Sample2", "Sample3", "Date"
  )

## drop unneeded rows (that also contain numeric data that is a summary from
### the sampling data)

x <-
  x[1:18, ]

## Keep only numeric data----
### df will have 14 rows
##

Expected = 14

x <-
  x %>%
  mutate(
    across(
      .cols = 1:4,
      .fns = as.numeric
    )
  ) %>%
  drop_na()

nrow(x) == Expected # True

## Add to df----

Expected <- nrow(df) + nrow(x)

df <-
  rbind(
    df, x
  )

nrow(df) == Expected # True

# stopped here---














