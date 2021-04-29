# clear workspace
rm(list=ls(all.names=TRUE)) 

library(ggplot2)
library(dplyr)
library(reshape2)
library(tidyr)
library(stringr)
library(gridExtra)
library(anytime)
library("readxl")

memory.limit(20000)

#################################################################################
#set working directory as appropriate
# J:\MishraTeam\COVID-19_spatial_project\repo\covid-neighbourhoods\data\private\raw
setwd("J:/MishraTeam/COVID-19_spatial_project/repo/covid-neighbourhoods")
#################################################################################
##############################################################################################################
##read in DA level variables
DA = read.csv("./data/private/r_processed/DA_total_income_pop_DA_var_HRname_sub.csv", header = T)
colnames(DA)
nrow(DA)
ncol(DA)

DA_full_list = DA$DAUID
table(DA$PHU_name, exclude = NULL)

DA_list = read_excel("./data/private/raw/ConversionFiles/Conversion_DAs16_to_NHs396_04June2020_v12a.xlsx",
                     sheet = "DAs16_N396_v12_04June2020", range = "A1:W20006")
nrow(DA_list)
DA_list_sub = DA_list[, c("DA2016_num",
                          "OCHPPid",
                          "NHid",
                          "NHid_apNum",
                          "NHname",
                          "HRname")]
length(unique(DA_list_sub$DA2016_num))
DA_full_list_ON = DA_list_sub[, "DA2016_num"]
DA_full_list_Toronto = subset(DA_list_sub, HRname == "City of Toronto Health Unit")
DA_full_list_GTA = subset(DA_list_sub, HRname %in% c("City of Toronto Health Unit",
                                                     "Durham Regional Health Unit",
                                                     "Halton Regional Health Unit",
                                                     "Peel Regional Health Unit",
                                                     "York Regional Health Unit"))
#################################################################################
# IPHIS_REPORT_SUB = read.csv("J:/MishraTeam/Research/Projects/MathModeling/Covid_model/data/SFTS/OCT 7/IPHIS_REPORT.csv", header = T)
IPHIS_REPORT_SUB = read.csv("J:/MishraTeam/Research/Projects/MathModeling/Covid_model/data/SFTS/2021/MAR 18/IPHIS_REPORT.csv", header = T)
colnames(IPHIS_REPORT_SUB)
nrow(IPHIS_REPORT_SUB)
ncol(IPHIS_REPORT_SUB)
IPHIS_REPORT_SUB$SOURCE
IPHIS_REPORT_SUB$SUBTYPE_NAME
table(IPHIS_REPORT_SUB$SUBTYPE_NAME, exclude = NULL)
table(IPHIS_REPORT_SUB$DIAGNOSING_HEALTH_UNIT_AREA, exclude = NULL)
sum(IPHIS_REPORT_SUB$DAUID %in% DA_full_list)
DA_full_list_Toronto = subset(DA_list_sub, HRname == "City of Toronto Health Unit")
sum(IPHIS_REPORT_SUB$DAUID %in% DA_full_list_Toronto$DA2016_num)

sum(DA_full_list_Toronto$DA2016_num %in% DA_full_list)

table(IPHIS_REPORT_SUB$SUBTYPE_NAME, IPHIS_REPORT_SUB$DIAGNOSING_HEALTH_UNIT_AREA, exclude = NULL)

table(subset(IPHIS_REPORT_SUB, DAUID %in% DA_full_list_Toronto$DA2016_num)$SUBTYPE_NAME, exclude = NULL)
table(subset(IPHIS_REPORT_SUB, DAUID %in% DA_full_list_Toronto$DA2016_num), exclude = NULL)
table(IPHIS_REPORT_SUB$VOC_TEST_LAB_CLL3, exclude = NULL)
table(IPHIS_REPORT_SUB$VOC_TESTING_REPORTED_DATE, exclude = NULL)
IPHIS_REPORT_SUB$VOC_TESTING_REPORTED_DATE = anydate(IPHIS_REPORT_SUB$VOC_TESTING_REPORTED_DATE)
summary(IPHIS_REPORT_SUB$VOC_TESTING_REPORTED_DATE)
table(IPHIS_REPORT_SUB$VOC_TESTING_REPORTED_DATE, exclude = NULL)

table(IPHIS_REPORT_SUB$VOC_TESTING_REPORTED_DATE, IPHIS_REPORT_SUB$VOC_TEST_LAB_CLL3, exclude = NULL)


###############################################################################
##format all dates and clean dates
IPHIS_REPORT_SUB$CASE_REPORTED_DATE = anydate(IPHIS_REPORT_SUB$CASE_REPORTED_DATE)
IPHIS_REPORT_SUB$ACCURATE_EPISODE_DATE = anydate(IPHIS_REPORT_SUB$ACCURATE_EPISODE_DATE)
IPHIS_REPORT_SUB$CASE_CREATED_DATE = anydate(IPHIS_REPORT_SUB$CASE_CREATED_DATE)
# IPHIS_REPORT_SUB$SPECIMENDATE = anydate(IPHIS_REPORT_SUB$SPECIMENDATE)

min(IPHIS_REPORT_SUB$ACCURATE_EPISODE_DATE)
max(IPHIS_REPORT_SUB$ACCURATE_EPISODE_DATE)
# min(IPHIS_REPORT_SUB$CASE_CREATED_DATE)
# max(IPHIS_REPORT_SUB$CASE_CREATED_DATE)

subset(IPHIS_REPORT_SUB, DAUID %in% DA_full_list_Toronto$DA2016_num & 
         SUBTYPE_NAME == "LINEAGE B.1.1.7 (UK VARIANT 202012/01)")$CASE_REPORTED_DATE
