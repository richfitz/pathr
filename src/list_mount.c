#include <R.h>
#include <Rinternals.h>

// multiple versions of this need to be written.  At the least:
//
// * linux
// * osx/macOS
// * solaris
//
// but not windows (though a stub might be useful to help avoid issues QA)

#include <mntent.h>
typedef struct mntent mntent;
#define POSIX_NSTRINGS 4

SEXP mntent_to_sexp(mntent * el);

SEXP r_posix_path_list_mount() {
  FILE* mtab = setmntent("/etc/mtab", "r");

  SEXP entries = R_NilValue;
  size_t n = 0;

  struct mntent* el;
  while ((el = getmntent(mtab))) {
    entries = PROTECT(CONS(mntent_to_sexp(el), entries));
    ++n;
  }

  endmntent(mtab);

  SEXP ret = PROTECT(allocMatrix(STRSXP, n, POSIX_NSTRINGS));
  for (int i = n - 1; i >= 0; --i) {
    SEXP x = CAR(entries);
    for (size_t j = 0; j < POSIX_NSTRINGS; ++j) {
      SET_STRING_ELT(ret, i + n * j, STRING_ELT(x, j));
    }
    entries = CDR(entries);
  }

  SEXP dimnames = PROTECT(allocVector(VECSXP, 2));
  SEXP colnames = PROTECT(allocVector(STRSXP, POSIX_NSTRINGS));
  SET_STRING_ELT(colnames, 0, mkChar("fsname"));
  SET_STRING_ELT(colnames, 1, mkChar("dir"));
  SET_STRING_ELT(colnames, 2, mkChar("type"));
  SET_STRING_ELT(colnames, 3, mkChar("opts"));
  SET_VECTOR_ELT(dimnames, 1, colnames);
  setAttrib(ret, R_DimNamesSymbol, dimnames);

  UNPROTECT(n + 3);
  return ret;
}

SEXP mntent_to_sexp(struct mntent * el) {
  SEXP ret = PROTECT(allocVector(STRSXP, POSIX_NSTRINGS));
  SET_STRING_ELT(ret, 0, mkChar(el->mnt_fsname));
  SET_STRING_ELT(ret, 1, mkChar(el->mnt_dir));
  SET_STRING_ELT(ret, 2, mkChar(el->mnt_type));
  SET_STRING_ELT(ret, 3, mkChar(el->mnt_opts));
  UNPROTECT(1);
  return ret;
}
