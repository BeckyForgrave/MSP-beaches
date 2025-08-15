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
### units in mpn
# Only Crystal Lake

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

nrow(x) == Expected # True

## add measurement unit and beach name----

x <-
  x %>%
  mutate(
    Ecoli_units = "mpn",
    BeachName = "Crystal Beach"
  )

## Create df for all data----

df <- x

# Clean "2023" element----

x <-
  burnsville[[2]]

## units of measure == mpn
## Only Crystal Beach in this df

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

## add measurement unit and beach name----

x <-
  x %>%
  mutate(
    Ecoli_units = "mpn",
    BeachName = "Crystal Beach"
  )

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

## units == mpn
## only Crystal Beach in df

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

## add measurement unit and beach name----

x <-
  x %>%
  mutate(
    Ecoli_units = "mpn",
    BeachName = "Crystal Beach"
  )

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
## only Crystal Beach in df

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

## add measurement unit and beach name----

x <-
  x %>%
  mutate(
    Ecoli_units = "mpn",
    BeachName = "Crystal Beach"
  )

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
## only Crystal Beach in df

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

## add measurement unit and Beach name----

x <-
  x %>%
  mutate(
    Ecoli_units = "mpn",
    BeachName = "Crystal Beach"
  )

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
## only Crystal Beach in df

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

## add measurement unit and beach name----

x <-
  x %>%
  mutate(
    Ecoli_units = "mpn",
    BeachName = "Crystal Beach"
  )

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
## Crystal Beach and AL in this df
## AL appears to be Alimagnet Lake

## Rename cols----

### col2 = CL_Sample1
### col3 = CL_Sample2
### col4 = CL_Sample3
### col5 = AL_Sample1
### col6 = AL_Sample2
### col7 = Date

x <-
  x %>%
  rename(
    "CL_Sample1" = 2,
    "CL_Sample2" = 3,
    "CL_Sample3" = 4,
    "AL_Sample1" = 5,
    "AL_Sample2" = 6,
    "Date" = 7
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "CL_Sample1", "CL_Sample2", "CL_Sample3", "AL_Sample1", 
    "AL_Sample2", "Date"
  )

## Keep only numeric data----
### df will have 14 rows

Expected = 14

x <-
  x %>%
  mutate(
    across(
      .cols = 1:6,
      .fns = as.numeric
    )
  ) %>%
  drop_na()

nrow(x) == Expected # True

## Create col of samples and beach names----
### pivot longer to create column for beach names

x <-
  x %>%
  pivot_longer(
    cols = 1:5,
    names_to = "BeachName",
    values_to = "Meas"
  )

### split the BeachName col into two cols

x <-
  x %>%
  separate_wider_delim(
    cols = BeachName,
    delim = "_",
    names = c("BeachName", "Sample")
  )

### add actual names of beaches

x <-
  x %>%
  mutate(
    BeachName = if_else(
      condition = BeachName == "CL",
      true = "Crystal Beach",
      false = "Alimagnet"
    )
  )

### pivot wider

x <-
  x %>%
  pivot_wider(
    names_from = Sample,
    values_from = Meas
  )

## add measurement unit----

x <-
  x %>%
  mutate(
    Ecoli_units = "mpn"
  )

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
### Crystal beach and Alimagnet
### col2 = CL_Sample1
### col3 = CL_Sample2
### col4 = CL_Sample3
### col5 = AL_Sample1
### col6 = AL_Sample2
### col7 = Date

x <-
  x %>%
  rename(
    "CL_Sample1" = 2,
    "CL_Sample2" = 3,
    "CL_Sample3" = 4,
    "AL_Sample1" = 5,
    "AL_Sample2" = 6,
    "Date" = 7
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "CL_Sample1", "CL_Sample2", "CL_Sample3", "AL_Sample1", 
    "AL_Sample2", "Date"
  )

## Keep only needed rows----
### df will have 14 rows

Expected = 14

x <-
  x[4:17, ]

nrow(x) == Expected # True

## change cols 1-5 to numeric----

x <-
  x %>%
  mutate(
    across(
      .cols = 1:5,
      .fns = as.numeric
    )
  )

## Create col of samples and beach names----
### pivot longer to create column for beach names

x <-
  x %>%
  pivot_longer(
    cols = 1:5,
    names_to = "BeachName",
    values_to = "Meas"
  )

