#' PBADownloader
#'
#' @export PBADownloader
#'
#' @param concello Municipality name based on the pbaurls (availables in data)
#' @param outdir directory where file structure of downloads and products will be created
#'
#' @description this is the main function of the package. It downloads the .zip file for a Municipality (concello)
#' and extracts from it the vectorial information to stored into a single .gpkg file.
#' This are the particularities:
#' Temporal data of extractions will be remove.
#' Original .zip file will be kept in folder. This serves as security copy and avoid recurrent downloads.
#'
#' @return it returns nothing but the download and folder structure.
#'
#' @examples
#' \dontrun{
#' # PARAMETERS
#' # read data
#' data("pbaurls")
#' outdir <- '../02_OUTPUT/'
#'
#' # Single execution
#' PBADownloader("Beade", outdir)
#'
#' # Single execution in a serie of municipalities (on by one)
#' concellos <- c("Paderne", "Taboada", "Parada De Sil", "Vedra")
#'
#' lapply(concellos, PBADownloader, outdir)
#'
#' # Download all
#' concellos <- pbaurls$Concello
#' lapply(concellos, PBADownloader, outdir)
#' }
PBADownloader <- function(concello, outdir){

        # load data (just it case if was not loaded before)
        data("pbaurls")

        # get zipurl given a concello (catch in data --> pbaurls.RData)
        # find exact match only
        exactconcello <- paste0('\\<',concello,'$\\>')
        ziplink <- pbaurls$URL[which(grepl(exactconcello, pbaurls$Concello)==TRUE)]

        #---------------------------------------------------------------------------
        # set tempdir
        temp = paste0(outdir,concello,'/')
        ifelse(!dir.exists(temp),dir.create(temp),NA)
        #---------------------------------------------------------------------------
        # Download zip with municipality concello (in case it does not exist)
        tempzip <- paste0(temp, concello, '.zip')
        if(!file.exists(tempzip)){
                message("Downloading PBA --> ", concello, "\n")
                getzip <- filedownload(URLencode(ziplink), tempzip)
        } else {
                cat("Not downloading PBA --> ", concello, "--> already exists")
        }
        #---------------------------------------------------------------------------
        # find filename of vectorial data within the zip file
        ns <- unzip(tempzip, list=TRUE)$Name
        nsv <- ns[grepl('Vectorial',ns)]
        # extract just vectorial data
        vectorial <- utils::unzip(tempzip, exdir = gsub('.{1}$','',temp), nsv)
        #---------------------------------------------------------------------------
        # Extract Vectorial info
        # find filename within the temfile
        vs <- unzip(vectorial, list=TRUE)$Name

        # KEY PART --> EXTRACT SHP's AND CREATE A CONDENSED GPKG :-)
        # extract all within the same folder
        shp <- unzip(vectorial, exdir = gsub('.{1}$','',temp))

        # catch all .shp paths, get the filename and export into a gpkg package
        shpsel <- dir(temp, pattern = '.shp$', recursive = TRUE, full.names = TRUE)
        # names of the shapefiles
        shpname <- gsub('.{4}$', '', basename(shpsel))
        # categories of shps --> seems that all shp of PBA are stored in 16 categories
        shpcat <- basename(unlist(lapply(shpsel, folderpath)))
        # create the compose name with cat+name
        shpn <- paste0(shpcat, '_', shpname)

        # Save gpkg layers within the same gpkg file
        gpkgname <- paste0(gsub('.{1}$','',vs[[1]]), '.gpkg')

        # need this extra step or something within loop fails
        ls <- lapply(lapply(lapply(shpsel, st_read), st_zm), cleanfields)

        # Save all the layers within a .gpkg file
        for (i in 1:length(ls)){
                cat("Creating GPKG PBA --> ", concello, "\n")
                if (i == 1){
                        st_write(ls[[i]], paste0(temp, gpkgname), layer=shpn[[i]], append=FALSE)
                } else {
                        st_write(ls[[i]], paste0(temp, gpkgname), layer=shpn[[i]], append=TRUE)
                }
        }

        # Remove temporal data (extracted shps and .zip with vectorial)
        # --> KEEP ORIGINAL DOWNLOADED FILE
        unlink(paste0(temp,vs[[1]]), recursive = TRUE)
        unlink(vectorial)

        # 60 seconds wait (this avoids brakes in parallel function)
        cat("Waiting 60 sec --> This avoids unexpected brakes in functions")
        Sys.sleep(60)
}
