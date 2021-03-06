#' Lists the branches available for loading in the adapr project
#' @param project.id project to find branches within
#' @return dataframe of descriptions available branches
#' @export
#' @examples 
#' \dontrun{
#' listBranches("adaprHome")
#'} 
#'
#' 
listBranches <- function(project.id=getProject()){
  
  file_data <- list(file=NULL)
  
  si <- pullSourceInfo(project.id)
  
  dependency.dir <- si$dependency.dir
  
  # Search for branches (intermediate results loaded by other R scripts)
  
  try({
    treedf <- readDependency(dependency.dir)
    not.this.source <- subset(treedf,(!is.na(dependency)))
    file_data$file<- condenseFileInfo(not.this.source)
  },silent=TRUE)
  
  if(length(file_data$file)==0){
    print("No available branch files")
    return(NULL)
  }
  
  file_sub  <- subset(file_data$file,grepl("(rda$)|(rdata$)",tolower(file_data$file$file)),select = c("file","path","description"))
  
  if(length(file_sub$file)==0){
    print("No available branches")
    return(NULL)
  }
  
  file_sub$path <- gsub(file.path(getProjectPath(),"Results/"),"",file_sub$path)
  return(file_sub)
  
}
list.branches <- listBranches
#' Lists the R scripts in the adapr project
#' @param  project.id project.id
#' @return dataframe of R scripts, descriptions, run time duration, last run/modification date, number of lines
#' @export
#' @examples 
#' \dontrun{
#' listScripts("adaprHome")
#'} 
#'
#'
listScripts <- function(project.id=getProject()){
  
  
  trees <- readDependency(file.path(getProjectPath(project.id),project.directory.tree$dependency.dir))
  
  programs <- subset(trees,!duplicated(file.path(trees$source.file.path,trees$source.file)),
                     select=c("source.file","source.file.description"))
  
  run.times <- plyr::ddply(trees, "source.file", 
                           function(x) {
                             last.run.time <- max(difftime(as.POSIXct(x$target.mod.time), 
                                                           as.POSIXct(x$source.run.time), units = "secs"), 
                                                  na.rm = TRUE)
                             n.lines <- length(readLines(file.path(x$source.file.path[1],x$source.file[1]),warn=FALSE))
                             mod.date <- as.Date(file.info(file.path(x$source.file.path[1],x$source.file[1]))$mtime)
                             run.date <- as.Date(x$source.run.time[1]) 
                             run.days.ago <- difftime(Sys.Date(),run.date,units="days")
                             
                             return(data.frame(n.lines=n.lines,last.run.time.sec = last.run.time,mod.date=mod.date,run.date=run.date,run.days.ago=run.days.ago))
                           })
  programs <- merge(programs, run.times, by = "source.file")
  
  return(programs)
  
}
#' Returns the information related to the adapr script
#' @return list with information about the project
#' @export
#' @examples 
#' \dontrun{
#' getSourceInfo()
#'} 
#'
getSourceInfo <- function(){
  
  return(options()$adaprScriptInfo)
  
  
}
#' Lists the data files available for reading in the adapr project
#' @param project.id Project to look for data files within
#' @return description of data files
#' @export
#' @examples 
#' \dontrun{
#' listDatafiles("adaprHome")
#'} 
#'
listDatafiles <- function(project.id=getProject()){
  
  
  si <- pullSourceInfo(project.id)
  
  si$data.dir <- file.path(si$project.path,project.directory.tree$data)
  allfiles <- data.frame(file=list.files(si$data.dir,recursive=TRUE,full.names = 1),stringsAsFactors = FALSE)
  
  allfiles$path <- dirname(substring(as.character(allfiles$file),nchar(si$project.path)+2,nchar(as.character(allfiles$file))))
  
  allfiles$file <- basename(allfiles$file)
  
  file_data <- list(file=NULL)
  
  dependency.dir <- si$dependency.dir
  
  try({
    treedf <- readDependency(dependency.dir)
    not.this.source <- subset(treedf,(!is.na(dependency)))
    file_data$file <- condenseFileInfo(not.this.source)
  },silent=TRUE)
  
  
  file_sub <- data.frame()
  try({
    file_sub <- subset(file_data$file,file_data$file$path==si$data.dir,select = c("file","path","description"))
  })
  
  if(is.null(file_sub)){
    return(allfiles)
  }
  
  
  if(nrow(file_sub)==0){
    
    return(allfiles)
    
  }
  
  file_sub$path <- gsub(".*/","",file_sub$path)
  
  allfiles <- merge(allfiles,file_sub,by=c("file","path"),all.x=TRUE)
  
  return(allfiles)
  
}
#' Opens results directory of project or R script within a project
#' @param project.id character string specifies project 
#' @param rscript character string specifies the R script result directory to open
#' @details Use BrowseURL to open results directory
#' @export
#' @examples 
#' \dontrun{
#' showResults("adaprHome")
#'} 
#'
showResults <- function(project.id=getProject(),rscript=getSourceInfo()$file$file){
  
  si <- pullSourceInfo(project.id)
  
  if(is.null(rscript)){
    utils::browseURL(file.path(getProjectPath(project.id),project.directory.tree$results))
  }else{
    resultdir <- file.path(getProjectPath(project.id),project.directory.tree$results,rscript)
    utils::browseURL(resultdir)
  }
}
#' Opens project directory
#' @param project.id character string specifies project to open
#' @details Use BrowseURL to open project directory.
#' @export
#' @examples 
#' \dontrun{
#' showProject("adaprHome")
#'} 
#'
 
