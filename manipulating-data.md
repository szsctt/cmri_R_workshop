---
title: 'Manipulating data with `dplyr`'
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

So once we have our data in a tidy format, what do we do with it?  For analysis, I often turn to the `dplyr` package, which contains several useful functions for manipulating tables of data.

To illustrate the functions of this package, we'll use a dataset of weather observations in Brisbane and Sydney from [the Bureau of Meterology](http://www.bom.gov.au/climate/data/).

These files are called `weather_brisbane.csv` and `weather_sydney.csv`.

First, we load both files using `readr`:


```r
# load tidyverse
library(tidyverse)
```

```{.output}
── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
✔ ggplot2 3.4.0      ✔ purrr   0.3.5 
✔ tibble  3.1.8      ✔ dplyr   1.0.10
✔ tidyr   1.2.1      ✔ stringr 1.4.1 
✔ readr   2.1.3      ✔ forcats 0.5.2 
── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
```

```r
# data files
data_dir <- here::here("..", "episodes", "data") # change this for your computer
data_files <- file.path(data_dir, c("weather_sydney.csv", "weather_brisbane.csv"))

# column types
col_types <- list(
  date = col_date(format="%Y-%m-%d"),
  min_temp_c = col_double(),
  max_temp_c = col_double(),
  rainfall_mm = col_double(),
  evaporation_mm = col_double(),
  sunshine_hours = col_double(),
  dir_max_wind_gust = col_character(),
  speed_max_wind_gust_kph = col_double(),
  time_max_wind_gust = col_time(),
  temp_9am_c = col_double(),
  rel_humid_9am_pc = col_integer(),
  cloud_amount_9am_oktas = col_double(),
  wind_direction_9am = col_character(),
  wind_speed_9am_kph = col_double(),
  MSL_pressure_9am_hPa = col_double(),
  temp_3pm_c = col_double(),
  rel_humid_3pm_pc = col_double(),
  cloud_amount_3pm_oktas = col_double(),
  wind_direction_3pm = col_character(),
  wind_speed_3pm_kph = col_double(),
  MSL_pressure_3pm_hPa = col_double()
)

# read in data
weather <- readr::read_csv(data_files, skip=10, 
                           col_types=col_types, col_names = names(col_types),
                           id="file")
```

```{.error}
Error: '/home/runner/work/cmri_R_workshop/cmri_R_workshop/site/built/../episodes/data/weather_sydney.csv' does not exist.
```

### Creating summaries with `summarise()`

First, we would like to know what the mean minimum and maximum temperatures were overall.  For this, we can use `summarise()`:


```r
weather %>% 
  summarise(mean_min_temp = mean(min_temp_c),
            mean_max_temp = mean(max_temp_c))
```

```{.error}
Error in summarise(., mean_min_temp = mean(min_temp_c), mean_max_temp = mean(max_temp_c)): object 'weather' not found
```

Notice that the mean_max_temp is `NA`, because we had some `NA` values in this column.  In `R` we use `NA` for missing values.  So how does one take the mean of some numbers, some of which are missing?  We can't so the answer is also a missing value.  We can, however, tell the `mean()` function to ignore the missing values using `na.rm=TRUE`:


```r
weather %>% 
  summarise(mean_min_temp = mean(min_temp_c),
            mean_max_temp = mean(max_temp_c, na.rm=TRUE))
```

```{.error}
Error in summarise(., mean_min_temp = mean(min_temp_c), mean_max_temp = mean(max_temp_c, : object 'weather' not found
```


::::::::::::::::: challenge


#### Challenge 1: medians

What is the median minimum and maximum temperature in the weather observations?

::::: solution


#### Show me the solution



```r
weather %>% 
  summarise(median_min_temp = median(min_temp_c),
            median_max_temp = median(max_temp_c, na.rm=TRUE))
```

```{.error}
Error in summarise(., median_min_temp = median(min_temp_c), median_max_temp = median(max_temp_c, : object 'weather' not found
```
::::::::::::::

:::::::::::::::::::::::::::


`dplyr` also has some special functions that are designed to be used inside of other functions.  For example, if we want to know how many observations there were of the minimum and maximum temperatures, we could use `n()`. Or if we wanted to know how many different directions the maximum wind gust had, we can use `n_distinct()`.


