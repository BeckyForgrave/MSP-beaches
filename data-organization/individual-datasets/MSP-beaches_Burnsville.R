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

## add measurement unit----

x <-
  x %>%
  mutate(
    Ecoli_units = "mpn"
  )

## Create df for all data----

df <- x

# Clean "2023" element----

x <-
  burnsville[[2]]

## units of measure == mpn

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

# Clean "2022" element----

x <-
  burnsville[[3]]

## units == mpn

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
    "Sample1", "Sample2", "Sample3", "Date", "...1"
  )

## drop unneeded rows (that also contain numeric data that is a summary from
### the sampling data)

x <-
  x[1:18, ]

## Keep only numeric data----
### df will have 14 rows

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
      condition = ...1 == "week 6***",
      true = "mpn",
      false = Ecoli_units
    )
  )

### remove col with weeks info

x <-
  x %>%
  select(
    !...1
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

# First 3 columns E. coli measurements at Crystal Lake
## Cols further right that have similar name are geometric mean calculations

## 13 sampling dates
## There is no indication of what unit was used
## dates are in POSIXct
## last set of measurements have no associated date

## Rename cols----
### will not use site AL
### CL-N...1 = Sample1
### CL-M...2 = Sample2
### CL-S...3 = Sample3
### Date Sampled = Date

x <-
  x %>%
  rename(
    "Sample1" = "CL-N...1",
    "Sample2" = "CL-M...2",
    "Sample3" = "CL-S...3",
    "Date" = "Date Sampled"
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
  x[1:13, ]

## add measurement unit----
### create col of NAs

x <-
  x %>%
  mutate(
    Ecoli_units = NA
  )

## Create alternate df where date col is already POSIXct----

df_alt <- x

# Clean "2008" element----

x <-
  burnsville[[16]]

# First 3 columns E. coli measurements at Crystal Lake
## Cols further right that have similar name are geometric mean calculations

## 2 sampling dates
## There is no indication of what unit was used
## dates are in POSIXct

## Rename cols----
### will not use site AL
### Crystal 1...1 = Sample1
### Crystal 2...2 = Sample2
### Crystal 3...3 = Sample3
### Date Sampled = Date

x <-
  x %>%
  rename(
    "Sample1" = "Crystal 1...1",
    "Sample2" = "Crystal 2...2",
    "Sample3" = "Crystal 3...3",
    "Date" = "Date Sampled"
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
  x[1:2, ]

## add measurement unit----
### create col of NAs

x <-
  x %>%
  mutate(
    Ecoli_units = NA
  )

## Add to df_alt----

Expected <- nrow(df_alt) + nrow(x)

df_alt <-
  rbind(
    df_alt, x
  )

nrow(df_alt) == Expected # True

# Clean "2007" element----

x <-
  burnsville[[17]]

## 14 sampling dates
## sample unit not included

## Rename cols----
### will not use site AL
### col1 = Sample1
### col2 = Sample2
### col3 = Sample3
### col6 = Date

x <-
  x %>%
  rename(
    "Sample1" = 1,
    "Sample2" = 2,
    "Sample3" = 3,
    "Date" = 6
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

## Rename cols----
### will not use site AL
### col1 = Sample1
### col2 = Sample2
### col3 = Sample3
### col6 = Date

x <-
  x %>%
  rename(
    "Sample1" = 1,
    "Sample2" = 2,
    "Sample3" = 3,
    "Date" = 6
  )

## drop unneeded cols----

x <-
  x %>%
  select(
    "Sample1", "Sample2", "Sample3", "Date"
  )

## Keep only appropriate rows----
### df will have 5 rows

Expected = 5

x <- x[3:7, ]

nrow(x) == Expected # True

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

# Change Date and sample cols to numeric in df----

df <-
  df %>%
  mutate(
    across(
      .cols = 1:4,
      .fns = as.numeric
    )
  )

# Convert numeric to POSIXct----

df <- # convert numeric date to date format
  df %>%
  mutate(
    Date = as_date(
      Date,
      origin = "1899-12-30"
    )
  )

## Add df_alt to df----

Expected <- nrow(df) + nrow(df_alt)

df <- bind_rows(df, df_alt)

nrow(df) == Expected # True

# Checking df----

str(df)
summary(df)

# nothing looks out of the ordinary

# Find geometric mean for each sampling date
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

## calculate product for each sampling date----

df <-
  df %>%
  mutate(
    product = prod(Meas),
    .by = Date
  )

## determine how many sample size for each date per site----

df <-
  df %>%
  mutate(
    n = n(),
    .by = Date
  )

## find the nth log of the products----
### create a vector for the base for the log transformation-----

v <- as.numeric(unique(df$n))

### find the nth log

df <-
  df %>%
  mutate(
    Ecoli_1dGM = log(
      x = product,
      base = v
    ),
    .by = Date
  )

# Find 30 day geometric mean----
## create separate df for 30 day calculations----

x <- df

## keep only needed cols----

x <-
  x %>%
  select(
    Date, SampleID, Meas
  )

## create df with all time intervals for each site----

x <-
  x %>%
  mutate(
    Date = as_date(Date)
  )

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
  distinct(Date, date_30d)

## Cross join both df's----

Expected <- nrow(x) * nrow(y)

z <-
  cross_join(
    x, y
  )

nrow(z) == Expected # True

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
    .by = "date_30d"
  )

## calculate product for each sampling date per site----

z <-
  z %>%
  mutate(
    product = prod(Meas),
    .by = "date_30d"
  )

## find the nth log of the products----

z <-
  z %>%
  mutate(
    Ecoli_30dGM = log(
      x = product,
      base = n
    ),
    .by = "date_30d"
  )

## Remove rows where Date.x does not match with Date.y to reduce to one meas----
### per date per site

z <-
  z %>%
  filter(
    Date.x == Date.y
  )

## keep only Date.x, and Ecoli_30d----

z <-
  z %>%
  select(
    Date.x, Ecoli_30dGM
  ) %>%
  unique() %>%
  arrange(Date.x)

## Rename cols----

z <-
  z %>%
  rename(
    Date = Date.x
  )

## add to df----
### drop unneeded cols from z and df

df <-
  df %>%
  select( # remove unneeded cols
    !c(SampleID, Meas, product, n)
  ) %>%
  distinct() # keep only unique rows

### merge both df's into one

df <-
  left_join(
    x = df,
    y = z,
    by = "Date"
  )

# Note when beach closed due to high ecoli levels----
## are there days when 1 day gm > 1260?

df$Ecoli_1dGM > 1260 # none over 1260

# are there days when 30 day gm > 126

df$Ecoli_30dGM > 126 # none over 126

## Do not need to note when beach closed due to E. coli levels

# Standardize df to match master df----
## Add missing cols with single value----

df <-
  df %>%
  mutate(
    BeachName = "Crystal Beach",
    DNRID = 19002700,
    Entero_avg_cfu = NA,
    Microcystin_ugL = NA,
    Cylindro_ugL = NA,
    Anatoxin_ugL = NA,
    ClosureYN = "N",
    ClosureReason = NA,
    MonitoringOrg = "Burnsville"
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
  file = here("MSP-beaches_Burnsville_clean.csv")
)
