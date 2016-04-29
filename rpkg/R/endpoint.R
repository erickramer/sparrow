#' Create a custom endpoint
#'
#' This creates an API endpoint. Model specific preprocessing and postprocessing
#' are added for several model types
#'
#' @export
#'
endpoint <- function(model,
                     preprocess = NULL,
                     predict = NULL,
                     postprocess = NULL){

  if(any(class(model) == "glm")){
    glm_endpoint(model, preprocess, predict, postprocess)
  } else if(any(class(model) == "lm")){
    lm_endpoint(model, preprocess, predict, postprocess)
  } else{
    warning("Model type not recognized. Defaulting to custom endpoint")
    custom_endpoint(model, preprocess, predict, postprocess)
  }

}


#' Predict
#'
#' Predict from an endpoint
#'
#' @export

predict.endpoint <- function(endpoint,
                             json = NULL){

  json_error <- function(when, res){
    toJSON(paste("Error when", when,
            "\n",
            res$error))
  }

  # create wrappers for all functions
  parse_json_safe = safely(parse_json)

  preprocess_safe = if(is.null(endpoint$preprocess)) NULL else
    safely(endpoint$preprocess)

  predict_safe = safely(endpoint$predict)

  postprocess_safe = if(is.null(endpoint$postprocess)) NULL else
    safely(endpoint$postprocess)

  # parse input JSON
  res_parse = parse_json_safe(json)

  if(!is.null(res_parse$error)){
    return(json_error("parsing input", res_parse))
  } else{
    df = res_parse$result

    # preprocess
    if(!is.null(endpoint$preprocess)){
      res_pre = preprocess_safely(df)

      if(is.null(res_pres$result)){
        return(json_error("preprocssing data.frame", res_pre))
      }

      df = res_pre$result
    }

    # make predictions
    res_predict = predict_safe(endpoint$model, df)

    if(!is.null(res_predict$error)){
      return(json_error("making predictions", res_predict))
    }

    predictions = res_predict$result

    # postprocess
    if(!is.null(endpoint$postprocess)){
      res_post = postprocess_safe(predictions)

      if(!is.null(res_post$error)){
        return(json_error("postprocessing predictions", res_post))
      }

      predictions = res_post$result
    }

    # return results
    res_final = list(
      metadata = "No metadata yet!",
      results = toJSON(predictions)
    )
    return(toJSON(res_final))

  }

}
