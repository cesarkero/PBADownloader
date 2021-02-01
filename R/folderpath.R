#' folderpath
#'
#' @export folderpath
#'
#' @param path text dir
#'
#' @description Accesory function to the the path of a folder or file
#'
#' @return path of a folder or file
#'
#' @examples
#' \dontrun{
#' folderpath('./dir1/dir2/')
#' > './dir1/'
#' }
folderpath <- function(path){
        x <- setdiff(strsplit(path,"/|\\\\")[[1]], "")
        subpath <- paste0('/',paste(x[-length(x)], collapse = "/"),"/")
        return(subpath)
}
