library(R.matlab)
server<-function(input, output, session) {
  
  HCPMeta <- reactive({
    S=round(readMat(paste('R/DSE_',as.character(input$HCP),'_FPP.mat',sep = ''))$S,digits=2);
    D=round(readMat(paste('R/DSE_',as.character(input$HCP),'_FPP.mat',sep = ''))$D,digits=2);
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
    S=round(readMat(paste('R/DSE_FPP_',as.character(input$PCP),'.mat',sep = ''))$S,digits=2);
    D=round(readMat(paste('R/DSE_FPP_',as.character(input$PCP),'.mat',sep = ''))$D,digits=2);
    nsub=dim(S)[1]
    
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
    PL=c(1,2,3,4);
    list("S"=Sfilt,
         "D"=Dfilt,
         "nsub"=nsub,
         "xtick"=xtick,
         "xcentre"=PL)
  })
  #--------------------------------------------------------------------
  
  output$PCPPlot <- renderPlot({
    PCPMeta=PCPMeta()

    D=PCPMeta$D;
    S=PCPMeta$S;
    PL=PCPMeta$xcentre; minPL=min(PL); maxPL=max(PL);
    
    mS=lapply(S,mean);
    mD=lapply(D,mean);
    
    Dcol=rgb(0, 0, 1, 0.5);
    Scol=rgb(1, 0, 0, 0.5);
    YlimTmp=c(20,80)
    for(i in 1:4){
      #print(length(D[[i]]))
      #print(length(PCPMeta$xtick[[i]]))
      par(new=TRUE)
      #print(mean(PCPMeta$xtick[[i]]))
      plot(PCPMeta$xtick[[i]],D[[i]],col=Dcol,xlim = c(minPL,maxPL),ylim = YlimTmp ,ann=FALSE, xaxt='n',pch=16,cex=1)
      par(new=TRUE)
      plot(PCPMeta$xtick[[i]],S[[i]],col=Scol,xlim = c(minPL,maxPL),ylim = YlimTmp,ann=FALSE, xaxt='n',pch=16,cex=1)
    }
    par(new=TRUE)
    plot( PCPMeta$xcentre,mS,col = 'black', pch=4,ylim = YlimTmp,ann=FALSE, xaxt='n',cex=1.2)
    lines(PCPMeta$xcentre,mS,col = Scol,  lty=4)
    par(new=TRUE)
    plot( PCPMeta$xcentre,mD,col = 'black',pch=4,ylim = YlimTmp,ann=FALSE, xaxt='n',cex=1.2)
    lines(PCPMeta$xcentre,mD,col = Dcol,  lty=4)
    grid(nx = 10, ny = 10, col = "lightgray", lty = "dotted")
    axis(1,at = PCPMeta$xcentre,labels = c('ccs','cpac','niak','dparsf'),ylim = YlimTmp)
    par(new=TRUE)
    plot(c(minPL-.5,maxPL+.5),c(50,50),type = "l",xaxt='n',yaxt='n',xlab = 'Pipileline',ylab = '%A-var')
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
