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

SEXP r_posix_path_same_file(SEXP r_path1, SEXP r_path2,
                            SEXP r_follow_links, SEXP r_absent_is_false) {
  bool
    follow_links = scalar_logical(r_follow_links),
    absent_is_false = scalar_logical(r_absent_is_false);
  const char
    *path1 = scalar_character(r_path1),
    *path2 = scalar_character(r_path2);
  struct stat st1, st2;
  bool ok;
  if (follow_links) {
    ok = stat(path1, &st1) == 0 && stat(path2, &st2) == 0;
  } else {
    ok = lstat(path1, &st1) == 0 && lstat(path2, &st2) == 0;
  }
  int ret;
  if (ok) {
    ret = st1.st_ino == st2.st_ino && st1.st_dev == st2.st_dev;
  } else {
    ret = absent_is_false ? 0 : NA_INTEGER;
  }
  return ScalarLogical(ret);
}
