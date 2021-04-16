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
library(data.table)

#################################################################################
#set working directory as appropriate
setwd("J:/MishraTeam/COVID-19_spatial_project/repo/covid-neighbourhoods")
DA_list = read_excel("J:/MishraTeam/COVID-19_spatial_project/repo/covid-neighbourhoods/data/private/raw/ConversionFiles/Conversion_DAs16_to_NHs396_04June2020_v12a.xlsx",
                     sheet = "DAs16_N396_v12_04June2020", range = "A1:W20006")
nrow(DA_list)
DA_list_sub = DA_list[, c("DA2016_num",
                          "OCHPPid",
                          "NHid",
                          "NHid_apNum",
                          "NHname",
                          "HRname")]
length(unique(DA_list_sub$DA2016_num))

table(DA_list_sub$HRname, exclude = NULL)

DA_full_list_Toronto = subset(DA_list_sub, HRname == "City of Toronto Health Unit")

pops = read_excel("J:/MishraTeam/COVID-19_spatial_project/repo/covid-neighbourhoods/data/private/raw/Census2016_Variables/PopCounts_Income_DAsCSDsCDs_GTA.xlsx",
                  sheet = "VariableCountsBY_Geography", range = "B2:D8327")

colnames(pops)
nrow(pops)
ncol(pops)

setnames(pops,
         colnames(pops), c("DAUID",
                           "FirstNation",
                           "DA_population"))
nrow(pops)
# write.csv(pops, "./data/private/r_processed/DA_total_pops.csv", row.names = F)

#########################################################################################################################
##multigeneration household
multi_household = read.csv("J:/MishraTeam/COVID-19_spatial_project/repo/covid-neighbourhoods/data/private/raw/Census2016_Variables/EO3139_T17A_2016_DA_MultiGenHHLDS_02Dec2020_TRIM.csv", header = T)
colnames(multi_household)
table(multi_household$Age_Group, exclude = NULL)
multi_household_total = subset(multi_household, Age_Group == "Total - Age")
nrow(multi_household_total)

#########################################################################################################################
# DA_variables = read_excel("./data/private/raw/Census2016_Variables/ModelVariables_IncDwellDensity_ONT_DAsCSDs_06Nov2020.xlsx",
#                           sheet = "98-401-X2016044_SELVars_DA_noFN", range = "A2:BY20007")
DA_variables = read_excel("J:/MishraTeam/COVID-19_spatial_project/repo/covid-neighbourhoods/data/private/raw/Census2016_Variables/ModelVariables_IncDwellDensityOccTransp_ONT_DAsCSDs_07Dec2020c_ISSUED.xlsx",
                          sheet = "98-401-X2016044_SELVars_DA_noFN", range = "A3:FE20008")

colnames(DA_variables)
nrow(DA_variables)
ncol(DA_variables)
summary(DA_variables$DA16UID)
table(DA_variables$'Government transfers (%)', exclude = NULL)


#############################################################################################
quin <- function (x, desc){
  if(desc == T){
    y <-ifelse(x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.2),na.rm=TRUE), 5,
               ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.2),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.4),na.rm=TRUE), 4,
                      ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.4),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.6),na.rm=TRUE), 3,
                             ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.6),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.8),na.rm=TRUE), 2,
                                    ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.8),na.rm=TRUE), 1, NA)))))
  }
  if(desc == F){
    y <-ifelse(x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.2),na.rm=TRUE), 1,
               ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.2),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.4),na.rm=TRUE), 2,
                      ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.4),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.6),na.rm=TRUE), 3,
                             ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.6),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.8),na.rm=TRUE), 4,
                                    ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.8),na.rm=TRUE), 5, NA)))))
  }
  
  y
}

perc <- function (x, desc){
  if(desc == T){
    y <-ifelse(x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.25),na.rm=TRUE), 4,
               ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.25),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.5),na.rm=TRUE), 3,
                      ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.5),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.75),na.rm=TRUE), 2,
                             ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.75),na.rm=TRUE), 1,NA))))
  }
  
  if(desc == F){
    y <-ifelse(x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.25),na.rm=TRUE), 1,
               ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.25),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.5),na.rm=TRUE), 2,
                      ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.5),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.75),na.rm=TRUE), 3,
                             ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.75),na.rm=TRUE), 4,NA))))
  }
  y
}