```r
weather %>% 
  summarise(n_days_observed = n(),
            n_wind_dir = n_distinct(dir_max_wind_gust))
```

```{.error}
Error in summarise(., n_days_observed = n(), n_wind_dir = n_distinct(dir_max_wind_gust)): object 'weather' not found
```

#### Grouped summaries with `group_by()`

However, all of these summaries have combined the observations for Sydney and Brisbane. It probably makes sense to group the observations by city, and then compute the summary statistics.  For this, we can use `group_by()`.

If you use `group_by()` on a tibble, it doesn't actually look like it changes that much.


```r
weather %>% 
  group_by(file)
```

```{.error}
Error in group_by(., file): object 'weather' not found
```

The only difference is that when you print it out, it tells you that it's grouped by file.  However, a grouped data frame interacts differently with other `dplyr` verbs, such as `summary`.


```r
weather %>% 
  group_by(file) %>% 
  summarise(median_min_temp = median(min_temp_c),
            median_max_temp = median(max_temp_c, na.rm=TRUE))
```

```{.error}
Error in group_by(., file): object 'weather' not found
```

Now we get the median temperature for both Sydney and Brisbane.

:::::::::::::::: challenge


#### Challenge 2: medians

What is the maximum wind speed (`speed_max_wind_gust_kph`) in each direction (`dir_max_wind_gust`) for each city?

::::: solution


#### Show me the solution



```r
weather %>% 
  group_by(file, dir_max_wind_gust) %>% 
  summarise(max_max_wind_gust = max(speed_max_wind_gust_kph))
```

```{.error}
Error in group_by(., file, dir_max_wind_gust): object 'weather' not found
```
::::::::::::::

Can you pivot the table wider to make it easier to compare between directions and cities?

::::: solution

#### Show me the solution


```r
weather %>% 
  group_by(file, dir_max_wind_gust) %>% 
  summarise(max_max_wind_gust = max(speed_max_wind_gust_kph)) %>% 
  ungroup() %>% 
  pivot_wider(id_cols=file, names_from = "dir_max_wind_gust", values_from = "max_max_wind_gust")
```

```{.error}
Error in group_by(., file, dir_max_wind_gust): object 'weather' not found
```

Do you prefer the long or wide form of the table?

::::::::::::::

:::::::::::::::::::::::::::


### Creating new columns with `mutate()`

It's kind of annoying that we have the whole file names, rather than just the names of the cities.  To fix this, we can create (or overwrite) columns with `mutate()`.  

