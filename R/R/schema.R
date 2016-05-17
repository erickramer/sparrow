schema <- function(classes, xlevels){

  if(!all(names(xlevels) %in% names(classes))){
    stop("Mismatch between xlevels and classes")
  }

  s = list(classes = classes, xlevels = xlevels)
  class(schema) = "schema"
  return(s)
}

coerce_schema <- function(schema, df){


  coerce <- function(name, x){
    if(classes[name] == "factor"){
      factor(x, levels=xlevels[[name]])
    } else{
      f = switch(classes[name],
                 numeric = as.numeric,
                 integer = as.integer,
                 character = as.character,
                 as.numeric)

      f(x)
    }
  }

  classes = schema$classes
  xlevels = schema$xlevels
  vars = names(classes)

  df_coerced = df %>%
    select(one_of(vars)) %>%
    map2(names(.), ., coerce)

  names(df_coerced) = vars

  df_coerced = df_coerced %>%
    as.data.frame

  return(df_coerced)
}
