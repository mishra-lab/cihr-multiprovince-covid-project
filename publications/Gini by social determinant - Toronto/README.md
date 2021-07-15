# Gini by social determinants - Toronto
This repo contains data used in our paper titled "Increasing concentration of COVID-19 by socioeconomic determinants and geography in Toronto, Canada: an observational study".

## Abstract
Background: Inequities in the burden of COVID-19 were observed early in Canada and around the world suggesting economically marginalized communities faced disproportionate risks.  However, there has been limited systematic assessment of how heterogeneity in risks has evolved in large urban centers over time.  

Purpose: To address this gap, we quantified the magnitude of risk heterogeneity in Toronto, Ontario from January-November, 2020 using a retrospective, population-based observational study using surveillance data. 

Methods: We generated epidemic curves by social determinants of health (SDOH) and crude Lorenz curves by neighbourhoods to visualize inequities in the distribution of COVID-19 and estimated Gini coefficients. We examined the correlation between SDOH using Pearson-correlation coefficients. 

Results: Gini coefficient of cumulative cases by population size was 0.41 (95% confidence interval [CI]:0.36-0.47) and estimated for: household income (0.20, 95%CI: 0.14-0.28); visible minority (0.21, 95%CI:0.16-0.28); recent immigration (0.12, 95%CI:0.09-0.16); suitable housing (0.21, 95%CI:0.14-0.30); multi-generational households (0.19, 95%CI:0.15-0.23); and essential workers (0.28, 95%CI:0.23-0.34). 

Conclusions: There was rapid epidemiologic transition from higher to lower income neighbourhoods with Lorenz curve transitioning from below to above the line of equality across SDOH. Moving forward necessitates integrating programs and policies addressing socioeconomic inequities and structural racism into COVID-19 prevention and vaccination programs.