subset(IPHIS_REPORT_SUB, DAUID %in% DA_full_list_Toronto$DA2016_num & 
         SUBTYPE_NAME == "LINEAGE B.1.1.7 (UK VARIANT 202012/01)")$ACCURATE_EPISODE_DATE
###update ACCURATE_EPISODE_DATE < "2020-01-20" to CASE_REPORTED_DATE
subset(IPHIS_REPORT_SUB, ACCURATE_EPISODE_DATE < "2020-01-20")[, c("CASE_REPORTED_DATE",
                                                                   "SPECIMENDATE",
                                                                   "CASE_CREATED_DATE",
                                                                   "ACCURATE_EPISODE_DATE")]
IPHIS_REPORT_SUB$ACCURATE_EPISODE_DATE_UPDATE1 = if_else(IPHIS_REPORT_SUB$ACCURATE_EPISODE_DATE < "2020-01-20",
                                                         IPHIS_REPORT_SUB$CASE_REPORTED_DATE,
                                                         # pmin(IPHIS_REPORT_SUB$CASE_REPORTED_DATE,
                                                         #      IPHIS_REPORT_SUB$SPECIMENDATE,
                                                         #      IPHIS_REPORT_SUB$CASE_CREATED_DATE, na.rm = T),
                                                         IPHIS_REPORT_SUB$ACCURATE_EPISODE_DATE)
IPHIS_REPORT_SUB$ACCURATE_EPISODE_DATE_UPDATE = if_else(IPHIS_REPORT_SUB$ACCURATE_EPISODE_DATE_UPDATE1 < "2020-01-20",
                                                        IPHIS_REPORT_SUB$CASE_CREATED_DATE,
                                                        # pmin(IPHIS_REPORT_SUB$CASE_REPORTED_DATE,
                                                        #      IPHIS_REPORT_SUB$SPECIMENDATE,
                                                        #      IPHIS_REPORT_SUB$CASE_CREATED_DATE, na.rm = T),
                                                        IPHIS_REPORT_SUB$ACCURATE_EPISODE_DATE_UPDATE1)
min(IPHIS_REPORT_SUB$ACCURATE_EPISODE_DATE_UPDATE)
max(IPHIS_REPORT_SUB$ACCURATE_EPISODE_DATE_UPDATE)



###############################################################################
##format age category
IPHIS_REPORT_SUB$Age_cat = ifelse(IPHIS_REPORT_SUB$age_grp %in% c("age0_09",  
                                                                  "age10_19", 
                                                                  "age20_29",  
                                                                  "age30_39",  
                                                                  "age40_49"), "age49UNDER",
                                  ifelse(IPHIS_REPORT_SUB$age_grp == "age50_59", "age50_59",
                                         ifelse(IPHIS_REPORT_SUB$age_grp == "age60_69", "age60_69",
                                                ifelse(IPHIS_REPORT_SUB$age_grp == "age70_79", "age70_79",
                                                       ifelse(IPHIS_REPORT_SUB$age_grp == "age80PLUS", "age80PLUS",
                                                              "unknown")))))

##############################################################################
HCW         = IPHIS_REPORT_SUB$HCW == 'YES'
LTCF_HCW    = IPHIS_REPORT_SUB$LTCH_HCW == 'YES'
OCC_SHELTER = IPHIS_REPORT_SUB$OCC_SHELTERHOMELESSSTAFF  == 'YES'
TRAVEL      = IPHIS_REPORT_SUB$LIKELY_ACQUISITION == 'TRAVEl'
SHELTER     = IPHIS_REPORT_SUB$RES_HOMELESSSHELTER == "YES" |
  IPHIS_REPORT_SUB$SETTING_COMBINED == "Shelter" |
  IPHIS_REPORT_SUB$OCC_SHELTERHOMELESSSTAFF == "YES"


IPHIS_REPORT_SUB$ShelterStaff   = OCC_SHELTER & !LTCF_HCW & !TRAVEL
IPHIS_REPORT_SUB$Shelterresident = SHELTER & !IPHIS_REPORT_SUB$ShelterStaff

table(IPHIS_REPORT_SUB$OCC_LTCH, exclude = NULL)
table(IPHIS_REPORT_SUB$LTCH_HCW, IPHIS_REPORT_SUB$OCC_LTCH, exclude = NULL)
table(IPHIS_REPORT_SUB$OCC_RETIREMENTHOME, exclude = NULL)
table(IPHIS_REPORT_SUB$LTCH_HCW, IPHIS_REPORT_SUB$OCC_RETIREMENTHOME, exclude = NULL)
table(IPHIS_REPORT_SUB$OCC_RETIREMENTHOME, exclude = NULL)

table(IPHIS_REPORT_SUB$OCC_SHELTERHOMELESSSTAFF, exclude = NULL)

table(IPHIS_REPORT_SUB$HCW, exclude = NULL)
table(IPHIS_REPORT_SUB$HCW, IPHIS_REPORT_SUB$LTCH_HCW, exclude = NULL)
table(IPHIS_REPORT_SUB$HCW, IPHIS_REPORT_SUB$OCC_SHELTERHOMELESSSTAFF, exclude = NULL)

