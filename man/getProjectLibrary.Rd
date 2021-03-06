% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_project_path.R
\name{getProjectLibrary}
\alias{getProjectLibrary}
\title{Given Project name, Return project library directory}
\usage{
getProjectLibrary(project.id0 = getProject())
}
\arguments{
\item{project.id0}{is string with project name}
}
\value{
string containing project library directory. Will return empty string if default library.
}
\description{
Given Project name, Return project library directory
}
\details{
Reads "~/ProjectPaths/projectid_2_diretory.csv" into dataframe

Will create directory if doesn't already exist.
}
\examples{
\dontrun{
getProjectLibrary("adaprHome")
} 

}
