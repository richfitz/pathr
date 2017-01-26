path_list_mount <- function() {
  if (is_windows()) {
    windows_path_list_mount()
  } else {
    posix_path_list_mount()
  }
}

posix_path_list_mount <- function() {
  res <- .Call("r_posix_path_list_mount", PACKAGE = "pathr")
  as.data.frame(res, stringsAsFactors = FALSE)
}

windows_path_list_mount <- function() {
  stop("FIXME")
  ## This code (from didewin) will get the network drives.
  ##
  ## For others, see:
  ##
  ## wmic logicaldisk /?
  ## fsutil fsinfo drives (requires admin)
  windir <- Sys.getenv("WINDIR", "C:\\windows")
  format_csv <- sprintf('/format:"%s\\System32\\wbem\\en-US\\csv"', windir)

  ## Using stdout = path does not work here, yielding a file that has
  ## embedded NULs and failing to be read.
  path <- tempfile()
  tmp <- system2("wmic", c("netuse", "list", "brief", format_csv), stdout = TRUE)
  writeLines(tmp[-1], path)
  on.exit(file.remove(path))
  dat <- read.csv(path, stringsAsFactors = FALSE)

  cbind(remote = dat$RemoteName, local = dat$LocalName)
}