IPHIS_REPORT_SUB$LTCF_worker    = IPHIS_REPORT_SUB$LTCH_HCW == "YES" | IPHIS_REPORT_SUB$OCC_LTCH == "YES"
IPHIS_REPORT_SUB$RH_worker      = IPHIS_REPORT_SUB$OCC_RETIREMENTHOME == "YES"
IPHIS_REPORT_SUB$LTCF_RH_worker = IPHIS_REPORT_SUB$LTCH_HCW == "YES" | IPHIS_REPORT_SUB$OCC_LTCH == "YES" | IPHIS_REPORT_SUB$OCC_RETIREMENTHOME == "YES"
table(IPHIS_REPORT_SUB$LTCF_RH_worker, exclude = NULL)
table(IPHIS_REPORT_SUB$LTCF_RH_worker, IPHIS_REPORT_SUB$LTCH_HCW, exclude = NULL)
table(IPHIS_REPORT_SUB$LTCF_RH_worker, IPHIS_REPORT_SUB$OCC_LTCH, exclude = NULL)


IPHIS_REPORT_SUB$shelter_worker = IPHIS_REPORT_SUB$OCC_SHELTERHOMELESSSTAFF  == 'YES'
table(IPHIS_REPORT_SUB$shelter_worker, IPHIS_REPORT_SUB$HCW, exclude = NULL)
table(IPHIS_REPORT_SUB$shelter_worker, exclude = NULL)


IPHIS_REPORT_SUB$LTCF_RH_shelter_worker = IPHIS_REPORT_SUB$LTCH_HCW == "YES" | IPHIS_REPORT_SUB$OCC_LTCH == "YES" | IPHIS_REPORT_SUB$OCC_RETIREMENTHOME == "YES" | IPHIS_REPORT_SUB$OCC_SHELTERHOMELESSSTAFF  == 'YES'
table(IPHIS_REPORT_SUB$LTCF_RH_shelter_worker, exclude = NULL)

table(IPHIS_REPORT_SUB$HCW, exclude = NULL)
IPHIS_REPORT_SUB$other_HCW = IPHIS_REPORT_SUB$HCW == "YES" & !IPHIS_REPORT_SUB$LTCF_worker & !IPHIS_REPORT_SUB$shelter_worker
table(IPHIS_REPORT_SUB$other_HCW, exclude = NULL)

# hospital_nonHCW
IPHIS_REPORT_SUB$hospital_nonHCW = IPHIS_REPORT_SUB$OCC_HOSPITAL == "YES" & !IPHIS_REPORT_SUB$HCW == "YES"
table(IPHIS_REPORT_SUB$hospital_nonHCW, exclude = NULL)

TRAVEL  = IPHIS_REPORT_SUB$LIKELY_ACQUISITION == 'TRAVEL'
table(TRAVEL, exclude = NULL)

table(IPHIS_REPORT_SUB$OCC_HOSPITAL, IPHIS_REPORT_SUB$HCW, exclude = NULL)





##############################################################################
##check missing values for DAs
#Ontario
# cut_date = "2020-08-21"
# cut_date = max(IPHIS_REPORT_SUB$ACCURATE_EPISODE_DATE_UPDATE)

cut_date = max(IPHIS_REPORT_SUB$ACCURATE_EPISODE_DATE_UPDATE)

IPHIS_REPORT_SUB_ON = subset(IPHIS_REPORT_SUB, ACCURATE_EPISODE_DATE_UPDATE <= cut_date)
summary(IPHIS_REPORT_SUB_ON$DAUID)

IPHIS_REPORT_SUB_ON_withDAUID = subset(IPHIS_REPORT_SUB_ON, !is.na(DAUID) & DAUID  %in% as.numeric(DA_full_list_ON$DA2016_num))
nrow(IPHIS_REPORT_SUB_ON_withDAUID)
sum(IPHIS_REPORT_SUB_ON_withDAUID$DAUID == "0")
summary(IPHIS_REPORT_SUB_ON_withDAUID$DAUID)
IPHIS_REPORT_SUB_ON_missingDAUID = subset(IPHIS_REPORT_SUB_ON, is.na(DAUID) | !(DAUID  %in% as.numeric(DA_full_list_ON$DA2016_num)))
nrow(IPHIS_REPORT_SUB_ON_missingDAUID)
nrow(IPHIS_REPORT_SUB_ON_withDAUID)
nrow(IPHIS_REPORT_SUB_ON)
nrow(IPHIS_REPORT_SUB_ON_withDAUID)
1 - nrow(IPHIS_REPORT_SUB_ON_withDAUID)/nrow(IPHIS_REPORT_SUB_ON)
nrow(IPHIS_REPORT_SUB_ON) - nrow(IPHIS_REPORT_SUB_ON_withDAUID)
sum(IPHIS_REPORT_SUB_ON_withDAUID$DAUID %in% as.numeric(DA_full_list_ON$DA2016_num))
nrow(IPHIS_REPORT_SUB_ON) - sum(IPHIS_REPORT_SUB_ON_withDAUID$DAUID %in% as.numeric(DA_full_list_ON$DA2016_num))

IPHIS_REPORT_SUB_ON_check = IPHIS_REPORT_SUB_ON_withDAUID[, c("ACCURATE_EPISODE_DATE_UPDATE", "DAUID")]




##############################################################################
###filter use Toronto DA list directly & report date
IPHIS_REPORT_SUB_ON_withDAUID$CASE_REPORTED_DATE_UPDATE = if_else(is.na(IPHIS_REPORT_SUB_ON_withDAUID$CASE_REPORTED_DATE) |
                                                                    IPHIS_REPORT_SUB_ON_withDAUID$CASE_REPORTED_DATE < "2020-01-23",
                                                                  IPHIS_REPORT_SUB_ON_withDAUID$ACCURATE_EPISODE_DATE_UPDATE,
                                                                  # pmin(IPHIS_REPORT_SUB$CASE_REPORTED_DATE,
                                                                  #      IPHIS_REPORT_SUB$SPECIMENDATE,
                                                                  #      IPHIS_REPORT_SUB$CASE_CREATED_DATE, na.rm = T),
                                                                  IPHIS_REPORT_SUB_ON_withDAUID$CASE_REPORTED_DATE)
