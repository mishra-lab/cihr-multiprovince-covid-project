rm(list=ls(all.names=TRUE)) 

library(ggplot2)
library(dplyr)
library(reshape2)
library(tidyr)
library(stringr)
library(gridExtra)
library(anytime)
library("readxl")
library(DescTools)


#################################################################################
#set working directory as appropriate
setwd("J:/MishraTeam/COVID-19_spatial_project/manuscript/Employment and COVID risk")

######################################
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
DA_full_list_Toronto = subset(DA_list_sub, HRname == "City of Toronto Health Unit")

DA = read.csv("./data/DA_total_income_pop_DA_var_Toronto.csv", header = T)
colnames(DA)
nrow(DA)
ncol(DA)


DA_Toronto = subset(DA, DAUID %in% DA_full_list_Toronto$DA2016_num)
sum(DA_Toronto$DA_population)


summary(DA_Toronto$d_sales_services_rank_tert)

date_cut_employment = "2021-01-24"

epidemic_curve_by_var <- function(byvar_raw, rank_type){
  
  library(zoo)
  
  byvar_raw  <- as.name(byvar_raw)
  
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
  # date_type  <- as.name(date_type)                # Create quosure
  
  DA_Toronto_population =
    DA_Toronto %>%
    group_by(!!byvar) %>%
    summarize(Population = sum(DA_population))
  
  iphis_DA_aggregated =
    iphis_DA_Report_Date %>% 
    filter(!is.na(!!byvar)) %>%
    group_by(!!byvar, CASE_REPORTED_DATE_UPDATE) %>%
    summarize(total_new_case = sum(case_new_total_minus_LTCF_resident),
              total_cum_case = sum(case_cum_total_minus_LTCF_resident))
  
  iphis_DA_aggregated_pop = merge(iphis_DA_aggregated, DA_Toronto_population, all.x = T)
  iphis_DA_aggregated_pop$total_new_case100k = iphis_DA_aggregated_pop$total_new_case/iphis_DA_aggregated_pop$Population * 100000
  iphis_DA_aggregated_pop$total_cum_caseper100k = iphis_DA_aggregated_pop$total_cum_case/iphis_DA_aggregated_pop$Population * 100000
  
  iphis_DA_aggregated_pop_rolling =
    iphis_DA_aggregated_pop %>% 
    filter(!is.na(!!byvar)) %>%
    group_by(!!byvar) %>%
    mutate(rolling_newcases_100k = rollmean(total_new_case100k, k = 7, fill = NA))
  write.csv(iphis_DA_aggregated_pop_rolling, "./fig/Figure1_cases.csv", row.names = F)
  
  return(iphis_DA_aggregated_pop_rolling)
}


colnames(iphis_DA_Report_Date)

##########
# all essential
#####decile
iphis_DA_aggregated_pop = epidemic_curve_by_var("d_essential", rank_type = "tertile")
iphis_DA_aggregated_pop$d_essential_rank_tert_label = ifelse(iphis_DA_aggregated_pop$d_essential_rank_tert == 1,
                                                             "1 = 27.8% (23.4-31.5)", 
                                                             ifelse(iphis_DA_aggregated_pop$d_essential_rank_tert == 2,
                                                                    "2 = 44.7% (40.0-50.0)",
                                                                    ifelse(iphis_DA_aggregated_pop$d_essential_rank_tert == 3,
                                                                           "3 = 62.9% (58.4-68.0)", NA)))
table(iphis_DA_aggregated_pop$d_essential_rank_tert, iphis_DA_aggregated_pop$d_essential_rank_tert_label, exclude = NULL)

