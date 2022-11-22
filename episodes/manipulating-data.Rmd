---
title: 'manipulating-data'
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- What are the main `dplyr` verbs?
- How can I analyse data within groups?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Know how to use the main `dplyr` verbs
- Use `group_by()` to aggregate and manipulate within groups

::::::::::::::::::::::::::::::::::::::::::::::::

## Manipulating data with `dplyr`

### Creating summaries with `group_by()` and `summarise()`

### Filtering rows with `filter()`

![`dplyr::filter()`](https://ab604.github.io/docs/coding-together-2019/img/dplyr_filter.png)

#### Complex filters with `case_when()`

#### Filter within groups with `slice_xxx()`
 
### Selecting columns with `select()`

![`dplyr::select()`](https://ab604.github.io/docs/coding-together-2019/img/dplyr_select.png)

### Sorting rows with `arrange()`

![`dplyr::arrange()`](https://ab604.github.io/docs/coding-together-2019/img/dplyr_arrange.png)

### Renaming colunmns with `rename()`

### Creating new columns with `mutate()`

![`dplyr::mutate()`](https://ab604.github.io/docs/coding-together-2019/img/dplyr-mutate-16-10-2019.png)

#### Mutating multiple columns with `across()`

### Joining data with `left_join()`, `full_join()` and `anti_join()`

::::::::::::::::::::::::::::::::::::: keypoints 

- Use `.md` files for episodes when you want static content
- Use `.Rmd` files for episodes when you need to generate output
- Run `sandpaper::check_lesson()` to identify any issues with your lesson
- Run `sandpaper::build_lesson()` to preview your lesson locally

::::::::::::::::::::::::::::::::::::::::::::::::

