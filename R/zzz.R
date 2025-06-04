# 파일: R/zzz.R

.onLoad <- function(libname, pkgname) {
  # 초기화 작업 가능 (globalVariables는 여기 넣으면 안됨)
}

# 여기에 선언!
if (getRversion() >= "2.15.1") {
  utils::globalVariables(c("N", "MEAN", "SD"))
}
