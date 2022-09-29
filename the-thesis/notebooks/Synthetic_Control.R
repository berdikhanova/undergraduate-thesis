library(Synth)

oblasts_data <- read.csv("/Users/marinaberdikhanova/Downloads/Capstone_Data - Compiled_Dataset.csv")
dataprep.out <- dataprep(
  foo = oblasts_data,
  predictors = c("Number_of_Schools_City", "New_Schools", "Number_of_Schools_Rural”, “Number_of_Students_Rural", "Students_per_Teacher","Percent_of_Students_Covered_City", "Percent_of_Students_Covered_Rural", "Total.City"),
  predictors.op = "aggregate",
  time.predictors.prior = 2014:2019,
  special.predictors = list(
    list("Total.High..City", 2014:2019 , "mean"),
    list("Total.High..City", 2014:2019, "mean")),
  dependent = "Total.High..City",
  unit.variable = "Region_ID",
  unit.names.variable = "Region",
  time.variable = "Year",
  treatment.identifier = 4,
  controls.identifier = c(1:3, 5:17),
  time.optimize.ssr = 2014:2019,
  time.plot = 2014:2021)
print(dataprep.out$X0) 
print(dataprep.out$Z1) 

synth.out <- synth(data.prep.obj = dataprep.out, method = "BFGS")

gaps <- dataprep.out$Y1plot - (dataprep.out$Y0plot %*% synth.out$solution.w)
print(gaps[1:3, 1])

synth.tables <- synth.tab(dataprep.res = dataprep.out,synth.res = synth.out)
names(synth.tables) 

synth.tables$tab.pred[1:2, ]
synth.tables$tab.w[1:17, ]
path.plot(synth.res = synth.out, dataprep.res = dataprep.out,
          Ylab = "Number of Students who scored high", Xlab = "year",
          Ylim = c(0,1000), Legend = c("Almaty City","synthetic Almaty City"), 
          Legend.position = "bottomleft")
gaps.plot(synth.res = synth.out, dataprep.res = dataprep.out,
          Ylab = "Number of Students who scored high", Xlab = "year",
          Ylim = c(-150, 1500), Main = NA)
