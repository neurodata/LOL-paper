library(FlashR)
library(MASS)
fm.set.conf("/mnt/nfs2/zhengda/FlashX/matrix/conf/run_test-EM.txt")
data <- fm.get.dense.matrix("MRN.mat")
load("/mnt/nfs2/zhengda/MRN.label")
source("/mnt/nfs2/zhengda/FlashX-stable/Rpkg/R/SVD.R")
source("/mnt/nfs2/zhengda/FlashX-stable/FlashR-learn/R/LOL.R")
source("run_test.R")

rand.split.test(data, labels, 40, 0.9, c(1, seq(10, 100, 10)), TRUE)

