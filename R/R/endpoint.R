#' Create a custom endpoint
#'
#' This creates an API endpoint. Model specific preprocessing and postprocessing
#' are added for several model types
#'
#' @export
#'
endpoint <- function(model,
                     predict = NULL,
                     ...){

  if(any(class(model) == "glm")){
    glm_endpoint(model, predict, ...)
  } else if(any(class(model) == "lm")){
    lm_endpoint(model, predict, ...)
  } else{
    warning("Model type not recognized. Defaulting to custom endpoint")
    custom_endpoint(model, preprocess, predict, postprocess)
  }

}


#' Predict
#'
#' Predict from an endpoint
#'
#' This assumes that the incoming data
#'
#' @param endpoint An endpoint object
#' @param newdata A JSON object for input
#'
#' @export

predict.endpoint <- function(endpoint,
                             newdata = NULL){

  if(is.character(newdata)){
    newdata = fromJSON(newdata) %>%
      as.list
  }

  newdata = schema_check(endpoint, newdata)

  df = endpoint$predict(newdata)

  # assume that the first column is the actual prediction
  # all other columns are stored in "info"

  p = df[,1]

  predictions = if(ncol(df) > 1){
    transpose(df[,2:ncol(df)]) %>%
      list(info = ., prediction = p) %>%
      transpose
  } else map(p, function(x) list(prediction=x))

  toJSON(predictions)

}

#'@export
schema_check <- function(endpoint, df){

  coercer <- function(name, x){
    if(endpoint$classes[name] == "numeric"){
      as.numeric(x)
    } else if(endpoint$classes[name] == "character"){
      as.character(x)
    } else if(endpoint$classes[name] == "factor"){
      factor(x, levels = endpoint$xlevels[[name]])
    }
  }

  # make sure all features are there
  needed_col_names = names(endpoint$classes)
  if(!all(needed_col_names %in% names(df))){
    stop("Missing features in input data")
  }

  # attempt feature coercion
  df_coerced = map2(names(df), df, coercer)
  names(df_coerced) = names(df)
  as_data_frame(df_coerced)
}
