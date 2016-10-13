library(rvest)
library(stringr)
library(magrittr)
## Extract all the links from the page 
page = read_html("http://mittromneycentral.com/speeches/")

links = page %>% html_nodes("#content p + p") %>% html_text()
links = links[-c(5,12)]

links1 = links[1:20]
links2 = links[20:40]
links3 = links[41:66]
#### Extract text ### 
generate_url = function(x)
{
  temp = unlist(strsplit(x," "))
  date = temp[length(temp)]
  url = paste(unlist(strsplit(date,"/")),collapse = "")
  temp = temp[-c(length(temp), length(temp)-1) ]
  temp = gsub("[[:punct:]]","",temp)
  temp = paste(tolower(temp),collapse = "-")
  temp = gsub("--","-",temp)
  # temp = gsub(intToUtf8(8217),"",paste(tolower(temp),collapse = "-"))
  # temp = gsub(intToUtf8(8216),"",temp)
  # temp = gsub("[.]","",temp)
  url = paste(url,"-",sep = "")
  url = paste(url,temp,sep = "")
  url = gsub("-us-","-u-s-",url)
  
  url
}

extract_text = function(x)
{
  temp = tryCatch(read_html(paste("http://mittromneycentral.com/speeches/2012-speeches/",generate_url(x),sep = "")),error = function(e) {message(paste(links[i]))})
  temp.text  = temp %>% html_nodes(".entry-content p") %>% html_text()
  
  t = paste(temp.text,collapse = "")
  t = gsub("\\(APPLAUSE\\)","",t)
  return(t)
}

get_speech_romney = function(x)
{
  for( i in 1:length(x))
  {
    temp = extract_text(x[i])
    fileCon = file(paste(generate_url(x[i]),".txt",collapse = ""))
    writeLines(temp,fileCon)
    close(fileCon)
  }
}

get_speech_romney(links2)
get_speech_romney(links3)
get_speech_romney(links1)
