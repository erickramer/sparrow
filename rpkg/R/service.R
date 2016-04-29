#' Create a new service
#'
#' @param port An integer. The port for the new service
#'
#' @export

service <- function(port = 10000){

  s = list(port = port,
          endpoints = list())

  class(s) <- "service"

  return(s)
}

#' @export
print.service <- function(s){
  cat(paste("Service with", length(s[["endpoints"]]), "endpoints"))
  cat("\n")
  cat(paste("Port:", s[["port"]]))
}

#' Adds endpoints to a service
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
