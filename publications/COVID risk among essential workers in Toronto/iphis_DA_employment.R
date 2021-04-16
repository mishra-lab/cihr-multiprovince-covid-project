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
DA_list = read_excel("./data/private/raw/ConversionFiles/Conversion_DAs16_to_NHs396_04June2020_v12a.xlsx",
                     sheet = "DAs16_N396_v12_04June2020", range = "A1:W20006")
nrow(DA_list)
colnames(DA_list)
DA_list_sub = DA_list[, c("DA2016_num",
                          "OCHPPid",
                          "NHid",
                          "NHid_apNum",
                          "NHname",
                          "HRname",
                          "HRid")]
length(unique(DA_list_sub$DA2016_num))
DA_full_list_ON = DA_list_sub[, "DA2016_num"]
nrow(DA_full_list_ON)
table(DA_list_sub$HRname, exclude = NULL)
# write.csv(DA_full_list_ON, "./data/private/r_processed/DA_full_list_ON.csv", row.names = F)
DA_full_list_Toronto = subset(DA_list_sub, HRname == "City of Toronto Health Unit")
DA_full_list_Ottawa = subset(DA_list_sub, HRname == "City of Ottawa Health Unit")

nrow(DA_full_list_Toronto) #3702 DAs in City of Toronto Health Unit
nrow(DA_full_list_Ottawa) #3702 DAs in City of Toronto Health Unit

#################################################################################
# IPHIS_REPORT_SUB = read.csv("J:/MishraTeam/Research/Projects/MathModeling/Covid_model/data/SFTS/OCT 7/IPHIS_REPORT.csv", header = T)
IPHIS_REPORT_SUB = read.csv("J:/MishraTeam/Research/Projects/MathModeling/Covid_model/data/SFTS/2021/FEB 1/IPHIS_REPORT.csv", header = T)
colnames(IPHIS_REPORT_SUB)
nrow(IPHIS_REPORT_SUB)
ncol(IPHIS_REPORT_SUB)
table(IPHIS_REPORT_SUB$SOURCE, exclude = NULL)

###############################################################################
##format all dates and clean dates
IPHIS_REPORT_SUB$CASE_REPORTED_DATE = anydate(IPHIS_REPORT_SUB$CASE_REPORTED_DATE)
IPHIS_REPORT_SUB$ACCURATE_EPISODE_DATE = anydate(IPHIS_REPORT_SUB$ACCURATE_EPISODE_DATE)
IPHIS_REPORT_SUB$CASE_CREATED_DATE = anydate(IPHIS_REPORT_SUB$CASE_CREATED_DATE)
IPHIS_REPORT_SUB$SPECIMENDATE = anydate(IPHIS_REPORT_SUB$SPECIMENDATE)

min(IPHIS_REPORT_SUB$ACCURATE_EPISODE_DATE)
max(IPHIS_REPORT_SUB$ACCURATE_EPISODE_DATE)
min(IPHIS_REPORT_SUB$CASE_CREATED_DATE)
max(IPHIS_REPORT_SUB$CASE_CREATED_DATE)

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


IPHIS_REPORT_SUB$LTCF_RH_shelter_worker = IPHIS_REPORT_SUB$LTCH_HCW == "YES" | IPHIS_REPORT_SUB$OCC_LTCH == "YES" | 
  IPHIS_REPORT_SUB$OCC_RETIREMENTHOME == "YES" | IPHIS_REPORT_SUB$OCC_SHELTERHOMELESSSTAFF  == 'YES'
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

#Toronto
IPHIS_REPORT_SUB_TO = subset(IPHIS_REPORT_SUB,
                             ACCURATE_EPISODE_DATE_UPDATE <= as.Date("2020-11-21") & 
                               DIAGNOSING_HEALTH_UNIT_AREA %in% c("TORONTO (3895)") &
                               LTCH_RESIDENT != "YES")
summary(IPHIS_REPORT_SUB_TO$DAUID) #617 missing
nrow(IPHIS_REPORT_SUB_TO)

IPHIS_REPORT_SUB_TO_withDAUID = subset(IPHIS_REPORT_SUB_TO, !is.na(DAUID) & DAUID  %in% as.numeric(DA_full_list_Toronto$DA2016_num))
nrow(IPHIS_REPORT_SUB_TO_withDAUID)
sum(IPHIS_REPORT_SUB_TO_withDAUID$DAUID == "0")
summary(IPHIS_REPORT_SUB_TO_withDAUID$DAUID)
1 - nrow(IPHIS_REPORT_SUB_TO_withDAUID)/nrow(IPHIS_REPORT_SUB_TO)
nrow(IPHIS_REPORT_SUB_TO) - nrow(IPHIS_REPORT_SUB_TO_withDAUID)
sum(IPHIS_REPORT_SUB_TO_withDAUID$DAUID %in% as.numeric(DA_full_list_ON$DA2016_num))
nrow(IPHIS_REPORT_SUB_TO) - sum(IPHIS_REPORT_SUB_TO_withDAUID$DAUID %in% as.numeric(DA_full_list_ON$DA2016_num))

