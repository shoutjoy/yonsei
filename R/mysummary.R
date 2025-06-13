
#' my summary descriptive statistics
#'
#' @param myobject data.frame, matrix
#' @param ... column variable
#' @param digits round default 3
#' @param msdn TRUE only output var, N, mean. sd
#' @param na.rm FALSE, TRUE is remove NA
#' @importFrom utils globalVariables
#' @keywords internal
#'
#' @return size   MEAN    SD  MIN  MAX
#' @export
#'
#' @examples
#' \dontrun{
#' mysummary(mtcars, "mpg","wt","hp")
#' ## size      MEAN         SD    MIN     MAX
#' ## 1   32  20.09062  6.0269481 10.400  33.900
#' ## 2   32   3.21725  0.9784574  1.513   5.424
#' ## 3   32 146.68750 68.5628685 52.000 335.000
#'
#' ## all variable
#'  jjstat::mysummary(mtcars, colnames(mtcars))
#'
#' mysummary(mtcars, colnames(mtcars))
#'
#' mysummary(mtcars)
#'
#' mysummary(mtcars, all=FALSE)
#'
#' }
mysummary <- function(myobject, ... , digits=5, msdn=FALSE, na.rm=FALSE){
  library(dplyr)
  #  Returning more (or less) than 1 row per `summarise()` group was deprecated in dplyr
  # 1.1.0.
  # ℹ Please use `reframe()` instead.
  # ℹ When switching from `summarise()` to `reframe()`, remember that `reframe()` always
  #   returns an ungrouped data frame and adjust accordingly.
  # utils::globalVariables(c("N", "MEAN", "SD", "var"))
  # Extracting and cleaning only the numeric variable from the data
  myvars <- c(...)

  if(na.rm){
    # Removing rows with NA values if na.rm is TRUE
    myobject <- myobject %>% na.omit()
  }

  if(!is.null(myvars)){
    myvars <- c(...)
    myresult <- dplyr::reframe(myobject,
                               var = myvars,
                               N = sapply(myobject[myvars], length),
                               MEAN = sapply(myobject[myvars], mean, na.rm = TRUE),
                               SD = sapply(myobject[myvars], sd, na.rm = TRUE),
                               MIN = sapply(myobject[myvars], min, na.rm = TRUE),
                               MAX = sapply(myobject[myvars], max, na.rm = TRUE),
                               Skew = sapply(myobject[myvars], SKEW),
                               Kurt = sapply(myobject[myvars], KURT))
  } else {
    myobject <- myobject %>% purrr::keep(is.numeric)
    myvars <- colnames(myobject)

    myresult <- dplyr::reframe(myobject %>% purrr::keep(is.numeric),
                               var = myvars,
                               N = sapply(myobject[myvars], length),
                               MEAN = sapply(myobject[myvars], mean, na.rm = TRUE),
                               SD = sapply(myobject[myvars], sd, na.rm = TRUE),
                               MIN = sapply(myobject[myvars], min, na.rm = TRUE),
                               MAX = sapply(myobject[myvars], max, na.rm = TRUE),
                               Skew = sapply(myobject[myvars], SKEW),
                               Kurt = sapply(myobject[myvars], KURT))
  }

  if(msdn){
    res <- myresult %>% dplyr::select(var, N, MEAN, SD) %>%
      tibble::tibble()
  } else {
    res <- myresult %>% tibble::tibble()
  }

  options(pillar.sigfig = digits)
  return(res)
  # on.exit(options(current_options))
}



#' mydes 'n','mean','sd','min','max'
#'
#'
#' @param myvariable variable vector
#' @param var input variable name
#' @param digits digits
#' @export
#' @examples
#' \dontrun{
#' ## view variable
#' mydes(mtcars$mpg,"mpg")
#' ##not see variable
#' mydes(mtcars$mpg)
#'
#' }
#'
mydes <- function(myvariable, var = NULL, digits = 2){
  Var = var
  N <- length(myvariable)
  Mean <- round(mean(myvariable),digits)
  SD <- round(sd(myvariable),digits)
  Min <- round(min(myvariable),digits)
  Max <- round(max(myvariable),digits)
  Skew <- round(SKEW(myvariable),digits)
  Kurt <- round(KURT(myvariable),digits)

  if(is.null(Var)){
    mydes <- cbind.data.frame(N, Mean, SD, Min, Max, Skew, Kurt)
  }else{
    mydes <- cbind.data.frame(Var, N, Mean, SD, Min, Max, Skew, Kurt)
  }
  mydes <- tibble::tibble(mydes)
  mydes
}



