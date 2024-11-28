library(FELLA)
library(org.Mm.eg.db)
library(KEGGREST)

library(igraph)
library(magrittr)

set.seed(1)

dyn.load(paste("RPluMA", .Platform$dynlib.ext, sep=""))
source("RPluMA.R")
source("RIO.R")

input <- function(inputfile) {
  parameters <<- read.table(inputfile, as.is=T);
  rownames(parameters) <<- parameters[,1];
    pfix = prefix()
  if (length(pfix) != 0) {
     pfix <- paste(pfix, "/", sep="")
  }

# Filter overview pathways
my_graph <<- buildGraphFromKEGGREST(
    organism = parameters["organism", 2],
    filter.path = readSequential(paste(pfix,parameters["pathways", 2], sep="/"))
)
}

run <- function() {}

output <- function(outputfile) {

tmpdir <- paste0(outputfile)
# Mke sure the database does not exist from a former vignette build
# Otherwise the vignette will rise an error
# because FELLA will not overwrite an existing database
#unlink(tmpdir, recursive = TRUE)
buildDataFromGraph(
    keggdata.graph = my_graph,
    databaseDir = tmpdir,
    internalDir = FALSE,
    matrices = "none",
    normality = "diffusion",
    niter = 100)
}
