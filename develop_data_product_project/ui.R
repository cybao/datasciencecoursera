library(shiny)

shinyUI(navbarPage("MyNHLStars",
    tabPanel("About",
        titlePanel("About MyNHLStars"),
        navlistPanel(
	    tabPanel("What is MyNHLStars?",
	        p("MyNHLStars is a webapp for predicting National Hockey League (NHL) player performance using 
	        statistics from previous seasons. This app is inspired by the demand of choosing best producing
	        players for hockey pools."),
		p("Right now it provides a list of players ranked by their predicted offensive points in the 
		upcoming season and the predicative model is faily simple. Better prediction and more features 
		will be added to the app soon. Stay tuned!"),
		p("All the data used to build predicative model and to forcast player performance is from",
		   a(href="www.hockeyabstract.com","Hockey Abstract"),"and",a(href="www.nhl.com","NHL"),
		   ". The app is written in R.")
		),
	    tabPanel("How to use MyNHLStars?",
		h2("Output"),
		p("MyNHLStars produces a downlodable data table of NHL players ranked by their predicted offensive 
		   performance for the upcoming season. The data table contains player name, age, position (forward 
		   or defenseman) and their scoring from the prediction."),
	        p("If you just want to test the app, you could just go with the default settings. Otherwise, you can
		   read on about customizing your input for the predictative model."),
	        h2("Input"),
		h3("Minimum Games Played per Season"),
		p("Only players who played at least this amount of games (out of 82) per season will be included in 
		   the prediction. Please notice that the higher this threshold is, the better statistics one can get 
		   about the player performance; but the chance of cutting good player who missed majority of a season 
		   due to injury is also higher."),
		h3("Number of Past Seasons Used for Prediction"),
		p("Only players who played at least this amount of seasons will be included in the prediction. This 
		   means rookies and young players are not included in the prediction. (This will change in
		   the near future!)"),
		h3("Points per Goal/Assist"),
		p("This is the metric used to characterize the offensive performance of a player. By default, each 
		   goal or assist is worth one point for all players. These input parameters allow the user to 
		   specify the number of points awarded for a goal or assist for forwards or defensemen. For example,
		   some hockey pools may choose to give a defenseman two points for eacy goal he scores since these
		   goals are rarer.")
		),
	    tabPanel("Contact me",
	         p("If you have any comments/suggestions regarding to improve this app, please feel free to",
		   a(href="mailto:ssnb336@gmail.com","contact me"))
	    )
	)
    ),
    tabPanel("Player performance prediction",
        sidebarLayout(
	    sidebarPanel(
	          sliderInput("mingp",label=h4("Minimum Games Played per Season"),
		      min=20,max=40,value=20),
		  selectInput("years",label=h4("Number of Past Seasons Used for Prediction"),
		      choices=list("3"=3,"4"=4,"5"=5),
		      selected=3),
		  h3("Forwards"),
		  numericInput("goalf",label=h4("Point per Goal"),
		      min=1,max=3,value=1,step=0.5),
		  numericInput("assistf",label=h4("Point per Assist"),
		      min=1,max=3,value=1,step=0.5),
		  h3("Defensemen"),
		  numericInput("goald",label=h4("Point per Goal"),
		      min=1,max=3,value=1,step=0.5),
		  numericInput("assistd",label=h4("Point per Goal"),
		      min=1,max=3,value=1,step=0.5),	      
		  actionButton("gobutton","Get my NHL stars!"),
	          downloadButton('downloadData', 'Download')
    		  ),
    	    mainPanel(
	          dataTableOutput(outputId="prediction")
    		  )))
#    tabPanel("Individual Player History")
))