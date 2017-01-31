data1 = read.table("https://s3.amazonaws.com/hr-testcases/368/assets/trainingdata.txt",sep = "\n")
data = data1
x = unlist(strsplit(as.character(data[1,]),","))
dat = data.frame(names = paste(x[1:10],collapse = ","),Win = x[11])

for(i in 2:nrow(data)){
  x = unlist(strsplit(as.character(data[i,]),","))
  x = data.frame(names = paste(x[1:10],collapse = ","),Win = x[11])
  dat = rbind(dat,x)
}


clean = function(x)
{
  y = unlist(strsplit(as.character(x),""))[1]
  return(y)
  
}

win = function(x){
  x = unlist(strsplit(as.character(x),","))
  return(x[1:5])
}
lose = function(x){
  x = unlist(strsplit(as.character(x),","))
  return(x[6:10])
}

winner = lapply(dat$names,function(x) win(x))
winner = (do.call(rbind,winner))
loser = lapply(dat$names,function(x) lose(x))
loser = (do.call(rbind,loser))

fillblanks = function(x)
{
  y = gsub(" ","-",as.character(x))
  return(y)
}
removecom = function(x){
  return(gsub(","," ",as.character(x)))
}
dat$Win = sapply(dat$Win,function(x) clean(x))
dat[,2] = as.factor(dat[,2])
dat$names = sapply(dat$names,function(x) fillblanks(x))
dat$names = sapply(dat$names,function(x) removecom(x))

##
library(tm)
dat.corpus = Corpus(VectorSource(dat$names))
dat.dtm = as.data.frame(as.matrix(DocumentTermMatrix(dat.corpus)))
dat.dtm = cbind(dat.dtm,dat$Win)
