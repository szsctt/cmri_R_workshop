---
title: 'Reading in data: readr and readxl'
teaching: 10
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

The workhorse of this package is the `read_excel()` function.  It takes as input a path to the file you want to read:


```r
# define path to excel file to read
my_excel_sheet <- here::here("learners", "data", "readxl_example_1.xlsx")

# read in data 
readxl::read_excel(my_excel_sheet)
```

```{.error}
Error: `path` does not exist: '/home/runner/work/cmri_R_workshop/cmri_R_workshop/site/built/learners/data/readxl_example_1.xlsx'
```

This creates a `tibble` object, which is a convenient way of storing rectangular data.


## Reading in data from text files: readr

## Resources

 - [Data import cheat sheet](https://github.com/rstudio/cheatsheets/blob/main/data-import.pdf)


::::::::::::::::::::::::::::::::::::: keypoints 

- Keeping your data tidy makes it easier to work with
- Use `readxl::read_excel()` to import data from excel
- Use `readr::read_delim()` to import data from delimited text files

::::::::::::::::::::::::::::::::::::::::::::::::



