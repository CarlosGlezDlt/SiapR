#' Agricultural Data
#' @description Extract agricultural data available in siap since 1980
#' @return a df with all the agricultural data available in siap since 1980
#' @export
#'
#' @examples
#' agricultural_dataframe <- extract_a()
extract_a <-
function(){
  #Obtenemos los enlaces de descargas de las bases de Agricultura
  ref <- 'http://infosiap.siap.gob.mx/gobmx/'
  basesAgricultura <- rvest::read_html('http://infosiap.siap.gob.mx/gobmx/datosAbiertos_a.php')%>%
    rvest::html_elements('body > main > div > div.row.datos ul > li a')%>%
    rvest::html_attrs()%>%unlist() %>% unname() %>% paste0(ref,.)%>%
    rev(.)

  basesAgricultura <- basesAgricultura[stringr::str_detect(basesAgricultura, 'no_seguimiento') == FALSE]


  for (b in 1:length(basesAgricultura)) {
    if(b >= which(stringr::str_detect(basesAgricultura, '2003') == TRUE)){
      dfG <- data.table::fread(basesAgricultura[b], encoding = 'Latin-1')
      if(any(stringr::str_detect(names(dfG), "Nomcultivo Sin Um"))){
        names(dfG)[stringr::str_detect(names(dfG), "Nomcultivo Sin Um")] <- "Nomcultivo"
      }
      if(any(stringr::str_detect(names(dfG), "Preciomediorural"))){
        names(dfG)[stringr::str_detect(names(dfG), "Preciomediorural")] <- "Precio"
      }
      #dfG <- dfG %>% filter(Nomestado == 'Jalisco')
      dfG[,c(18,21,22)] <- lapply(dfG[,c(18,21,22)], stringr::str_replace_all, ',', '')
      dfG[,c(18,21,22)] <- lapply(dfG[,c(18,21,22)], as.numeric)
      if(b==which(stringr::str_detect(basesAgricultura, '2003') == TRUE)){
        # Find all unique column names from both data frames
        all_columns <- union(names(dfG), names(Agricultura))
        # Add missing columns to each data frame
        dfG <- dfG %>%
          dplyr::select(all_of(all_columns)) %>%
          dplyr::bind_rows(setNames(rep(list(NA), length(all_columns) - ncol(dfG)), setdiff(all_columns, names(dfG))))
        # Now, perform the union all operation
        Agricultura <- dplyr::bind_rows(dfG, Agricultura)
      }else{
        Agricultura <- dplyr::union_all(Agricultura, dfG)
      }


    }else{
      dfG <- data.table::fread(basesAgricultura[b], encoding = 'Latin-1')
      if(b == which(stringr::str_detect(basesAgricultura, '2001') == TRUE)){
        dfG <- dplyr::select(dfG, -c(V19))
      }

      #dfG <- dfG %>% filter(Nomestado == 'Jalisco')
      if(b == 1){
        Agricultura <- dfG
      }else{
        Agricultura <- dplyr::union_all(Agricultura, dfG)
      }
    }

  }
  rm(dfG)
  return(Agricultura)
}
