#' Write object and capture file information
#' @param file.name file to write to the source "Result" directory
#' @param description describes object to write
#' @param write.fcn function for writing file of object type. Will open graphics device.
#' @param date logical for adding date to filename
#' @param ... arguments passed to write.fcn
#' @return File information list 
#' @export
#' @examples 
#'\dontrun{
#'  # Within adapr R Script body:
#'  Graph("hist.pdf","Gaussian RV")
#'  hist(rnorm(100))
#'  dev.off()
#'} 
Graph <- function(file.name="data.csv",description="Result file",write.fcn=guessWriteFcn(file.name),date=FALSE,...){
  
  # lightweight Write.cap take small number of args
  # used file.name and description create file.information
  
  obj <- NULL
  source_info <- getSourceInfo()
  
  if(date){
    
    prefix <- gsub("\\..*","",file.name)
    suffix <- gsub(".*\\.","\\.",file.name)
    
    datestring <- gsub("\\-","_",Sys.Date())
    
    file.name <- paste0(prefix,"_",datestring,suffix)
    
    file.name <- gsub(" ","_",file.name)
    
  }
  
  
  if(dirname(file.name)!="."){
    outpath <- file.path(getSourceInfo()$results.dir,dirname(file.name))
    
  }else{outpath <- source_info$results.dir}
  
  
  outfile <- basename(file.name)
  
  file.info <- createFileInfo(outpath,outfile,description)
  
  write.obj <-Write.cap(obj,file.info,write.fcn,getSourceInfo(),...)
  
  return(file.info)
  
}
