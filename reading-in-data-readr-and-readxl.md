---
title: 'Reading in data: readr and readxl'
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- What is tidy data?
- How can we get data into `R`?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Understand the advantages of tidy data
- Use `readxl` to import data from excel
- Use `readr` to import data from text files

::::::::::::::::::::::::::::::::::::::::::::::::

## Tidy data

When recording observations, we don't often give that much thought to how we record the data.

::::::::::::::::::::::::::::::::::::: discussion

Open the excel file `readr/untidy_data.xlsx`.  Do you think this dataset is in a tidy format?  Why/why not?

List ways that it could be improved.

:::::::::: instructor

Issues with this dataset:

 - Doesn't start in cell A1
 - Column names don't describe contents - information is missing.  What do the numbers represent?  Better column name would be 'count' or similar
 - Used a mixture of words and numbers in a column
 
To make it tidy:

 - Columns should be 'batch' and 'count' (or whatever is being measured)
 - Start at cell A1
 - How to deal with missing values?  As a separate table?
 - Or we could have batch 1 and batch 2 as two separate tables

 
::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::


## Reading in data from excel: readxl

## Reading in data from text files: readr


::::::::::::::::::::::::::::::::::::: keypoints 

- Keeping your data tidy makes it easier to work with
- Use `readxl::read_excel()` to import data from excel
- Use `readr::read_delim()` to import data from delimited text files

::::::::::::::::::::::::::::::::::::::::::::::::

