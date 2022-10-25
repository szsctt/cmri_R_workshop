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
- Use `readxl` to import data from Microsoft Excel
- Use `readr` to import data from text files

::::::::::::::::::::::::::::::::::::::::::::::::




## Tidy data

When recording observations, we don't often give that much thought to how we record the data.  Usually we enter data into an excel spreadsheet and care most about entering the data in the easiest way.  However, this often results in 'messy' data that requires a little bit of massaging before analysis.  

There are many possible ways to structure a dataset.  For example, if we conducted an experiment where we made two sequencing libraries, in which we have counted the instances of six different barcodes, we could structure the data like this:


```{.output}
# A tibble: 2 × 7
  library    b1    b2    b3    b4    b5    b6
  <chr>   <int> <int> <int> <int> <int> <int>
1 lib1      811    87   413   811   406   401
2 lib2      795    96   104   428   811    95
```

In this table, the counts for each barcode are stored in a separate column.  The 'library' column tells us which library the counts on each row are from.


Conversely, we could keep the counts for each library in a separate column, and the rows can tell us which barcode is being counted:


```{.output}
# A tibble: 6 × 3
  barcode  lib1  lib2
  <chr>   <int> <int>
1 b1        811   795
2 b2         87    96
3 b3        413   104
4 b4        811   428
5 b5        406   811
6 b6        401    95
```


We could even structure the table like this:


```{.output}
# A tibble: 2 × 11
  library `811`  `87`   `413`  `406`  `401`  `795`  `96`   `104`  `428`  `95`  
  <chr>   <list> <list> <list> <list> <list> <list> <list> <list> <list> <list>
1 lib1    <chr>  <chr>  <chr>  <chr>  <chr>  <NULL> <NULL> <NULL> <NULL> <NULL>
2 lib2    <chr>  <NULL> <NULL> <NULL> <NULL> <chr>  <chr>  <chr>  <chr>  <chr> 
```

This is one of the least intuitive ways to structure the data - the columns are the counts (except for the library column), and the rows tell us which barcode had which count.

These are all examples of messy ways to structure the data.  There are usually very many ways to make the data messy, but only one  ['Tidy' format](https://vita.had.co.nz/papers/tidy-data.pdf).  Being tidy means a dataset has:

1. Each variable forms a column.
2. Each observation forms a row.
3. Each type of observational unit forms a table.

Here, variables record all the values that measure the same attribute (for example library, sample, count), and an observation contains all the measurements on a single unit (like a sequencing run, or a single experiment).  Each observational unit (like independent experiments with different variables) should get its own table. This just means that if we ran another experiment with different variables, it should go in a different table.

In our this case, the tidy version looks like this:


```r
table1
```

```{.output}
# A tibble: 12 × 3
   library barcode count
   <chr>   <chr>   <int>
 1 lib1    b1        811
 2 lib1    b2         87
 3 lib1    b3        413
 4 lib1    b4        811
 5 lib1    b5        406
 6 lib1    b6        401
 7 lib2    b1        795
 8 lib2    b2         96
 9 lib2    b3        104
10 lib2    b4        428
11 lib2    b5        811
12 lib2    b6         95
```

This is tidy because each column represents a variable (library, barcode and count), each row is an observation (count for a given library and barcode), and we have all the data from this experiment in the one table.



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

If you've entered data into a digital format, chances are that you've used spreadsheet software like Microsoft Excel.

## Reading in data from text files: readr

## Resources

 - [Tidy data vignette](https://cloud.r-project.org/web/packages/tidyr/vignettes/tidy-data.html)
 - [Tidy data paper](https://vita.had.co.nz/papers/tidy-data.pdf)


::::::::::::::::::::::::::::::::::::: keypoints 

- Keeping your data tidy makes it easier to work with
- Use `readxl::read_excel()` to import data from excel
- Use `readr::read_delim()` to import data from delimited text files

::::::::::::::::::::::::::::::::::::::::::::::::



