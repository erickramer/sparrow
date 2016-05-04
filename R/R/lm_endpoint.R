#' Create an endpoint from a \code{\link{lm}} object
#'
#' @param model A model object. The model from which to build the endpoint
#' @param predict A predict function. The function to use to predict from the model
#' @param ... additional arguments passed to predict
#' @export

lm_endpoint <- function(model, predict = NULL, ...){

  pred <- if(is.null(predict)){
    function(newdata){
      p = predict(model, newdata, ...)
      as.data.frame(p)
    }
  } else predict

  classes = attr(model$terms, "dataClasses")
  xlevels = model$xlevels

  e = list(model = model,
           predict = pred,
           classes = classes,
           xlevels = xlevels)

  class(e) = c("lm_endpoint", "endpoint")

  return(e)
}
