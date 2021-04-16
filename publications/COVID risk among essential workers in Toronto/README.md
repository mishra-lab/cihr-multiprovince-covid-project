# COVID-19 cases and deaths among essential workers in Toronto, Canada
This repo contains codes and output figures of per-capita daily epidemic curves and cumulative per-capita rates used our report titled "A disproportionate epidemic: COVID-19 cases and deaths among essential workers in Toronto, Canada".

## Summary of work
Shelter-in-place mandates and closure of non-essential businesses have been central to COVID-19 response strategies including in Toronto, Canada. Approximately half of the working population in Canada are employed in occupations that do not allow for remote work suggesting potentially limited impact of some of the strategies proposed to mitigate COVID-19 acquisition and onward transmission risks and associated morbidity and mortality. 

We compared per-capita rates of COVID-19 cases and deaths from January 23, 2020 to January 24, 2021, across neighborhoods in Toronto by proportion of the population working in essential services. We used person-level data on laboratory-confirmed COVID-19 community cases (N=74,477) and deaths (N=2319), and census data for neighborhood-level attributes. Cumulative per-capita rates of COVID-19 cases and deaths were 3-fold and 2.5-fold higher, respectively, in neighborhoods with the highest versus lowest concentration of essential workers. 

Findings suggest that the population who continued to serve the essential needs of society throughout COVID-19 shouldered a disproportionate burden of transmission and deaths. Taken together, results signal the need for active intervention strategies to complement restrictive measures to optimize both the equity and effectiveness of COVID-19 responses.

This report as available as a [preprint](https://www.medrxiv.org/content/10.1101/2021.02.15.21251572v1.full-text) on medRxiv.

This work is supported by Canadian Institutes of Health Research Operating Grant: COVID-19 Rapid Research Funding Opportunity.

## Authors and contact information
* Amrita Rao*: [arao24@jhu.edu](mailto:arao24@jhu.edu)
* Huiting Ma*: [huiting.ma@unityhealth.to](mailto:huiting.ma@unityhealth.to)
* Gary Moloney: [gary.moloney@unityhealth.to](mailto:gary.moloney@unityhealth.to)
* Jeffrey C. Kwong: [jeff.kwong@utoronto.ca](mailto:jeff.kwong@utoronto.ca)
* Peter Juni: [peter.juni@utoronto.ca](mailto:peter.juni@utoronto.ca)
* Beate Sander: [beate.sander@uhnresearch.ca](mailto:beate.sander@uhnresearch.ca)
* Rafal Kustra: [r.kustra@utoronto.ca](mailto:r.kustra@utoronto.ca)
* Stefan D. Baral: [sbaral@jhu.edu](mailto:sbaral@jhu.edu)
* Sharmistha Mishra: [sharmistha.mishra@utoronto.ca](mailto:sharmistha.mishra@utoronto.ca)

*Equal contribution/co-first authors

## Summary of data sources
### COVID-19 cases
This [dataset](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/322d928eec34d1c5fcc8097de0e423e852398688/publications/COVID%20risk%20among%20essential%20workers%20in%20Toronto/Figure1AC_cases.csv) includes community cases (excluding long-term care residents) reported between January 23, 2020 and January 24, 2021 in Toronto. The case data were obtained from Contact Management Solutions (CCM)+. Neighbourhood-level attributes were obtained from [Statistics Canada 2016 Census](https://www12.statcan.gc.ca/census-recensement/2016/dp-pd/index-eng.cfm).

We stratified the city’s 3702 dissemination areas (DA; geographic area of approximately 400-700 individuals) into tertiles by ranking the proportion of population in each DA working in essential services (health, trades, transport, equipment, manufacturing, utilities, sales, services, agriculture).

The dataset includes the following information organized by tertiles:
* Case reported date
* Total new cases
* Total cumulative cases
* Population
* Total new cases per 100k
* Total cumulative cases per 100k
* Rolling new cases per 100k

### COVID-19 deaths
This [dataset](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/322d928eec34d1c5fcc8097de0e423e852398688/publications/COVID%20risk%20among%20essential%20workers%20in%20Toronto/Figure1BD_death.csv) includes community deaths (excluding long-term care residents) reported between January 23, 2020 and January 24, 2021 in Toronto. 

The data on deaths were obtained from Contact Management Solutions (CCM)+. Neighbourhood-level attributes were obtained from [Statistics Canada 2016 Census](https://www12.statcan.gc.ca/census-recensement/2016/dp-pd/index-eng.cfm).

We stratified the city’s 3702 DA into tertiles by ranking the proportion of population in each DA working in essential services.

The dataset includes the following information organized by tertiles:
* Reported date of death
* Total new deaths
* Total cumulative deaths
* Population
* Total new deaths per 100k
* Total cumulative deaths per 100k
* Rolling new deaths per 100k

## Figure legends
### [Figure 1 A&B](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/4d251054a71f4bdb9ec545bfe971d68441ef89eb/publications/COVID%20risk%20among%20essential%20workers%20in%20Toronto/Figure1_Final.png). Daily per-capita COVID-19 cases (A) and deaths (B) by neighbourhood-level proportion of essential workers in Toronto, Canada (January 23, 2020 to January 24, 2021).
The daily per-capita rate is depicted as a 7-day rolling average. Stratum1 represents neighbourhooods with the smallest proportion of the population working in essential services, while stratum3 represents neighbourhoods with the highest proportion essential workers. Cases and deaths do not include residents of long-term care homes. Essential services include: health, trades, transport, equipment, manufacturing, utilities, sales, services, agriculture. Closure of non-essential workplaces are indicated by (a) at start of first lockdown on March 17, 2020 to the re-opening on May 18, 2020 (b), and (c) indicating the start of the 2nd-major restriction on November 23to (d) the start of a more stringentlockdown on December 26, 2020. 

### [Figure 1 C&D](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/4d251054a71f4bdb9ec545bfe971d68441ef89eb/publications/COVID%20risk%20among%20essential%20workers%20in%20Toronto/Figure1_Final.png). Cumulative per-capita COVID-19 cases (C) and deaths (D) by neighbourhood-level proportion of essential workers in Toronto, Canada (January 23, 2020 to January 24, 2021).
Stratum 1 represents neighbourhooods with the smallest proportion of the population working in essential services, while stratum3 represents neighbourhoods with the highest proportion essential workers. By the end of the study period, cumulative rate of casesper 100,000 populationwas 1332, 2495, and 4355 in strata 1, 2, and 3, respectively; and cumulative rate of COVID-19 deaths per 100,000 population was 49, 81, and 123 in strata 1, 2, and 3, respectively. 

