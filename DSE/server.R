library(R.matlab)
library(shinythemes)

server <- function(input, output, session) {

#  observe({
#    x <- input$DSAd
    
    #switch(x,
           #"HCP"   = updateSelectInput(session, "StAd",choices = c('100Unrelated'), selected = ch[1]),
  #         "ABIDE" = updateSelectInput(session, "StAd",choices = c('NYU','CALTECH'), selected = ch[1])
    #)
  #})
  
  #-------------------------------------------------
  
  output$SiteSelect <- renderUI({
    if (is.null(input$DSAd))
      return()
    
    switch(input$DSAd,
           "HCP"   = selectInput("StAd", label = "Select a site:",  choices = as.character(c('100Unrelated')),selectize = FALSE,selected = '100Unrelated'),
           "ABIDE" = selectInput("StAd", label = "Select a site:",  choices = as.character(c('CALTECH','CMU','KKI','LEUVEN_1','LEUVEN_2',
                                                                                'MAX_MUN','NYU','OHSU','OLIN','PITT','SBL',
                                                                                'SDSU','STANFORD','TRINITY','UCLA_1','UCLA_2',
                                                                                'UM_1','UM_2','USM','YALE')),selectize = FALSE,selected = 'NYU')
    )
  })
  #-------------------------------------------------
  #StAd <- reactive({ input$StAd })
  #StAd()
      
  DSMeta <- function(WhichComp){
    StAd <- reactive({
      input$StAd
    })
    dd<-StAd()
    print(dd)
    
    MSSDflag=input$NormBot;
    
    Variabilities<-loadMe(WhichComp)
    S=Variabilities$S
    D=Variabilities$D
    
  
    nsub=dim(S)[1]
    xn=dim(S)[2]
    
    xtick<-list(); Dfilt<-list(); Sfilt<-list();
    for(i in 1:xn){
      diffVar_tmp=abs(S[,i]-D[,i]);
      Idx_tmp=diffVar_tmp<=quantile(diffVar_tmp,input$DSFilter/100)
      
      set.seed(1);
      xtick_tmp  = rnorm(nsub,mean = 0,sd = 0.02)+i
      xtick[[i]] = xtick_tmp[Idx_tmp]
      
      Sfilt[[i]]=S[Idx_tmp,i]
      Dfilt[[i]]=D[Idx_tmp,i]
      
      rm(diffVar_tmp,Idx_tmp,xtick_tmp)
    }
    outmeout<-list("S"=Sfilt,
         "D"=Dfilt,
         "nsub"=nsub,
         "xtick"=xtick,
         "xn"=xn,
         "MSSDflag"=MSSDflag)
    return(outmeout)
  }
  

  #--------------------------------------------------
  
  output$DSPlot_Whole <- renderPlot({
    plotter(c('S','D'))
  })  
  
  output$DSPlot_Global <- renderPlot({
    plotter(c('gS','gD'))
  })    
  #--------------------------------------------------
  loadMe<-function(strvar){
    
    if (input$NormBot){normprefix='p'}
    else {normprefix='m'}
    
    outtmp<-list()

    cnt=1;
    for (st in strvar){
      wherefrom=paste('R/DSE_',as.character(input$DSAd),'_',as.character(input$StAd),'.mat',sep = '');
      print(wherefrom)
      outtmp[[cnt]]=eval(parse(text = paste('readMat("',wherefrom,'")$',normprefix,st,sep=''))); 
      cnt=cnt+1
    }
    OutMe<-list('S'= outtmp[[1]],
         'D'=outtmp[[2]])
    return(OutMe)
  }
  #--------------------------------------------------
  plotter<-function(WhichComp){

    DSMeta=DSMeta(WhichComp)
    
    load(paste('Meta/',input$DSAd,'_Meta.Rdata',sep = ''))
    ylabstr=Meta$pplabels
    
    D=DSMeta$D;
    S=DSMeta$S;
    
    xn=DSMeta$xn;
    
    xcentres=as.vector(1:xn); 
    minPL=min(xcentres); maxPL=max(xcentres);
    
    mS=lapply(S,mean);
    mD=lapply(D,mean);
    
    Dcol=rgb(0, 0, 1, 0.5);
    Scol=rgb(1, 0, 0, 0.5);
    
    if(DSMeta$MSSDflag){
      YlimTmp=c(5,95) 
      RefLine=c(50,50)
      ylabtog="%A-var"} 
    else {
      YlimTmp=c(-.01,22) 
      RefLine=c(0,0)
      ylabtog="Successive Difference (MSSD)"}
    
    if (sum(grepl('g',WhichComp))>0){
      legendstr=c('%S_G-var','%D_G-var');
      YlimTmp=c(-0.01,6)
      RefLine=c(0,0)}
    else {
      legendstr=c('%S-var','%D-var');
#      YlimTmp=c(20,80)
#      RefLine=c(50,50) 
    }
    
    for(i in xcentres){
      par(new=TRUE)
      plot(DSMeta$xtick[[i]],D[[i]],col=Dcol,xlim = c(minPL,maxPL),ylim = YlimTmp ,ann=FALSE, xaxt='n',pch=16,cex=1)
      
      par(new=TRUE)
      plot(DSMeta$xtick[[i]],S[[i]],col=Scol,xlim = c(minPL,maxPL),ylim = YlimTmp,ann=FALSE, xaxt='n',pch=16,cex=1)
    }
    par(new=TRUE)
    plot( xcentres,mS,col = 'black', pch=4,ylim = YlimTmp,ann=FALSE, xaxt='n',cex=1.2)
    lines(xcentres,mS,col = Scol,  lty=4)
    
    par(new=TRUE)
    plot( xcentres,mD,col = 'black',pch=4,ylim = YlimTmp,ann=FALSE, xaxt='n',cex=1.2)
    lines(xcentres,mD,col = Dcol,  lty=4)
    
    par(new=TRUE)
    grid(nx = 10, ny = 10, col = "lightgray", lty = "dotted")
    axis(1,at = xcentres,labels = ylabstr,ylim = YlimTmp,xlab = 'Pipileline',ylab = ylabtog)
    
    par(new=TRUE)
    plot(c(minPL-.5,maxPL+.5),RefLine,type = "l",xaxt='n',yaxt='n',ylim = YlimTmp,xlab = 'Pipileline',ylab = ylabtog)
    legend("topright",'groups',legend = legendstr,pch = c(16,16),col =c('red','blue'),cex=0.8)
  }

}