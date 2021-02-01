#' pbaurls
#'
#' @export pbaurls
#'
#' @param layer Concellos_IGN.shp from IET that serves as base for Concellos Names
#' @param attrname atrribute name used in the function to capture Concellos Names
#' @param mainurl base url where zips are stored
#' @param PBAprefix text piece that goes before Concello to construct the zip url
#'
#' @description function to create the fixed pbaurls (users don't have to use
#'  this unless they are aware of a change in the url composition of PBA or Concello change of name)
#'
#' @return data.frame with 2 fields Concello|URL . This gives the user the
#' list of all Concellos available (and the right way to write their names...)
#'
#' @examples
#' \dontrun{
#' # create pbaurls (a priori it shouldnt change...)
#' pbaurls <- pbaurls() # create table
#' save(pbaurls, file = "./data/pbaurls.RData") # save table
#' }
pbaurls <- function(layer="./data/base/Concellos_IGN/Concellos_IGN.shp",
                    attrname="NomeMAY",
                    mainurl='visorgis.cmati.xunta.es/cdix/descargas/PlanBasicoAutonomico/2020/concellos_ZIPS/',
                    PBAprefix = 'PBA_2020_'){
        # read layer
        mun <- st_read(layer)

        # create a list of concellos well written
        mlist <- sort(str_to_title(mun[[attrname]]))
        mziplist <- paste0(str_replace_all(mlist," ","%20"), '.zip')

        # compose the url of download
        mainurl <- mainurl
        urls <- paste0(mainurl, PBAprefix, mziplist)

        # create a data frame with mlist and urls
        pbaurls <- tibble(Concello = mlist, URL = urls)

        return(pbaurls)
}
