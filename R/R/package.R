#' Bundle a service
#'
#' Bundles a service for deployment
#'
#' @export

package <- function(service, description = tempfile()){
  save(service, file = description)
  service
}
