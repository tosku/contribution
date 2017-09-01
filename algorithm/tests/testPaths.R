rm(list=ls())
Sys.setenv(LANG = "en")
library("devtools")

source("../flow_contribution/R/hatmatrix.R")
source("../flow_contribution/R/contributionmatrix.R")
source("../flow_contribution/R/contributionrow-new.R")

indata = read.csv("griselda_wide.csv",header=TRUE,sep=",")
C = getContributionMatrix(indata,type="netwide_binary",model="random",sm="OR")

# indata = read.csv2("diabetes_new.csv",header=TRUE,sep=";")
# C = getContributionMatrix(indata,type="netwide_binary",model="random",sm="OR")

# indata = read.csv2("binary.csv",header=TRUE,sep=";")
# C = getContributionMatrix(indata,type="netwide_binary",model="random",sm="OR")

# indata = read.csv("Leucht.csv",header=TRUE,sep=";")
# C = getContributionMatrix(indata,type="iv",model="fixed",sm="OR")
# indata = read.csv("OSrob.csv",header=TRUE,sep=",")
# C = getContributionMatrix(indata,type="iv",model="random",sm="OR")

print(c("calculated matrix"))
# Direct effects
md = -C$hatMatrix$Pairwise[,1]
newnmd = lapply(names(md), function(n){gsub(" vs ",":",n)})
names(md) = newnmd
md = md[order(names(md))]
#network effects
mn = C$hatMatrix$NMA[,1]
#hatmatrix
HM = C$hatMatrix$H2bu
colnames(HM) <- C$hatMatrix$colNames
allComparisons = rownames(HM)
CM = C$contributionMatrix
# CR = lapply(head(allComparisons,1), function(comp){getComparisonContribution(C$hatMatrix,comparison=comp)})
CR = lapply(allComparisons, function(comp){getComparisonContribution(C$hatMatrix,comparison=comp)})
diffs = lapply(CR, function(cont){return(cont$contribution-cont$rcontr)})
filterDiffs = function (diffs, thres) {
  lapply(diffs, function(diff){diff[diff>thres]})
}
fods = function(diffs, thres) {
  allDiffs = length(md) * length(CR)
  return (sum(
    lapply(filterDiffs(diffs, thres), function(d){length(d)}) %>% unlist()
  )*100/allDiffs)
}

biggestDiff = function(diffs){
  xs = seq(0.01,100,0.01)
  return(Reduce(function(out, x){
                  o = 0
                  if(fods(diffs,x)>0){
                    o=x
                  }else{
                    o=out
                  }
                  return(o)
  },xs,0))
}
print("equivelance threshold")
print(biggestDiff(diffs))
xs = seq(0.01,1.5,0.01)
plot(xs,lapply(xs,function(x){fods(diffs,x)}))

# testRows = all(lapply(newnmd, function(n){all(getComparisonContribution(C$hatMatrix,comparison=n[1])$contribution-CM[n[1],]==0)}))
# print("test contribution by row agrees with contribution matrix")
# print(testRows)