This report is available as a [preprint](https://www.medrxiv.org/content/10.1101/2021.04.01.21254585v1) on medRxiv.

This work is supported by Canadian Institutes of Health Research Operating Grant: COVID-19 Rapid Research Funding Opportunity and St. Michael's Hospital Foundation.

## Authors and contact information
* Sharmistha Mishra: [sharmistha.mishra@utoronto.ca](mailto:sharmistha.mishra@utoronto.ca)
* Huiting Ma*: [huiting.ma@unityhealth.to](mailto:huiting.ma@unityhealth.to)
* Gary Moloney*: [gary.moloney@unityhealth.to](mailto:gary.moloney@unityhealth.to)
* Kristy C.Y. Yiu: [kristy.yiu@unityhealth.to](mailto:kristy.yiu@unityhealth.to)
* Dariya Darvin: [dariya.darvin@mail.utoronto.ca](mailto:dariya.darvin@mail.utoronto.ca)
* David Landsmand: [david.landsman@mail.utoronto.ca](mailto:david.landsman@mail.utoronto.ca)
* Jeffrey C. Kwong: [jeff.kwong@utoronto.ca](mailto:jeff.kwong@utoronto.ca)
* Andrew Calzavara: [andrew.calzavara@ices.on.ca](mailto:andrew.calzavara@ices.on.ca)
* Sharon Straus: [sharon.straus@utoronto.ca](mailto:sharon.straus@utoronto.ca)
* Adrienne K. Chan: [adrienne.chan@utoronto.ca](mailto:adrienne.chan@utoronto.ca)
* Effie Gournis: [effie.gournis@toronto.ca](mailto:effie.gournis@toronto.ca)
* Heather Rilkoff: [heather.rilkoff@canada.ca](mailto:heather.rilkoff@canada.ca)
* Yiqing Xia: [yiqing.xia@unityhealth.to](mailto:yiqing.xia@unityhealth.to)
* Alan Katz: [alan_Katz@cpe.umanitoba.ca](mailto:alan_Katz@cpe.umanitoba.ca)
* Tyler Williamson: [tyler.williamson@ucalgary.ca](mailto:tyler.williamson@ucalgary.ca)
* Kamil Malikov: [kamil.malikov@ontario.ca](mailto:kamil.malikov@ontario.ca)
* Rafal Kustra: [r.kustra@utoronto.ca](mailto:r.kustra@utoronto.ca)
* Mathieu Maheu-Giroux: [mathieu.maheu-giroux@mcgill.ca](mailto:mathieu.maheu-giroux@mcgill.ca)
* Beate Sander: [beate.sander@uhnresearch.ca](mailto:beate.sander@uhnresearch.ca)
* Stefan D. Baral: [sbaral@jhu.edu](mailto:sbaral@jhu.edu)

*Equal contribution

## Summary of data sources
### Gini coefficient of COVID-19 cases over time by income ([Figure 4](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/fig4.png))
This [dataset](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/d_after_tax_income_PPE_decile.zip) includes Gini coefficients of community cases (excluding long-term care residents) reported between January 21, 2020 and November 21, 2020 in Toronto stratified by income. Person-level data on laboratory-confirmed COVID-19 cases were obtained from Contact Management Solutions (CCM)+. Individual-level data have been transformed into aggregated data in the posted dataset. After-tax, per-person equivalent income ranking across dissemination areas within Toronto was obtained from ICES (a not-for-profit research institute that securely houses Ontario’s health-related data).

### Gini coefficient of COVID-19 cases over time by visible minority ([Figure A5](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/figA5.png))
This [dataset](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/d_visible_minority_decile.zip) includes Gini coefficients of community cases (excluding long-term care residents) reported between January 21, 2020 and November 21, 2020 in Toronto stratified by percentage of visible minority. Person-level data on laboratory-confirmed COVID-19 cases were obtained from Contact Management Solutions (CCM)+. Individual-level data have been transformed into aggregated data in the posted dataset. Neighbourhood-level attributes were obtained from [Statistics Canada 2016 Census](https://www12.statcan.gc.ca/census-recensement/2016/dp-pd/index-eng.cfm)

### Gini coefficient of COVID-19 cases over time by recent immigration ([Figure A5](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/figA5.png))
This [dataset](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/d_recent_immigrantion_decile.zip) includes Gini coefficients of community cases (excluding long-term care residents) reported between January 21, 2020 and November 21, 2020 in Toronto stratified by percentage of recent immigration. Person-level data on laboratory-confirmed COVID-19 cases were obtained from Contact Management Solutions (CCM)+. Individual-level data have been transformed into aggregated data in the posted dataset. Neighbourhood-level attributes were obtained from [Statistics Canada 2016 Census](https://www12.statcan.gc.ca/census-recensement/2016/dp-pd/index-eng.cfm)

### Gini coefficient of COVID-19 cases over time by suitable housing ([Figure A5](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/figA5.png))
This [dataset](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/d_suitable_house_decile.zip) includes Gini coefficients of community cases (excluding long-term care residents) reported between January 21, 2020 and November 21, 2020 in Toronto stratified by percentage of suitable housing. Person-level data on laboratory-confirmed COVID-19 cases were obtained from Contact Management Solutions (CCM)+. Individual-level data have been transformed into aggregated data in the posted dataset. Neighbourhood-level attributes were obtained from [Statistics Canada 2016 Census](https://www12.statcan.gc.ca/census-recensement/2016/dp-pd/index-eng.cfm)

### Gini coefficient of COVID-19 cases over time by multi-generational household ([Figure A5](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/figA5.png))
This [dataset](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/d_multi_generation_decile.zip) includes Gini coefficients of community cases (excluding long-term care residents) reported between January 21, 2020 and November 21, 2020 in Toronto stratified by percentage of multi-generational household. Person-level data on laboratory-confirmed COVID-19 cases were obtained from Contact Management Solutions (CCM)+. Individual-level data have been transformed into aggregated data in the posted dataset. The measure of multi-generational household was curated by and sourced from the Ontario Community Health Profiles Partnership.

The datasets mentioned above include the following information organized by deciles:
* Total population in each decile (total_pop)
* Total cumulative cases at each decile (total_cum)
* Proportion of the population (X)
* Proportion of cases in the population (Y)

The Gini coefficient is calculated using the following formula:
* GINI = abs(A-B), where:
* A = sum[X(i) * Y(i+1)]
* B = sum[X(i+1) * Y(i)]
* X(i+1) = lag(X(i))
* Y(i+1) = lag(Y(i))

More information about the concept of Gini coefficient can be found [here](http://mchp-appserv.cpe.umanitoba.ca/viewConcept.php?conceptID=1053).


