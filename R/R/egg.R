#' Create a custom endpoint
#'
#' This creates an API endpoint. Model specific preprocessing and postprocessing
#' are added for several model types
#'
#' @export
#'

egg <- function(model,
                predict = NULL,
                ...){

  if(any(class(model) == "glm")){
    glm_egg(model, predict, ...)
  } else if(any(class(model) == "lm")){
    lm_egg(model, predict, ...)
  } else{
    warning("Model type not recognized. Defaulting to custom endpoint")
    custom_endpoint(model, predict, ...)
  }

}

#' Predict
#'
#' Predict from an egg
#'
#' @param endpoint An endpoint object
#' @param newdata A JSON object for input
#'
#' @export

predict_egg <- function(egg,
                        newdata = NULL){

  predict = egg$predict
  input_schema = egg$input_schema
  output_schema = egg$output_schema

  if(is.character(newdata)){
    newdata = fromJSON(newdata) %>%
      as.list %>%
      as.data.frame
  }

  newdata = coerce_schema(input_schema, newdata)

  # log newdata into database

  df = predict(newdata) %>%
    coerce_schema(output_schema)

  # log df into database

  # some formatting for the JSON

  p = df[,1]

  predictions = if(ncol(df) > 1){
    transpose(df[,2:ncol(df)]) %>%
      list(info = ., prediction = p) %>%
      transpose
  } else map(p, function(x) list(prediction=x))

  toJSON(predictions)

}

#'Returns a summary of the model
#'
#'This function returns the summary of the mode
#'for an endpoint as a character. Useful for the
#'webapp and displaying output
#'
#'@export

model_summary <- function(egg){
  pasteN = function(...) paste(..., sep="\n")

  x = egg$model %>%
    summary %>%
    print %>%
    capture.output

  do.call(pasteN, as.list(x))
}
