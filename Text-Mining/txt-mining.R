library(twitteR)
library(tm)
library(RCurl)
library(wordcloud)
consumer_key = "PKIqzBYSv4TRN4SnR8MXnW1kQ"
consumer_secret = "ZRWS4RXUDDe4o3FWArxUofthP7zjnUa3lv7gzwRSYQMqtWkJi9"
access_token= "99661008-tNkqwsS4cKWiK4ov2VOzuB1h9NIPPfEjB9qn0fqRa"
access_token_secret = "GHjsDvBE0qLAYA38sEC2FJU8mQfyVwOnxJn5OeKTSxdWT"

setup_twitter_oauth(consumer_key,consumer_secret,access_token,access_token_secret)

MANU_tweets = searchTwitter("Manchester United", n =1000 , lang = 'en')


text = sapply(MANU_tweets, function(x) x$getText())

manu.corpus = Corpus(VectorSource(text))

CleanCorpus = function(corpus)
{
  corpus.tmp = tm_map(corpus,removePunctuation,lazy = T)
  corpus.tm = tm_map(corpus.tmp,stripWhitespace,lazy= T)
  corpus.tm = tm_map(corpus.tm,tolower,lazy = T)
  corpus.tm = tm_map(corpus.tm,removeNumbers,lazy = T)
  corpus.tm = tm_map(corpus.tm,removeWords,stopwords("english"),lazy = T)
  corpus.tm = tm_map(corpus.tm,removeWords,c("everest","himalaya","himalayas"),lazy = T)
  return(corpus.tm)
}

manu.corpus.clean = CleanCorpus(manu.corpus)

corpus.DTM = TermDocumentMatrix(manu.corpus)

wordcloud(manu.corpus.clean)
