fluidPage(
  headerPanel("Data Quality Control by DSE Decomposition"),
  br(),
  fluidRow(
    column(4,
           h4("HCP"),
           p("100 unrelated fully pre-processed (FPP) subjects of the Human Connectome Proeject. [date accessed: 15/8/2017]")
           ),
    column(6,
           h4("ABIDE"),
           p("530 healthy subjects across 20 acquisition sites from Autism Brain Imaging Data Exchange. \
             Fully pre-processed images downloaded from Pre-processed Connectome Proejct (PCP). \
             [date accessed: 15/8/2017]")
           )
    ),
  fluidRow(
    column(4,
           hr(),
           selectInput('HCP', 'Choose a dataset:', c('HCP'), selectize=FALSE,width = 400),
           verbatimTextOutput('out1')
    ),
    column(6,
           hr(),
           selectInput('PCP', 'Choose a dataset:', c('CALTECH','CMU','KKI','LEUVEN_1','LEUVEN_2',
                                                     'MAX_MUN','NYU','OHSU','OLIN','PITT','SBL',
                                                     'SDSU','STANFORD','TRINITY','UCLA_1','UCLA_2',
                                                     'UM_1','UM_2','USM','YALE'), selectize=FALSE,width = 650),
           verbatimTextOutput('out2')
    )
  ),
  fluidRow(
    column(4,
           hr(),
           plotOutput("out3",width = 400)
    ),
    column(6,
           hr(),
           plotOutput('out4',width = 400)
    )
  ),  
  fluidRow(
    column(4,
           hr(),
           sliderInput("HCPSB","Percentile of %Svar-%Dvar:", min = 0, max = 100, value = 75,width = 400)
    ),
    column(6,
           hr(),
           sliderInput("PCPSB","Percentile of %Svar-%Dvar:", min = 0, max = 100, value = 75,width = 650)
    )
  ),  
  fluidRow(
    column(4,
           hr(),
           h6("%Dvar:"),
           verbatimTextOutput("DHCPSum"),
           h6("%Svar:"),
           verbatimTextOutput("SHCPSum")           
    ),
    column(6,
           hr(),
           h6("%Dvar:"),
           verbatimTextOutput("DPCPSum"),
           h6("%Svar:"),
           verbatimTextOutput("SPCPSum")           
    )
  ), 
  fluidRow(
    column(2),
    column(6,
           h5("Help us expand this page:"),
           p("We are actively seeking to add other openly available data-sets to this page. Please contact us if you have any pre-processed data-sets and want to publicly evaluate their quality via DSE decomposition.\n
              Email Soroosh Afyouni <srafyouni@gmail.com> or Thomas Nichols <thomas.nichols@bdi.ox.ac.uk>"),
           h5("Citation:"),
           p("Afyouni, Soroosh, and Thomas E. Nichols. Insight and Inference for DVARS. bioRxiv (2017). doi: https://doi.org/10.1101/125021"),
           h6("______________________________________________"),
           h6("Neuroimaging Statistics Oxford (NISOx)"),
	         h6("Oxford Big Data Institute (BDI)"),
	         h6("http://nisox.org | https://www.bdi.ox.ac.uk/")
           )
    )
  )
  