### split the BeachName col into two cols

x <-
  x %>%
  separate_wider_delim(
    cols = BeachName,
    delim = "_",
    names = c("BeachName", "Sample")
  )

### add actual names of beaches

x <-
  x %>%
  mutate(
    BeachName = if_else(
      condition = BeachName == "CL",
      true = "Crystal Beach",
      false = "Alimagnet"
    )
  )

### pivot wider

x <-
  x %>%
  pivot_wider(
    names_from = Sample,
    values_from = Meas
  )

## add measurement unit----

x <-
  x %>%
  mutate(
    Ecoli_units = "mpn"
  )

## create temporary df with row with different date format----
### filter for different date format

add_to_df <-
  x %>%
  filter(
    Date == "8/28/2017*"
  )

### remove asterisk

add_to_df <-
  add_to_df %>%
  mutate(
    Date = str_remove(
      string = Date,
      pattern = "\\*"
    )
  )

### put into date format

add_to_df <-
  add_to_df %>%
  mutate(
    Date = mdy(Date)
  )

class(add_to_df$Date)

## Change date col in df to numeric format----
### drop rows with odd date format

x <-
  x %>%
  filter(
    Date != "8/28/2017*"
  )

x <-
  x %>%
  mutate(
    Date = as.numeric(Date)
  )

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
## Crystal Beach and AL in this df
## AL appears to be Alimagnet Lake

## Rename cols----

### col2 = CL_Sample1
### col3 = CL_Sample2
### col4 = CL_Sample3
### col5 = AL_Sample1
### col6 = AL_Sample2
### col7 = Date

x <-
  x %>%
  rename(
    "CL_Sample1" = 2,
    "CL_Sample2" = 3,
    "CL_Sample3" = 4,
    "AL_Sample1" = 5,
    "AL_Sample2" = 6,
    "Date" = 7
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "CL_Sample1", "CL_Sample2", "CL_Sample3", "AL_Sample1", 
    "AL_Sample2", "Date"
  )

## Keep only numeric data----
### df will have 14 rows

Expected = 14

x <-
  x %>%
  mutate(
    across(
      .cols = 1:6,
      .fns = as.numeric
    )
  ) %>%
  drop_na()

nrow(x) == Expected # True

## Create col of samples and beach names----
### pivot longer to create column for beach names

x <-
  x %>%
  pivot_longer(
    cols = 1:5,
    names_to = "BeachName",
    values_to = "Meas"
  )

### split the BeachName col into two cols

x <-
  x %>%
  separate_wider_delim(
    cols = BeachName,
    delim = "_",
    names = c("BeachName", "Sample")
  )

### add actual names of beaches

x <-
  x %>%
  mutate(
    BeachName = if_else(
      condition = BeachName == "CL",
      true = "Crystal Beach",
      false = "Alimagnet"
    )
  )

### pivot wider

x <-
  x %>%
  pivot_wider(
    names_from = Sample,
    values_from = Meas
  )

## add measurement unit----

x <-
  x %>%
  mutate(
    Ecoli_units = "mpn"
  )

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
## Crystal Beach and AL in this df
## AL appears to be Alimagnet Lake

## Rename cols----

### col2 = CL_Sample1
### col3 = CL_Sample2
### col4 = CL_Sample3
### col5 = AL_Sample1
### col6 = AL_Sample2
### col7 = Date

x <-
  x %>%
  rename(
    "CL_Sample1" = 2,
    "CL_Sample2" = 3,
    "CL_Sample3" = 4,
    "AL_Sample1" = 5,
    "AL_Sample2" = 6,
    "Date" = 7
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "CL_Sample1", "CL_Sample2", "CL_Sample3", "AL_Sample1", 
    "AL_Sample2", "Date"
  )

## Keep only needed rows----
### df will have 15 rows

Expected = 15

x <-
  x[4:18, ]

nrow(x) == Expected # True

## change cols to numeric----

x <-
  x %>%
  mutate(
    across(
      .cols = 1:6,
      .fns = as.numeric
    )
  )

## Create col of samples and beach names----
### pivot longer to create column for beach names

x <-
  x %>%
  pivot_longer(
    cols = 1:5,
    names_to = "BeachName",
    values_to = "Meas"
  )

### split the BeachName col into two cols

x <-
  x %>%
  separate_wider_delim(
    cols = BeachName,
    delim = "_",
    names = c("BeachName", "Sample")
  )

