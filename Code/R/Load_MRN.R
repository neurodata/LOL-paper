library(FlashR)
library(MASS)
fm.set.conf("/FlashX/matrix/conf/run_test.txt")
df <- read.csv(url("http://neurodata-public-lol.s3-website-us-east-1.amazonaws.com/ndmg.csv"))
files <- read.csv(url("http://neurodata-public-lol.s3-website-us-east-1.amazonaws.com/files.txt"),
				  header=FALSE)
vs <- list()
mats <- list()
num <- 0
labels <- rep.int(0, length(df$Sex))
for (idx in 1:length(df$URSI)) {
    id <- as.character(df$URSI[idx])
	file <- paste("MRN114_", id, "_1_DTI_aligned.dat.gz", sep="")
	path <- paste("http://neurodata-public-lol.s3-website-us-east-1.amazonaws.com/",
				  file, sep="")
	if (file %in% files$V1) {
		print(path)
		conn <- gzcon(url(path))
		v <- fm.load.dense.matrix.bin(conn, TRUE, 505472240, 1, FALSE, "F", id)
		if (!is.null(v)) {
			num <- num + 1
			vs <- c(vs, v)
			labels[num] <- df$Sex[idx]
		}
		close(conn)
	}
	if (length(vs) == 16) {
		mat <- fm.cbind.list(vs)
		name <- paste("MRN", length(mats), ".mat", sep="")
		mat <- fm.conv.store(mat, in.mem=FALSE, name=name)
		vs <- list()
		mats <- c(mats, mat)
	}
}
if (length(vs) > 0) {
	mat <- fm.cbind.list(vs)
	name <- paste("MRN", length(mats), ".mat", sep="")
	mat <- fm.conv.store(mat, in.mem=FALSE, name=name)
	vs <- list()
	mats <- c(mats, mat)
}

data <- fm.cbind.list(mats)
save(labels, file="/FlashX/MRN.label")

