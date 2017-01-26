#ifndef _PATHR_UTIL_H_
#define _PATHR_UTIL_H_
#include <R.h>
#include <Rinternals.h>
#include <stdbool.h>
bool scalar_logical(SEXP x);
const char * scalar_character(SEXP x);
SEXP alloc_list_element(SEXP list, size_t i, int type, size_t n);
#endif
