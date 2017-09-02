library(R.matlab)
server<-function(input, output, session) {
  
  HCPMeta <- reactive({
    if (input$HCPBot){
      S=round(readMat(paste('R/DSE_',as.character(input$HCP),'_HCP100UR.mat',sep = ''))$pS,digits=2)
      D=round(readMat(paste('R/DSE_',as.character(input$HCP),'_HCP100UR.mat',sep = ''))$pD,digits=2)}
    else{
      S=round(readMat(paste('R/DSE_',as.character(input$HCP),'_HCP100UR.mat',sep = ''))$mS,digits=2)
      D=round(readMat(paste('R/DSE_',as.character(input$HCP),'_HCP100UR.mat',sep = ''))$mD,digits=2)}      
 
    nsub=dim(S)[1]
    
    PL=3
    set.seed(1);
    xtick=rnorm(nsub,mean = PL,sd = 0.02)

    diffVar=abs(S-D);
    Idx=diffVar<=quantile(diffVar,input$HCPSB/100)
    
    xtick=xtick[Idx]
    S=S[Idx]
    D=D[Idx]
    
    list("S"=S,
         "D"=D,
        "nsub"=nsub,
        "xtick"=xtick,
        "xcentre"=PL)
  })
  
  #--------------------------------------------------------------------
  output$HCPPlot <- renderPlot({
    HCPMeta=HCPMeta()
    
    Dcol=rgb(0, 0, 1, 0.5);
    Scol=rgb(1, 0, 0, 0.5);
    YlimTmp=c(20,80)
    
    plot(HCPMeta$xtick,HCPMeta$D,col = Dcol,xlim = c(HCPMeta$xcentre-.5,HCPMeta$xcentre+.5),ylim = YlimTmp ,ann=FALSE, xaxt='n',pch=16,cex=1)
    par(new=TRUE)
    plot(HCPMeta$xtick,HCPMeta$S,col = Scol,xlim = c(HCPMeta$xcentre-.5,HCPMeta$xcentre+.5),ylim = YlimTmp,ann=FALSE, xaxt='n',pch=16,cex=1)
    grid(nx = 10, ny = 10, col = "lightgray", lty = "dotted")
    par(new=TRUE)
    plot(c(HCPMeta$xcentre-.5,HCPMeta$xcentre+.5),c(50,50),type = "l",xaxt='n',yaxt='n',xlab = 'Processing Level',ylab = '%A-var')
    axis(1,at = HCPMeta$xcentre,labels = ('FPP'),xlim = c(HCPMeta$xcentre-.5,HCPMeta$xcentre+.5),ylim = YlimTmp)
    legend("topright",'groups',legend = c('%S-var','%D-var'),pch = c(16,16),col =c('red','blue'),cex=0.8)
    })
  #--------------------------------------------------------------------
  output$out1 <- renderText({
    HCPMeta=HCPMeta()
    HCP_Into_texts=paste(input$HCP,' # of Subjects: ', HCPMeta$nsub,sep = '')
    HCP_Into_texts},quoted = FALSE)
  #--------------------------------------------------------------------
#  output$DHCPSum <- renderPrint({
#    HCPMeta=HCPMeta()
#    summary(HCPMeta$D)
#  })
#    HCPMeta=HCPMeta()
#  output$SHCPSum <- renderPrint({
#    summary(HCPMeta$S)
#  })
  
  
  
  #----------------------------------------------------------------------------------------------------------------------------------------
  #----------------------------------------------------------------------------------------------------------------------------------------
  #----------------------------------------------------------------------------------------------------------------------------------------
  
  
  
  PCPMeta <- reactive({
    #'NYU'
    MSSDflag=input$PCPBot;
    if (MSSDflag){
      S=round(readMat(paste('R/DSE_ABIDE_',as.character(input$PCP),'.mat',sep = ''))$pS,digits=2);
      D=round(readMat(paste('R/DSE_ABIDE_',as.character(input$PCP),'.mat',sep = ''))$pD,digits=2);
    } else {
      S=round(readMat(paste('R/DSE_ABIDE_',as.character(input$PCP),'.mat',sep = ''))$mS,digits=2);
      D=round(readMat(paste('R/DSE_ABIDE_',as.character(input$PCP),'.mat',sep = ''))$mD,digits=2);
    }
    nsub=dim(S)[1]
    xn=dim(S)[2]
    
    xtick<-list(); Dfilt<-list(); Sfilt<-list();
    for(i in 1:4){
      diffVar_tmp=abs(S[,i]-D[,i]);
      Idx_tmp=diffVar_tmp<=quantile(diffVar_tmp,input$PCPSB/100)
      
      set.seed(1);
      xtick_tmp  = rnorm(nsub,mean = 0,sd = 0.02)+i
      xtick[[i]] = xtick_tmp[Idx_tmp]
      
      Sfilt[[i]]=S[Idx_tmp,i]
      Dfilt[[i]]=D[Idx_tmp,i]
      
      rm(diffVar_tmp,Idx_tmp,xtick_tmp)
    }
    list("S"=Sfilt,
         "D"=Dfilt,
         "nsub"=nsub,
         "xtick"=xtick,
         "xn"=xn,
         "MSSDflag"=MSSDflag)
  })
  #--------------------------------------------------------------------
  
  output$PCPPlot <- renderPlot({
    PCPMeta=PCPMeta()

    D=PCPMeta$D;
    S=PCPMeta$S;
    
    xn=PCPMeta$xn;
    
    xcentres=as.vector(1:xn); 
    minPL=min(xcentres); maxPL=max(xcentres);
    
    mS=lapply(S,mean);
    mD=lapply(D,mean);
    
    Dcol=rgb(0, 0, 1, 0.5);
    Scol=rgb(1, 0, 0, 0.5);
    
    if(PCPMeta$MSSDflag){
      YlimTmp=c(20,80) 
      RefLine=c(50,50)} 
    else {
      YlimTmp=c(-.01,12) 
      RefLine=c(0,0)}
    
    for(i in 1:4){
      par(new=TRUE)
      plot(PCPMeta$xtick[[i]],D[[i]],col=Dcol,xlim = c(minPL,maxPL),ylim = YlimTmp ,ann=FALSE, xaxt='n',pch=16,cex=1)
      
      par(new=TRUE)
      plot(PCPMeta$xtick[[i]],S[[i]],col=Scol,xlim = c(minPL,maxPL),ylim = YlimTmp,ann=FALSE, xaxt='n',pch=16,cex=1)
    }
    par(new=TRUE)
    plot( xcentres,mS,col = 'black', pch=4,ylim = YlimTmp,ann=FALSE, xaxt='n',cex=1.2)
    lines(xcentres,mS,col = Scol,  lty=4)
    
    par(new=TRUE)
    plot( xcentres,mD,col = 'black',pch=4,ylim = YlimTmp,ann=FALSE, xaxt='n',cex=1.2)
    lines(xcentres,mD,col = Dcol,  lty=4)
    
    par(new=TRUE)
    grid(nx = 10, ny = 10, col = "lightgray", lty = "dotted")
    axis(1,at = xcentres,labels = c('ccs','cpac','niak','dparsf'),ylim = YlimTmp,xlab = 'Pipileline',ylab = '%A-var')
    
    par(new=TRUE)
    plot(c(minPL-.5,maxPL+.5),RefLine,type = "l",xaxt='n',yaxt='n',ylim = YlimTmp,xlab = 'Pipileline',ylab = '%A-var')
    legend("topright",'groups',legend = c('%S-var','%D-var'),pch = c(16,16),col =c('red','blue'),cex=0.8)
  })
  #--------------------------------------------------------------------
  output$out2 <- renderText({
    PCPMeta=PCPMeta()
    PCP_Into_texts=paste(input$PCP,' # of Subjects: ', PCPMeta$nsub,sep = '')
    PCP_Into_texts},quoted = FALSE)
  #--------------------------------------------------------------------
#  output$DPCPSum <- renderPrint({
#    PCPMeta=PCPMeta()
#    summary(PCPMeta$D)
#  })
#  output$SPCPSum <- renderPrint({
#    PCPMeta=PCPMeta()
#    summary(PCPMeta$S)
#  })
}
