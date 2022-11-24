---
title: 'Reading in data: readr and readxl'
teaching: 20
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- How can we get data into `R`?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Understand the advantages of tidy data
- Use `readxl` to import data from Microsoft Excel
- Use `readr` to import data from text files

::::::::::::::::::::::::::::::::::::::::::::::::


## Reading in data




So you want to make some awesome plots using `R`.  The first step you'll need to take is to import your data.

When I first learnt `R` in a first-year statistics course, the way we did this was:

1. Open an Excel spreadsheet with the data
2. Select the data to be imported
3. Copy to the clipboard (<kbd>Cmd</kbd> + <kbd>c</kbd>)
4. Open an R terminal
5. Enter the command `read.table(pipe("pbpaste"), header = TRUE)`

This is a pretty convoluted way to do things! This weird process was part of the reason that, after I finished the course, I didn't touch `R` again for almost ten years.  

Luckily, in the meantime people worked out better ways of doing things.  This lesson will cover two awesome packages which can help you import your data: `readxl` for Excel files, and `readr` for text files.


## Reading in data from Excel: readxl

If you've entered data into a digital format, chances are that you've used spreadsheet software like Microsoft Excel.  Excel makes data entry easy because it takes care of all of the formatting for you.  But at some point, you'll probably want to get your data out of Excel and into `R`. That's where the `readxl` package comes in!

The workhorse of this package is the `read_xlsx()` function (or `read_xls` for older excel files).  It takes as input a path to the file you want to read.


```r
# define path to excel file to read
my_excel_sheet <- here::here("..", "episodes",  "data", "readxl_example_1.xlsx")

# read in data 
my_excel_data <- readxl::read_xlsx(my_excel_sheet)
```

```{.error}
Error: `path` does not exist: '/home/runner/work/cmri_R_workshop/cmri_R_workshop/site/built/../episodes/data/readxl_example_1.xlsx'
```

```r
my_excel_data
```

```{.error}
Error in eval(expr, envir, enclos): object 'my_excel_data' not found
```

### File paths with `here::here()`

