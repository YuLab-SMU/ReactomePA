##' @importFrom utils packageDescription
.onAttach <- function(libname, pkgname) {
  pkgVersion <- packageDescription(pkgname, fields="Version")
  msg <- paste0(pkgname, " v", pkgVersion, "  ",
                "For help: https://guangchuangyu.github.io/", pkgname, "\n\n")

  citation <- paste0("If you use ", pkgname, " in published research, please cite:\n",
                     "Guangchuang Yu, Qing-Yu He. ",
                     "ReactomePA: an R/Bioconductor package for reactome pathway analysis and visualization. ",
                     "Molecular BioSystems 2016, 12(2):477-479")

  packageStartupMessage(paste0(msg, citation))

}