### add actual names of beaches

x <-
  x %>%
  mutate(
    BeachName = if_else(
      condition = BeachName == "CL",
      true = "Crystal Beach",
      false = "Alimagnet"
    )
  )

### pivot wider

x <-
  x %>%
  pivot_wider(
    names_from = Sample,
    values_from = Meas
  )

## add measurement unit----

x <-
  x %>%
  mutate(
    Ecoli_units = "mpn"
  )

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
## Crystal Beach and AL in this df
## AL appears to be Alimagnet Lake

## Rename cols----

### col2 = CL_Sample1
### col3 = CL_Sample2
### col4 = CL_Sample3
### col5 = AL_Sample1
### col6 = AL_Sample2
### col7 = Date

x <-
  x %>%
  rename(
    "CL_Sample1" = 2,
    "CL_Sample2" = 3,
    "CL_Sample3" = 4,
    "AL_Sample1" = 5,
    "AL_Sample2" = 6,
    "Date" = 7
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "CL_Sample1", "CL_Sample2", "CL_Sample3", "AL_Sample1", 
    "AL_Sample2", "Date"
  )

## Keep only numeric data----
### df will have 14 rows

Expected = 14

x <-
  x %>%
  mutate(
    across(
      .cols = 1:6,
      .fns = as.numeric
    )
  ) %>%
  drop_na()

nrow(x) == Expected # True

## Create col of samples and beach names----
### pivot longer to create column for beach names

x <-
  x %>%
  pivot_longer(
    cols = 1:5,
    names_to = "BeachName",
    values_to = "Meas"
  )

### split the BeachName col into two cols

x <-
  x %>%
  separate_wider_delim(
    cols = BeachName,
    delim = "_",
    names = c("BeachName", "Sample")
  )

### add actual names of beaches

x <-
  x %>%
  mutate(
    BeachName = if_else(
      condition = BeachName == "CL",
      true = "Crystal Beach",
      false = "Alimagnet"
    )
  )

### pivot wider

x <-
  x %>%
  pivot_wider(
    names_from = Sample,
    values_from = Meas
  )

## add measurement unit----

x <-
  x %>%
  mutate(
    Ecoli_units = "mpn"
  )

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
## sample unit = cfu
## Crystal Beach and AL in this df
## AL appears to be Alimagnet Lake

## Rename cols----

### col2 = CL_Sample1
### col3 = CL_Sample2
### col4 = CL_Sample3
### col5 = AL_Sample1
### col6 = AL_Sample2
### col7 = Date

x <-
  x %>%
  rename(
    "CL_Sample1" = 2,
    "CL_Sample2" = 3,
    "CL_Sample3" = 4,
    "AL_Sample1" = 5,
    "AL_Sample2" = 6,
    "Date" = 7
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "CL_Sample1", "CL_Sample2", "CL_Sample3", "AL_Sample1", 
    "AL_Sample2", "Date"
  )

## Keep only numeric data----
### df will have 14 rows

Expected = 14

x <-
  x %>%
  mutate(
    across(
      .cols = 1:6,
      .fns = as.numeric
    )
  ) %>%
  drop_na()

nrow(x) == Expected # True

## Create col of samples and beach names----
### pivot longer to create column for beach names

x <-
  x %>%
  pivot_longer(
    cols = 1:5,
    names_to = "BeachName",
    values_to = "Meas"
  )

### split the BeachName col into two cols

x <-
  x %>%
  separate_wider_delim(
    cols = BeachName,
    delim = "_",
    names = c("BeachName", "Sample")
  )

### add actual names of beaches

x <-
  x %>%
  mutate(
    BeachName = if_else(
      condition = BeachName == "CL",
      true = "Crystal Beach",
      false = "Alimagnet"
    )
  )

### pivot wider

x <-
  x %>%
  pivot_wider(
    names_from = Sample,
    values_from = Meas
  )

## add measurement unit----

x <-
  x %>%
  mutate(
    Ecoli_units = "cfu"
  )

## Add to df----

Expected <- nrow(df) + nrow(x)

df <-
  rbind(
    df, x
  )

nrow(df) == Expected # True

# Clean "2012" element----

x <-
  burnsville[[13]]

## 15 sampling dates
## sample unit = cfu except for week 6 which is in mpn
## Crystal Beach and AL in this df
## AL appears to be Alimagnet Lake

