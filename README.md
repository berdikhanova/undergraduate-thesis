
# Evaluating the Impact of a Policy in Education in Kazakhstan using Synthetic Difference-in-Differences

*Berdikhanova M. (2023)* 
## Key Points

### Question 
What is the impact of the shift to per capita funding in K-12 in Kazakhstan on student UNT scores in Astana? 
### Findings 
Using high school examination scores as a measure of success and controlling for demographic characteristics across regions, the shift to per capita funding has no effect on student outcomes in public schools.
### Meaning 
Despite the government’s report of the program's positive effect on student outcomes (~8.6% increase), the results of this study show no effect of this program. 
## Abstract

### Importance 
Kazakhstan’s Ministry of Education been implementing numerous educational programs in the past decade to improve the quality of education and increase student scores on international assessments like PISA and TIMSS. However, there is little to no empirical evidence to support these programs and justify the allocated million-dollar budget apart from success in the low-scale pilot studies. 
### Objective 
To evaluate the impact of the shift to per capita funding in the city of Astana using a quasi-experimental design and publicly available data, controlling for confounding variables across regions.   
### Design, Setting and Units of Analysis 
Using difference-in-differences (DID), synthetic control (SC), and synthetic difference-in-difference (SDID) estimators, this study examines the effect of the shift to per capita funding in the city of Astana using UNT examination scores from 2014 until 2022 and compares it to the student outcomes of the remaining 13 regions (excluding an outlier). 
### Program 
In 2018, 76% of schools in Astana city had to undergo a mandatory transition from “smeta” funding to per capita funding, followed by two other major cities, Almaty and Shymkent, in 2019 (the cities were, thus, excluded from the analysis).
### Main Outcomes and Measures 
The study uses UNT examination scores (specifically, the number of students who score below the national threshold to enrol in a higher education institution) as an outcome variable. Future studies will also use PISA and TIMSS scores to measure the policy's success as soon as the results become available in 2023 and 2024. 
### Results 
The results from all three methods (DID, SC, SDID) show no impact of the program on student UNT scores (coefficients 0.04, 0.03, respectively). The sensitivity analyses showed the model’s sensitivity to covariates.
### Limitations 
Due to inconsistency in data reporting, many other educational programs initiated by the government simultaneously, and possible lagged effects of the policy, the study only lays the foundation for further analyses for impact evaluation. It will benefit from using scores from international examinations after sufficient time has passed. 

## Repository Structure

**Main Directory**
| File | Content |
| ------------- | ------------- |
| /data| Raw Data from Kazakhstan's Ministry of Education |
| /Final_Data/DataAstana.csv| The compiled dataset used in the analysis |
| /code/Capstone_Final.R| Code for SDID, SC, and DID estimators, and Sensitivity Analyses |
| /code/Capstone_DiD.ipynb| Code for DiD Analysis in Python |


## License

Copyright (c) 2023 Berdikhanova, M.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## Cite
Berdikhanova, M. (2023, February). Evaluating the Impact of a Policy in Education in Kazakhstan using Synthetic Difference-in-Differences
