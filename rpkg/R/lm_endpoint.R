#' Create an endpoint from a \code{\link{lm}} object
#'
#' @export

lm_endpoint <- function(model,
                        preprocess,
                        predict,
                        postprocess){

  if(is.null(predict)){
    predict = lm_predict
  }

  if(is.null(postprocess)){
    postprocess = lm_postprocess
  }

  e = list(model = model,
           preprocess = preprocess,
           predict = predict,
           postprocess = postprocess)

  class(e) = c("lm_endpoint", "endpoint")

  return(e)
}

lm_postprocess <- function(x){
  as.data.frame(x)
}

lm_predict <- function(...){
  predict(..., interval="confidence")
}
