\name{huberM}
\alias{huberM}
\title{Safe (generalized) Huber M-Estimator of Location}
\concept{robust location}
\description{
  (Generalized) Huber M-estimator of location with MAD scale, being
  sensible also when the scale is zero where \code{\link[MASS]{huber}()}
  returns an error.
}
\usage{
huberM(x, k = 1.5, weights = NULL, tol = 1e-06,
       mu = if(is.null(weights)) median(x) else wgt.himedian(x, weights),
       s =  if(is.null(weights)) mad(x, center=mu)
	    else wgt.himedian(abs(x - mu), weights),
       warn0scale = getOption("verbose"))
}
\arguments{
  \item{x}{numeric vector.}
  \item{k}{positive factor; the algorithm winsorizes at \code{k}
    standard deviations.}
  \item{weights}{numeric vector of non-negative weights of same length
    as \code{x}, or \code{NULL}.}
  \item{tol}{convergence tolerance.}
  \item{mu}{initial location estimator.}
  \item{s}{scale estimator held constant through the iterations.}
  \item{warn0scale}{logical; if true, and \code{s} is 0 and
    \code{length(x) > 1}, this will be warned about.}
}
\value{
  list of location and scale parameters, and number of iterations used.
  \item{mu}{location estimate}
  \item{s}{the \code{s} argument, typically the \code{\link{mad}}.}
  \item{it}{the number of \dQuote{Huber iterations} used.}
}
\details{
  Note that currently, when non-\code{NULL} \code{weights} are
  specified, the default for initial location \code{mu} and scale
  \code{s} is \code{\link{wgt.himedian}}, where strictly speaking a
  weighted \dQuote{non-hi} median should be used for consistency.
  Since \code{s} is not updated, the results slightly differ, see the
  examples below.
}
\author{Martin Maechler, building on the MASS code mentioned.}
\references{
  Huber, P. J. (1981)
  \emph{Robust Statistics.}
  Wiley.
}
\seealso{
  \code{\link[MASS]{hubers}} (and \code{huber}) in package \pkg{MASS};
  \code{\link{mad}}.
}
\examples{
huberM(c(1:9, 1000))
mad  (c(1:9, 1000))
mad  (rep(9, 100))
huberM(rep(9, 100))

## When you have "binned" aka replicated observations:
set.seed(7)
x <- c(round(rnorm(1000),1), round(rnorm(50, m=10, sd = 10)))
t.x <- table(x) # -> unique values and multiplicities
x.uniq <- as.numeric(names(t.x)) ## == sort(unique(x))
x.mult <- unname(t.x)
str(Hx  <- huberM(x.uniq, weights = x.mult), digits = 7)
str(Hx. <- huberM(x, s = Hx$s), digits = 7) ## should be ~= Hx
stopifnot(all.equal(Hx, Hx.))
str(Hx2 <- huberM(x), digits = 7)## somewhat different, since 's' differs
}
\keyword{univar}
\keyword{robust}