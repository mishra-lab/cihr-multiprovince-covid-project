# SARS-CoV-2 Variants of Concern among essential workers in Greater Toronto Area

This repo contains codes, output data, and figures of daily per-capita and cumulative epidemic curves used our paper titled "Characterizing the disproportionate burden of SARS-CoV-2 variants of concern among essential workers in the Greater Toronto Area, Canada".

## Summary of work
The emergence of SARS-CoV-2 Variants of Concern (VOC) across North America has been associated with concerns of increased COVID-19 transmission. Characterizing the distribution of VOCs can inform the development and implementation of policies and programs to address the prevention needs of disproportionately affected communities.

We compared per-capita rates of COVID-19 cases (overall and VOC) from February 3, 2021 to March 10, 2021, across neighborhoods in the health regions of Toronto and Peel, Ontario, by proportion of the population working in essential services and income. We used person-level data on laboratory-confirmed COVID-19 community cases (N=22,478) and census data for neighborhood-level attributes. Per-capita daily epidemic curves were generated using 7-days rolling averages for cases and deaths. Cumulative per-capita cases were determined using census-reported population of each neighbourhood.

During the study period, VOC cases emerged faster in groups with lowest income (growth rate 43.8%, 34.6% and 21.6% by income tertile from lowest to highest), and most essential work (growth rate 18.4%, 30.8% and 50.8% by tertile from lowest tertile of essential workers to highest tertile of essential workers).

The recent introduction of VOC in the large urban area of Toronto has disproportionately affected neighbourhoods with the most essential workers and lowest income levels. Notably, this is consistent with the increased burden of non-VOC COVID-19 cases suggesting shared risk factors. To date, restrictive public health strategies have been of limited impact in these communities suggesting the need for complementary and well-specified supportive strategies including vaccine prioritization to address disparities and overall incidence of both VOC and non-VOC COVID-19.

This report is available as a [preprint](https://www.medrxiv.org/content/10.1101/2021.03.22.21254127v1) on medRxiv.

This work is supported by Canadian Institutes of Health Research Operating Grant: COVID-19 Rapid Research Funding Opportunity.

## Authors and contact information
* Zain Chagla: [chaglaz@mcmaster.ca](mailto:chaglaz@mcmaster.ca)
* Huiting Ma: [huiting.ma@unityhealth.to](mailto:huiting.ma@unityhealth.to)
* Beate Sander: [beate.sander@uhnresearch.ca](mailto:beate.sander@uhnresearch.ca)
* Stefan D. Baral*: [sbaral@jhu.edu](mailto:sbaral@jhu.edu)
* Sharmistha Mishra*: [sharmistha.mishra@utoronto.ca](mailto:sharmistha.mishra@utoronto.ca)
*Equal contribution/co-senior responsible authors

## Summary of data sources
### COVID-19 cases
This dataset includes laboratory-confirmed COVID-19 community cases (excluding long-term care cases) reported between February 3 and March 10, 2021 in the City of Toronto and Region of Peel. Person-level data on VOC screen positive cases were obtained from Contact Management Solutions (CCM)+. Individual-level data have been transformed into aggregated data in the posted dataset. From February 3 onwards, all samples positive on RT-PCR with a cycle threshold <35 underwent Polymerase Chain Reaction for the N501Y mutation as screening, and genetic sequencing ofr positive results.

Neighbourhood-level attributes were obtained from [Statistics Canada 2016 Census](https://www12.statcan.gc.ca/census-recensement/2016/dp-pd/index-eng.cfm). We stratified the dissemination areas (DA; geographic area of approximately 400-700 individuals) into tertiles by ranking the proportion of population in each DA working in essential services (health, trades, transport, equipment, manufacturing, utilities, sales, services, agriculture) and the per-person equivalent household income.

## Figure legends
### Figure 1. Daily rates and cumulative COVID-19 overall and VOC cases in Toronto and Peel regions, Canada (February 3 - March 10, 2021), by neighbourhood-level prevalence of essential workers.

By March 7, the 7-day rolling average had reached 8.0, 14.1, and 20.0 per 100,000 population in tertiles 1, 2, and 3 respectively (A); and VOC daily rates were at 3.5, 6.6, and 10.1 per 100,000 population in tertiles 1, 2, and 3 respectively (B). Cumulative number of cases, stratified by tertiles are shown for overall cases (C) and VOC cases (D). VOC (variants of concern, detected via N501Y screening). Cases exclude those diagnosed among residents of long-term care homes.

### Figure 2. Daily rates and cumulative COVID-19 overall and VOC cases in Toronto and Peel regions, Canada (February 3 - March 10, 2021), by neighbourhood-level household income tertile.
By March 7, the 7-day rolling average had reached 17,9, 14.9, and 9.2 per 100,000 population in tertiles 1, 2, and 3 respectively (A); and VOC daily rates were at 8.5, 7.3, and 4.4 per 100,000 population in tertiles 1, 2, and 3 respectively (B). Cumulative number of cases, stratified by tertiles are shown for overall cases (C) and VOC cases (D). VOC (variants of concern, detected via N501Y screening). Cases exclude those diagnosed among residents of long-term care homes. After-tax income tertile refers to neighbourhoods ranked by afer tax, per-person equivalent household income.