showProject <- function(project.id =getProject()){
 
    utils::browseURL(getProjectPath(project.id))
}
#' Returns project's data directory, allows relative directories. Used within an R script.
#' @param project.id project specifies which data directory
#' @return path to data directory
#' @export
#' @examples 
#' \dontrun{
#' dataDir(getProject())
#'} 
dataDir <- function(project.id =getProject()){
  
  dataDir <- file.path(getProjectPath(project.id),project.directory.tree$data)
  
  return(dataDir)
  
}
#' Returns project's results directory, allows relative directories. Only used within an R script, after create_source_file_dir.
#' @param sourceInfo R source_info list created by create_source_file_dir
#' @return path to data directory
#' @export
#' @examples 
#' \dontrun{
#' resultsDir(getSourceInfo())
#'} 
resultsDir <- function(sourceInfo = getSourceInfo()){
  
  if(is.null(sourceInfo)){
    
    return(file.path(getProjectPath(),project.directory.tree$results))
    
  }
  
  resultsDir <- sourceInfo$results.dir
  
  return(resultsDir)
  
}

#' Opens a data frame as a csv file
#' @param df data frame to write and then open
#' @param overwriteTF logical to overwrite existing file. Default is FALSE
#' @details Viewing only. Does not edit the data! Writes into the temp directory and uses system's .csv file browser.
#' @return path to data directory
#' @export
#' @examples 
#' \dontrun{
#' viewData(mtcars)
#'} 
#'
viewData <- function(df,overwriteTF=FALSE){
  
  
  n <- 1
  
  filename <- make.names(as.character(substitute(df)))
  
  fileToWrite <- file.path(tempdir(),paste0(filename,"_",n,".csv"))
  
  if(!overwriteTF){
    while(file.exists(fileToWrite)){
      
      n <- n + 1
      
      fileToWrite <- file.path(tempdir(),paste0(filename,"_",n,".csv"))
      
    }
  }
  #print(filename)
  
  utils::write.csv(df,fileToWrite,row.names=FALSE)
  
  utils::browseURL(fileToWrite)
  
  
  return(fileToWrite)
  
}


#' Opens available Branches as a csv file
#' @param projectId character string specifying project
#' @details Viewing only. Does not edit the data! Writes into the temp directory and uses system's .csv file browser.
#' @return 'listBranches' output
#' @export
#' @examples 
#' \dontrun{
#' viewData("adaprHome")
#'} 
#'
viewBranches <- function(projectId = getProject()){
  
  branches <-listBranches(projectId)
  
  branches <-  branches[order(branches$path,branches$file),][,c("path","file","description")]
  
  viewData(branches)
  
  return(branches)
  
}


