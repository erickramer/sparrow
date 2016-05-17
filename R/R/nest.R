#' Create a new service
#'
#' @param name A character. The name of the service
#' @param rport An integer. The port for the R server
#' @param rurl A character. The URL for the Rserve server
#' @param pyport An interger. The port for the Flask server
#'
#' @export

nest <- function(name = NULL, ...){

  n = list(name = as.character(name),
           eggs = list())

  class(n) <- "nest"

  n = add_eggs(n, ...)

  return(n)
}


#' @export
print.nest <- function(s){
  cat(paste("Nest with", length(s[["eggs"]]), "eggs"))
  cat("\n")
}

#' Adds endpoints to a service
#'
#'@param ... named arguments for the endpoints
#'
#'@export

add_eggs <- function(s, ...){
  eggs = list(...)

  for(e_name in names(eggs)){
    s[["eggs"]][[e_name]] = eggs[[e_name]]
  }

  return(s)
}

#' @export
get_egg <- function(nest, egg_name){
  return(nest[["eggs"]][[egg_name]])
}

#' @export
list_eggs <- function(nest){
  names(nest[["eggs"]])
}

#' Package a service for deployment
#'
#' This function will package a service for deployment
#'
#'@param A character. The file to save the
#'@export

bundle <- function(nest, file = stop('file must be specified')){
  save(nest, file=file)
  nest
}
