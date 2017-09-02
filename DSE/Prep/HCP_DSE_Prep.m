clear; close all;

Site={'HCP'};

PPLine={''};

addpath /Users/sorooshafyouni/Home/GitClone/DVARS/

ModeList={'Unproc','PreFix','PostFix'};

load(['/Users/sorooshafyouni/Home/DVARS/fMRIDiag/HCP/QC-FC/PowerAtlas/HCP_100Unrel_SubList.mat'])
SubList=HCP_10Unrel_SubList;
%------------------------------------------------------------------
GSRStat={'noglobal'}; %%BE CAREFULLLLL****************

pl=15;
lw=2;
lfs=14;

m_cnt = 1;
for m = ModeList
    s_cnt = 1;
    for s=SubList
            load(['/Users/sorooshafyouni/Home/DVARS/fMRIDiag/HCP/DSE/R/' m{1} '/HCP_DSE_' m{1} '_' s{1} '_' GSRStat{1} '.mat'],'DSE_Stat','V')
%------------------------------------------------------------------
            pD(s_cnt,m_cnt)=DSE_Stat.Prntg(2);
            pS(s_cnt,m_cnt)=DSE_Stat.Prntg(3);
            pE(s_cnt,m_cnt)=DSE_Stat.Prntg(4);
            
            pgD(s_cnt,m_cnt)=DSE_Stat.Prntg(6);
            pgS(s_cnt,m_cnt)=DSE_Stat.Prntg(7);
            pgE(s_cnt,m_cnt)=DSE_Stat.Prntg(8);

%------------------------------------------------------------------
            mD(s_cnt,m_cnt)=sqrt(mean(V.Dvar_ts));
            mS(s_cnt,m_cnt)=sqrt(mean(V.Svar_ts));
            mE(s_cnt,m_cnt)=sqrt(mean(V.Evar_ts));
            
            mgD(s_cnt,m_cnt)=sqrt(mean(V.g_Dvar_ts));
            mgS(s_cnt,m_cnt)=sqrt(mean(V.g_Svar_ts));
            mgE(s_cnt,m_cnt)=sqrt(mean(V.g_Evar_ts));
%------------------------------------------------------------------            
            s_cnt = s_cnt + 1;
    end
        m_cnt = m_cnt+1;
end

save(['/Users/sorooshafyouni/Home/GitClone/shiny-server/DSE/R/DSE_HCP_100Unrelated.mat'],...
    'pD' ,'pS' ,'pE',...
    'pgD','pgS','pgE',...
    'mD' ,'mS' ,'mE',...
    'mgD','mgS','mgE',...
    'SubList')