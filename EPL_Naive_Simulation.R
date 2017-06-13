
conf.tab  = matrix(0,nrow =6,ncol = 6)
rownames(conf.tab) = c("Chelsea","Tottenham","Man. City","Liverpool","Manchester United", "Arsenal")
colnames(conf.tab) = c("1st","2nd","3rd","4th","5th","6th")
t = rownames(conf.tab)
# simulation for 14 games
for (j in 1:1e4){
table = data.frame(teams =c("Chelsea","Tottenham","Man. City","Liverpool","Manchester United", "Arsenal"), Points = c(69,59,56,55,53,50))
points = c(3,1,0)
for(i in 1:11){
  table[,2] = table[,2] + sample(points,6,replace = TRUE)
}
table = table[rev(order(table[,2])),]
for(i in t){
  conf.tab[which(rownames(conf.tab) == i),which(table[,1]== i)] = conf.tab[which(rownames(conf.tab) == i),which(table[,1] == i)] + 1
}
}
conf.tab
par(mfrow = c(3,2))
for(i in 1:6){
barplot(conf.tab[i,],main = rownames(conf.tab)[i])
}
par(mfrow = c(1,1))


# 
# plaw = function(x,a){
#   return(5*x^-a)
# }
# pl = matrix(0,nrow = 101,ncol = 6)
# x = seq(0,10,.1)
# y = plaw(x,0.1)
# matplot(y,col = 1:6,type = "l")
# 