IPHIS_REPORT_SUB_TO_check = IPHIS_REPORT_SUB_TO_withDAUID[, c("ACCURATE_EPISODE_DATE_UPDATE", "DAUID")]


##############################################################################
###filter use Toronto DA list directly & report date
IPHIS_REPORT_SUB_ON_withDAUID$CASE_REPORTED_DATE_UPDATE = if_else(is.na(IPHIS_REPORT_SUB_ON_withDAUID$CASE_REPORTED_DATE) |
                                                                    IPHIS_REPORT_SUB_ON_withDAUID$CASE_REPORTED_DATE < "2020-01-10",
                                                                  IPHIS_REPORT_SUB_ON_withDAUID$ACCURATE_EPISODE_DATE_UPDATE,  
                                                                  IPHIS_REPORT_SUB_ON_withDAUID$CASE_REPORTED_DATE)
max(IPHIS_REPORT_SUB_ON_withDAUID$CASE_REPORTED_DATE_UPDATE)
min(IPHIS_REPORT_SUB_ON_withDAUID$CASE_REPORTED_DATE_UPDATE)

iphis_Toronto_DA_Episode_filterwithDAUID_REPORT_DATE =
  IPHIS_REPORT_SUB_ON_withDAUID %>%
  filter(DAUID %in% DA_full_list_Toronto$DA2016_num) %>%
  arrange(DAUID, CASE_REPORTED_DATE_UPDATE) %>%
  group_by(DAUID, CASE_REPORTED_DATE_UPDATE) %>%
  summarise(case_new_all = n(),
            
            case_new_LTCF_worker = sum(LTCF_worker),
            
            case_new_RH_worker = sum(RH_worker),
            
            case_new_LTCF_RH_worker = sum(LTCF_RH_worker),
            
            case_new_shelter_worker = sum(shelter_worker),
            
            case_new_LTCF_RH_shelter_worker = sum(LTCF_RH_shelter_worker),
            
            case_new_other_HCW = sum(other_HCW),
            
            case_new_hospital_nonHCW = sum(hospital_nonHCW),
            
            case_new_travel = sum(LIKELY_ACQUISITION == 'TRAVEL'),
            
            #####################################
            case_new_LTCF_resident = sum(LTCH_RESIDENT == "YES"),
            
            #####################################
            case_new_shelter_resident = sum(Shelterresident),
            
            #####################################
            case_new_total_minus_LTCF_resident = case_new_all - case_new_LTCF_resident,
            
            #####################################
            case_new_total_minus_LTCFshelter_resident  = case_new_all - case_new_LTCF_resident - case_new_shelter_resident,
            
            #####################################
            case_new_total_minus_LTCFshelter_resident_shelter  = case_new_all - case_new_LTCF_resident - case_new_shelter_resident
  ) %>%
  complete(CASE_REPORTED_DATE_UPDATE = seq.Date(min(IPHIS_REPORT_SUB_ON_withDAUID$CASE_REPORTED_DATE_UPDATE), 
                                                max(IPHIS_REPORT_SUB_ON_withDAUID$CASE_REPORTED_DATE_UPDATE), by=1),
           # DAUID = DA_full_list_Toronto$DA2016_num,
           fill = list(case_new_all = 0,
                       
                       case_new_LTCF_worker = 0,
                       
                       case_new_RH_worker = 0,
                       
                       case_new_LTCF_RH_worker = 0,
                       
                       case_new_shelter_worker = 0,
                       
                       case_new_LTCF_RH_shelter_worker = 0,
                       
                       case_new_other_HCW = 0,
                       
                       case_new_hospital_nonHCW = 0,
                       
                       #####################################
                       case_new_travel = 0,
                       
                       #####################################
                       case_new_LTCF_resident = 0,
                       
                       #####################################
                       case_new_shelter_resident = 0,
                       
                       #####################################
                       case_new_total_minus_LTCF_resident = 0,
                       
                       #####################################
                       case_new_total_minus_LTCFshelter_resident = 0,
                       
                       #####################################
                       case_new_total_minus_LTCFshelter_resident_shelter = 0
           ))%>%
  mutate(case_cum_all = cumsum(case_new_all),
         
         case_cum_LTCF_worker = cumsum(case_new_LTCF_worker),
         
         case_cum_RH_worker = cumsum(case_new_RH_worker),
         
         case_cum_LTCF_RH_worker = cumsum(case_new_LTCF_RH_worker),
         
         case_cum_shelter_worker = cumsum(case_new_shelter_worker),
         
         case_cum_LTCF_RH_shelter_worker = cumsum(case_new_LTCF_RH_shelter_worker),
         
         case_cum_other_HCW = cumsum(case_new_other_HCW),
         
         case_cum_hospital_nonHCW = cumsum(case_new_hospital_nonHCW),
         
         #####################################
         case_cum_travel = cumsum(case_new_travel),
         
         #####################################
         case_cum_LTCF_resident = cumsum(case_new_LTCF_resident),
         
         #####################################
         case_cum_shelter_resident = cumsum(case_new_shelter_resident),
         
         #####################################
         case_cum_total_minus_LTCF_resident = cumsum(case_new_total_minus_LTCF_resident),
         
         #####################################
         case_cum_total_minus_LTCFshelter_resident = cumsum(case_new_total_minus_LTCFshelter_resident),
         
         #####################################
         case_cum_total_minus_LTCFshelter_resident_shelter = cumsum(case_new_total_minus_LTCFshelter_resident_shelter)#,
  )


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



