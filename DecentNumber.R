library(tm)
library(randomForest)


data = read.table("https://s3.amazonaws.com/hr-testcases/597/assets/trainingdata.txt",sep = "\n")
data = lapply(data,as.character)
data = data[[1]]
clean = function(x){
  x = sub(" ",";",x)
  x = unlist(strsplit(x,";"))
  return(x)
}
data = unlist(lapply(data, function(x) clean(x)))
num = as.integer(data[1])
data = data.frame(Document = data[seq(2,length(data),2)],Text = data[seq(3,length(data),2)])
data[,2] = as.character(data[,2])

data.corpus = Corpus(VectorSource(data$Text))

clean.corpus = function(x)
{
  x = tm_map(x,removePunctuation)
  x = tm_map(x,stripWhitespace)
  x = tm_map(x, content_transformer(tolower))
  x = tm_map(x,removeWords,stopwords("english"))
}

data.clean = clean.corpus(data.corpus)
dtm = DocumentTermMatrix(data.clean)
dtm = as.matrix(removeSparseTerms(dtm,0.85))
dtm = as.data.frame(dtm)
dtm = cbind(dtm,Document = data$Document)
dtm$Document = as.factor(dtm$Document)

index = sample(nrow(dtm),ceil(nrow(dtm) * .7))
train = dtm[index,]
test = dtm[-index,]

model = randomForest(Document~.,data = train)
x = predict(model,test[,-ncol(test)])
conf.table = table(Actual = test[,ncol(test)],Prediction = x)

sum(diag(conf.table)/length(x))
conf.table






# decent number
# only 3s and 5s
# number of 5s divisible by 3
# number of 3s divisible by 5


# - the number will be divisible by 3

n  = 11
decent = function(n){
  x = n
  while(x %% 3 !=0){
    if(x <= 0) {break}
    x = x - 5
    if((x %% 3 == 0) && ((n-x)%%5!=0)){
      x = x - 5
    }
    
  }
  
  ifelse(x >= 0,return((paste(c(rep(5,x),rep(3,(n-x))),collapse = ""))),-1)
}