max(IPHIS_REPORT_SUB_ON_withDAUID$CASE_REPORTED_DATE_UPDATE)
min(IPHIS_REPORT_SUB_ON_withDAUID$CASE_REPORTED_DATE_UPDATE)




##############################################################################
###death date
table(IPHIS_REPORT_SUB_ON_withDAUID$OUTCOME1, exclude = NULL)
table(IPHIS_REPORT_SUB_ON_withDAUID$DEATHCAUSE, exclude = NULL)

table(IPHIS_REPORT_SUB_ON_withDAUID$OUTCOME1, IPHIS_REPORT_SUB_ON_withDAUID$DEATHCAUSE, exclude = NULL)



IPHIS_REPORT_SUB_ON_withDAUID$Fatal = ifelse(IPHIS_REPORT_SUB_ON_withDAUID$OUTCOME1 == "FATAL", "Yes", "No")
table(IPHIS_REPORT_SUB_ON_withDAUID$Fatal, exclude = NULL)

IPHIS_REPORT_SUB_ON_withDAUID$CLIENT_DEATH_DATE = anydate(IPHIS_REPORT_SUB_ON_withDAUID$CLIENT_DEATH_DATE)
table(IPHIS_REPORT_SUB_ON_withDAUID$CLIENT_DEATH_DATE, exclude = NULL)

min(IPHIS_REPORT_SUB_ON_withDAUID$CLIENT_DEATH_DATE, na.rm = T)
max(IPHIS_REPORT_SUB_ON_withDAUID$CLIENT_DEATH_DATE, na.rm = T)

table(IPHIS_REPORT_SUB_ON_withDAUID$CLIENT_DEATH_DATE, IPHIS_REPORT_SUB_ON_withDAUID$Fatal, exclude = NULL)

# 9 has no date


##############################################################################
###Hospitalization
table(IPHIS_REPORT_SUB_ON_withDAUID$HOSPITALIZED, exclude = NULL)

IPHIS_REPORT_SUB_ON_withDAUID$Hospitalization = ifelse(IPHIS_REPORT_SUB_ON_withDAUID$HOSPITALIZED == "YES", "Yes", "No")
table(IPHIS_REPORT_SUB_ON_withDAUID$Hospitalization, exclude = NULL)
table(IPHIS_REPORT_SUB_ON_withDAUID$Hospitalization, IPHIS_REPORT_SUB_ON_withDAUID$HOSPITALIZED, exclude = NULL)

table(IPHIS_REPORT_SUB_ON_withDAUID$HOSPADMITDATE, exclude = NULL)
IPHIS_REPORT_SUB_ON_withDAUID$HOSPADMITDATE = anydate(IPHIS_REPORT_SUB_ON_withDAUID$HOSPADMITDATE)
min(IPHIS_REPORT_SUB_ON_withDAUID$HOSPADMITDATE, na.rm = T)
max(IPHIS_REPORT_SUB_ON_withDAUID$HOSPADMITDATE, na.rm = T)

subset(IPHIS_REPORT_SUB_ON_withDAUID, HOSPADMITDATE < " 2020-01-21" |  HOSPADMITDATE > max(IPHIS_REPORT_SUB_ON_withDAUID$CASE_REPORTED_DATE_UPDATE))[, c("CASE_REPORTED_DATE_UPDATE",
                                                                                                                                                         "HOSPADMITDATE",
                                                                                                                                                         "ACCURATE_EPISODE_DATE_UPDATE")]
IPHIS_REPORT_SUB_ON_withDAUID$HOSPADMITDATE_UPDATE = if_else(IPHIS_REPORT_SUB_ON_withDAUID$HOSPADMITDATE < " 2020-01-21" |  IPHIS_REPORT_SUB_ON_withDAUID$HOSPADMITDATE > max(IPHIS_REPORT_SUB_ON_withDAUID$CASE_REPORTED_DATE_UPDATE),
                                                             IPHIS_REPORT_SUB_ON_withDAUID$ACCURATE_EPISODE_DATE_UPDATE,
                                                             IPHIS_REPORT_SUB_ON_withDAUID$HOSPADMITDATE)
min(IPHIS_REPORT_SUB_ON_withDAUID$HOSPADMITDATE_UPDATE, na.rm = T)
max(IPHIS_REPORT_SUB_ON_withDAUID$HOSPADMITDATE_UPDATE, na.rm = T)


#######################
#subtype
table(IPHIS_REPORT_SUB_ON_withDAUID$SUBTYPE_NAME, exclude = NULL)

IPHIS_REPORT_SUB_ON_withDAUID$Variant = ifelse(IPHIS_REPORT_SUB_ON_withDAUID$SUBTYPE_NAME %in% c("LINEAGE B.1.351 (S AFRICAN VARIANT 501Y.V2)",
                                                                                                 "LINEAGE B.1.1.7 (UK VARIANT 202012/01)",
                                                                                                 "LINEAGE P.1 (BRAZIL VARIANT 501Y.V3)"), "LINEAGE variant", "Not LINEAGE variant")


table(IPHIS_REPORT_SUB_ON_withDAUID$Variant, IPHIS_REPORT_SUB_ON_withDAUID$SUBTYPE_NAME, exclude = NULL)
table(IPHIS_REPORT_SUB_ON_withDAUID$Variant, exclude = NULL)