deci <- function (x, desc){
  if(desc == T){
    y <-ifelse(x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.1),na.rm=TRUE), 10,
               ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.1),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.2),na.rm=TRUE), 9,
                      ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.2),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.3),na.rm=TRUE), 8,
                             ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.3),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.4),na.rm=TRUE), 7,
                                    ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.4),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.5),na.rm=TRUE), 6,
                                           ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.5),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.6),na.rm=TRUE), 5,
                                                  ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.6),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.7),na.rm=TRUE), 4,
                                                         ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.7),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.8),na.rm=TRUE), 3,
                                                                ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.8),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.9),na.rm=TRUE), 2,
                                                                       ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.9),na.rm=TRUE), 1, NA))))))))))
  }
  
  if(desc == F){
    y <-ifelse(x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.1),na.rm=TRUE), 1,
               ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.1),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.2),na.rm=TRUE), 2,
                      ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.2),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.3),na.rm=TRUE), 3,
                             ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.3),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.4),na.rm=TRUE), 4,
                                    ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.4),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.5),na.rm=TRUE), 5,
                                           ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.5),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.6),na.rm=TRUE), 6,
                                                  ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.6),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.7),na.rm=TRUE), 7,
                                                         ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.7),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.8),na.rm=TRUE), 8,
                                                                ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.8),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.9),na.rm=TRUE), 9,
                                                                       ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.9),na.rm=TRUE), 10, NA))))))))))
  }
 
  y
}

tertile <- function (x, desc){
  if(desc == T){
    y <-ifelse(x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.33),na.rm=TRUE), 3,
               ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.33),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.67),na.rm=TRUE), 2,
                      ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.67),na.rm=TRUE), 1, NA)))
  }
  if(desc == F){
    y <-ifelse(x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.33),na.rm=TRUE), 1,
               ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.33),na.rm=TRUE)&x<=quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.67),na.rm=TRUE), 2,
                      ifelse(x>quantile(rep(x, income_pop_DA_var_Toronto$DA_population),c(.67),na.rm=TRUE), 3, NA)))
  }
  
  y
}

colnames(DA_variables_Toronto)
DA_variables_Toronto_sub = DA_variables_Toronto[, c("DA16UID",
                                                    "Population, 2016",
                                                    "Total Labour Force population aged 15 years and over by Industry - North American Industry Classification System (NAICS) 2012 - 25% sample data - BOTH")]



#########################################################################################################################
# Material deprivation index
MargIndex = read_excel("J:/MishraTeam/COVID-19_spatial_project/repo/covid-neighbourhoods/data/private/raw/ON-Marg2016/ON-Marg2016_DAsCTsPHUsCSDs_ONT_14OCT2020_ISSUED.xlsx",
                       sheet = "ON-Marg2016_DAs_ONT", range = "A4:E20164")
colnames(MargIndex)
MargIndex_Toronto = subset(MargIndex, DA16UID_txt %in% DA_full_list_Toronto$DA2016_num)
nrow(MargIndex_Toronto)
table(MargIndex_Toronto$'deprivation2016_DA', exclude = NULL)
summary(MargIndex_Toronto$'deprivation2016_DA')

colnames(MargIndex_Toronto)

###################
# income_ON = read_excel("./data/private/raw/COVID19 Modeling - income-occ by DA - 2020-12-04.xlsx",
#                        sheet = "da_income_occ", range = "A1:X20161")

income_ON = read_excel("./data/private/raw/COVID19 Modeling - income-occ by DA - 2021-01-04.xlsx",
                       sheet = "da_income_occ", range = "A1:Y20161")

colnames(income_ON)
ncol(income_ON)
nrow(income_ON)
income_ON$DA = income_ON$prcdda

table(income_ON$`After tax income quintile`, exclude = NULL)
income_Toronto = subset(income_ON, DA %in% DA_full_list_Toronto$DA2016_num)
nrow(income_Toronto)
ncol(income_Toronto)
colnames(income_Toronto)

table(income_Toronto$`After tax income quintile`, exclude = NULL)
table(income_Toronto$`After tax income decile`, exclude = NULL)
table(income_Toronto$CMA_name, exclude = NULL)

nrow(pops)
colnames(pops)
nrow(income_ON)
colnames(income_ON)
income_pop_Toronto = merge(pops, income_Toronto, 
                           by.x = 'DAUID', by.y = "DA", all.y = T)
nrow(income_pop_Toronto)

income_pop_deprivation_Toronto = merge(income_pop_Toronto,
                                       MargIndex_Toronto, 
                                       by.x = 'DAUID', by.y = "DA16UID_txt", all.x = T)
nrow(income_pop_deprivation_Toronto)
colnames(income_pop_deprivation_Toronto)

colnames(multi_household_total)
income_pop_deprivation_Toronto_multi_gene = merge(income_pop_deprivation_Toronto, 
                                                  multi_household_total, 
                                                  by.x = 'DAUID', by.y = "DA16UID", all.x = T)
nrow(income_pop_deprivation_Toronto_multi_gene)
income_pop_DA_var_Toronto = merge(income_pop_deprivation_Toronto_multi_gene, 
                                  DA_variables_Toronto_sub, 
                                  by.x = 'DAUID', by.y = "DA16UID", all = T)
