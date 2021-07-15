# Gini by social determinants - Toronto
This repo contains data used in our paper titled "Increasing concentration of COVID-19 by socioeconomic determinants and geography in Toronto, Canada: an observational study".

## Summary of work
Inequities in the burden of COVID-19 were observed early in Canada and around the world suggesting economically marginalized communities faced disproportionate risks.  However, there has been limited systematic assessment of how heterogeneity in risks has evolved in large urban centers over time. To address this gap, we quantified the magnitude of risk heterogeneity in Toronto, Ontario from January-November, 2020 using a retrospective, population-based observational study using surveillance data. We generated epidemic curves by social determinants of health (SDOH) and crude Lorenz curves by neighbourhoods to visualize inequities in the distribution of COVID-19 and estimated Gini coefficients. We examined the correlation between SDOH using Pearson-correlation coefficients. There was rapid epidemiologic transition from higher to lower income neighbourhoods with Lorenz curve transitioning from below to above the line of equality across SDOH. 

This report is available as a [preprint](https://www.medrxiv.org/content/10.1101/2021.04.01.21254585v1) on medRxiv.

This work is supported by Canadian Institutes of Health Research Operating Grant: COVID-19 Rapid Research Funding Opportunity and St. Michael's Hospital Foundation.

## Contact information
* Sharmistha Mishra: [sharmistha.mishra@utoronto.ca](mailto:sharmistha.mishra@utoronto.ca)
* Huiting Ma: [huiting.ma@unityhealth.to](mailto:huiting.ma@unityhealth.to)

## Summary of data sources
### Gini coefficient of COVID-19 cases over time by income ([Figure 4](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/fig4.png))
This [dataset](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/d_after_tax_income_PPE_decile.zip) includes Gini coefficients of community cases (excluding long-term care residents) reported between January 21, 2020 and November 21, 2020 in Toronto stratified by income. 

### Gini coefficient of COVID-19 cases over time by visible minority ([Figure A5](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/figA5.png))
This [dataset](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/d_visible_minority_decile.zip) includes Gini coefficients of community cases (excluding long-term care residents) reported between January 21, 2020 and November 21, 2020 in Toronto stratified by percentage of visible minority. 

### Gini coefficient of COVID-19 cases over time by recent immigration ([Figure A5](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/figA5.png))
This [dataset](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/d_recent_immigrantion_decile.zip) includes Gini coefficients of community cases (excluding long-term care residents) reported between January 21, 2020 and November 21, 2020 in Toronto stratified by percentage of recent immigration. 

### Gini coefficient of COVID-19 cases over time by suitable housing ([Figure A5](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/figA5.png))
This [dataset](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/d_suitable_house_decile.zip) includes Gini coefficients of community cases (excluding long-term care residents) reported between January 21, 2020 and November 21, 2020 in Toronto stratified by percentage of suitable housing. 

### Gini coefficient of COVID-19 cases over time by multi-generational household ([Figure A5](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/figA5.png))
This [dataset](https://github.com/mishra-lab/cihr-multiprovince-covid-project/blob/main/publications/Gini%20by%20social%20determinant%20-%20Toronto/d_multi_generation_decile.zip) includes Gini coefficients of community cases (excluding long-term care residents) reported between January 21, 2020 and November 21, 2020 in Toronto stratified by percentage of multi-generational household. 

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


