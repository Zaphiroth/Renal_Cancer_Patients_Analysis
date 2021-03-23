# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ProjectName:  肾癌首诊病人分析
# Purpose:      Read in raw data
# programmer:   Xin Huang
# Date:         10-22-2018
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

# loading the required packages
options(java.parameters = "-Xmx2048m")

suppressPackageStartupMessages({
  library(openxlsx)
  library(RODBC)
  library(dplyr)
  library(plm)
  library(dynlm)
  library(randomForest)
  library(tidyr)
  library(stringi)
  library(stringr)
  library(lubridate)
  library(data.table)
})

##-- readin the raw data

raw_data <- fread("02_Inputs/病人流-肾癌-20180521/肾癌15-17.csv") %>%
  setDF()
