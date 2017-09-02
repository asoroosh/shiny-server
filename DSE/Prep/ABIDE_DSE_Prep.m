clear

PipeList={'ccs','cpac','niak','dparsf'};
load(['/Users/sorooshafyouni/Home/PCP/FileID/S/PCP_FileID.mat']);

st_cnt=1;
for st=Site_ids'
    pl_cnt=1;
    for pl=PipeList
        fileid=cont_file_id{st_cnt};
        for s=1:Sites_nsub(st_cnt)
            load(['/Users/sorooshafyouni/Home/PCP/DSE/R/R_' st{1} '_' pl{1} '/DSE_' fileid{s} '_' pl{1} '.mat'],'DSEstat','V')
%------------------------------------------------------------------
            pD(s,pl_cnt)=DSEstat.Prntg(2);
            pS(s,pl_cnt)=DSEstat.Prntg(3);
            pE(s,pl_cnt)=DSEstat.Prntg(4);
            
            pgD(s,pl_cnt)=DSEstat.Prntg(6);
            pgS(s,pl_cnt)=DSEstat.Prntg(7);
            pgE(s,pl_cnt)=DSEstat.Prntg(8);

%------------------------------------------------------------------
            mD(s,pl_cnt)=sqrt(mean(V.Dvar_ts));
            mS(s,pl_cnt)=sqrt(mean(V.Svar_ts));
            mE(s,pl_cnt)=sqrt(mean(V.Evar_ts));
            
            mgD(s,pl_cnt)=sqrt(mean(V.g_Dvar_ts));
            mgS(s,pl_cnt)=sqrt(mean(V.g_Svar_ts));
            mgE(s,pl_cnt)=sqrt(mean(V.g_Evar_ts));
%------------------------------------------------------------------  
        end
        pl_cnt=pl_cnt+1;
    end
    save(['/Users/sorooshafyouni/Home/GitClone/shiny-server/DSE/R/DSE_ABIDE_' st{1} '.mat'],...
    'pD' ,'pS' ,'pE',...
    'pgD','pgS','pgE',...
    'mD' ,'mS' ,'mE',...
    'mgD','mgS','mgE',...
        'cont_file_id','Site_ids','Sites_nsub')
    st_cnt=st_cnt+1;
    
    clear S D
end