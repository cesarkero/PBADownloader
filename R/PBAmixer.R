#' PBAmixer
#'
#' @export PBAmixer
#'
#' @param outdir directory where PBADownloader have created the structure (it should be the same outdir for both functions)
#'
#' @description Funcition to read the .gpkg files created and merge layers into a superior file
#'
#' @return Funcition to read the .gpkg files created and merge layers into a superior file
#'
#' @examples
#' \dontrun{
#' # PARAMETERS
#' data("pbaurls")
#' outdir <- '../02_OUTPUT/'
#' PBAmixer(outdir)
#' }
PBAmixer <- function(outdir){
        # list .gpkg files within the directory (created by PBADownloader|parPBADownloader)
        x <- list.files(outdir, pattern=".gpkg", full.names=T, recursive = T)
        # Save gpkg layers within the same gpkg file
        gpkgname <- paste0(outdir, 'PBA.gpkg')
        # Save all the layers within a .gpkg file
        for (i in 1:length(x)){
                layers <- ogrListLayers(x[[i]])
                for(l in 1:length(layers)){
                        message("GPKG ",i, " layer ", l)
                        lname <- layers[[l]]
                        layer <- st_read(x[[i]], layer = lname)
                        if (i == 1){
                                message("Creating GPKG PBA: ", lname, "\n")
                                st_write(layer, gpkgname, layer=lname, append=FALSE)
                        } else {
                                message("Adding GPKG PBA: ", lname, "\n")
                                st_write(layer, gpkgname, layer=lname, append=TRUE)
                        }
                }
        }
}
