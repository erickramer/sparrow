parse_json <- function(json, collapsed=T){
  res = fromJSON(json)

  if(collapsed){
    as.data.frame(res)
  } else {
    bind_rows(res)
  }
}
