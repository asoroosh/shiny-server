library(R.matlab)
library(shinythemes)
#shinyApp(
  ui <- tagList(
    #shinythemes::themeSelector(),
    navbarPage(theme = shinytheme("darkly"),
               # theme = "cerulean",  # <--- To use a theme, uncomment this
               "NISOx.org",
               tabPanel("DSE Decomposition",
                        #start of slide bar===================================================== 
                        sidebarPanel(
                          selectInput('DSAd', label = 'Choose a dataset:', choices = c('HCP','ABIDE'), selectize=FALSE,selected = 'HCP'),
                          #------
                          #selectInput("StAd", label = "Select a site:",  choices = c('100Unrelated'),selectize = FALSE,selected = '100Unrelated'),
                          uiOutput('SiteSelect'),
                          #------
                          sliderInput("DSFilter","Percentile of %Svar-%Dvar:", min = 0, max = 100, value = 75),
                          checkboxInput('NormBot', 'Normalised by A-var', value = TRUE)
                        ), 
                        #end of slide bar=====================================================
                        #===================================================================== 
                        #=====================================================================    
                        mainPanel(
                          tabsetPanel(
                            #Whole=====================================================
                            tabPanel("Whole Variability",
                                     plotOutput("DSPlot_Whole")
                            ),
                            #Global=====================================================
                            tabPanel("Global Variability", 
                                     plotOutput("DSPlot_Global")         
                            )
                            #Global=====================================================
                            #tabPanel("Non-global Variability", 
                            #         plotOutput("DSPlot_nGlobal")
                            #)
                            #End of Tabs=====================================================
                          )
                        )
               ),
               #Contact=====================================================
               tabPanel("Contacts", "Under Construction!")
    )
  )
  
  #================================================================================================
  #================================================================================================
#)
