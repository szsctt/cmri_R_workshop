## R workshop @ CMRI



Useful links:
 - [Docs for sandpaper](https://carpentries.github.io/sandpaper-docs/)
 - [Data analysis and visuzliation in R for Ecologists](https://datacarpentry.org/R-ecology-lesson/index.html)
 - [R for genomics](https://datacarpentry.org/genomics-r-intro/)
 - [R for reproducilbe scientific analysis](https://swcarpentry.github.io/r-novice-gapminder/)
 - [Tips and tricks for teaching R](https://carpentries.org/blog/2019/05/R-tips-and-tricks/)
 - [One-page summary of R commands](https://drive.google.com/file/d/1bo8vMXeeiRy8l89eIjOALezO3V5oaewY/view)
 - [Rmarkdown cookbook](https://bookdown.org/yihui/rmarkdown-cookbook/)

Workshop for introductory R analysis for people at CMRI - TVRU, GTRU?

Ideally one day's worth of material - two sessions, could be spread over one day.

Consider covering:

 - Rstudio basics
 - git
 - conda?
 - R basics
 - tidyverse:
   - readr / vroom
   - dplyr / dtplyr
     - mutate
     - slice
     - filter
     - joins
   - ggplot2 / patchwork / cowplot
   - stringr?
 - bioconductor: what is bioconductor, biostrings?
 - case study: peptide analysis
 
## Rstudio basics

 - projects
 - panes
 - installing packages
 - Rmarkdown
 - git in rstudio?
 - getting help: vignettes, help (?func, help pane), stack overflow
 - reprex
 

## R basics

 - comments
 - types: numeric, string
 - coercing types
 - assignment and variables
 - vectors/matrices/data.frame
  - indexing
 - control flow: if/else, for loops
 - functions
   - inbuilt functions
   - writing own functions
 - pipes
 - libraries
 - design principles for reproducibility
   - don't re-use code/repeat yourself
   - comment frequently
   - testing / unit tests
   - what output do you expect?
   - formatting and readability matters
   - consider package versions: conda / venv
   - consider paths of input/output files (here)
 
## Tidyverse

Cheatsheats

### Readr / vroom

- read_tsv, read_csv, read_delim
- column types
- headers
- vroom for multiple files


### dplyr

 - mutate
 - slice
 - grouping
 - summarize
 - joins
 - pivot wide/long
 - tidy select
 - dtplyr /  dbplyr / multidplyr
 
### ggplot2

- aesthetics
- geoms
- facets
- scales
- labels
- annotation
- saving plots
- patchwork / cowplot

### other tidyverse

 - stringr: regex
 - glue
 - purrr: map, reduce
 
### other libraries

- pheatmap
- rstatix
 

## Bioconductor

 - intro to bioconductor
 - biostrings
 - edgeR / DEseq2
 - seurat 
 - GenomicRanges
 - karyoploteR


