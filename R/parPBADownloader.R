#' parPBADownloader
#'
#' @export parPBADownloader
#'
#' @param concellos Municipality name based on the pbaurls (availables in data)
#' @param outdir directory where file structure of downloads and products will be created
#' @param ncores number of cores used for the process
#'
#' @description función to do the same as PBADownloader in parallel
#' (careful with restrictions...max 5-6 simultaneous downloads)
#' OS independent function (written just for windows and linux)
#'
#' @return it returns nothing but the download and folder structure.
#'
#' @examples
#' \dontrun{
#' # PARAMETERS
#' data("pbaurls")
#' outdir <- '../02_OUTPUT/'
#'
#' pbaurls$Concello # show municipalities available
#' concellos <- c("Paderne", "Pol","A Peroxa", "Sarria")
#' parPBADownloader(concellos, outdir, ncores = 5)
#'
#' # DOWNLOAD ALL IN PARALLEL
#' concellos <- pbaurls$Concello
#' parPBADownloader(concellos, outdir, ncores = 6)
#' }
parPBADownloader <- function(concellos, outdir, ncores=5){
        # set max cores, meaning max simulataneus downloads too
        maxload <- ifelse(ncores>=5, 5, ncores)
        if (Sys.info()[[1]] == "Windows") {
                # Set parallel
                cl <- parallel::makeCluster(maxload, type="PSOCK")
                doParallel::registerDoParallel(cl)
                clusterEvalQ(cl, library("PBADownloader")) # load libraries
                clusterExport(cl, c('concellos', 'outdir', 'ncores'))
                # Execute function
                foreach(i=concellos) %dopar% {PBADownloader(i,outdir)}
                # Stop parallel
                stopCluster(cl)
        } else if (Sys.info()[[1]] == "Linux"){
                # Set parallel
                cl <- parallel::makeCluster(maxload, type="FORK")
                doParallel::registerDoParallel(cl)
                # Execute function
                foreach(i=concellos) %dopar% {PBADownloader(i,outdir)}
                # Stop parallel
                stopCluster(cl)
        } else {
                return ("Unknown OS system")
        }
}
