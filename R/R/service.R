#' Create a new service
#'
#' @param name A character. The name of the service
#' @param rport An integer. The port for the R server
#' @param rurl A character. The URL for the Rserve server
#' @param pyport An interger. The port for the Flask server
#'
#' @export

service <- function(name = NULL,
                    rport = 6311,
                    rurl = "localhost",
                    pyport = 5000){

  s = list(name = as.character(name),
           rport = as.integer(rport),
           rurl = as.character(rurl),
           pyport = as.integer(pyport))

  class(s) <- "service"

  return(s)
}


#' @export
print.service <- function(s){
  cat(paste("Service with", length(s[["endpoints"]]), "endpoints"))
  cat("\n")
  cat(paste("rport:", s[["rport"]]))
  cat("\n")
  cat(paste("rurl:", s[["rurl"]]))
  cat("\n")
  cat(paste("pyport:", s[["pyport"]]))
}

#' Adds endpoints to a service
#'
#'@param ... named arguments for the endpoints
#'
#'@export

add_endpoints <- function(s, ...){
  endpoints = list(...)

  for(e_name in names(endpoints)){
    s[["endpoints"]][[e_name]] = endpoints[[e_name]]
  }

  return(s)
}

#' @export
get_endpoint <- function(service, name){
  return(service[["endpoints"]][[name]])
}

#' @export
list_endpoints <- function(service){
  names(service[["endpoints"]])
}

#' Package a service for deployment
#'
#' This function will package a service for deployment
#'
#'@param A character. The file to save the
#'@export

package <- function(service, file = stop('file must be specified')){
  save(service, file=file)
}
