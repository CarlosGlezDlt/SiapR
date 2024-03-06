#' Cattle Data
#' @description Extract cattle data available in siap since 1980
#' @importFrom magrittr `%>%`
#' @return a df with all the cattle data available in siap since 1980
#' @export
#'
#' @examples
#' cattle_dataframe <- extract_g()
extract_g <-
function(){

  #Obtenemos los enlaces de descargas de las bases de ganaderia
  ref <- 'http://infosiap.siap.gob.mx/gobmx/'
  basesGanaderia <- rvest::read_html('http://infosiap.siap.gob.mx/gobmx/datosAbiertos_p.php')%>%
    rvest::html_elements('body > main > div > div.row.datos ul > li a')%>%
    rvest::html_attrs()%>%unlist() %>% unname() %>% paste0(ref,.)%>%
    rev(.)


  for (b in 1:length(basesGanaderia)) {
    if(b >= which(stringr::str_detect(basesGanaderia, '2006') == TRUE)){
      dfG <- data.table::fread(basesGanaderia[b], encoding = 'Latin-1')
      #dfG <- dfG %>% filter(Nomestado == 'Jalisco')
      dfG[,c(12,14,15)] <- lapply(dfG[,c(12,14,15)], stringr::str_replace_all, ',', '')
      dfG[,c(12,14,15)] <- lapply(dfG[,c(12,14,15)], as.numeric)
      if(b==which(stringr::str_detect(basesGanaderia, '2006') == TRUE)){
        # Find all unique column names from both data frames
        all_columns <- union(names(dfG), names(Ganaderia))
        # Add missing columns to each data frame
        dfG <- dfG %>%
          dplyr::select(all_of(all_columns)) %>%
          dplyr::bind_rows(setNames(rep(list(NA), length(all_columns) - ncol(dfG)), setdiff(all_columns, names(dfG))))
        # Now, perform the union all operation
        Ganaderia <- dplyr::bind_rows(dfG, Ganaderia)
      }else{
        Ganaderia <- dplyr::union_all(Ganaderia, dfG)
      }


    }else{
      dfG <- data.table::fread(basesGanaderia[b], encoding = 'Latin-1')
      #dfG <- dfG %>% filter(Nomestado == 'Jalisco')
      if(b == 1){
        Ganaderia <- dfG
      }else{
        Ganaderia <- dplyr::union_all(Ganaderia, dfG)
      }
    }

  }
  rm(dfG)

  return(Ganaderia)
}
