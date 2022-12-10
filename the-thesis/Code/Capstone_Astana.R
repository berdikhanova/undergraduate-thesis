# Title: Evaluating the Impact of an Educational Policy in Kazakhstan Using Synthetic Difference-in-Differences
# Author: Marina Berdikhanova
# Description: This notebook takes the raw data from the Bureau of National Statistics of the Republic of Kazakhstan and the Ministry of Education and conducts an Impact Evaluation using Synthetic Difference-in-Difference estimator and the Difference-in-Difference estimator

library(pastecs)
library(synthdid)

# Uploading the dataset
df <- read.csv("https://raw.githubusercontent.com/berdikhanova/undergraduate-thesis/main/the-thesis/Final_Data/Data_Astana.csv")

# Removing unnecessary fields
new_df = subset(df, select = c(Region_ID, 
                               Region, 
                               Year, 
                               Treatment, 
                               Total.Low..City.., 
                               Population_City,		
                               New_Schools,	
                               Number_of_Schools_City,
                               Number_of_Students_City,	
                               Number_of_Teachers,	
                               Students_Per_Teacher,	
                               Teachers_per_School))


# Summary Statistics
stat.desc(new_df)

# Removing the outlier
new_df <- new_df[new_df$Region != "Atyrau",]

data <- data.table(new_df)

# Creating a panel matrix for the synthdid_estimate
setup <- 
  synthdid::panel.matrices(
    data,
    unit = 2,
    time = 3,
    outcome = 5,
    treatment = 4
  )

# Changing the type of the two fields to use as covariates

data$Total.Low..City.. <- as.integer(data$Total.Low..City..)
data$Number_of_Teachers <- as.integer(data$Number_of_Teachers)

# Creating a 3D array of the covariates 
X_mat <- 
  data[, .(Region,
           Year, 
           Population_City,
           New_Schools,	
           Number_of_Schools_City,
           Number_of_Students_City,	
           Number_of_Teachers)] %>% 
  melt(id.var = c("Region", "Year")) %>% 
  nest_by(variable) %>% 
  mutate(X = list(
    dcast(data.table(data), Region ~ Year, value.var = "value") %>% 
      .[data.table(Region = rownames(setup$Y)), on = "Region"] %>% 
      .[, Region := NULL] %>% 
      as.matrix() 
  )) %>% 
  .$X %>% 
  abind(along = 3) 

# Calculating the SDID estimator and the 95% CI
tau_hat <- synthdid_estimate(
  setup$Y, 
  setup$N0, 
  setup$T0, 
  X = X_mat)

se = sqrt(vcov(tau.hat, method='placebo'))

sprintf('point estimate: %1.2f', tau.hat)

sprintf('95%% CI (%1.2f, %1.2f)', tau.hat - 1.96 * se, tau.hat + 1.96 * se)

# Plotting the results 

plot(tau.hat, treated.name='Astana City')

# I also ran the regression and found the DiD in Python (see github)

yau.hat = did_estimate(setup$Y, setup$N0, setup$T0)

se = sqrt(vcov(yau.hat, method='placebo'))

sprintf('point estimate: %1.2f', yau.hat)

sprintf('95%% CI (%1.2f, %1.2f)', yau.hat - 1.96 * se, yau.hat + 1.96 * se)

plot(yau.hat)


# Plotting the two results 
estimators = list(tau.hat,yau.hat)
names(estimators) = c('Synthetic Difference in Differences', 'Difference in Difference')

synthdid_plot(list(sdid.control=tau.hat, did=yau.hat), facet=c(1,1), treated.name='Astana City', lambda.comparable=TRUE,
              trajectory.linetype = 1, trajectory.alpha=.8, effect.alpha=1, diagram.alpha=1, effect.curvature=-.4, onset.alpha=.7) +
  theme(legend.position=c(.95,.90), legend.direction='vertical', legend.key=element_blank(), legend.background=element_blank())

synthdid_plot(estimators, facet.vertical=FALSE, control.name='control', treated.name='Astana City', lambda.comparable=TRUE,
trajectory.linetype = 1, trajectory.alpha=.7, effect.alpha=.7, diagram.alpha=1, line.width=.75, effect.curvature=-.4, onset.alpha=.7) +
theme(legend.position=c(.36,.07), legend.direction='horizontal', legend.key=element_blank(), legend.background=element_blank(),
strip.background=element_blank(), strip.text.x = element_blank())

synthdid_units_plot(list(sdid.control=tau.hat, did=yau.hat)) +
  theme(legend.background=element_blank(), legend.title = element_blank(), legend.direction='horizontal', legend.position=c(.17,.07),
        strip.background=element_blank(), strip.text.x = element_blank())