iphis_DA_overall_noLTCF_Feb03 =
  IPHIS_REPORT_SUB_ON_withDAUID %>%
  filter(DAUID %in% DA_full_list_GTA$DA2016_num, CASE_REPORTED_DATE_UPDATE >= "2021-02-03") %>%
  arrange(DAUID, CASE_REPORTED_DATE_UPDATE) %>%
  group_by(DAUID, CASE_REPORTED_DATE_UPDATE) %>%
  summarise(case_new_all = n() - sum(LTCH_RESIDENT == "YES"),
            variant_new_all_basedon_subtype = sum(Variant == "LINEAGE variant" & LTCH_RESIDENT != "YES"),
            variant_new_all_basedonVOCtest = sum(VOC_TEST_LAB_CLL3 %in% c("Detected") & LTCH_RESIDENT != "YES"),
            variant_new_all_basedonVOCtest_nosubtype = sum(VOC_TEST_LAB_CLL3 %in% c("Detected") & Variant != "LINEAGE variant" & LTCH_RESIDENT != "YES"),
            variant_new_testing = sum(VOC_TEST_LAB_CLL3 %in% c("Detected", "Not Detected") & LTCH_RESIDENT != "YES")) %>%
  complete(CASE_REPORTED_DATE_UPDATE = seq.Date(as.Date("2021-02-03"),
                                                max(IPHIS_REPORT_SUB_ON_withDAUID$CASE_REPORTED_DATE_UPDATE), by=1),
           # DAUID = DA_full_list_Toronto$DA2016_num,
           fill = list(case_new_all = 0,
                       
                       variant_new_all_basedon_subtype = 0,
                       
                       variant_new_all_basedonVOCtest = 0,
                       
                       variant_new_all_basedonVOCtest_nosubtype = 0,
                       
                       variant_new_testing = 0)) %>%
  mutate(case_cum_all = cumsum(case_new_all),
         
         variant_cum_all_basedon_subtype = cumsum(variant_new_all_basedon_subtype),
         
         variant_cum_all_basedon_basedonVOCtest = cumsum(variant_new_all_basedonVOCtest),
         
         variant_cum_all_basedonVOCtest_nosubtype = cumsum(variant_new_all_basedonVOCtest_nosubtype),
         
         variant_cum_all_testing = cumsum(variant_new_testing))

iphis_DA_overall_noLTCF_Feb03_DA = merge(iphis_DA_overall_noLTCF_Feb03, DA, by = c("DAUID"), all.x = T)
colnames(iphis_DA_overall_noLTCF_Feb03_DA)
nrow(iphis_DA_overall_noLTCF_Feb03_DA)
ncol(iphis_DA_overall_noLTCF_Feb03_DA)

iphis_DA_overall_noLTCF_Feb03_DA = arrange(iphis_DA_overall_noLTCF_Feb03_DA, DAUID)
table(iphis_DA_overall_noLTCF_Feb03_DA$PHU_name)


essential_summary_Peel_Toronto =
  DA %>%
  filter(PHU_name %in% c("City of Toronto Health Unit",
                         "Peel Regional Health Unit")) %>%
  group_by(d_essential_rank_tert) %>%
  summarize(total_pop = sum(DA_population),
                          mean = mean(d_essential, na.rm = T),
                          median = median(d_essential, na.rm = T),
                          IQR = paste0(quantile(d_essential, 1/4, na.rm = T), " - ", quantile(d_essential, 3/4, na.rm = T)))


income_summary_Peel_Toronto =
  DA %>%
  filter(PHU_name %in% c("City of Toronto Health Unit",
                         "Peel Regional Health Unit")) %>%
  group_by(d_after_tax_income_PPE_rank_tert) %>%
  summarize(total_pop = sum(DA_population),
            mean = mean(d_after_tax_income_PPE, na.rm = T),
            median = median(d_after_tax_income_PPE, na.rm = T),
            IQR = paste0(quantile(d_after_tax_income_PPE, 1/4, na.rm = T), " - ", quantile(d_after_tax_income_PPE, 3/4, na.rm = T)))


total_case =
  iphis_DA_overall_noLTCF_Feb03_DA %>% 
  filter(PHU_name %in% c("City of Toronto Health Unit",
                         "Peel Regional Health Unit")) %>%
  group_by(CASE_REPORTED_DATE_UPDATE) %>%
  summarize(total_new_case = sum(case_new_all),
            total_cum_case = sum(case_cum_all),
            total_new_variant_basedon_subtype = sum(variant_new_all_basedon_subtype),
            total_cum_variant_basedon_subtype = sum(variant_cum_all_basedon_subtype),
            total_new_variant_basedonVOCtest = sum(variant_new_all_basedonVOCtest),
            total_cum_variant_basedonVOCtest = sum(variant_cum_all_basedon_basedonVOCtest),
            total_new_variant_tests = sum(variant_new_testing),
            total_cum_variant_tests = sum(variant_cum_all_testing))

