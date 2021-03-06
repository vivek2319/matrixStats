library("matrixStats")

rowSds_R <- function(x, na.rm = FALSE) {
  suppressWarnings({
    apply(x, MARGIN = 1L, FUN = sd, na.rm = na.rm)
  })
}

colSds_R <- function(x, na.rm = FALSE) {
  suppressWarnings({
    apply(x, MARGIN = 2L, FUN = sd, na.rm = na.rm)
  })
}


rowSds_center <- function(x, rows = NULL, cols = NULL, na.rm = FALSE) {
  center <- rowWeightedMeans(x, cols = cols, na.rm = na.rm)
  rowSds(x, rows = rows, cols = cols, center = center, na.rm = na.rm)
}

colSds_center <- function(x, rows = NULL, cols = NULL, na.rm = FALSE) {
  center <- colWeightedMeans(x, rows = rows, na.rm = na.rm)
  colSds(x, rows = rows, cols = cols, center = center, na.rm = na.rm)
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# With and without some NAs
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
for (mode in c("integer", "double")) {
  for (add_na in c(FALSE, TRUE)) {
    cat("add_na = ", add_na, "\n", sep = "")

    x <- matrix(1:100 + 0.1, nrow = 20, ncol = 5)
    if (add_na) {
      x[13:17, c(2, 4)] <- NA_real_
    }
    cat("mode: ", mode, "\n", sep = "")
    storage.mode(x) <- mode
    str(x)

    # Row/column ranges
    for (na.rm in c(FALSE, TRUE)) {
      cat("na.rm = ", na.rm, "\n", sep = "")
      r0 <- rowSds_R(x, na.rm = na.rm)
      r1 <- rowSds(x, na.rm = na.rm)
      r1b <- rowSds_center(x, na.rm = na.rm)
      r2 <- colSds(t(x), na.rm = na.rm)
      r2b <- colSds_center(t(x), na.rm = na.rm)
      stopifnot(all.equal(r1, r2))
      stopifnot(all.equal(r1, r0))
      stopifnot(all.equal(r2, r0))
      stopifnot(all.equal(r1b, r1))
      stopifnot(all.equal(r2b, r2))
    }
  } # for (add_na ...)
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# All NAs
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
for (mode in c("integer", "double")) {
  x <- matrix(NA_real_, nrow = 20, ncol = 5)
  cat("mode: ", mode, "\n", sep = "")
  storage.mode(x) <- mode
  str(x)

  for (na.rm in c(FALSE, TRUE)) {
    cat("na.rm = ", na.rm, "\n", sep = "")
    r0 <- rowSds_R(x, na.rm = na.rm)
    r1 <- rowSds(x, na.rm = na.rm)
    r1b <- rowSds_center(x, na.rm = na.rm)
    r2 <- colSds(t(x), na.rm = na.rm)
    r2b <- colSds_center(t(x), na.rm = na.rm)
    stopifnot(all.equal(r1, r2))
    stopifnot(all.equal(r1, r0))
    stopifnot(all.equal(r2, r0))
    stopifnot(all.equal(r1b, r1))
    stopifnot(all.equal(r2b, r2))
  }
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# A 1x1 matrix
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
x <- matrix(0, nrow = 1, ncol = 1)
for (na.rm in c(FALSE, TRUE)) {
  cat("na.rm = ", na.rm, "\n", sep = "")
  r0 <- rowSds_R(x, na.rm = na.rm)
  r1 <- rowSds(x, na.rm = na.rm)
  r1b <- rowSds_center(x, na.rm = na.rm)
  r2 <- colSds(t(x), na.rm = na.rm)
  r2b <- colSds_center(t(x), na.rm = na.rm)
  stopifnot(all.equal(r1, r2))
  stopifnot(all.equal(r1, r0))
  stopifnot(all.equal(r2, r0))
  stopifnot(all.equal(r1b, r1))
  stopifnot(all.equal(r2b, r2))
}
