library(shiny)
library(dplyr)
library(ggplot2)

#compute the mean statistics for the x past number of years specified by user
#also cut on minimum number of games played for a given season

getpaststat <- function(x,useseason,gpcutoff,lastseason){
  data <- x %>% filter(season>lastseason-useseason) %>%
	group_by(name) %>%
	summarise(meangp=mean(GP),meangpg=mean(gpg),meanapg=mean(apg),
	          meanshpg=mean(shpg),meantoipg=mean(toipg),
		        mingp=min(GP),startyear=min(season)) %>%
	filter(mingp>=gpcutoff,startyear==lastseason-useseason+1)
  return(data)
}

constructpred <- function(x,useseason,gpcutoff,lastseason,predfield){
    paststat <- getpaststat(x,useseason,gpcutoff,lastseason-1)
    laststat <- x %>% filter(season==lastseason) %>% 
                select(name,Age,Pos,GP,gpg,apg,shpg,toipg)
    dataset <- merge(paststat,laststat,by.x="name",by.y="name")
    if (predfield=="gp"){
        modelfit <- glm(GP~Age+meangp,data=dataset)
	return(modelfit)
	}
    if (predfield=="gpg"){
        modelfit <- glm(gpg~Age+Age^2+Pos+meangpg+meanshpg+meantoipg,data=dataset)
	return(modelfit)
	}
    if (predfield=="apg"){
        modelfit <- glm(apg~Age+Age^2+Pos+meanapg+meantoipg,data=dataset)
	return(modelfit)
	}
}

makepred <- function(x,useseason,gpcutoff,lastseason,fptpg,fptpa,dptpg,dptpa){
  predgp <- constructpred(x,useseason,gpcutoff,lastseason,"gp")
  predgpg <- constructpred(x,useseason,gpcutoff,lastseason,"gpg")
  predapg <- constructpred(x,useseason,gpcutoff,lastseason,"apg")
  paststat <- getpaststat(x,useseason,gpcutoff,lastseason)
  thisseason <- x %>% filter(season==lastseason,name %in% paststat$name) %>%
                mutate(Age=Age+1) %>% select(name,Age,Pos,Last.Name,First.Name)
  dataset <- merge(paststat,thisseason,by.x="name",by.y="name")
  thisseason <- mutate(thisseason,GP=as.integer(predict(predgp,newdata=dataset)),
                       gpg=predict(predgpg,newdata=dataset),apg=predict(predapg,newdata=dataset),
                       ptpg=fptpg,ptpa=fptpa)
  thisseason$ptpg[thisseason$Pos=="D"] <- dptpg
  thisseason$ptpa[thisseason$Pos=="D"] <- dptpa
  thisseason$GP[thisseason$GP>82] <- 82
  thisseason <-thisseason %>% mutate(G = GP*gpg, A = GP*apg, PTS=round(G*ptpg+A*ptpa,digits=1)) %>%
               arrange (desc(PTS)) %>% select(First.Name,Last.Name,Age,Pos,PTS)
  names(thisseason) <- c("First Name","Last Name","Age","Position","Scoring")
  return(thisseason)
  
}

post2004 <- read.csv("data/nhl_player_04-15_norm12.csv")
lastseason <- max(post2004$season)
post2004 <- mutate(post2004,name=paste(First.Name,Last.Name))

shinyServer(
	function(input,output){
	prediction <- eventReactive(input$gobutton,{
	    makepred(post2004,as.numeric(input$years),as.numeric(input$mingp),lastseason,
	                     input$goalf,input$assistf,input$goald,input$assistd)      
	})
	output$prediction <- renderDataTable({
  	    prediction()
	})
	output$downloadData <- downloadHandler(
   	 filename = function() { 
		 paste('MyNHLStars','_',format(Sys.time(),"%Y%m%d%H%M%S"),'.csv', sep='') 
	 },
    	 content = function(file) {
      	 write.csv(prediction(), file)
    	 })
	}
)