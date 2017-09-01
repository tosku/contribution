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
#hatmatrix
HM = C$hatMatrix$H2bu
nmn = HM %*% md
# test that hmatrix works
diff = all(lapply((mn - nmn), function(n){n == 0}))
print("hatmatrix gives correct network measures")
print(diff)


#Check if Contribution matrix * direct effectes is 100
CM = C$contributionMatrix
ch2 = (CM * sign(HM)) %*% md
test2 = all(lapply((ch2), function(n){n == 100}))
print("Check if Contribution matrix * direct effectes is 100")
print(test2)