nrow(income_pop_DA_var_Toronto)
colnames(income_pop_DA_var_Toronto)

#####################################
# "Employed in sales/trades/manufacturing/agriculture (%)"    
income_pop_DA_var_Toronto$d_sales_trades_manufacturing_agriculture = as.numeric(income_pop_DA_var_Toronto$`Employed in sales/trades/manufacturing/agriculture (%)`)
summary(income_pop_DA_var_Toronto$d_sales_trades_manufacturing_agriculture)


# "Employed in health (%)"    
income_pop_DA_var_Toronto$d_health = as.numeric(income_pop_DA_var_Toronto$`Employed in health (%)`)
summary(income_pop_DA_var_Toronto$d_health)


# "Employed in non-essential (%)"    
income_pop_DA_var_Toronto$d_other_non_essential = income_pop_DA_var_Toronto$d_business_admin + income_pop_DA_var_Toronto$d_education_law_govt + income_pop_DA_var_Toronto$d_executive_managerial_professional
summary(income_pop_DA_var_Toronto$d_other_non_essential)
subset(income_pop_DA_var_Toronto, d_other_non_essential > 100)[, c("d_other_non_essential",
                                                                  "d_business_admin",
                                                                  "d_education_law_govt",
                                                                  "d_executive_managerial_professional")]

# "Employed in all essential (%)"    
income_pop_DA_var_Toronto$d_essential = income_pop_DA_var_Toronto$d_sales_trades_manufacturing_agriculture + income_pop_DA_var_Toronto$d_health
summary(income_pop_DA_var_Toronto$d_essential)

subset(income_pop_DA_var_Toronto, d_essential > 80)[, c("d_essential",
                                                        "d_sales_trades_manufacturing_agriculture",
                                                        "d_health")]



###########################################################################################################################################
###Ranking
###################################
###################################
#d_other_non_essential
summary(income_pop_DA_var_Toronto$d_other_non_essential)

income_pop_DA_var_Toronto$d_other_non_essential_rank_quin = quin(income_pop_DA_var_Toronto$d_other_non_essential, desc = F)
income_pop_DA_var_Toronto$d_other_non_essential_rank_deci = deci(income_pop_DA_var_Toronto$d_other_non_essential, desc = F)
income_pop_DA_var_Toronto$d_other_non_essential_rank_tert = tertile(income_pop_DA_var_Toronto$d_other_non_essential, desc = F)

table(income_pop_DA_var_Toronto$d_other_non_essential_rank_quin, exclude = NULL)
table(income_pop_DA_var_Toronto$d_other_non_essential_rank_deci, exclude = NULL)
table(income_pop_DA_var_Toronto$d_other_non_essential_rank_tert, exclude = NULL)


###################################
#d_essential
summary(income_pop_DA_var_Toronto$d_essential)

income_pop_DA_var_Toronto$d_essential_rank_quin = quin(income_pop_DA_var_Toronto$d_essential, desc = F)
income_pop_DA_var_Toronto$d_essential_rank_deci = deci(income_pop_DA_var_Toronto$d_essential, desc = F)
income_pop_DA_var_Toronto$d_essential_rank_tert = tertile(income_pop_DA_var_Toronto$d_essential, desc = F)

table(income_pop_DA_var_Toronto$d_essential_rank_quin, exclude = NULL)
table(income_pop_DA_var_Toronto$d_essential_rank_deci, exclude = NULL)
table(income_pop_DA_var_Toronto$d_essential_rank_tert, exclude = NULL)




######################################################################
DA_level_characteristics <- function(byvar_raw){

  byvar_raw <- as.name(byvar_raw)                 # Create quosure
  # date_type  <- as.name(date_type)                # Create quosure

  byvar = paste0(byvar_raw,  "_rank_tert")
  byvar <- as.name(byvar)                 # Create quosure
  
  
  DA_level =
    # income_pop_DA_var_Toronto %>%
    DA %>%
    group_by(!!byvar) %>%
    summarize(total_pop = sum(DA_population),
              mean = round(mean(!!byvar_raw, na.rm = T), 1),
              median = round(median(!!byvar_raw, na.rm = T), 1),
              IQR = paste0(round(quantile(!!byvar_raw, 1/4, na.rm = T), 1), " - ",
                           round(quantile(!!byvar_raw, 3/4, na.rm = T), 1)))%>%
    mutate(median_IQR = paste0(median, " (", IQR, ")"))

  DA_level$var_name = quo_name(byvar_raw)
  write.csv(DA_level, paste0("./fig/", "DA_level_summary_Toronto_overall_", byvar, ".csv"), row.names = F)

  return(DA_level)
}

DA_level_characteristics(byvar_raw = "d_essential")

