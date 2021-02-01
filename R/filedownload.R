#' filedownload
#'
#' @export filedownload
#'
#' @param url url of the file (currently a .zip)
#' @param filename name of the downloaded file
#'
#' @description This is an accesory function that catch error when downloading zip files
#' It is OS dependent, using "curl" in Linux and "auto" in Windows.
#'
#' @return it returns the error or warning in case it has been producen.
#' Otherwise it just download the file into the desired filename directory
#'
#' @examples
#' \dontrun{
#' # Download zip with municipality concello (in case it does not exist)
#' tempzip <- paste0(temp, concello, '.zip')
#' if(!file.exists(tempzip)){
#'                 getzip <- filedownload(URLencode(ziplink), tempzip)
#'                 } else {
#'                         cat("Not downloading PBA --> ", concello, "--> already exists")
#'                         }
#' }
filedownload <- function(url, filename) {
        # set method based on OS
        method <- ifelse(Sys.info()[[1]] == "Windows", "auto","curl")
        out <- tryCatch(
                expr = {
                        message("Downloading: ", url)
                        download.file(URLencode(url), filename, method)
                },
                error=function(cond1) {
                        message(paste("Download problem...", url))
                        message("Here's the original error message:")
                        message(cond1)
                        return(cond1)
                },
                warning=function(cond2) {
                        message(paste("URL caused a warning:", url))
                        message("Here's the original warning message:")
                        message(cond2)
                        return(cond2)
                },
                finally={
                        # message(paste("Downloaded URL:", url))
                }
        )
        return(out)
}
