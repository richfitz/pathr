#include <R.h>
#include <Rinternals.h>
#include <stdbool.h>
#include <sys/stat.h>

#include "util.h"

int posix_is_mount1(const char * path, bool absent_is_false);

SEXP posix_is_mount(SEXP r_path, SEXP r_absent_is_false) {
  bool absent_is_false = scalar_logical(r_absent_is_false);
  size_t len = (size_t) length(r_path);
  SEXP ret = allocVector(LGLSXP, len);
  int *cret = INTEGER(ret);
  for (size_t i = 0; i < len; ++i) {
    SEXP el = STRING_ELT(r_path, i);
    if (el == NA_STRING) {
      cret[i] = NA_INTEGER;
    } else {
      cret[i] = posix_is_mount1(CHAR(el), absent_is_false);
    }
  }
  return ret;
}

int posix_is_mount1(const char * path, bool absent_is_false) {
  struct stat buf, buf_up;

  int code = lstat(path, &buf);
  if (code < 0) {
    return absent_is_false ? false : NA_INTEGER;
  }

  char * path_up = (char*) R_alloc(strlen(path) + 3, sizeof(char));
  if (!sprintf(path_up, "%s/..", path)) {
    // This should never happen, but I'm checking anyway to be safe
    // (otherwise accessing path_up will access uninitialised memory).
    Rf_error("internal pathr error [sprintf]"); // #nocov
  }

  code = lstat(path_up, &buf_up);
  if (code < 0) {
    // Similarly, I don't see how this can happen, but if it does
    // error then the next line would cause an R crash.
    Rf_error("internal pathr error [lstat]"); // #nocov
  }

  return buf.st_dev != buf_up.st_dev || buf.st_ino == buf_up.st_ino;
}
