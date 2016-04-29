#' Deploys a service
#'

deploy <- function(service, dir = tempdir()){
  # create directories
  r_path = paste(dir, "R", sep="/")
  python_path = paste(dir, "python", sep="/")
  log_path = paste(dir, "log", sep="/")

  r = map(c(r_path, python_path, log_path),
      check_and_create)
  if(!all(r)) stop("Cound not create all directories")

  # copy necessary files
  save(service, file=paste(r_path, "service.Rdata", sep="/"))
  file.copy("deployr.py", python_path)


  # start server
  system(paste("python", py_path))

}

check_and_create <- function(dir){
  if(!dir.exists(dir)) dir.create(dir)
  return(dir.exists(dir))
}
