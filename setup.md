---
title: Setup
---


## Data Sets

Download the [data zip file](data/data.tar.gz) and unzip it to your Desktop.

## Software Setup

Ideally you'll have a laptop to work on during the sessions.  If you don't have a CMRI laptop, you can bring one from home or organise to share with someone that does.  

::::::::::::::::::::::::::::::::::::::: discussion

### Details

You will need to install `R` and `Rstudio` before the workshop begins.  Windows users will also need to install `git`.


:::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::: solution

### Windows

You will need to ask IT to install `R`, `Rstudio` and `git`:

 - [R](https://cran.r-project.org/bin/windows/base/)
 - [Rstudio](https://www.rstudio.com/products/rstudio/download/#download)
 - [git](https://git-scm.com/downloads)

:::::::::::::::::::::::::

:::::::::::::::: solution

### MacOS

Please install:

 - [R](https://cran.r-project.org/bin/macosx/)
 - [Rstudio](https://www.rstudio.com/products/rstudio/download/#download)


MacOS usually comes with `git` already installed; you can verify this by opening a terminal and typing:

```bash
git --version
```

:::::::::::::::::::::::::


### Packages

Once you have `R` and `Rstudio` installed, please also install the necessary packages by opening `Rstudio` and typing:

```R
install.packages(c("tidyverse", "patchwork", "wesanderson", "BiocManager"))
BiocManager::install(c("Biostrings", "karyoploteR"))

```

