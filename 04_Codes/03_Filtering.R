# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ProjectName:  肾癌首诊病人分析
# Purpose:      filtering patients got kidney cancer diagnosis for the 1st time
# programmer:   Zhe Liu
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


# filtering first diagnosis

kidney_ca_rec <- raw_data %>%
  filter(grepl("肾.*癌|肾.*恶性肿瘤|肾.*CA", toupper(AKC185)))

# patients 1st diagnosis

pt_1st_dx <- kidney_ca_rec %>%
  mutate(#AAE030 = ifelse(AAE030 == "", AAE043, AAE030),
         year = substr(AAE030, 1, 4)) %>%
  filter(year != "2018") %>%
  arrange(AAC001, AAE030) %>%
  group_by(AAC001, year) %>%
  filter(row_number() == 1) %>%
  group_by(AAC001) %>%
  filter(n() == 1, year == "2017")

# patients distribution

pt_city <- pt_1st_dx %>%
  group_by(AAB301) %>%
  summarise(AAC001 = n()) %>%
  arrange(desc(AAC001))

pt_hosp_code <- pt_1st_dx %>%
  group_by(AKB020) %>%
  summarise(AAC001 = n()) %>%
  arrange(desc(AAC001))

pt_hosp_name <- pt_1st_dx %>%
  group_by(AKB021) %>%
  summarise(AAC001 = n()) %>%
  arrange(desc(AAC001))

pt_city_hosp_code <- pt_1st_dx %>%
  group_by(AAB301, AKB020) %>%
  summarise(AAC001 = n()) %>%
  arrange(desc(AAC001))

pt_city_hosp_name <- pt_1st_dx %>%
  group_by(AAB301, AKB021) %>%
  summarise(AAC001 = n()) %>%
  arrange(desc(AAC001))

pt_dis_wb <- createWorkbook()
addWorksheet(pt_dis_wb, "patients_1st_diagnosis_2017")
addWorksheet(pt_dis_wb, "city_distribution")
addWorksheet(pt_dis_wb, "hosp(code)_distribution")
addWorksheet(pt_dis_wb, "hosp(name)_distribution")
addWorksheet(pt_dis_wb, "city_hosp(code)_distribution")
addWorksheet(pt_dis_wb, "city_hosp(name)_distribution")

writeData(pt_dis_wb, "patients_1st_diagnosis_2017", pt_1st_dx)
writeData(pt_dis_wb, "city_distribution", pt_city)
writeData(pt_dis_wb, "hosp(code)_distribution", pt_hosp_code)
writeData(pt_dis_wb, "hosp(name)_distribution", pt_hosp_name)
writeData(pt_dis_wb, "city_hosp(code)_distribution", pt_city_hosp_code)
writeData(pt_dis_wb, "city_hosp(name)_distribution", pt_city_hosp_name)

saveWorkbook(pt_dis_wb, "03_Outputs/patients_distribution.xlsx", overwrite = TRUE)






