Note that I use a function called `here` to create the file path to the excel file.  You can read more about this function [here](https://cran.r-project.org/web/packages/here/vignettes/here.html).   

Using this function helps with cross-platform compatbility (so it works on Windows as well as MacOX and Linux).  This is because directories on Windows are usually separated with a backslash `\`, whereas on Unix-based distributions (like MacOS and Linux) directories are separated by a slash `/`.

You can check what the file path looks like on your platform by printing out the variable we defined with the file path:


```r
my_excel_sheet
```

```{.output}
[1] "/home/runner/work/cmri_R_workshop/cmri_R_workshop/site/built/../episodes/data/readxl_example_1.xlsx"
```


Using `here::here()` always generates paths relative to the project root (the file created by RStudio when you make a new project, which has the file extension `.Rproj`).  If you move the project around on your filesystem (or send it to someone else), the import will still work.  This wouldn't be the case if you manually specified the absolute path to the file.

Note that this example file path is a little convoluted, because of the way the lessons are created.  Yours should be more straightforward and look more like this:


```r
my_excel_sheet <- here::here("data", "readxl_example_1.xlsx")
```


### Tibbles

Coming back to the output of the call to `readxl::read_xlsx()` - calls to this function return a `tibble` object with the data contained in the excel spreadsheet.

The `tibble` object is a convenient way of storing rectangular data, where column has a type, (which is shown when you print the table).  Ideally, in a tibble each column should contain data from one variable, and each row consists of observations of each varaiables - this is known as 'tidy data' (more on this in the next lesson).

If you don't specify the types (like character, integer, double) of each column, `readxl` will try to [guess them based on the types in the excel spreadhsheet](https://readxl.tidyverse.org/articles/cell-and-column-types.html).  This can lead to unexpected behaviour, especially if you mix numbers and strings in the same column.

::::::::::::::::::::::::::::::::::::: challenge 

#### Challenge 1: Column types


Open the file `readxl_example_2.xlsx` in Excel.  What do you think the types will be when you import this file?

:::::::::::::::::::::::: solution 

#### Show me the solution
 


```r
# read in data 
data <- readxl::read_xlsx(here::here("..", "episodes", "data", "readxl_example_2.xlsx"))
```

```{.error}
Error: `path` does not exist: '/home/runner/work/cmri_R_workshop/cmri_R_workshop/site/built/../episodes/data/readxl_example_2.xlsx'
```

```r
head(data)
```

```{.output}
                                                                            
1 function (..., list = character(), package = NULL, lib.loc = NULL,        
2     verbose = getOption("verbose"), envir = .GlobalEnv, overwrite = TRUE) 
3 {                                                                         
4     fileExt <- function(x) {                                              
5         db <- grepl("\\\\.[^.]+\\\\.(gz|bz2|xz)$", x)                     
6         ans <- sub(".*\\\\.", "", x)                                      
```

Note that:

 - The 'replicate' column has a type of `dbl` even though it contains only integers.
 - The 'drug concentration' column is of type `chr` because R doesn't know that 'uM' is a unit.
 - Mixing numbers and charaters in the 'assay 2' column results in a column of characters (why do you think this is?)
 
:::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::

The type of the columns is important to be aware of because some fucntions in R expect that you feed them columns of a particular type.  For example, we can extract the 'drug concentration' column from the second file we imported using the `$` operator.


```r
conc <- data$`drug concentration`
```

```{.error}
Error in data$`drug concentration`: object of type 'closure' is not subsettable
```

```r
conc
```

```{.error}
Error in eval(expr, envir, enclos): object 'conc' not found
```

We can then extract the first two characters of each string in this column using `stringr::str_sub()`:


```r
nums <- stringr::str_sub(conc, 1, 2)
```

```{.error}
Error in stri_sub(string, from = start, to = end): object 'conc' not found
```

But we can't add one to this column:


```r
conc + 1
```

```{.error}
Error in eval(expr, envir, enclos): object 'conc' not found
```

### Specifying column types


Since the guessing of types can result in unexpected behaviour, it's best to always specify the types of data when you import it.  You can do this in a verbose way:


```r
data <- readxl::read_xlsx(here::here("..", "episodes", "data", "readxl_example_2.xlsx"),
                           col_types = c("numeric", "text", "text", "text", "numeric"))
```

```{.error}
Error: `path` does not exist: '/home/runner/work/cmri_R_workshop/cmri_R_workshop/site/built/../episodes/data/readxl_example_2.xlsx'
```

```r
data
```

```{.output}
function (..., list = character(), package = NULL, lib.loc = NULL, 
    verbose = getOption("verbose"), envir = .GlobalEnv, overwrite = TRUE) 
{
    fileExt <- function(x) {
        db <- grepl("\\.[^.]+\\.(gz|bz2|xz)$", x)
        ans <- sub(".*\\.", "", x)
        ans[db] <- sub(".*\\.([^.]+\\.)(gz|bz2|xz)$", "\\1\\2", 
            x[db])
        ans
    }
    my_read_table <- function(...) {
        lcc <- Sys.getlocale("LC_COLLATE")
        on.exit(Sys.setlocale("LC_COLLATE", lcc))
        Sys.setlocale("LC_COLLATE", "C")
        read.table(...)
    }
    stopifnot(is.character(list))
    names <- c(as.character(substitute(list(...))[-1L]), list)
    if (!is.null(package)) {
        if (!is.character(package)) 
            stop("'package' must be a character vector or NULL")
    }
    paths <- find.package(package, lib.loc, verbose = verbose)
    if (is.null(lib.loc)) 
        paths <- c(path.package(package, TRUE), if (!length(package)) getwd(), 
            paths)
    paths <- unique(normalizePath(paths[file.exists(paths)]))
    paths <- paths[dir.exists(file.path(paths, "data"))]
    dataExts <- tools:::.make_file_exts("data")
    if (length(names) == 0L) {
        db <- matrix(character(), nrow = 0L, ncol = 4L)
        for (path in paths) {
            entries <- NULL
            packageName <- if (file_test("-f", file.path(path, 
                "DESCRIPTION"))) 
                basename(path)
            else "."
            if (file_test("-f", INDEX <- file.path(path, "Meta", 
                "data.rds"))) {
                entries <- readRDS(INDEX)
            }
            else {
                dataDir <- file.path(path, "data")
                entries <- tools::list_files_with_type(dataDir, 
                  "data")
                if (length(entries)) {
                  entries <- unique(tools::file_path_sans_ext(basename(entries)))
                  entries <- cbind(entries, "")
                }
            }
            if (NROW(entries)) {
                if (is.matrix(entries) && ncol(entries) == 2L) 
                  db <- rbind(db, cbind(packageName, dirname(path), 
                    entries))
                else warning(gettextf("data index for package %s is invalid and will be ignored", 
                  sQuote(packageName)), domain = NA, call. = FALSE)
            }
        }
        colnames(db) <- c("Package", "LibPath", "Item", "Title")
        footer <- if (missing(package)) 
            paste0("Use ", sQuote(paste("data(package =", ".packages(all.available = TRUE))")), 
                "\n", "to list the data sets in all *available* packages.")
        else NULL
        y <- list(title = "Data sets", header = NULL, results = db, 
            footer = footer)
        class(y) <- "packageIQR"
        return(y)
    }
    paths <- file.path(paths, "data")
    for (name in names) {
        found <- FALSE
        for (p in paths) {
            tmp_env <- if (overwrite) 
                envir
            else new.env()
            if (file_test("-f", file.path(p, "Rdata.rds"))) {
                rds <- readRDS(file.path(p, "Rdata.rds"))
                if (name %in% names(rds)) {
                  found <- TRUE
                  if (verbose) 
                    message(sprintf("name=%s:\t found in Rdata.rds", 
                      name), domain = NA)
                  thispkg <- sub(".*/([^/]*)/data$", "\\1", p)
                  thispkg <- sub("_.*$", "", thispkg)
                  thispkg <- paste0("package:", thispkg)
                  objs <- rds[[name]]
                  lazyLoad(file.path(p, "Rdata"), envir = tmp_env, 
                    filter = function(x) x %in% objs)
                  break
                }
                else if (verbose) 
                  message(sprintf("name=%s:\t NOT found in names() of Rdata.rds, i.e.,\n\t%s\n", 
                    name, paste(names(rds), collapse = ",")), 
                    domain = NA)
            }
            if (file_test("-f", file.path(p, "Rdata.zip"))) {
                warning("zipped data found for package ", sQuote(basename(dirname(p))), 
                  ".\nThat is defunct, so please re-install the package.", 
                  domain = NA)
                if (file_test("-f", fp <- file.path(p, "filelist"))) 
                  files <- file.path(p, scan(fp, what = "", quiet = TRUE))
                else {
                  warning(gettextf("file 'filelist' is missing for directory %s", 
                    sQuote(p)), domain = NA)
                  next
                }
            }
            else {
                files <- list.files(p, full.names = TRUE)
            }
            files <- files[grep(name, files, fixed = TRUE)]
            if (length(files) > 1L) {
                o <- match(fileExt(files), dataExts, nomatch = 100L)
                paths0 <- dirname(files)
                paths0 <- factor(paths0, levels = unique(paths0))
                files <- files[order(paths0, o)]
            }
            if (length(files)) {
                for (file in files) {
                  if (verbose) 
                    message("name=", name, ":\t file= ...", .Platform$file.sep, 
                      basename(file), "::\t", appendLF = FALSE, 
                      domain = NA)
                  ext <- fileExt(file)
                  if (basename(file) != paste0(name, ".", ext)) 
                    found <- FALSE
                  else {
                    found <- TRUE
                    zfile <- file
                    zipname <- file.path(dirname(file), "Rdata.zip")
                    if (file.exists(zipname)) {
                      Rdatadir <- tempfile("Rdata")
                      dir.create(Rdatadir, showWarnings = FALSE)
                      topic <- basename(file)
                      rc <- .External(C_unzip, zipname, topic, 
                        Rdatadir, FALSE, TRUE, FALSE, FALSE)
                      if (rc == 0L) 
                        zfile <- file.path(Rdatadir, topic)
                    }
                    if (zfile != file) 
                      on.exit(unlink(zfile))
                    switch(ext, R = , r = {
                      library("utils")
                      sys.source(zfile, chdir = TRUE, envir = tmp_env)
                    }, RData = , rdata = , rda = load(zfile, 
                      envir = tmp_env), TXT = , txt = , tab = , 
                      tab.gz = , tab.bz2 = , tab.xz = , txt.gz = , 
                      txt.bz2 = , txt.xz = assign(name, my_read_table(zfile, 
                        header = TRUE, as.is = FALSE), envir = tmp_env), 
                      CSV = , csv = , csv.gz = , csv.bz2 = , 
                      csv.xz = assign(name, my_read_table(zfile, 
                        header = TRUE, sep = ";", as.is = FALSE), 
                        envir = tmp_env), found <- FALSE)
                  }
                  if (found) 
                    break
                }
                if (verbose) 
                  message(if (!found) 
                    "*NOT* ", "found", domain = NA)
            }
            if (found) 
                break
        }
        if (!found) {
            warning(gettextf("data set %s not found", sQuote(name)), 
                domain = NA)
        }
        else if (!overwrite) {
            for (o in ls(envir = tmp_env, all.names = TRUE)) {
                if (exists(o, envir = envir, inherits = FALSE)) 
                  warning(gettextf("an object named %s already exists and will not be overwritten", 
                    sQuote(o)))
                else assign(o, get(o, envir = tmp_env, inherits = FALSE), 
                  envir = envir)
            }
            rm(tmp_env)
        }
    }
    invisible(names)
}
<bytecode: 0x55f34fc2f7c8>
<environment: namespace:utils>
```

Note that the last column ('assay 3') contains boolean (TRUE/FALSE) values, but we coerced it to a numeric type when we imported it.  `R` prints a warning to let us know.

### Other options

`readxl::read_xlsx()` also has lots of other options to deal with other aspects of data imports - for example, you can:

 - Use the `sheet` and `range` named arguments to specifiy which parts of the sheet to import 
 - Skip a number of header rows using the `skip` option, 
 - Provide a vector of your own column names using the `col_names` argument
 - Pass `col_names=FALSE` to avoid using the first line of the file as your column names if your data doesn't have column names
 
:::::::::::::: challenge

#### Challenge 2: readxl

Open the file `human_codon_table.xlsx` in Excel.  The columns of this table contain codons, frequencies of observations of each codon, and counts of each codon. 

How do you think it should be imported?

Import this data, including the `col_names`, `skip`, `col_types`, `sheet` and `range` named arguments.

:::::: solution


#### Show me the solution


```r
readxl::read_xlsx(here::here("..", "episodes", "data", "human_codon_table.xlsx"),
                  col_names = c("codon", "frequency", "count"),
                  skip=0,
                  col_types = c('text', 'numeric', 'numeric'),
                  sheet = 'human_codon_table',
                  range = 'A2:C65' )
```

```{.error}
Error: `path` does not exist: '/home/runner/work/cmri_R_workshop/cmri_R_workshop/site/built/../episodes/data/human_codon_table.xlsx'
```

:::::::::::::::

::::::::::::::::::::::::

## Reading in data from text files: readr

Alternatively, you might have tabular data in a text file.  In these kinds of files, each row of the file is a row of the table, and usually either tabs or commas separate the values in each column.  

If you have comma-separated data (like a `.csv` file) the `readr::read_csv()` function will be most convenient, and if your data is tab-separated (like a `.tsv` file), you'll want `readr::read_tsv()`.  If you have a different delimiter, you can use `readr::read_delim(file, delim=delimiter)`, where `delimiter` is a string containing your delimiter.

The syntax is very similar to `read_xlsx()`, and you should specify the column types here as well.  Here I use the short form of the column specification - '`c`' for character and '`i`' for integer.


```r
data <- readr::read_csv(here::here("..", "episodes", "data", "readr_example_1.tsv"),
                           col_types = c("cci"))
```

```{.error}
Error: '/home/runner/work/cmri_R_workshop/cmri_R_workshop/site/built/../episodes/data/readr_example_1.tsv' does not exist.
```

```r
data
```

```{.output}
function (..., list = character(), package = NULL, lib.loc = NULL, 
    verbose = getOption("verbose"), envir = .GlobalEnv, overwrite = TRUE) 
{
    fileExt <- function(x) {
        db <- grepl("\\.[^.]+\\.(gz|bz2|xz)$", x)
        ans <- sub(".*\\.", "", x)
        ans[db] <- sub(".*\\.([^.]+\\.)(gz|bz2|xz)$", "\\1\\2", 
            x[db])
        ans
    }
    my_read_table <- function(...) {
        lcc <- Sys.getlocale("LC_COLLATE")
        on.exit(Sys.setlocale("LC_COLLATE", lcc))
        Sys.setlocale("LC_COLLATE", "C")
        read.table(...)
    }
    stopifnot(is.character(list))
    names <- c(as.character(substitute(list(...))[-1L]), list)
    if (!is.null(package)) {
        if (!is.character(package)) 
            stop("'package' must be a character vector or NULL")
    }
    paths <- find.package(package, lib.loc, verbose = verbose)
    if (is.null(lib.loc)) 
        paths <- c(path.package(package, TRUE), if (!length(package)) getwd(), 
            paths)
    paths <- unique(normalizePath(paths[file.exists(paths)]))
    paths <- paths[dir.exists(file.path(paths, "data"))]
    dataExts <- tools:::.make_file_exts("data")
    if (length(names) == 0L) {
        db <- matrix(character(), nrow = 0L, ncol = 4L)
        for (path in paths) {
            entries <- NULL
            packageName <- if (file_test("-f", file.path(path, 
                "DESCRIPTION"))) 
                basename(path)
            else "."
            if (file_test("-f", INDEX <- file.path(path, "Meta", 
                "data.rds"))) {
                entries <- readRDS(INDEX)
            }
            else {
                dataDir <- file.path(path, "data")
                entries <- tools::list_files_with_type(dataDir, 
                  "data")
                if (length(entries)) {
                  entries <- unique(tools::file_path_sans_ext(basename(entries)))
                  entries <- cbind(entries, "")
                }
            }
            if (NROW(entries)) {
                if (is.matrix(entries) && ncol(entries) == 2L) 
                  db <- rbind(db, cbind(packageName, dirname(path), 
                    entries))
                else warning(gettextf("data index for package %s is invalid and will be ignored", 
                  sQuote(packageName)), domain = NA, call. = FALSE)
            }
        }
        colnames(db) <- c("Package", "LibPath", "Item", "Title")
        footer <- if (missing(package)) 
            paste0("Use ", sQuote(paste("data(package =", ".packages(all.available = TRUE))")), 
                "\n", "to list the data sets in all *available* packages.")
        else NULL
        y <- list(title = "Data sets", header = NULL, results = db, 
            footer = footer)
        class(y) <- "packageIQR"
        return(y)
    }
    paths <- file.path(paths, "data")
    for (name in names) {
        found <- FALSE
        for (p in paths) {
            tmp_env <- if (overwrite) 
                envir
            else new.env()
            if (file_test("-f", file.path(p, "Rdata.rds"))) {
                rds <- readRDS(file.path(p, "Rdata.rds"))
                if (name %in% names(rds)) {
                  found <- TRUE
                  if (verbose) 
                    message(sprintf("name=%s:\t found in Rdata.rds", 
                      name), domain = NA)
                  thispkg <- sub(".*/([^/]*)/data$", "\\1", p)
                  thispkg <- sub("_.*$", "", thispkg)
                  thispkg <- paste0("package:", thispkg)
                  objs <- rds[[name]]
                  lazyLoad(file.path(p, "Rdata"), envir = tmp_env, 
                    filter = function(x) x %in% objs)
                  break
                }
                else if (verbose) 
                  message(sprintf("name=%s:\t NOT found in names() of Rdata.rds, i.e.,\n\t%s\n", 
                    name, paste(names(rds), collapse = ",")), 
                    domain = NA)
            }
            if (file_test("-f", file.path(p, "Rdata.zip"))) {
                warning("zipped data found for package ", sQuote(basename(dirname(p))), 
                  ".\nThat is defunct, so please re-install the package.", 
                  domain = NA)
                if (file_test("-f", fp <- file.path(p, "filelist"))) 
                  files <- file.path(p, scan(fp, what = "", quiet = TRUE))
                else {
                  warning(gettextf("file 'filelist' is missing for directory %s", 
                    sQuote(p)), domain = NA)
                  next
                }
            }
            else {
                files <- list.files(p, full.names = TRUE)
            }
            files <- files[grep(name, files, fixed = TRUE)]
            if (length(files) > 1L) {
                o <- match(fileExt(files), dataExts, nomatch = 100L)
                paths0 <- dirname(files)
                paths0 <- factor(paths0, levels = unique(paths0))
                files <- files[order(paths0, o)]
            }
            if (length(files)) {
                for (file in files) {
                  if (verbose) 
                    message("name=", name, ":\t file= ...", .Platform$file.sep, 
                      basename(file), "::\t", appendLF = FALSE, 
                      domain = NA)
                  ext <- fileExt(file)
                  if (basename(file) != paste0(name, ".", ext)) 
                    found <- FALSE
                  else {
                    found <- TRUE
                    zfile <- file
                    zipname <- file.path(dirname(file), "Rdata.zip")
                    if (file.exists(zipname)) {
                      Rdatadir <- tempfile("Rdata")
                      dir.create(Rdatadir, showWarnings = FALSE)
                      topic <- basename(file)
                      rc <- .External(C_unzip, zipname, topic, 
                        Rdatadir, FALSE, TRUE, FALSE, FALSE)
                      if (rc == 0L) 
                        zfile <- file.path(Rdatadir, topic)
                    }
                    if (zfile != file) 
                      on.exit(unlink(zfile))
                    switch(ext, R = , r = {
                      library("utils")
                      sys.source(zfile, chdir = TRUE, envir = tmp_env)
                    }, RData = , rdata = , rda = load(zfile, 
                      envir = tmp_env), TXT = , txt = , tab = , 
                      tab.gz = , tab.bz2 = , tab.xz = , txt.gz = , 
                      txt.bz2 = , txt.xz = assign(name, my_read_table(zfile, 
                        header = TRUE, as.is = FALSE), envir = tmp_env), 
                      CSV = , csv = , csv.gz = , csv.bz2 = , 
                      csv.xz = assign(name, my_read_table(zfile, 
                        header = TRUE, sep = ";", as.is = FALSE), 
                        envir = tmp_env), found <- FALSE)
                  }
                  if (found) 
                    break
                }
                if (verbose) 
                  message(if (!found) 
                    "*NOT* ", "found", domain = NA)
            }
            if (found) 
                break
        }
        if (!found) {
            warning(gettextf("data set %s not found", sQuote(name)), 
                domain = NA)
        }
        else if (!overwrite) {
            for (o in ls(envir = tmp_env, all.names = TRUE)) {
                if (exists(o, envir = envir, inherits = FALSE)) 
                  warning(gettextf("an object named %s already exists and will not be overwritten", 
                    sQuote(o)))
                else assign(o, get(o, envir = tmp_env, inherits = FALSE), 
                  envir = envir)
            }
            rm(tmp_env)
        }
    }
    invisible(names)
}
<bytecode: 0x55f34fc2f7c8>
<environment: namespace:utils>
```

You can read more about the column specification for `readr` functions [here](https://r4ds.had.co.nz/data-import.html).

The other options for `read_csv()` are also similar to those for `read_xslx`, including `col_names` and `skip`.


### Reading multiple files 

If you have multiple files with the same columns and column types, you can pass a vector of file paths rather than an atomic vector.  To add an extra column with the file name (so you know which rows came from which files), use the `id` parameter.


```r
files <- c(here::here("episodes", "data", "sim_0_counts.txt"),
           here::here("episodes", "data", "sim_1_counts.txt"))

data <- readr::read_tsv(files, col_types = 'cci', id="file")
```

```{.error}
Error: '/home/runner/work/cmri_R_workshop/cmri_R_workshop/site/built/episodes/data/sim_0_counts.txt' does not exist.
```

```r
head(data)
```

```{.output}
                                                                            
1 function (..., list = character(), package = NULL, lib.loc = NULL,        
2     verbose = getOption("verbose"), envir = .GlobalEnv, overwrite = TRUE) 
3 {                                                                         
4     fileExt <- function(x) {                                              
5         db <- grepl("\\\\.[^.]+\\\\.(gz|bz2|xz)$", x)                     
6         ans <- sub(".*\\\\.", "", x)                                      
```



## Resources

 - [Data import cheat sheet](https://github.com/rstudio/cheatsheets/blob/main/data-import.pdf)
 - [Data import section from R for data science](https://r4ds.had.co.nz/data-import.html)
 - [readxl documentation](https://readxl.tidyverse.org/)
 - [readr documentation](https://readr.tidyverse.org/)


::::::::::::::::::::::::::::::::::::: keypoints 

- Use `readxl::read_xlsx()` to import data from excel
- Use `readr::read_tsv()`, `readr::read_csv()`, `readr::read_delim()` to import data from delimited text files

::::::::::::::::::::::::::::::::::::::::::::::::
