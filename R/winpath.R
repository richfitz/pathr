win_curdir <- '.'
win_pardir <- '..'
win_extsep <- '.'
win_pathsep <- ';'
win_sep <- '\\'
win_altsep <- '/'
win_defpath = '.;C:\\bin'
win_devnull = 'nul'
## Win9x family and earlier do not support support Unicode filenames,
## but I don't think that R runs on those platforms any longer
win_supports_unicode_filenames <- TRUE