![`dplyr::mutate()`](https://ab604.github.io/docs/coding-together-2019/img/dplyr-mutate-16-10-2019.png)

For example, the `stringr::str_extract()` function extracts a matching pattern from a string:


```r
stringr::str_extract(data_files, "sydney|brisbane")
```

```{.output}
[1] "sydney"   "brisbane"
```

::::::::::: callout

The second argument to `str_extract()` is a regular expression, or *regex*.  Using regular expressions is a hugely flexible way to specify a pattern to match in a string, but it's a somewhat complicated topic that I won't go into here.  If you're interested in learning more, you can look at the [stringr documentation on regular expressions](https://stringr.tidyverse.org/articles/regular-expressions.html).

::::::::::::::::::


We can use `mutate()` to apply the `str_extract()` function to the `file` column


```r
weather <- weather %>% 
  mutate(city = stringr::str_extract(file, "sydney|brisbane"))
```

```{.error}
Error in mutate(., city = stringr::str_extract(file, "sydney|brisbane")): object 'weather' not found
```

```r
weather
```

```{.error}
Error in eval(expr, envir, enclos): object 'weather' not found
```

Now if we repeat the same summary as before, we get an output that's a bit easier to read.


```r
weather %>% 
  group_by(city) %>% 
  summarise(median_min_temp = median(min_temp_c),
            median_max_temp = median(max_temp_c, na.rm=TRUE))
```

```{.error}
Error in group_by(., city): object 'weather' not found
```


#### Mutating multiple columns with `across()`

Let's imagine that the calibration was wrong for both temperature sensors, and all the temperature measurements are out by 1°C.  We'd like to add 1 to each of the temperature measurements. There are multiple columns that contain temperatures, so we could do this:


```r
weather %>% 
  mutate(min_temp_c = min_temp_c + 1,
         max_temp_c = max_temp_c + 1,
         temp_9am_c = temp_9am_c + 1,
         temp_3pm_c = temp_3pm_c + 1) 
```

```{.error}
Error in mutate(., min_temp_c = min_temp_c + 1, max_temp_c = max_temp_c + : object 'weather' not found
```


But it's a bit annoying to type out each column.  Instead, we can use `across()` inside `mutate()` to apply the same transformation to all columns whose name contains the string "temp".  The syntax is a little complicated, so don't worry if you don't get it straight away.  We use the `contains()` function to get the columns we want (by matching the regex "temp"), and then to each of these columns we add one - the `.` will be replaced by the name of each column when the expression is evaluated.



```r
weather %>% 
  mutate(across(contains("temp"), ~.+1))
```

```{.error}
Error in mutate(., across(contains("temp"), ~. + 1)): object 'weather' not found
```

Equivalently, we could also use a function to make the transformation.


```r
weather %>% 
  mutate(across(contains("temp"), function(x){
    return(x+1)
  }))
```

```{.error}
Error in mutate(., across(contains("temp"), function(x) {: object 'weather' not found
```

### Filtering rows with `filter()`

Let's say that now we want information about days that were cloudy - for example, those where there were fewer than 10 sunshine hours.  We can use `filter()` to get only those rows.


![`dplyr::filter()`](https://ab604.github.io/docs/coding-together-2019/img/dplyr_filter.png)


```r
weather %>% 
  filter(sunshine_hours < 10)
```

```{.error}
Error in filter(., sunshine_hours < 10): object 'weather' not found
```


::::::::::::: challenge


#### Challenge 3: Is it better to live in Sydney or Brisbane?

Combine `filter()` with `group_by()`,`summarise()` and `n()` to count the number of days when there were more than 10 hours of sunshine in each city.

::::::::: solution


```r
weather %>% 
  filter(sunshine_hours > 10) %>% 
  group_by(city) %>% 
  summarise(n_days = n())
```

```{.error}
Error in filter(., sunshine_hours > 10): object 'weather' not found
```

There were more days with more than 10 hours of sunlight in Brisbane than in Sydney.  I'll let you draw your own conclusions.

::::::::::::::::::

:::::::::::::::::::::::

#### Complex filters with `case_when()`

Let's say we wanted to keep only the rows from sunny, warm days and cloudy, cold days.  We could do this just with one logical expression.


```r
weather %>% 
  filter((sunshine_hours > 10 & max_temp_c > 25) | (sunshine_hours < 10 & max_temp_c < 15))
```

```{.error}
Error in filter(., (sunshine_hours > 10 & max_temp_c > 25) | (sunshine_hours < : object 'weather' not found
```

But you can imagine that with more conditions, this can get a bit messy.  I prefer to use `case_when()` in such situations:


```r
weather %>% 
  filter(case_when(
    sunshine_hours > 10 & max_temp_c > 25 ~ TRUE,
    sunshine_hours < 10 & max_temp_c < 15 ~ TRUE,
    TRUE ~ FALSE
  ))
```

```{.error}
Error in filter(., case_when(sunshine_hours > 10 & max_temp_c > 25 ~ TRUE, : object 'weather' not found
```

Essentially, `case_when()` looks at each condition in turn, and if the left part of the expression (before the `~`) evaulates to `TRUE`, then it returns whatever is on the right of the `~`.  

 - We first ask if this row has more than ten sunshine hours and a maximum temperature of more than 25 - if this is the case, we return `TRUE` (and `filter()` retains this row).  
 - Next, we ask if the row has less than ten sunshine hours and a maximum temperature of less than 15, in which case we also return `TRUE`.  
 - If both these statements are `FALSE`, then the `TRUE` on the next line ensures that we don't keep those rows by always returning `FALSE`.


::::::::::::: challenge

#### Challenge 4: Using `case_when()` with `mutate()`

`case_when()` is also quite useful in combination with `mutate()`.  

For example, let's suppose you want to compare the mean relative humidity on about cloudy cold days and sunny hot days. 

You can first use `mutate()` and `case_when()` to create a column that tells which of these categories the day belongs to (`hot_sunny`, `cold_cloudy`, or `neither`), and then use `group_by()` and `summarise()` to get the mean relative humidity at 9am and 3pm.

Write the code to compute this.

::::::::: solution



```r
weather %>% 
  mutate(day_type = case_when(
    sunshine_hours > 10 & max_temp_c > 25 ~ "hot_sunny",
    sunshine_hours < 10 & max_temp_c < 15 ~ "cold_cloudy",
    TRUE ~ "neither"
  )) %>% 
  group_by(day_type) %>% 
  summarise(mean_rel_humid_9am = mean(rel_humid_9am_pc, na.rm=TRUE),
            mean_rel_humid_3pm = mean(rel_humid_3pm_pc, na.rm=TRUE))
```

```{.error}
Error in mutate(., day_type = case_when(sunshine_hours > 10 & max_temp_c > : object 'weather' not found
```

Notice that we didn't actually have any cold cloudy days, but hot sunny days seem to be less humid.

::::::::::::::::::

:::::::::::::::::::::::


#### Filter within groups with `slice_xxx()`

If you want to filter within groups, you could use `filter()` and `group_by()` together - for example if we wanted to know what the hottest day in each city was, 
you might try this:


```r
weather %>% 
  group_by(city) %>% 
  filter(max_temp_c == max(max_temp_c))
```

```{.error}
Error in group_by(., city): object 'weather' not found
```


But it doesn't work!  The reasons why are somewhat technical, so here I'll sidestep them and just give you the solution instead: use `slice_max()`


```r
weather %>% 
  group_by(city) %>% 
  slice_max(order_by=max_temp_c, n=1)
```

```{.error}
Error in group_by(., city): object 'weather' not found
```

If you want the minimum values instead, use `slice_min()` and if you want a random sample, use `slice_sample()`.



::::::::::::: challenge

#### Challenge 5: Hottest days


What is the mean maximum temperature on the 5 hottest days in each city?

::::::::: solution



```r
weather %>% 
  group_by(city) %>% 
  # use with_ties to ensure we only get five rows
  slice_max(order_by=max_temp_c, n=5, with_ties = FALSE) %>% 
  summarise(
    mean_temp = mean(max_temp_c)
  )
```

```{.error}
Error in group_by(., city): object 'weather' not found
```

Ooof, Brisbane was hot!  Maybe this changes your conclusion about which city is better.

::::::::::::::::::

:::::::::::::::::::::::



### Selecting columns with `select()`

If you want to drop or only retain columns from your table, use `select()`.

![`dplyr::select()`](https://ab604.github.io/docs/coding-together-2019/img/dplyr_select.png)

For example, we added a `city` column to our table, so we can drop the `file` column that also contains this information.  


```r
weather %>% 
  select(-file)
```

```{.error}
Error in select(., -file): object 'weather' not found
```

Alternatively, if we only wanted to keep the date, city and the 3pm observations, we can do this as well.


```r
weather %>% 
  select(date, city, contains("3pm"))
```

```{.error}
Error in select(., date, city, contains("3pm")): object 'weather' not found
```

### Sorting rows with `arrange()`

You can re-order the rows in a table by the values in one or more columns using `arrange()`.

![`dplyr::arrange()`](https://ab604.github.io/docs/coding-together-2019/img/dplyr_arrange.png)
Here I sort for the hottest days, using `desc()` to get the maximum temperatures in descending order.



```r
weather %>% 
  arrange(desc(max_temp_c))
```

```{.error}
Error in arrange(., desc(max_temp_c)): object 'weather' not found
```




### Joining data  

![left join](https://ab604.github.io/docs/coding-together-2019/img/left_join.png)

![inner join](https://ab604.github.io/docs/coding-together-2019/img/inner_join.png)

#### Filtering joins



![Semi join](https://ab604.github.io/docs/coding-together-2019/img/semi_join.png)


![Anti join](https://ab604.github.io/docs/coding-together-2019/img/anti_join.png)

## Useful links and acknowlegements

 - 
 - I've borrowed figures (and inspiration) from the excellent [coding togetheR course material](https://ab604.github.io/docs/coding-together-2019/data-wrangle-1.html)


::::::::::::::::::::::::::::::::::::: keypoints 

- Use `.md` files for episodes when you want static content
- Use `.Rmd` files for episodes when you need to generate output
- Run `sandpaper::check_lesson()` to identify any issues with your lesson
- Run `sandpaper::build_lesson()` to preview your lesson locally

::::::::::::::::::::::::::::::::::::::::::::::::

