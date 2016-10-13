library(rvest)
library(stringr)
library(magrittr)
## Extract all the links from the page 
page = read_html("http://obamaspeeches.com/E-Barack-Obama-Speech-Manassas-Virgina-Last-Rally-2008-Election.htm")

links = page %>% html_nodes("a") %>% html_attr("href") %>%
  str_subset("\\.htm")


links.htm = " "

for( i in links)
{
  temp = unlist(strsplit(i,"-"))
  if("Podcast.htm" %in% temp)
  {
    next
  }else
  {
    links.htm = rbind(links.htm,i)
  }
}

links.htm = links.htm[-1]

for( i in 18:38)
{
  links.htm[i] = paste("/E",links.htm[i],sep = "")
}
##### Extract text from the links ###
extract_text = function(x)
{
temp = paste("http://obamaspeeches.com",x,sep = "")
temp.text  = temp %>% read_html() %>% html_nodes("br + table td") %>% html_text()

t = unlist(strsplit(temp.text,"\n"))
t.t = unlist(strsplit(t,"  "))
ext.text = paste(t.t,collapse = "")
return(ext.text)
}

### Extract file name 
extract_name = function(x)
{
 temp = paste(unlist(strsplit(x,"-"))[-1],collapse = "-")
 temp = paste(unlist(strsplit(temp,"[.]"))[-2],collapse = "-")
 return(temp)
}

## Function to combine all the functions ###
get_speech_obama = function()
{
  for(i in 1:38)
{
    temp = extract_text(links.htm[i])
    fileCon = file(paste(extract_name(links.htm[i]),".txt",collapse = ""))
writeLines(temp,fileCon)
close(fileCon)
  }
}

get_speech_obama()