(Figure2A =
    ggplot(subset(iphis_DA_aggregated_pop, CASE_REPORTED_DATE_UPDATE <= as.Date(date_cut_employment)),
           aes(CASE_REPORTED_DATE_UPDATE, total_cum_caseper100k)) +  
    geom_line(aes(color=factor(d_essential_rank_tert_label)), size=2) +
    xlab(label="Report Date") +
    ylab(label="Cumulative Diagnosed COVID-19 Cases \n per 100k population (excluding LTCH residents)") +
    labs(color="") + 
    theme_bw(base_size = 30) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.line = element_line(colour = "black"),
          axis.text.x = element_text(angle=45,hjust=1, size = 30),
          axis.text.y = element_text(size = 30),
          legend.position = "bottom",
          legend.text=element_text(size= 30)) +
    scale_x_date(breaks = c(as.Date("2020-01-23"),
                            as.Date("2020-02-24"),
                            as.Date("2020-03-24"),
                            as.Date("2020-04-24"),
                            as.Date("2020-05-24"),
                            as.Date("2020-06-24"),
                            as.Date("2020-07-24"),
                            as.Date("2020-08-24"),
                            as.Date("2020-09-24"),
                            as.Date("2020-10-24"),
                            as.Date("2020-11-24"),
                            as.Date("2020-12-24"),
                            as.Date("2021-01-24")))+
    scale_y_continuous(limits = c(0, 4000),
                       breaks = seq(0, 4000, 500))+
    ggtitle("(C)"))



(Figure1A_shading =
    ggplot(subset(iphis_DA_aggregated_pop, CASE_REPORTED_DATE_UPDATE <= as.Date(date_cut_employment)), 
           aes(CASE_REPORTED_DATE_UPDATE, rolling_newcases_100k)) +  
    geom_line(aes(color= factor(d_essential_rank_tert_label)),size=2) +
    xlab(label="Report Date") +
    ylab(label="Daily Diagnosed COVID-19 Cases \n per 100k population (excluding LTCH residents)") +
    labs(color="Median (IQR) Proportion Essential Workers") + 
    guides(colour = guide_legend(title.position = "top")) +
    theme_bw(base_size = 30) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.line = element_line(colour = "black"),
          axis.text.x = element_text(angle= 45,hjust=1, size = 30),
          axis.text.y = element_text(size = 30),
          legend.position = "right",
          legend.text=element_text(size= 30)) +
    scale_x_date(breaks = c(as.Date("2020-01-23"),
                            as.Date("2020-02-24"),
                            as.Date("2020-03-24"),
                            as.Date("2020-04-24"),
                            as.Date("2020-05-24"),
                            as.Date("2020-06-24"),
                            as.Date("2020-07-24"),
                            as.Date("2020-08-24"),
                            as.Date("2020-09-24"),
                            as.Date("2020-10-24"),
                            as.Date("2020-11-24"),
                            as.Date("2020-12-24"),
                            as.Date("2021-01-24")))+
    scale_y_continuous(limits = c(0, 60),
                       breaks = seq(0, 60, 15)) +
    ggtitle("(A)")+
    geom_vline(xintercept = as.Date("2020-03-17"), size = 1, linetype = 2, color = "gray25")+
    annotate("text", x=as.Date("2020-03-11"), y= 40, 
             label="a", 
             color="gray25", size = 12) +
    geom_vline(xintercept = as.Date("2020-05-19"), size = 1, linetype = 2, color = "gray25")+
    annotate("text", x=as.Date("2020-05-13"), y= 40, 
             label="b", 
             color="gray25", size = 12) +
    geom_vline(xintercept = as.Date("2020-11-23"), size = 1, linetype = 2, color = "gray25")+
    annotate("text", x=as.Date("2020-11-17"), y= 40, 
             label="c", 
             color="gray25", size = 12)+ 
    geom_vline(xintercept = as.Date("2020-12-26"), size = 1, linetype = 2, color = "gray25")+
    annotate("text", x=as.Date("2020-12-20"), y= 40, 
             label="d", 
             color="gray25", size = 12)+ 
    theme(legend.position = "bottom") +
    annotate("rect", xmin = as.Date("2020-03-17"), xmax = as.Date("2020-05-18"), ymin = 0, ymax = Inf, 
             alpha = .2) +
    annotate("rect", xmin = as.Date("2020-11-23"), xmax = as.Date("2021-01-24"), ymin = 0, ymax = Inf, 
             alpha = .2))




