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
               tabPanel("Contacts", 
                      fluidRow(column(width=4),
                               column(width=4, align = "left",
                                      h2('Help us expand this page'),
                                      p('We are actively seeking to add other openly available data-sets to this page. Please contact us if you have any pre-processed data-sets and want to publicly evaluate their quality via DSE decomposition.'),
                                      p('Email Soroosh Afyouni <srafyouni@gmail.com> or Thomas Nichols <thomas.nichols@bdi.ox.ac.uk>')),
                               column(width =4)),
                      
                      fluidRow(column(width = 4),
                               column(width = 4, align = "left",
                               h3('Citation:'),
                               p('S. Afyouni and T.E. Nichols. Insight and Inference for DVARS. bioRxiv (2017). doi: https://doi.org/10.1101/125021')),
                               column(width = 4))
               )
    )
  )
  
  #================================================================================================
  #================================================================================================
#)
