% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/git_init.R
\name{gitInit}
\alias{gitInit}
\title{Initiate git}
\usage{
gitInit(gitdir, branch = NULL, git_binary = NULL)
}
\arguments{
\item{gitdir}{string with git directory}

\item{branch}{git branch}

\item{git_binary}{location of git executable}
}
\value{
git init lockaout
}
\description{
Initiate git
}
\details{
. Deprecated.
}
\examples{
\dontrun{
 gitInit(getProjectPath("adaprHome"))
} 
}
