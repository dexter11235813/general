setwd("/home/abhijit331/GeneralR/Text-Mining")
library(tm)
library(twitteR)
library(dplyr)
library(wordcloud)
library(RColorBrewer)
library(RWeka)

setup_twitter_oauth(consumer_key,consumer_secret,access_token,access_token_secret)

target.tweets = searchTwitter("Modi",n = 1000,lang = "en")
######

target.tweets.text = sapply(target.tweets,function(x) x$getText())  
target.tweets.text = iconv(target.tweets.text,to = "utf-8", sub = "")
target.tweets.text = gsub("^http(.*?)\\s","",target.tweets.text)
target.corpus = VCorpus(VectorSource(target.tweets.text))

target.corpus =  tm_map(target.corpus,removePunctuation)
target.corpus =  tm_map(target.corpus,removeNumbers)
target.corpus =  tm_map(target.corpus,stripWhitespace)
#target.corpus =  tm_map(target.corpus,content_transformer(replace_abbreviation),lazy = T)
target.corpus =  tm_map(target.corpus,removeWords,stopwords("en"),lazy = T)
target.corpus = tm_map(target.corpus,content_transformer(tolower),lazy = T)

# target.corpus
#target.corpus = VCorpus(VectorSource(target.corpus))

tokenizer = function(x)
{
  NGramTokenizer(x,Weka_control(min = 2 , max = 2))
}

target.tdm = TermDocumentMatrix(target.corpus,control =  list(tokenize = tokenizer,weighting = weightTfIdf))




target.mat = as.matrix(target.tdm)
term_freq = rowSums(target.mat)
term_freq =  rev(sort(term_freq))

word_freqs = data.frame(term = names(term_freq), num  = term_freq)
wordcloud(word_freqs$term,word_freqs$num,max.words = 100,color = brewer.pal(10,"PuOr")[-(1:2)])