#########################
epidemic_curve_by_var_death <- function(byvar_raw, 
                                        rank_type){
  
  library(zoo)
  ################################################
  date_type = "CLIENT_DEATH_DATE"
  
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
  
  
  ###################################################################################
  DA_population =
    DA %>%
    group_by(!!byvar) %>%
    summarize(Population = sum(DA_population))
  
  
  iphis_DA_aggregated =
    iphis_DA_death %>%
    filter(!is.na(!!byvar)) %>%
    group_by(!!byvar, !!date_type) %>%
    summarize(total_new_death = sum(death_new_total_minus_LTCF_resident),
              total_cum_death = sum(death_cum_total_minus_LTCF_resident))
  
  iphis_DA_aggregated_pop = merge(iphis_DA_aggregated, DA_population, all.x = T)
  iphis_DA_aggregated_pop$total_new_death100k = iphis_DA_aggregated_pop$total_new_death/iphis_DA_aggregated_pop$Population * 100000
  iphis_DA_aggregated_pop$total_cum_deathper100k = iphis_DA_aggregated_pop$total_cum_death/iphis_DA_aggregated_pop$Population * 100000

  iphis_DA_aggregated_pop_rolling =
    iphis_DA_aggregated_pop %>%
    filter(!is.na(!!byvar)) %>%
    group_by(!!byvar) %>%
    mutate(rolling_newdeah_100k = rollmean(total_new_death100k, k = 7, fill = NA))
  
  write.csv(iphis_DA_aggregated_pop_rolling, "./fig/Figure2_death.csv", row.names = F)
  return(iphis_DA_aggregated_pop_rolling)
}


iphis_DA_aggregated_pop_death = epidemic_curve_by_var_death("d_essential", rank_type = "tertile")
iphis_DA_aggregated_pop_death$d_essential_rank_tert_label = ifelse(iphis_DA_aggregated_pop_death$d_essential_rank_tert == 1,
                                                             "1 = 27.8% (23.4-31.5)", 
                                                             ifelse(iphis_DA_aggregated_pop_death$d_essential_rank_tert == 2,
                                                                    "2 = 44.7% (40.0-50.0)",
                                                                    ifelse(iphis_DA_aggregated_pop_death$d_essential_rank_tert == 3,
                                                                           "3 = 62.9% (58.4-68.0)", NA)))
table(iphis_DA_aggregated_pop_death$d_essential_rank_tert, iphis_DA_aggregated_pop_death$d_essential_rank_tert_label, exclude = NULL)

(Figure2B =
    ggplot(subset(iphis_DA_aggregated_pop_death, CLIENT_DEATH_DATE <= as.Date(date_cut_employment)),
           aes(x = CLIENT_DEATH_DATE,
               y = total_cum_deathper100k,
               group = factor(d_essential_rank_tert_label),
               color= factor(d_essential_rank_tert_label))) +
    geom_line(size= 1.5) +
    ylab(label="Cumulative COVID-19-related death per 100k population \n (excluding LTCF residents) 7-day rolling average") +
    labs(color = "")+
    # labs(color="Multi-generation tertile") + 
    theme_bw(base_size = 30) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.line = element_line(colour = "black"),
          axis.text.x = element_text(angle= 45,hjust=1, size = 30),
          axis.text.y = element_text(size = 30),
          legend.position = "right",
          legend.text=element_text(size= 30)) +
    scale_x_date(limits = c(as.Date("2020-01-23"),
                            as.Date("2021-01-24")),
                 breaks = c(as.Date("2020-01-23"),
                            as.Date("2020-02-24"),
                            as.Date("2020-03-24"),
                            as.Date("2020-04-24"),
                            as.Date("2020-05-24"),
                            as.Date("2020-06-24"),
                            as.Date("2020-07-24"),
                            as.Date("2020-08-24"),
                            as.Date("2020-09-24"),
                            as.Date("2020-10-24"),
                            as.Date("2020-11-24"),
                            as.Date("2020-12-24"),
                            as.Date("2021-01-24")))+
    scale_y_continuous(limits = c(0, 140),
                       breaks = seq(0, 140, 20))+
    theme(legend.position="bottom")  + 
    xlab(label="Death Date")+
    ggtitle("(D)"))


