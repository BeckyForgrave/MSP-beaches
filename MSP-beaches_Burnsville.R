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

# Look at structure of each df----

map(
  .x = burnsville,
  .f = str
)

map(
  .x = burnsville,
  .f = summary
)

### 2024-2020 have 11 cols
### 2019 has 12 cols
### 2018-2011 have 17 cols
### 2010-2007 have 11 cols
### 2006 has 6 cols

