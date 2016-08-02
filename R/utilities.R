##' mapping organism name to annotationDb package name
##'
##'
##' @title getDb
##' @param organism one of supported organism
##' @return annotationDb name
##' @author Yu Guangchuang
getDb <- function(organism) {
    if (organism == "worm") {
        organism = "celegans"
        warning("'worm' is deprecated, please use 'celegans' instead...")
    }
    
    annoDb <- switch(organism,
                     anopheles   = "org.Ag.eg.db",
                     arabidopsis = "org.At.tair.db",
                     bovine      = "org.Bt.eg.db",
                     canine      = "org.Cf.eg.db",
                     celegans    = "org.Ce.eg.db",
                     chicken     = "org.Gg.eg.db",
                     chimp       = "org.Pt.eg.db",
                     coelicolor  = "org.Sco.eg.db", 
                     ecolik12    = "org.EcK12.eg.db",
                     ecsakai     = "org.EcSakai.eg.db",
                     fly         = "org.Dm.eg.db",
                     gondii      = "org.Tgondii.eg.db",
                     human       = "org.Hs.eg.db",
                     malaria     = "org.Pf.plasmo.db",
                     mouse       = "org.Mm.eg.db",
                     pig         = "org.Ss.eg.db",
                     rat         = "org.Rn.eg.db",
                     rhesus      = "org.Mmu.eg.db",
                     xenopus     = "org.Xl.eg.db",
                     yeast       = "org.Sc.sgd.db",
                     zebrafish   = "org.Dr.eg.db",
                     )
    return(annoDb)
}

enricher_internal <- DOSE:::enricher_internal
GSEA_internal <- DOSE:::GSEA_internal