##################################################################################
###Epidemic curve by variable
##################################################################################
epidemic_curve_by_var_Peel_Toronto <- function(byvar_raw, 
                                               rank_type,
                                               ylimit1, 
                                               ylimit2,
                                               labs,
                                               new_var,
                                               cum_var,
                                               space1,
                                               space2,
                                               label){
  
  library(zoo)
  ################################################
  
  date_type = "CASE_REPORTED_DATE_UPDATE"
  
  ################################################
  if(rank_type == "tertile"){
    byvar = paste0(byvar_raw, "_rank_tert")
  }
  
  if(rank_type == "quintile"){
    byvar = paste0(byvar_raw, "_rank_quin")
  }
  
  if(rank_type == "decile"){
    byvar = paste0(byvar_raw, "_rank_deci")
  }
  
  byvar <- as.name(byvar)                         # Create quosure
  byvar_raw <- as.name(byvar_raw)                 # Create quosure
  date_type  <- as.name(date_type)                # Create quosure
  new_var <- as.name(new_var) 
  cum_var <- as.name(cum_var) 
  
  ###################################################################################
  DA_population =
    DA %>%
    filter(PHU_name %in% c("Peel Regional Health Unit",
                           "City of Toronto Health Unit")) %>%
    group_by(!!byvar) %>%
    summarize(Population = sum(DA_population))
  
  iphis_DA_aggregated =
    iphis_DA_overall_noLTCF_Feb03_DA %>%
    filter(!is.na(!!byvar) & PHU_name %in% c("Peel Regional Health Unit",
                                             "City of Toronto Health Unit")) %>%
    group_by(!!byvar, !!date_type) %>%
    summarize(total_new_case = sum(!!new_var),
              total_cum_case = sum(!!cum_var))
  
  iphis_DA_aggregated_pop = merge(iphis_DA_aggregated, DA_population, all.x = T)
  iphis_DA_aggregated_pop$total_new_case100k = iphis_DA_aggregated_pop$total_new_case/iphis_DA_aggregated_pop$Population * 100000
  iphis_DA_aggregated_pop$total_cum_caseper100k = iphis_DA_aggregated_pop$total_cum_case/iphis_DA_aggregated_pop$Population * 100000
  
  iphis_DA_aggregated_pop_rolling =
    iphis_DA_aggregated_pop %>%
    # filter(!is.na(!!byvar)) %>%
    group_by(!!byvar) %>%
    mutate(rolling_newcases_100k = rollmean(total_new_case100k, k = 7, fill = NA))
  
  write.csv(iphis_DA_aggregated_pop_rolling,
            paste0("./fig/", "Toronto_Peel", byvar_raw,"_", new_var, ".csv"), row.names = F)
  
  
  fig_new =
    ggplot(subset(iphis_DA_aggregated_pop_rolling, CASE_REPORTED_DATE_UPDATE <= as.Date("2021-03-07")),
           aes(x = !!date_type,
               y = rolling_newcases_100k,
               group = factor(!!byvar),
               color= factor(!!byvar))) +
    geom_line(size= 1.5) +
    # xlab(label="Episode Date") +
    ylab(label= paste0(label, "\n 7-day rolling average")) +
    labs(color = labs)+
    # labs(color="Multi-generation tertile") +
    theme_bw(base_size = 30) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.line = element_line(colour = "black"),
          axis.text.x = element_text(angle=45,hjust=1, size = 30),
          axis.text.y = element_text(size = 30),
          legend.position = "bottom",
          legend.text=element_text(size= 30)) +
    scale_x_date(limits = c(as.Date("2021-02-03"), as.Date("2021-03-10")),
                 breaks = seq.Date(as.Date("2021-02-03"), as.Date("2021-03-10"), by = 7))+
    scale_y_continuous(limits = c(0, ylimit1),
                       breaks = seq(0, ylimit1, space1))+
    theme(legend.position="none") + xlab(label="Report Date") + ggtitle("Toronto and Peel Public Health")
  
  return(fig_new)
  
}


(Fig1A = epidemic_curve_by_var_Peel_Toronto(byvar_raw ="d_essential", 
                                            rank_type = "tertile", 
                                            labs = "Essential services tertile",
                                            ylimit1 = 25,
                                            ylimit2 = 500,
                                            space1 = 5,
                                            space2 = 50,
                                            new_var = "case_new_all",
                                            cum_var = "case_cum_all",
                                            label = "Daily COVID-19 cases per 100,000 population") + ggtitle("(A)"))

(Fig1B = epidemic_curve_by_var_Peel_Toronto(byvar_raw ="d_essential", 
                                            rank_type = "tertile", 
                                            labs = "Essential services tertile",
                                            ylimit1 = 10,
                                            ylimit2 = 200,
                                            space1 = 5,
                                            space2 = 20,
                                            new_var = "variant_new_all_basedonVOCtest",
                                            cum_var = "variant_cum_all_basedon_basedonVOCtest",
                                            label = "Daily COVID-19 VOC cases per 100,000 population")  + ggtitle("(B)"))



iphis_DA_subtype_DA_essential_noLTCF =
  iphis_DA_overall_noLTCF_Feb03_DA %>% 
  filter(!is.na(d_essential_rank_tert)) %>%
  group_by(PHU_name, d_essential_rank_tert, CASE_REPORTED_DATE_UPDATE) %>%
  summarize(total_new_case = sum(case_new_all),
            total_cum_case = sum(case_cum_all),
            total_new_variant_basedon_subtype = sum(variant_new_all_basedon_subtype),
            total_cum_variant_basedon_subtype = sum(variant_cum_all_basedon_subtype),
            total_new_variant_basedonVOCtest = sum(variant_new_all_basedonVOCtest),
            total_cum_variant_basedonVOCtest = sum(variant_cum_all_basedon_basedonVOCtest),
            total_new_variant_tests = sum(variant_new_testing),
            total_cum_variant_tests = sum(variant_cum_all_testing))
write.csv(iphis_DA_subtype_DA_essential_noLTCF, "J:/MishraTeam/SM Review/COVID-19/data/variant/iphis_DA_subtype_DA_essential_noLTCF.csv", row.names = F)

iphis_DA_subtype_DA_essential_Toronto_Peel_noLTCF = subset(iphis_DA_subtype_DA_essential_noLTCF, PHU_name %in% c("City of Toronto Health Unit",
                                                                                                                 "Peel Regional Health Unit"))