## Rename cols----

### col2 = CL_Sample1
### col3 = CL_Sample2
### col4 = CL_Sample3
### col5 = AL_Sample1
### col6 = AL_Sample2
### col7 = Date

x <-
  x %>%
  rename(
    "Week" = "...1",
    "CL_Sample1" = 2,
    "CL_Sample2" = 3,
    "CL_Sample3" = 4,
    "AL_Sample1" = 5,
    "AL_Sample2" = 6,
    "Date" = 7
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "Week","CL_Sample1", "CL_Sample2", "CL_Sample3", "AL_Sample1", 
    "AL_Sample2", "Date"
  )

## Keep only needed rows----
### df will have 15 rows

Expected = 15

x <-
  x[4:18, ]

nrow(x) == Expected # True

## change cols to numeric----

Expected <-
  length(which(x$AL_Sample1 == "~")) + length(which(x$AL_Sample2 == "~"))

x <-
  x %>%
  mutate(
    across(
      .cols = 2:7,
      .fns = as.numeric
    )
  )

sum(is.na(x)) == Expected 

## Create col of samples and beach names----
### pivot longer to create column for beach names

x <-
  x %>%
  pivot_longer(
    cols = 2:6,
    names_to = "BeachName",
    values_to = "Meas"
  )

### split the BeachName col into two cols

x <-
  x %>%
  separate_wider_delim(
    cols = BeachName,
    delim = "_",
    names = c("BeachName", "Sample")
  )

### add actual names of beaches

x <-
  x %>%
  mutate(
    BeachName = if_else(
      condition = BeachName == "CL",
      true = "Crystal Beach",
      false = "Alimagnet"
    )
  )

### pivot wider

x <-
  x %>%
  pivot_wider(
    names_from = Sample,
    values_from = Meas
  )

## add measurement unit----
### create col of "cfu"

x <-
  x %>%
  mutate(
    Ecoli_units = "cfu"
  )

### change unit to "mpn" for week 6

x <-
  x %>%
  mutate(
    Ecoli_units = if_else(
      condition = Week == "week 6***",
      true = "mpn",
      false = Ecoli_units
    )
  )

### remove col with weeks info

x <-
  x %>%
  select(
    !Week
  )

## Add to df----

Expected <- nrow(df) + nrow(x)

df <-
  rbind(
    df, x
  )

nrow(df) == Expected # True

# Clean "2011" element----

x <-
  burnsville[[14]]

## 14 sampling dates
## sample unit = cfu
## Crystal Beach and AL in this df
## AL appears to be Alimagnet Lake

## Rename cols----

### col2 = CL_Sample1
### col3 = CL_Sample2
### col4 = CL_Sample3
### col5 = AL_Sample1
### col6 = AL_Sample2
### col7 = Date

x <-
  x %>%
  rename(
    "CL_Sample1" = 2,
    "CL_Sample2" = 3,
    "CL_Sample3" = 4,
    "AL_Sample1" = 5,
    "AL_Sample2" = 6,
    "Date" = 7
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "CL_Sample1", "CL_Sample2", "CL_Sample3", "AL_Sample1", 
    "AL_Sample2", "Date"
  )

## Keep appropriate rows----
### df will have 14 rows

Expected = 14

x <-
  x[4:17, ]

nrow(x) == Expected # True

## Make cols numeric----

x <-
  x %>%
  mutate(
    across(
      .cols = 1:6,
      .fns = as.numeric
    )
  )

## Create col of samples and beach names----
### pivot longer to create column for beach names

x <-
  x %>%
  pivot_longer(
    cols = 1:5,
    names_to = "BeachName",
    values_to = "Meas"
  )

### split the BeachName col into two cols

x <-
  x %>%
  separate_wider_delim(
    cols = BeachName,
    delim = "_",
    names = c("BeachName", "Sample")
  )

### add actual names of beaches

x <-
  x %>%
  mutate(
    BeachName = if_else(
      condition = BeachName == "CL",
      true = "Crystal Beach",
      false = "Alimagnet"
    )
  )

### pivot wider

x <-
  x %>%
  pivot_wider(
    names_from = Sample,
    values_from = Meas
  )

## add measurement unit----
### create col of "cfu"

x <-
  x %>%
  mutate(
    Ecoli_units = "cfu"
  )

