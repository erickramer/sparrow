#' Create an endpoint from a \code{\link{lm}} object
#'
#' @param model A model object. The model from which to build the endpoint
#' @param predict A predict function. The function to use to predict from the model
#' @param ... additional arguments passed to predict
#' @export

lm_egg <- function(model, predict = NULL, ...){

  pred <- if(is.null(predict)){
    function(newdata){
      p = predict(model, newdata = newdata, ...)
      as.data.frame(p)
    }
  } else function(newdata) predict(...)

  # create schema for inputs of model
  terms = attr(model$terms, "term.labels")[attr(model$terms, "order") == 1]
  classes = attr(model$terms, "dataClasses")[terms]
  xlevels = model$xlevels[names(model$xlevels) %in% terms]
  input_schema = schema(classes, xlevels)

  # create schema for outputs of model
  output = pred()
  classes = map(output, class) %>% unlist

  xlevels = output %>%
    keep(is.factor) %>%
    map(levels)

  output_schema = schema(classes, xlevels)

  e = list(model = model,
           predict = pred,
           input_schema = input_schema,
           output_schema = output_schema)

  class(e) = c("lm_egg", "egg")

  return(e)
}
