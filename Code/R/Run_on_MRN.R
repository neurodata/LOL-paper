library(FlashR)
library(MASS)
fm.set.conf("/FlashX/matrix/conf/run_test.txt")
data <- fm.get.dense.matrix("MRN.mat")
load("MRN.label")
source("run_test.R")

rand.split.test(data, labels, 40, 0.9, c(1, seq(10, 100, 10)))