## Add to df----

Expected <- nrow(df) + nrow(x)

df <-
  rbind(
    df, x
  )

nrow(df) == Expected # True

# Clean "2010" element----

x <-
  burnsville[[15]]

# Cols to right of "Date Sampled" are geometric mean calculations

## 13 sampling dates
## There is no indication of what unit was used
## dates are in POSIXct
## last set of measurements have no associated date
## Crystal Beach and AL in this df
## AL appears to be Alimagnet Lake

## Rename cols----

### col1 = CL_Sample1
### col2 = CL_Sample2
### col3 = CL_Sample3
### col4 = AL_Sample1
### col5 = AL_Sample2
### col6 = Date

x <-
  x %>%
  rename(
    "CL_Sample1" = 1,
    "CL_Sample2" = 2,
    "CL_Sample3" = 3,
    "AL_Sample1" = 4,
    "AL_Sample2" = 5,
    "Date" = 6
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "CL_Sample1", "CL_Sample2", "CL_Sample3", "AL_Sample1", 
    "AL_Sample2", "Date"
  )

## Keep appropriate rows----
### df will have 13 rows

Expected = 13

x <-
  x[1:13, ]

nrow(x) == Expected # True

## Make cols (except date) numeric----

x <-
  x %>%
  mutate(
    across(
      .cols = 1:5,
      .fns = as.numeric
    )
  )

## check if Date is in date class

class(x$Date) #POSIXct, change to date

x <-
  x %>%
  mutate(
    Date = as_date(Date)
  )

class(x$Date)

## Create col of samples and beach names----
### pivot longer to create column for beach names

x <-
  x %>%
  pivot_longer(
    cols = 1:5,
    names_to = "BeachName",
    values_to = "Meas"
  )

### split the BeachName col into two cols

x <-
  x %>%
  separate_wider_delim(
    cols = BeachName,
    delim = "_",
    names = c("BeachName", "Sample")
  )

### add actual names of beaches

x <-
  x %>%
  mutate(
    BeachName = if_else(
      condition = BeachName == "CL",
      true = "Crystal Beach",
      false = "Alimagnet"
    )
  )

### pivot wider

x <-
  x %>%
  pivot_wider(
    names_from = Sample,
    values_from = Meas
  )

## add measurement unit----
### create col of NAs

x <-
  x %>%
  mutate(
    Ecoli_units = NA
  )

## add to add_to_df where Date is already class date----

Expected <- nrow(add_to_df) + nrow(x)

add_to_df <-
  rbind(
    add_to_df, x
  )

nrow(add_to_df) == Expected # True

# Clean "2008" element----

x <-
  burnsville[[16]]

# Cols further right of Date Sampled are geometric mean calculations
## 2 sampling dates
## There is no indication of what unit was used
## dates are in POSIXct
## Crystal Beach and Lac Lavon in this df

## Rename cols----

### col1 = CL_Sample1
### col2 = CL_Sample2
### col3 = CL_Sample3
### col4 = LL_Sample1
### col5 = LL_Sample2
### col6 = Date

x <-
  x %>%
  rename(
    "CL_Sample1" = 1,
    "CL_Sample2" = 2,
    "CL_Sample3" = 3,
    "LL_Sample1" = 4,
    "LL_Sample2" = 5,
    "Date" = 6
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "CL_Sample1", "CL_Sample2", "CL_Sample3", "LL_Sample1", 
    "LL_Sample2", "Date"
  )

## Keep appropriate rows----
### df will have 2 rows

Expected = 2

x <-
  x[1:2, ]

nrow(x) == Expected # True

## Make cols (except date) numeric----

x <-
  x %>%
  mutate(
    across(
      .cols = 1:5,
      .fns = as.numeric
    )
  )

## check if Date is in date class

class(x$Date) #POSIXct, change to date

x <-
  x %>%
  mutate(
    Date = as_date(Date)
  )

class(x$Date)

## Create col of samples and beach names----
### pivot longer to create column for beach names

x <-
  x %>%
  pivot_longer(
    cols = 1:5,
    names_to = "BeachName",
    values_to = "Meas"
  )

### split the BeachName col into two cols

x <-
  x %>%
  separate_wider_delim(
    cols = BeachName,
    delim = "_",
    names = c("BeachName", "Sample")
  )

### add actual names of beaches