write.csv(iphis_DA_subtype_DA_essential_Toronto_Peel_noLTCF, "J:/MishraTeam/SM Review/COVID-19/data/variant/iphis_DA_subtype_DA_essential_Toronto_Peel__noLTCF_March10.csv", row.names = F)

iphis_DA_subtype_DA_essential_noLTCF_PEEL_TORONTO_MAR1_7_10 =
  iphis_DA_overall_noLTCF_Feb03_DA %>% 
  filter(PHU_name %in% c("City of Toronto Health Unit",
                                                         "Peel Regional Health Unit") &
           CASE_REPORTED_DATE_UPDATE %in% c(as.Date("2021-03-01"), as.Date("2021-03-07"), as.Date("2021-03-10"))) %>%
  group_by(d_essential_rank_tert, CASE_REPORTED_DATE_UPDATE) %>%
  summarize(total_new_case = sum(case_new_all),
            total_cum_case = sum(case_cum_all),
            total_new_variant_basedon_subtype = sum(variant_new_all_basedon_subtype),
            total_cum_variant_basedon_subtype = sum(variant_cum_all_basedon_subtype),
            total_new_variant_basedonVOCtest = sum(variant_new_all_basedonVOCtest),
            total_cum_variant_basedonVOCtest = sum(variant_cum_all_basedon_basedonVOCtest),
            total_new_variant_tests = sum(variant_new_testing),
            total_cum_variant_tests = sum(variant_cum_all_testing))


(Fig1C_count = ggplot(subset(iphis_DA_subtype_DA_essential_Toronto_Peel_noLTCF,
                             PHU_name %in% c("City of Toronto Health Unit",
                                             "Peel Regional Health Unit")), 
                      aes(fill=factor(d_essential_rank_tert),
                          y=total_cum_case, 
                          x=CASE_REPORTED_DATE_UPDATE)) + 
    geom_bar(position="stack",  stat="identity") +
    # facet_wrap(~PHU_name) +
    labs(fill="Employed in essential services") + 
    theme_bw(base_size = 30) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.line = element_line(colour = "black"),
          axis.text.x = element_text(angle=45,hjust=1, size = 30),
          axis.text.y = element_text(size = 30),
          legend.position = "bottom",
          legend.text=element_text(size= 30)) +
    geom_col(position = position_stack(reverse = T))+
    xlab("Report date") +
    ylab("Cumulative COVID-19 cases") +
    ylim(0, 20000) +
    scale_x_date(limits = c(as.Date("2021-02-03"), as.Date("2021-03-11")),
                 breaks = seq.Date(as.Date("2021-02-03"), as.Date("2021-03-10"), by = 7)) + ggtitle("(C)"))


(Fig1D_count = ggplot(subset(iphis_DA_subtype_DA_essential_Toronto_Peel_noLTCF,
                             PHU_name %in% c("City of Toronto Health Unit",
                                             "Peel Regional Health Unit")), 
                      aes(fill=factor(d_essential_rank_tert),
                          y=total_cum_variant_basedonVOCtest, 
                          x=CASE_REPORTED_DATE_UPDATE)) + 
    geom_bar(position="stack",  stat="identity") +
    # facet_wrap(~PHU_name) +
    labs(fill="Employed in essential services") + 
    theme_bw(base_size = 30) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.line = element_line(colour = "black"),
          axis.text.x = element_text(angle=45,hjust=1, size = 30),
          axis.text.y = element_text(size = 30),
          legend.position = "bottom",
          legend.text=element_text(size= 30)) +
    geom_col(position = position_stack(reverse = T))+
    xlab("Report date") +
    ylab("Cumulative COVID-19 VOC cases") +
    ylim(0, 6000) +
    scale_x_date(limits = c(as.Date("2021-02-03"), as.Date("2021-03-11")),
                 breaks = seq.Date(as.Date("2021-02-03"), as.Date("2021-03-10"), by = 7)) + ggtitle("(D)"))



grid.arrange(Fig1A, Fig1B, Fig1C_perc, Fig1D_perc)

g <- arrangeGrob(Fig1A, Fig1B, Fig1C_count, Fig1D_count, nrow=2) #generates g
ggsave(file= paste0("J:/MishraTeam/SM Review/COVID-19/data/variant/Figure1_count.png"), 
       width = 24, height = 24, limitsize = FALSE, g) #saves g

#################################################################################################


(Fig2A = epidemic_curve_by_var_Peel_Toronto(byvar_raw ="d_after_tax_income_PPE", 
                                            rank_type = "tertile", 
                                            labs = "After-tax income tertile",
                                            ylimit1 = 25,
                                            ylimit2 = 500,
                                            space1 = 5,
                                            space2 = 50,
                                            new_var = "case_new_all",
                                            cum_var = "case_cum_all",
                                            label = "Daily COVID-19 cases per 100,000 population") + ggtitle("(A)"))

(Fig2B = epidemic_curve_by_var_Peel_Toronto(byvar_raw ="d_after_tax_income_PPE", 
                                            rank_type = "tertile", 
                                            labs = "After-tax income tertile",
                                            ylimit1 = 10,
                                            ylimit2 = 200,
                                            space1 = 5,
                                            space2 = 20,
                                            new_var = "variant_new_all_basedonVOCtest",
                                            cum_var = "variant_cum_all_basedon_basedonVOCtest",
                                            label = "Daily COVID-19 VOC cases per 100,000 population")  + ggtitle("(B)"))



