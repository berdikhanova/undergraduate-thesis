# Paper: Evaluating the Impact of a Policy in Education in Kazakhstan Using Synthetic Difference-in-Differences
# Date: February 2023
# Author: Marina Berdikhanova
#
#Datasets used: 
#                    - DataAstana.csv
# Key variables:
#                		 - Region 
# 		          		 - Year
#			            	 - Treatment (whether the region underwent the transition) 
#			            	 - % of students scoring below the national threshold 
#                    - Urban population
#                    - The number of public schools in the urban areas
#                    - The number of students living in the urban areas
#                    - The number of public school teachers in the urban areas


#Use install.packages function if necessary
library(pastecs)
library(synthdid)
library(Synth)
library(data.table)
library(SCtools)


df <- read.csv("https://raw.githubusercontent.com/berdikhanova/undergraduate-thesis/main/the-thesis/Final_Data/Data_Astana.csv")

new_df = subset(df, select = c(Region_ID, 
                               Region, 
                               Year, 
                               Treatment, 
                               Total.Low..City.., 
                               Population_City,		
                               New_Schools,	
                               Number_of_Schools_City,
                               Number_of_Students_City,	
                               Number_of_Teachers))

# Summary Statistics
stat.desc(new_df)

new_df <- new_df[new_df$Region != "Atyrau",]

data <- data.table(new_df)

N <- 14 # number of regions
T <- 8 # number of time points

# Conducting a linear transformation of the covariates to reduce their size
population_city <- matrix(new_df$Population_City/10000000000, nrow = N, ncol = T)
number_of_schools <- matrix(new_df$Number_of_Schools_City/100000, nrow = N, ncol = T)
number_of_students<- matrix(new_df$Number_of_Students_City/10000000000, nrow = N, ncol = T)
new_schools <- matrix(new_df$New_Schools/1000000, nrow = N, ncol = T)
teachers <- matrix(new_df$Number_of_Teachers/10000, nrow = N, ncol = T)

# Combining the transformed covariates into a 3D array
covariates <- array(c(population_city, new_schools, teachers, number_of_schools, number_of_students), dim = c(N, T, 3))

# Converting a long panel to a wide matrix
setup <- 
  synthdid::panel.matrices(
    new_df,
    unit = 1,
    time = 3,
    outcome = 5,
    treatment = 4
  )

# Computing the synthetic diff-in-diff estimate of an ATE on Astana city
synthdid <- synthdid_estimate(setup$Y,setup$N0, setup$T0, X = covariates)

# Computing a SE of the treatment effect estimate using the placebo method
se = sqrt(vcov(synthdid, method='placebo'))

sprintf('point estimate: %1.2f', synthdid)

sprintf('95%% CI (%1.2f, %1.2f)', synthdid - 1.96 * se, synthdid + 1.96 * se)

plot(synthdid, treated.name='Astana City')

synthdid_controls(synthdid, sort.by = 1, mass = 0.9, weight.type = "omega")

# Computing the diff-in-diff estimate of an ATE on Astana

did = did_estimate(setup$Y, setup$N0, setup$T0, X = covariates)

se = sqrt(vcov(did, method='placebo'))

sprintf('point estimate: %1.2f', did)

sprintf('95%% CI (%1.2f, %1.2f)', did - 1.96 * se, did + 1.96 * se)

plot(did)

# Computing the synthetic control estimate of an ATE on Astana

sc = sc_estimate(setup$Y, setup$N0, setup$T0, X = covariates)

se = sqrt(vcov(sc, method='placebo'))

sprintf('point estimate: %1.2f', sc)

sprintf('95%% CI (%1.2f, %1.2f)', sc - 1.96 * se, sc + 1.96 * se)

plot(sc)


# Plotting all three estimator together in one plot
estimators = list(synthdid, did, sc)
names(estimators) = c('Synthetic Difference in Differences', 'Difference in Difference', 'Synthetic Control')


synthdid_plot(estimators, facet.vertical=FALSE, control.name='control', treated.name='Astana City', lambda.comparable=TRUE,
              trajectory.linetype = 1, trajectory.alpha=.7, effect.alpha=.7, diagram.alpha=1, line.width=.75, effect.curvature=-.4, onset.alpha=.7) +
  theme(legend.position=c(.87,.97), legend.direction='horizontal', legend.key=element_blank(), legend.background=element_blank())

# Plotting the weights assigned to each of the regions
synthdid_units_plot(estimators) +
  theme(legend.background=element_blank(), legend.title = element_blank(), legend.direction='horizontal', legend.position=c(.17,.07),
        strip.background=element_blank(), strip.text.x = element_blank())

# Plotting the same plot, now vertically 
synthdid_plot(estimators, facet.vertical=TRUE, control.name='control', treated.name='Astana City', lambda.comparable=TRUE,
              trajectory.linetype = 1, trajectory.alpha=.7, effect.alpha=.7, diagram.alpha=1, effect.curvature=-.4, onset.alpha=.7) +
  theme(legend.position=c(.90,.97), legend.direction='vertical', legend.key=element_blank(), legend.background=element_blank())

########## Sensitivity Analysis of SDID ########## 

# Estimating the SC, DID, and SDID by running placebo several tests:
# 1) a different year (2016, 2 years earlier than the actual treatment)
# 2) a different unit (randomly selected control unit)
# 3) a different unit and different time

df1 <- read.csv("https://raw.githubusercontent.com/berdikhanova/undergraduate-thesis/main/the-thesis/Final_Data/DataAstana.csv")