x <-
  x %>%
  mutate(
    BeachName = if_else(
      condition = BeachName == "CL",
      true = "Crystal Beach",
      false = "Lac Lavon"
    )
  )

### pivot wider

x <-
  x %>%
  pivot_wider(
    names_from = Sample,
    values_from = Meas
  )

## add measurement unit----
### create col of NAs

x <-
  x %>%
  mutate(
    Ecoli_units = NA
  )

## Add to add_to_df----

Expected <- nrow(add_to_df) + nrow(x)

add_to_df <-
  rbind(
    add_to_df, x
  )

nrow(add_to_df) == Expected # True

# Clean "2007" element----

x <-
  burnsville[[17]]

# Cols further right of Date Sampled are geometric mean calculations
## 14 sampling dates
## There is no indication of what unit was used
## dates are in POSIXct
## Crystal Beach and Lac Lavon in this df

## Rename cols----

### col1 = CL_Sample1
### col2 = CL_Sample2
### col3 = CL_Sample3
### col4 = LL_Sample1
### col5 = LL_Sample2
### col6 = Date

x <-
  x %>%
  rename(
    "CL_Sample1" = 1,
    "CL_Sample2" = 2,
    "CL_Sample3" = 3,
    "LL_Sample1" = 4,
    "LL_Sample2" = 5,
    "Date" = 6
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "CL_Sample1", "CL_Sample2", "CL_Sample3", "LL_Sample1", 
    "LL_Sample2", "Date"
  )

## Keep appropriate rows----
### df will have 14 rows

Expected = 14

x <-
  x[3:16, ]

nrow(x) == Expected # True

## Make cols (except date) numeric----

x <-
  x %>%
  mutate(
    across(
      .cols = 1:6,
      .fns = as.numeric
    )
  )

## Create col of samples and beach names----
### pivot longer to create column for beach names

x <-
  x %>%
  pivot_longer(
    cols = 1:5,
    names_to = "BeachName",
    values_to = "Meas"
  )

### split the BeachName col into two cols

x <-
  x %>%
  separate_wider_delim(
    cols = BeachName,
    delim = "_",
    names = c("BeachName", "Sample")
  )

### add actual names of beaches

x <-
  x %>%
  mutate(
    BeachName = if_else(
      condition = BeachName == "CL",
      true = "Crystal Beach",
      false = "Lac Lavon"
    )
  )

### pivot wider

x <-
  x %>%
  pivot_wider(
    names_from = Sample,
    values_from = Meas
  )

## add measurement unit----
### create col of NAs

x <-
  x %>%
  mutate(
    Ecoli_units = NA
  )

## Add to df----

Expected <- nrow(df) + nrow(x)

df <-
  rbind(
    df, x
  )

nrow(df) == Expected # True

# Clean "2006" element----

x <-
  burnsville[[18]]

## 5 sampling dates
## last numeric row contains calculated geometric mean
## Mention organisms/100 mL; will put as NA for now
## Crystal Beach and Lac Lavon in this df

## Rename cols----

### col1 = CL_Sample1
### col2 = CL_Sample2
### col3 = CL_Sample3
### col4 = LL_Sample1
### col5 = LL_Sample2
### col6 = Date

x <-
  x %>%
  rename(
    "CL_Sample1" = 1,
    "CL_Sample2" = 2,
    "CL_Sample3" = 3,
    "LL_Sample1" = 4,
    "LL_Sample2" = 5,
    "Date" = 6
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "CL_Sample1", "CL_Sample2", "CL_Sample3", "LL_Sample1", 
    "LL_Sample2", "Date"
  )

## Keep appropriate rows----
### df will have 5 rows

Expected = 5

x <-
  x[3:7, ]

nrow(x) == Expected # True

## Make cols numeric----

x <-
  x %>%
  mutate(
    across(
      .cols = 1:6,
      .fns = as.numeric
    )
  )

## Create col of samples and beach names----
### pivot longer to create column for beach names

x <-
  x %>%
  pivot_longer(
    cols = 1:5,
    names_to = "BeachName",
    values_to = "Meas"
  )

### split the BeachName col into two cols

x <-
  x %>%
  separate_wider_delim(
    cols = BeachName,
    delim = "_",
    names = c("BeachName", "Sample")
  )

### add actual names of beaches

