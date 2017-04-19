library(FlashR)
library(MASS)
fm.set.conf("/mnt/nfs2/zhengda/FlashX/matrix/conf/run_test-EM.txt")
df <- read.csv("/home/zhengda/ndmg.csv", header=TRUE)
files <- list.files("/mnt/nfs/MR/data/MRN114/ndmg_v0011/reg_dti/bins/")
vs <- list()
num <- 0
labels <- rep.int(0, length(df$Sex))
for (idx in 1:length(df$URSI)) {
    id <- as.character(df$URSI[idx])
    path <- paste("/mnt/nfs/MR/data/MRN114/ndmg_v0011/reg_dti/bins/MRN114_",
        id, "_1_DTI_aligned.dat", sep="")
    v <- fm.load.dense.matrix.bin(path, TRUE, 505472240, 1, FALSE, "F", id)
    if (!is.null(v)) {
        num <- num + 1
        vs[[num]] <- v
        labels[num] <- df$Sex[idx]
    }
}
data <- fm.cbind.list(vs)
#tmp <- fm.conv.store(data, in.mem=FALSE, name="MRN.mat")
save(labels, "/mnt/nfs2/zhengda/MRN.label")

