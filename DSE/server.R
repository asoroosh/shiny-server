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
    Idx=diffVar<=quantile(abs(S-D),input$HCPSB/100)
    
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
  output$out3 <- renderPlot({
    HCPMeta=HCPMeta()
    
    Dcol=rgb(1, 0, 0, 0.5);
    Scol=rgb(0, 0, 1, 0.5);
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
  output$out1 <- renderPrint({
    HCPMeta=HCPMeta()
    HCP_Into_texts=paste(input$HCP,' # of Subjects: ', HCPMeta$nsub,sep = '')
    HCP_Into_texts},quoted = FALSE)
  #--------------------------------------------------------------------
  output$DHCPSum <- renderPrint({
    HCPMeta=HCPMeta()
    summary(HCPMeta$D)
  })
  output$SHCPSum <- renderPrint({
    HCPMeta=HCPMeta()
    summary(HCPMeta$S)
  })
  #----------------------------------------------------------------------------------------------------------------------------------------
  #----------------------------------------------------------------------------------------------------------------------------------------
  #----------------------------------------------------------------------------------------------------------------------------------------
  
  PCPMeta <- reactive({
    S=round(readMat(paste('R/DSE_FPP_',as.character(input$PCP),'.mat',sep = ''))$S,digits=2);
    D=round(readMat(paste('R/DSE_FPP_',as.character(input$PCP),'.mat',sep = ''))$D,digits=2);
    nsub=dim(S)[1]
    
    set.seed(1);
    xtick=rnorm(nsub,mean = 3,sd = 0.02)

    S = S[,1]
    D = D[,1]
        
    diffVar=abs(S-D);
    Idx=diffVar<=quantile(abs(S-D),input$PCPSB/100)

    xtick=xtick[Idx]
    S=S[Idx]
    D=D[Idx]
    
    list("S"=S,
         "D"=D,
         "nsub"=nsub,
         "xtick"=xtick,
         "xcentre"=3)
  })
  #--------------------------------------------------------------------
  
  output$out4 <- renderPlot({
    PCPMeta=PCPMeta()
        
    PL=PCPMeta$xcentre; minPL=min(PL); maxPL=max(PL);
    D=PCPMeta$D;
    S=PCPMeta$S;
    
    Dcol=rgb(1, 0, 0, 0.5);
    Scol=rgb(0, 0, 1, 0.5);
    YlimTmp=c(20,80)
    
    plot(PCPMeta$xtick,D,col=Dcol,xlim = c(minPL-.5,maxPL+.5),ylim = YlimTmp ,ann=FALSE, xaxt='n',pch=16,cex=1)
    par(new=TRUE)
    plot(PCPMeta$xtick,S,col=Scol,xlim = c(minPL-.5,maxPL+.5),ylim = YlimTmp,ann=FALSE, xaxt='n',pch=16,cex=1)
    grid(nx = 10, ny = 10, col = "lightgray", lty = "dotted")
    par(new=TRUE)
    plot(c(PCPMeta$xcentre-.5,PCPMeta$xcentre+.5),c(50,50),type = "l",xaxt='n',yaxt='n',xlab = 'Processing Level',ylab = '%A-var')
    axis(1,at = PCPMeta$xcentre,labels = ('FPP'),xlim = c(minPL-.5,maxPL+.5),ylim = YlimTmp)
  })
  #--------------------------------------------------------------------
  output$out2 <- renderText({
    PCPMeta=PCPMeta()
    PCP_Into_texts=paste(input$PCP,' # of Subjects: ', PCPMeta$nsub,sep = '')
    PCP_Into_texts},quoted = FALSE)
  #--------------------------------------------------------------------
  output$DPCPSum <- renderPrint({
    PCPMeta=PCPMeta()
    summary(PCPMeta$D)
  })
  output$SPCPSum <- renderPrint({
    PCPMeta=PCPMeta()
    summary(PCPMeta$S)
  })
}
