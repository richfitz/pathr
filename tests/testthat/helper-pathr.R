## Will overwrite quite happily
new_empty_file <- function(filename) {
  writeLines(character(0), filename)
}
