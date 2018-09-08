library(ggplot2)

pbp=read.csv("Downloads/[10-20-2015]-[06-20-2016]-combined-stats (1).csv")
pbp_sub=subset(pbp,select=c("player","converted_x","converted_y","description","assist","result","points","type","shot_distance"))
pbp_sub1=subset(pbp_sub,shot_distance>=0)

#convert factor to numeric 
pbp$converted_x=as.numeric(pbp$converted_x)
pbp$converted_y=as.numeric(pbp$converted_y)
write.csv(pbp_sub1,file="nba_pbp_16.csv")

#import expected points data (from python script)
shot_chart=read.csv("shot_chart.csv")

#shots by distance 
deep_shots=subset(shot_chart,shot_distance>=22)
mean(deep_shots$pred_points) #0.968
mean(deep_shots$points) #1.06 

short_shots=subset(shot_chart,shot_distance<22)
mean(short_shots$pred_points) #1.02
mean(short_shots$points) #0.98 

paint=subset(shot_chart,shot_distance<=5)
mean(paint$pred_points) #1.09
mean(paint$points) #1.16

mid_range=subset(shot_chart,shot_distance>=8 & shot_distance<22)
mean(mid_range$pred_points) #0.942 
mean(mid_range$points) #0.807 

shot_chart$converted_x=as.numeric(shot_chart$converted_x)
shot_chart$converted_y=as.numeric(shot_chart$converted_y)

ggplot(shot_chart,aes(x=converted_x,y=converted_y,color=points))+geom_point()+
  xlab("x-coordinates")+ylab("y-coordindates")

player=subset(pbp,player=="Damian Lillard",select=c("player","converted_x","converted_y","shot_distance","assist","description","points"))
player1=subset(player,points>=0)
player2=player1[!grepl("Free",player1$description),]

#assist vs. no assist 
assist=player2[grep("AST",player2$description),]
mean(assist$shot_distance) #17.7
points_per_shot=sum(assist$points)/nrow(assist) 
points_per_shot

no_assist=player2[!grepl("AST",player2$description),]
mean(no_assist$shot_distance) 
no_assist_points=no_assist[grep("PTS",no_assist$description),]
points_per_shot1=sum(no_assist_points$points)/nrow(no_assist_points) #2.42
points_per_shot1

#15-16 regular season 
#three pointers (assist vs. no assist)
assist_3pa=assist[grep("3PT",assist$description),]
count(assist_3pa) 

no_assist_3pa=no_assist[grep("3PT",no_assist$description),]
no_assist_3pam=no_assist_3pa[grep("PTS",no_assist_3pa$description),]
count(no_assist_3pam) 

