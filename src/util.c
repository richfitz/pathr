#include "util.h"

bool scalar_logical(SEXP x) {
  if (TYPEOF(x) == LGLSXP && LENGTH(x) == 1) {
    int ret = INTEGER(x)[0];
    if (ret == NA_LOGICAL) {
      Rf_error("Expected a non-missing logical scalar");
    }
    return (bool)(ret);
  } else {
    Rf_error("Expected a logical scalar");
    return 0;
  }
}

const char * scalar_character(SEXP x) {
  if (TYPEOF(x) == STRSXP && LENGTH(x) == 1) {
    return CHAR(STRING_ELT(x, 0));
  } else {
    Rf_error("Expected a character scalar");
    return 0;
  }
}

SEXP alloc_list_element(SEXP list, size_t i, int type, size_t n) {
  SEXP ret = PROTECT(allocVector(type, n));
  SET_VECTOR_ELT(list, i, ret);
  UNPROTECT(1);
  return ret;
}
