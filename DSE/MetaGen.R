

Meta<-list('sites'=c('100Unrelated'), 
           'pplabels'=c('Unproc','MPP','FPP'))
save(Meta,file = 'Meta/HCP_Meta.Rdata')

rm(Meta)
Meta<-list('sites'=c('CALTECH','CMU','KKI','LEUVEN_1','LEUVEN_2',
                    'MAX_MUN','NYU','OHSU','OLIN','PITT','SBL',
                    'SDSU','STANFORD','TRINITY','UCLA_1','UCLA_2',
                    'UM_1','UM_2','USM','YALE'), 
           'pplabels'=c('ccs','cpac','niak','dparsf'))
save(Meta,file = 'Meta/ABIDE_Meta.Rdata')