new_df1 = subset(df1, select = c(Region_ID, 
                               Region, 
                               Year, 
                               Treatment, 
                               Total.Low..City.., 
                               Population_City,		
                               New_Schools,	
                               Number_of_Schools_City,
                               Number_of_Students_City,	
                               Number_of_Teachers,
                               Sensitivity_Time,
                               Sensitivity_UnitTime,
                               Sensitivity_Unit))

new_df1 <- new_df1[new_df1$Region != "Atyrau",]

N <- 14 # number of regions
T <- 8 # number of time points
population_city <- matrix(new_df1$Population_City/10000000000, nrow = N, ncol = T)
number_of_schools <- matrix(new_df1$Number_of_Schools_City/100000, nrow = N, ncol = T)
number_of_students<- matrix(new_df1$Number_of_Students_City/10000000000, nrow = N, ncol = T)
new_schools <- matrix(new_df1$New_Schools/1000000, nrow = N, ncol = T)
teachers <- matrix(new_df1$Number_of_Teachers/10000, nrow = N, ncol = T)

covariates <- array(c(population_city, new_schools, teachers, number_of_schools, number_of_students), dim = c(N, T, 3))

# Converting a long panel to a wide matrix
setup <- 
  synthdid::panel.matrices(
    new_df1,
    unit = 1,
    time = 3,
    outcome = 5,
    treatment = 11
  )

# To estimate the effect for a different year, I changed the treatment to column 11
# To estimate the effect for a different unit, I changed the treatment column 12
# To estimate the effect for a different time and unit, I changed the treatment column 13

# The rest of the code as follows 

# Computing the synthetic diff-in-diff estimate of an ATE on Astana city
synthdid <- synthdid_estimate(setup$Y,setup$N0, setup$T0, X = covariates)

# Computing a SE of the treatment effect estimate using the placebo method
se = sqrt(vcov(synthdid, method='placebo'))

sprintf('point estimate: %1.2f', synthdid)

sprintf('95%% CI (%1.2f, %1.2f)', synthdid - 1.96 * se, synthdid + 1.96 * se)

plot(synthdid, treated.name='Astana City')

# Computing the diff-in-diff estimate of an ATE on Astana

did = did_estimate(setup$Y, setup$N0, setup$T0, X = covariates)

se = sqrt(vcov(did, method='placebo'))

sprintf('point estimate: %1.2f', did)

sprintf('95%% CI (%1.2f, %1.2f)', did - 1.96 * se, did + 1.96 * se)

plot(did)

# Computing the synthetic control estimate of an ATE on Astana

sc = sc_estimate(setup$Y, setup$N0, setup$T0, X = covariates)

se = sqrt(vcov(sc, method='placebo'))

sprintf('point estimate: %1.2f', sc)

sprintf('95%% CI (%1.2f, %1.2f)', sc - 1.96 * se, sc + 1.96 * se)

plot(sc)


# Plotting all three estimator together in one plot
estimators = list(synthdid, did, sc)
names(estimators) = c('Synthetic Difference in Differences', 'Difference in Difference', 'Synthetic Control')


synthdid_plot(estimators, facet.vertical=FALSE, control.name='control', treated.name='Astana City', lambda.comparable=TRUE,
              trajectory.linetype = 1, trajectory.alpha=.7, effect.alpha=.7, diagram.alpha=1, line.width=.75, effect.curvature=-.4, onset.alpha=.7) +
  theme(legend.position=c(.87,.97), legend.direction='horizontal', legend.key=element_blank(), legend.background=element_blank())

# Plotting the weights assigned to each of the regions
synthdid_units_plot(estimators) +
  theme(legend.background=element_blank(), legend.title = element_blank(), legend.direction='horizontal', legend.position=c(.17,.07),
        strip.background=element_blank(), strip.text.x = element_blank())

# Plotting the same plot, now vertically 
synthdid_plot(estimators, facet.vertical=TRUE, control.name='control', treated.name='Astana City', lambda.comparable=TRUE,
              trajectory.linetype = 1, trajectory.alpha=.7, effect.alpha=.7, diagram.alpha=1, effect.curvature=-.4, onset.alpha=.7) +
  theme(legend.position=c(.90,.97), legend.direction='vertical', legend.key=element_blank(), legend.background=element_blank())

########## Sensitivity Analysis of SC ##########

# The following code is adapted from the "SCtools" package example by Bruno Castanho Silva (2022)

# Prepping the data to find a synthetic control by specifying all the necessary variables
dataprep.out <- dataprep(
  foo = new_df1,
  predictors = c("Population_City", "Number_of_Teachers", "New_Schools","Number_of_Schools_City","Number_of_Students_City"),
  predictors.op = "mean",
  time.predictors.prior = 2014:2017,
  dependent = "Total.Low..City..",
  unit.variable = "Region_ID",
  unit.names.variable = "Region",
  time.variable = "Year",
  treatment.identifier = 4,
  controls.identifier = c(1:3, 6:15),
  time.optimize.ssr = 2014:2021,
  time.plot = 2014:2021
)

# Calculating the MSPE 
synth.out <- synth(data.prep.obj = dataprep.out, method = "BFGS")

# Plotting the treatment and synthetic control's outcomes 
path.plot(synth.res = synth.out, dataprep.res = dataprep.out,
          Ylab = "Students Scoring Below Threshold (2018, % of total)", Xlab = "Year",
          Ylim = c(0, 0.4), Legend = c("Astana City",
                                      "Synthetic Astana city"), 
          Legend.position = "bottomright")

# The SCtools packages allows to permute the dataset and run multiple placebos to test the sensitivity of the SC model

# Costructing a synthetic control unit for each unit in the donor pool
placebo <- generate.placebos(dataprep.out = dataprep.out,
                             synth.out = synth.out, strategy = "multiprocess")

# Plotting the placebo tests
plot_placebos(placebo)
