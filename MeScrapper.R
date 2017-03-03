library(rvest)
library(stringr)

container<-data.frame()

for (a in 2:2) { # dane ze strony
  
  url1<-"https://www.pracuj.pl/praca/Hadoop;kw"
  url<-paste(url1,a,sep = "") # ³¹czenie linku z numerem strony
  link <- read_html(url) # czytanie kodu html strony
  h<-html_nodes(link,'h2 [itemprop="title"]') # czytanie wartosci ze strony html
  dane<-html_text(h) # konwersja kodu na tekst
  for (i in 1:length(dane)) { # iteracja po kolejnych ofertach na stronie
    container[i+(10*(a-2)),1]<-dane[i] # zapisywanie wynikow do data.frame
  }
}

container[,1] #wyœwietlanie

for (a in 2:2) {
  url1<-"https://www.pracuj.pl/praca/Hadoop;kw"
  url<-paste(url1,a,sep = "")
  link <- read_html(url)
  h<-html_nodes(link,'h3 [itemprop="name"]')
  dane<-html_text(h)
  for (i in 1:length(dane)) {
    container[i+(10*(a-2)),2]<-dane[i]
  }
}

container[,2]

for (a in 2:2) {
  url1<-"https://www.pracuj.pl/praca/Hadoop;kw"
  url<-paste(url1,a,sep = "")
  link <- read_html(url)
  h<-html_nodes(link,'span [itemprop="addressRegion"]')
  dane<-html_text(h)
  for (i in 1:length(dane)) {
    container[i+(10*(a-2)),3]<-dane[i]
  }
}

a<-sample(3000:15000,51)
#a

for (s in 1:40) {
  container[s,4]<-a[s]
}


container[,3]

hist(container[,4],col = rainbow(8),xlab = "Pensja", ylab = "Czêstotliwosc",main = "Histogram")

##geocodes<-geocode(flokalizacje, output="latlona")

##leaflet(geocodes) %>% addTiles() %>%
 ## addMarkers(~lon, ~lat, popup = ~as.character(foferty))

colnames(container)<-c("Praca","Firma","Lokalizacja","Wynagrodzenie")

write.csv(container, file = "F:/SC/Plik_CSV1.csv",row.names=FALSE)

data <- read.csv(file = "F:/SC/Plik_CSV1.csv")

container
data