(Figure1B_shading =
    ggplot(subset(iphis_DA_aggregated_pop_death, CLIENT_DEATH_DATE <= as.Date(date_cut_employment)),
           aes(x = CLIENT_DEATH_DATE,
               y = rolling_newdeah_100k,
               group = factor(d_essential_rank_tert_label),
               color= factor(d_essential_rank_tert_label))) +
    geom_line(size= 1.5) +
    ylab(label="Daily COVID-19-related death per 100k population \n (excluding LTCF residents) 7-day rolling average") +
    labs(color="Median (IQR) Proportion Essential Workers") + 
    guides(colour = guide_legend(title.position = "top")) +
    # labs(color="Multi-generation tertile") + 
    theme_bw(base_size = 30) +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          axis.line = element_line(colour = "black"),
          axis.text.x = element_text(angle= 45,hjust=1, size = 30),
          axis.text.y = element_text(size = 30),
          legend.text=element_text(size= 30)) +
    scale_x_date(limits = c(as.Date("2020-01-23"),
                            as.Date("2021-01-24")),
                 breaks = c(as.Date("2020-01-23"),
                            as.Date("2020-02-24"),
                            as.Date("2020-03-24"),
                            as.Date("2020-04-24"),
                            as.Date("2020-05-24"),
                            as.Date("2020-06-24"),
                            as.Date("2020-07-24"),
                            as.Date("2020-08-24"),
                            as.Date("2020-09-24"),
                            as.Date("2020-10-24"),
                            as.Date("2020-11-24"),
                            as.Date("2020-12-24"),
                            as.Date("2021-01-24")))+
    scale_y_continuous(limits = c(0, 1.5),
                       breaks = seq(0, 1.5, 0.3))+
    theme(legend.position="bottom")  + 
    xlab(label="Death Date")+
    ggtitle("(B)")+
    theme(legend.position = "bottom") +
    geom_vline(xintercept = as.Date("2020-03-17"), size = 1, linetype = 2, color = "gray25")+
    annotate("text", x=as.Date("2020-03-11"), y= 1, 
             label="a", 
             color="gray25", size = 12) +
    geom_vline(xintercept = as.Date("2020-05-19"), size = 1, linetype = 2, color = "gray25")+
    annotate("text", x=as.Date("2020-05-13"), y= 1, 
             label="b", 
             color="gray25", size = 12) +
    geom_vline(xintercept = as.Date("2020-11-23"), size = 1, linetype = 2, color = "gray25")+
    annotate("text", x=as.Date("2020-11-17"), y= 1, 
             label="c", 
             color="gray25", size = 12)+ 
    geom_vline(xintercept = as.Date("2020-12-26"), size = 1, linetype = 2, color = "gray25")+
    annotate("text", x=as.Date("2020-12-20"), y= 1, 
             label="d", 
             color="gray25", size = 12)+ 
    # theme(legend.position = c(0.1, 0.8)) +
    annotate("rect", xmin = as.Date("2020-03-17"), xmax = as.Date("2020-05-18"), ymin = 0, ymax = Inf, 
             alpha = .2) +
    annotate("rect", xmin = as.Date("2020-11-23"), xmax = as.Date("2021-01-24"), ymin = 0, ymax = Inf, 
             alpha = .2))



g <- arrangeGrob(Figure1A_shading, Figure1B_shading, nrow=1) #generates g
ggsave(file= paste0("./fig/Figure1_shading.png"), 
       width = 32, height = 16, limitsize = FALSE, g) #saves g

ggsave(file= paste0("./fig/Figure1_shading.pdf"), 
       width = 32, height = 16, limitsize = FALSE, g) #saves g

g <- arrangeGrob(Figure1A_shading_bar, Figure1B_shading_bar, nrow=1) #generates g


g <- arrangeGrob(Figure2A, Figure2B, nrow=1) #generates g
ggsave(file= paste0("./fig/Figure2.png"), 
       width = 32, height = 16, limitsize = FALSE, g) #saves g
ggsave(file= paste0("./fig/Figure2.pdf"), 
       width = 32, height = 16, limitsize = FALSE, g) #saves g


g <- arrangeGrob(Figure1A_shading, Figure1B_shading, Figure2A, Figure2B, nrow=2) #generates g
ggsave(file= paste0("./fig/Figure1_Final.png"), 
       width = 32, height = 32, limitsize = FALSE, g) #saves g
ggsave(file= paste0("./fig/Figure1_Final.pdf"), 
       width = 32, height = 32, limitsize = FALSE, g) #saves g

