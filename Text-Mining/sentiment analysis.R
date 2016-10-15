library(tm)
library(plyr)
library(dplyr)
library(class)
options(stringsAsFactors = F)

candidates = c("Romney","Obama")
pathname = "/home/abhijit331/Text-Mining/"

# Clean the text

CleanCorpus = function(corpus)
{
 corpus.tmp = tm_map(corpus,removePunctuation)
 corpus.tmp = tm_map(corpus.tmp,stripWhitespace)
 #corpus.tmp = tm_map(corpus.tmp,tolower)
 corpus.tmp = tm_map(corpus.tmp,removeWords,stopwords("english"))
 return(corpus.tmp)
}

generateTDM = function(cand,path){
  s.dir = paste0(path,cand)
  s.cor = Corpus(DirSource(directory = s.dir,encoding = "UTF-8"))
  s.cor.cl = CleanCorpus(s.cor)
  s.tdm = TermDocumentMatrix(s.cor.cl)
  s.tdm = removeSparseTerms(s.tdm,0.7)
  result = list(name = cand,tdm = s.tdm)
}

tdm = lapply(candidates,generateTDM,path = pathname)


bindCandidatetoTDM = function(tdm)
{
  s.mat = t(data.matrix(tdm[["tdm"]]))
  s.df = as.data.frame(s.mat, stringsAsFactors = F)
  
  s.df = cbind(s.df,rep(tdm[["name"]],nrow(s.df)))
  colnames(s.df)[ncol(s.df)] = "targetcandidate"
  return(s.df)
}

candTDM = lapply(tdm,bindCandidatetoTDM)


tdm.stack = do.call(rbind.fill,candTDM)
tdm.stack[is.na(tdm.stack)] = 0


# creating training and testing sample

train.idx = sample(nrow(tdm.stack),ceiling(nrow(tdm.stack) *0.7))
test.idx = (1:nrow(tdm.stack))[-train.idx]


# KNN model : 

tdm.cand = tdm.stack[,"targetcandidate"]
tdm.stack.nl = tdm.stack[,!colnames(tdm.stack) %in% "targetcandidate"]
knn.pred = knn(tdm.stack.nl[train.idx,] , tdm.stack.nl[test.idx,],tdm.cand[train.idx])

conf.mat = table("Pred" = knn.pred,Actual = tdm.cand[test.idx])
conf.mat