iphis_DA_subtype_DA_income_noLTCF =
  iphis_DA_overall_noLTCF_Feb03_DA %>% 
  filter(!is.na(d_after_tax_income_PPE_rank_tert)) %>%
  group_by(PHU_name, d_after_tax_income_PPE_rank_tert, CASE_REPORTED_DATE_UPDATE) %>%
  summarize(total_new_case = sum(case_new_all),
            total_cum_case = sum(case_cum_all),
            total_new_variant_basedon_subtype = sum(variant_new_all_basedon_subtype),
            total_cum_variant_basedon_subtype = sum(variant_cum_all_basedon_subtype),
            total_new_variant_basedonVOCtest = sum(variant_new_all_basedonVOCtest),
            total_cum_variant_basedonVOCtest = sum(variant_cum_all_basedon_basedonVOCtest),
            total_new_variant_tests = sum(variant_new_testing),
            total_cum_variant_tests = sum(variant_cum_all_testing))
write.csv(iphis_DA_subtype_DA_income_noLTCF, "J:/MishraTeam/SM Review/COVID-19/data/variant/iphis_DA_subtype_DA_income_noLTCF.csv", row.names = F)

iphis_DA_subtype_DA_income_Toronto_Peel_noLTCF = subset(iphis_DA_subtype_DA_income_noLTCF, PHU_name %in% c("City of Toronto Health Unit",
                                                                                                                 "Peel Regional Health Unit"))
write.csv(iphis_DA_subtype_DA_income_Toronto_Peel_noLTCF, "J:/MishraTeam/SM Review/COVID-19/data/variant/iphis_DA_subtype_DA_income_Toronto_Peel_noLTCF_March16.csv", row.names = F)

iphis_DA_subtype_DA_income_noLTCF_PEEL_TORONTO_MAR1_7_10 =
  iphis_DA_overall_noLTCF_Feb03_DA %>% 
  filter(PHU_name %in% c("City of Toronto Health Unit",
                         "Peel Regional Health Unit") &
           CASE_REPORTED_DATE_UPDATE %in% c(as.Date("2021-03-01"), as.Date("2021-03-07"), as.Date("2021-03-10"))) %>%
  group_by(d_after_tax_income_PPE_rank_tert, CASE_REPORTED_DATE_UPDATE) %>%
  summarize(total_new_case = sum(case_new_all),
            total_cum_case = sum(case_cum_all),
            total_new_variant_basedon_subtype = sum(variant_new_all_basedon_subtype),
            total_cum_variant_basedon_subtype = sum(variant_cum_all_basedon_subtype),
            total_new_variant_basedonVOCtest = sum(variant_new_all_basedonVOCtest),
            total_cum_variant_basedonVOCtest = sum(variant_cum_all_basedon_basedonVOCtest),
            total_new_variant_tests = sum(variant_new_testing),
            total_cum_variant_tests = sum(variant_cum_all_testing))

(Fig2C_count = ggplot(subset(iphis_DA_subtype_DA_income_Toronto_Peel_noLTCF,
                             PHU_name %in% c("City of Toronto Health Unit",
                                             "Peel Regional Health Unit")), 
                      aes(fill=factor(d_after_tax_income_PPE_rank_tert),
                          y=total_cum_case, 
                          x=CASE_REPORTED_DATE_UPDATE)) + 
    geom_bar(position="stack",  stat="identity") +
    # facet_wrap(~PHU_name) +
    labs(fill="After-tax income") + 
    theme_bw(base_size = 30) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.line = element_line(colour = "black"),
          axis.text.x = element_text(angle=45,hjust=1, size = 30),
          axis.text.y = element_text(size = 30),
          legend.position = "bottom",
          legend.text=element_text(size= 30)) +
    geom_col(position = position_stack(reverse = T))+
    xlab("Report date") +
    ylab("Cumulative COVID-19 cases") +
    ylim(0, 20000) +
    scale_x_date(limits = c(as.Date("2021-02-03"), as.Date("2021-03-11")),
                 breaks = seq.Date(as.Date("2021-02-03"), as.Date("2021-03-10"), by = 7)) + ggtitle("(C)"))


(Fig2D_count = ggplot(subset(iphis_DA_subtype_DA_income_Toronto_Peel_noLTCF,
                             PHU_name %in% c("City of Toronto Health Unit",
                                             "Peel Regional Health Unit")), 
                      aes(fill=factor(d_after_tax_income_PPE_rank_tert),
                          y=total_cum_variant_basedonVOCtest, 
                          x=CASE_REPORTED_DATE_UPDATE)) + 
    geom_bar(position="stack",  stat="identity") +
    # facet_wrap(~PHU_name) +
    labs(fill="After-tax income") + 
    theme_bw(base_size = 30) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.line = element_line(colour = "black"),
          axis.text.x = element_text(angle=45,hjust=1, size = 30),
          axis.text.y = element_text(size = 30),
          legend.position = "bottom",
          legend.text=element_text(size= 30)) +
    geom_col(position = position_stack(reverse = T))+
    xlab("Report date") +
    ylab("Cumulative COVID-19 VOC cases") +
    ylim(0, 6000) +
    scale_x_date(limits = c(as.Date("2021-02-03"), as.Date("2021-03-11")),
                 breaks = seq.Date(as.Date("2021-02-03"), as.Date("2021-03-10"), by =7)) + ggtitle("(D)"))



g <- arrangeGrob(Fig2A, Fig2B, Fig2C_count, Fig2D_count, nrow=2) #generates g
ggsave(file= paste0("J:/MishraTeam/SM Review/COVID-19/data/variant/Figure2_count.png"), 
       width = 24, height = 24, limitsize = FALSE, g) #saves g