x <-
  x %>%
  mutate(
    BeachName = if_else(
      condition = BeachName == "CL",
      true = "Crystal Beach",
      false = "Lac Lavon"
    )
  )

### pivot wider

x <-
  x %>%
  pivot_wider(
    names_from = Sample,
    values_from = Meas
  )

## add measurement unit----
### create col of NAs

x <-
  x %>%
  mutate(
    Ecoli_units = NA
  )

## Add to df----

Expected <- nrow(df) + nrow(x)

df <-
  rbind(
    df, x
  )

nrow(df) == Expected # True

# Changes to df -----------------------------------------------------------
# Convert Date to date class----

df <- # convert numeric date to date format
  df %>%
  mutate(
    Date = as_date(
      Date,
      origin = "1899-12-30"
    )
  )

## Add add_to_df to df----
### Rearrange cols in add_to_df

add_to_df <-
  add_to_df %>%
  select(Sample1, Sample2, Sample3, Date, Ecoli_units, BeachName)


Expected <- nrow(df) + nrow(add_to_df)

df <- bind_rows(df, add_to_df)

nrow(df) == Expected # True

# Checking df----

str(df)
summary(df)

# nothing looks out of the ordinary

# Find geometric mean for each sampling date ------------------------------
## pivot longer----

Expected <-
  nrow(df) * 3

df <-
  df %>%
  pivot_longer(
    cols = c(Sample1, Sample2, Sample3),
    names_to = "SampleID",
    values_to = "Meas"
  )

nrow(df) == Expected # True

## Drop rows where Meas is NA

Expected <-
  nrow(df) - sum(is.na(df$Meas))

df <-
  df %>%
  drop_na(Meas)

nrow(x) == Expected

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

df %>% filter(Ecoli_1dGM > 1260) %>% nrow
# There are 4 days when 1 day gm > 1260

df %>% filter(Ecoli_30dGM > 126) %>% nrow()
# There are 22 days when 30 day gm > 126

## Create a column to denote when 1 day geometric mean > 1260----

df <-
  df %>%
  mutate(
    Threshold = Ecoli_1dGM > 1260
  )

## Add column to note that threshold over and that it was due to 1 day----

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
      true = "Ecoli_1dGM",
      false = NA
    )
  )

length(which(df$ClosureYN=="Y")) == 4 # True

## Create a column to denote when 30 day geometric mean > 126----

df <-
  df %>%
  mutate(
    Threshold = Ecoli_30dGM > 126
  )

length(which(df$Threshold==TRUE)) == 22 # True

## Add column to note that threshold over and that it was due to 1 day----

df <-
  df %>%
  mutate(
    ClosureYN = if_else(
      condition = Threshold == TRUE,
      true = "Y",
      false = ClosureYN
    ),
    ClosureReason = if_else(
      condition = Threshold == TRUE &
        is.na(ClosureReason),
      true = "Ecoli_30dGM",
      false = ClosureReason
    )
  )

## Remove threshold and SampleID cols----

df <-
  df %>%
  select(!c(Threshold, SampleID))

# Standardize df to match master df----
## Add missing cols with single value----

df <-
  df %>%
  mutate(
    MonitoringOrg = "Burnsville"
  )

## add cols with values based on another col----
## DOW for Crystal Beach = 19002700
## DOW for Alimagnet = 19002100
## DOW for Lac Lavon = 19044600

df <- # add DOW for Crystal
  df %>%
  mutate(
    DOW = if_else(
      condition = BeachName == "Crystal Beach",
      true = 19002700,
      false = NA
    )
  )

df <- # add DOW for Alimagnet
  df %>%
  mutate(
    DOW = if_else(
      condition = BeachName == "Alimagnet",
      true = 19002100,
      false = DOW
    )
  )

df <- # add DOW for Lac Lavon
  df %>%
  mutate(
    DOW = if_else(
      condition = BeachName == "Lac Lavon",
      true = 19044600,
      false = DOW
    )
  )

# Save csv----

write_csv(
  x = df,
  file = here("MSP-beaches_Burnsville_clean.csv")
)

# Upload csv to Beaches Google Drive----

drive_upload(
  media = here("MSP-beaches_Burnsville_clean.csv"),
  path = "https://drive.google.com/drive/folders/1hM0Qh1wPfIoWRooyKnBGRF7MEVR9C51P",
  name = "MSP-beaches_Burnsville_clean.csv"
  )
