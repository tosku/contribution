Sys.setenv(LANG = "en")
library("devtools")
install_github("esm-ispm-unibe-ch/flow_contribution")
library(contribution)
rm(list=ls())
#indata = read.csv2("binary.csv",header=TRUE)
indata = read.csv2("diabetes_new.csv",header=TRUE,sep=";")

C = getContributionMatrix(indata,type="netwide_binary",model="random",sm="OR")
# Direct effects
md = -C$hatMatrix$Pairwise[,1]
newnmd = lapply(names(md), function(n){gsub(" vs ",":",n)})
names(md) = newnmd
md = md[order(names(md))]
#network effects
mn = C$hatMatrix$NMA[,1]
nmn = C$hatMatrix$H2bu %*% md
# test that hmatrix works
diff = mn - nmn
print(diff)