##############################
##############################
iphis_DA_death_filterwithDAUID =
  IPHIS_REPORT_SUB_ON_withDAUID %>%
  filter(DAUID %in% DA_full_list_Toronto$DA2016_num & !is.na(CLIENT_DEATH_DATE)) %>%
  arrange(DAUID, CLIENT_DEATH_DATE) %>%
  group_by(DAUID, CLIENT_DEATH_DATE) %>%
  summarise(#####################################
            death_new = sum(Fatal == "Yes"),
            
            death_new_total_minus_LTCF_resident = sum(Fatal == "Yes" & LTCH_RESIDENT !="Yes")
  ) %>%
  complete(CLIENT_DEATH_DATE = seq.Date(min(IPHIS_REPORT_SUB_ON_withDAUID$CLIENT_DEATH_DATE, na.rm= T), 
                                        max(IPHIS_REPORT_SUB_ON_withDAUID$CLIENT_DEATH_DATE, na.rm= T), by=1),
           # DAUID = DA_full_list_Toronto$DA2016_num,
           fill = list(death_new = 0,
                       
                       death_new_total_minus_LTCF_resident = 0
           ))%>%
  mutate(death_cum = cumsum(death_new),
         
         death_cum_total_minus_LTCF_resident = cumsum(death_new_total_minus_LTCF_resident)
  )

nrow(iphis_DA_death_filterwithDAUID)
length(unique(iphis_DA_death_filterwithDAUID$DAUID)) 



##############################################################################################################
##read in DA level variables
DA = read.csv("./data/private/r_processed/DA_total_income_pop_DA_var_Toronto.csv", header = T)
colnames(DA)
nrow(DA)
ncol(DA)

LTCH_population_by_DA = read.csv("./data/private/r_processed/LTCH_population_by_DA.csv", header = T)

DA_LTCH_population_by_DA = merge(DA, LTCH_population_by_DA, by = "DAUID", all.x = T)
DA_LTCH_population_by_DA$LTCH_pop = ifelse(is.na(DA_LTCH_population_by_DA$LTCH_pop), 0, DA_LTCH_population_by_DA$LTCH_pop)
summary(DA_LTCH_population_by_DA$LTCH_pop)

##merge DA level variables with iphis cases
colnames(iphis_Toronto_DA_Episode_filterwithDAUID_REPORT_DATE)

##merge DA level variables with iphis cases
iphis_DA_Report_Date = merge(iphis_Toronto_DA_Episode_filterwithDAUID_REPORT_DATE, DA, by = c("DAUID"), all.x = T)
colnames(iphis_DA_Report_Date)
nrow(iphis_DA_Report_Date)
ncol(iphis_DA_Report_Date)

iphis_DA_Report_Date = arrange(iphis_DA_Report_Date, DAUID)

sum(subset(iphis_DA_Report_Date, CASE_REPORTED_DATE_UPDATE == "2021-01-24")$case_cum_total_minus_LTCF_resident)
####################################################################################
############death date
iphis_DA_death = merge(iphis_DA_death_filterwithDAUID, DA, by = c("DAUID"), all.x = T)
table(iphis_DA_death$PHU_name)

sum(subset(iphis_DA_death, CLIENT_DEATH_DATE == "2021-01-24")$death_cum_total_minus_LTCF_resident)
