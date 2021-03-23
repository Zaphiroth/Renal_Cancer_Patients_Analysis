# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ProjectName:  HSK 肾癌首诊病人分析
# Purpose:      Data Summary
# programmer:   Zhe Liu
# Date:         02-13-2019
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

# loading the required packages
options(java.parameters = "-Xmx2048m")

suppressPackageStartupMessages({
  library(openxlsx)
  library(RODBC)
  library(dplyr)
  library(plm)
  library(dynlm)
  library(tidyr)
  library(data.table)
  library(stringi)
  library(stringr)
  library(lubridate)
})

##------------------------------------------------------------------------------
##--                 Raw data summary
##------------------------------------------------------------------------------

data4use <- raw_data %>%
  mutate(city = substr(AAB301, 1, 4),
         province = substr(AAB301, 1, 2))

data_sum_1 <- data4use %>%
  group_by(AAB301, AKB020, AAE043) %>%
  summarise(psn = n()) %>%
  arrange(AAB301, AKB020, AAE043) %>%
  ungroup() %>%
  spread(AAE043, psn)

data_sum_2 <- data4use %>%
  group_by(AAB301, AAE043) %>%
  summarise(psn = n()) %>%
  arrange(AAB301, AAE043) %>%
  ungroup() %>%
  spread(AAE043, psn)

data_sum_3 <- data4use %>%
  group_by(city, AAE043) %>%
  summarise(psn = n()) %>%
  arrange(city, AAE043) %>%
  ungroup() %>%
  spread(AAE043, psn)

data_sum_4 <- data4use %>%
  group_by(province, AAE043) %>%
  summarise(psn = n()) %>%
  arrange(province, AAE043) %>%
  ungroup() %>%
  spread(AAE043, psn)

data_sheet <- createWorkbook()
addWorksheet(data_sheet, "AAB301+AKB020~month")
addWorksheet(data_sheet, "AAB301~month")
addWorksheet(data_sheet, "city~month")
addWorksheet(data_sheet, "province~month")
writeData(data_sheet, "AAB301+AKB020~month", data_sum_1)
writeData(data_sheet, "AAB301~month", data_sum_2)
writeData(data_sheet, "city~month", data_sum_3)
writeData(data_sheet, "province~month", data_sum_4)
saveWorkbook(data_sheet, "03_Outputs/Data_sheet.xlsx", overwrite = TRUE)

##------------------------------------------------------------------------------
##--                 Data filtering
##------------------------------------------------------------------------------

flt_proc_1 <- raw_data %>%
  filter(grepl("肾.*癌|肾.*恶性肿瘤|肾.*CA", toupper(AKC185)))

flt_proc_2 <- flt_proc_1 %>%
  arrange(AAC001, AAE030) %>%
  group_by(AAC001) %>%
  filter(row_number() == 1) %>%
  ungroup()

chk <- flt_proc_2 %>%
  group_by(AAC001) %>%
  filter(n() != 1)

process <- data.frame(Datasets = c("raw_data", "flt_proc_1", "flt_proc_2"),
                      Processes = c("raw", "主诊断关键字筛选", "首诊筛选"),
                      Items = c(dim(raw_data)[1], dim(flt_proc_1)[1], dim(flt_proc_2)[1]))

##------------------------------------------------------------------------------
##--                 Data summary
##------------------------------------------------------------------------------

data_sum_month <- flt_proc_2 %>%
  mutate(month = substr(AAE030, 1, 6)) %>%
  group_by(AAB301, AKB020, month) %>%
  summarise(psn = n()) %>%
  arrange(AAB301, AKB020, month) %>%
  ungroup()

# data_chk <- data_sum %>%
#   group_by(AAB301) %>%
#   summarise(n = n())

summary <- data_sum_month %>%
  group_by(AAB301, AKB020) %>%
  summarise(mean = round(mean(psn), 4),
            var = round(var(psn), 4),
            months = n())

summary_sheet <- createWorkbook()
addWorksheet(summary_sheet, "Summary")
addWorksheet(summary_sheet, "Process")

writeData(summary_sheet, "Summary", summary)
writeData(summary_sheet, "Process", process)

saveWorkbook(summary_sheet, "03_Outputs/Summary_sheet.xlsx", overwrite = TRUE)

##------------------------------------------------------------------------------
##--                 Data check
##------------------------------------------------------------------------------

month_data <- data_sum_month %>%
  group_by(AAB301, AKB020, year = substr(month, 1, 4)) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  arrange(AAB301, AKB020, year) %>%
  filter(n > 6) %>%
  group_by(AAB301, AKB020) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  filter(n == 3)























