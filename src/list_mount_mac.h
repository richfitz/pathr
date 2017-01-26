#include <R.h>
#include <Rinternals.h>
#include <sys/mount.h>
#include "util.h"

SEXP r_posix_path_list_mount() {
  struct statfs* mounts;
  const size_t len = 3;
  int n = getmntinfo(&mounts, MNT_NOWAIT); // or MNT_WAIT
  if (n < 0) {
    Rf_error("Error getting mount information");
  }

  SEXP ret = PROTECT(allocVector(VECSXP, len));
  SEXP
    fstype  = alloc_list_element(ret, 0, STRSXP, n), // fs type name
    mnton   = alloc_list_element(ret, 1, STRSXP, n), // directory mounted on
    mntfrom = alloc_list_element(ret, 2, STRSXP, n); // mounted fs

  for (int i = 0; i < n; ++i) {
    SET_STRING_ELT(fstype, i, mkChar(mounts[i].f_fstypename));
    SET_STRING_ELT(mnton, i, mkChar(mounts[i].f_mntonname));
    SET_STRING_ELT(mntfrom, i, mkChar(mounts[i].f_mntfromname));
  }

  SEXP nms = PROTECT(allocVector(STRSXP, len));
  SET_STRING_ELT(nms, 0, mkChar("fstype"));
  SET_STRING_ELT(nms, 1, mkChar("mnton"));
  SET_STRING_ELT(nms, 2, mkChar("mntfrom"));
  setAttrib(ret, R_NamesSymbol, nms);

  UNPROTECT(2);
  return ret;
}
