#' cleanfields
#'
#' @export cleanfields
#'
#' @param sflayer sf object
#'
#' @description This cleans some text fields where special characters like ends of line.
#' This is accesory function for PBADownloader
#'
#' @return it returns the same layer with the corrections over the special characters
#'
#' @examples
#' \dontrun{
#' x <- st_read(sflayer)
#' cleanlayer <- cleanfields(x)
#' }
cleanfields <- function(sflayer){
        x <- sflayer
        for(col in 1:(ncol(x)-1)){
                name <- names(x)[[col]]
                # str_replace_all(ls[[3]], ".","") #find special characters
                x[,col] <- str_replace_all(x[[name]], "[\r\n]", '') #change \r\n
                x[,col] <- str_replace_all(x[[name]], "[\n]", '') #change \n
        }
        return(x)
}
