library(RSelenium)


dr = rsDriver(port = "Enter Port Number here",browser = c("firefox"))
remDr = dr$client

remDr$navigate("https://www.google.com")
remDr$getTitle()

# to use the press key
search = remDr$findElement(using = "css", "[name = 'q']" )
search$sendKeysToElement(list("Iron Maiden",key = "enter"))
search$clearElement()
search$sendKeysToElement(list("Hallowed be Thy Name",key = "enter"))

# to use the trackpad click
temp1 = remDr$findElement(using = 'css',"[name = 'q']")
temp1$sendKeysToElement(list("Hallowed be thy name"))
temp = remDr$findElement(using = 'css selector', "#_fZl")
temp$clickElement()
search$clearElement()


##### WhatsApp Shenanigans

remDr$navigate("https://web.whatsapp.com")
remDr$getTitle()


anu = remDr$findElement(using = "xpath",'//span[contains(text(),"John Doe")]') # Replace John Doe with contact/group name
anu$clickElement()

chat = remDr$findElement(using = 'css selector','.chat')
  
chat$sendKeysToElement(list("Enter text here",key = 'enter'))
#chat$clearElement()


