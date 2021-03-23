# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ProjectName:  肾癌首诊病人分析
# Purpose:      do the summary
# programmer:   Xin Huang
# Date:         10-22-2018
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

# loading the required packages
options(java.parameters = "-Xmx2048m")

suppressPackageStartupMessages({
  library(openxlsx)
  library(RODBC)
  library(dplyr)
  library(tidyr)
  library(lubridate)
  library(stringi)
  library(stringr)
  library(plm)
  library(dynlm)
  library(randomForest)
  library(data.table)
})

##-- do the qc summary

table(raw_data$AAE043, useNA = "always")
