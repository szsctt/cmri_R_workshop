---
title: "Introduction to R and Rstudio"
teaching: 45
exercises: 10
---



:::::::::::::::::::::::::::::::::::::: questions 

- How do I use the RStudio IDE?
- What are the basics of R?
- How do I install packages?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Understand the panes of the RStudio IDE
- Understand how to interact with the RStudio IDE
- Demonstrate how to include pieces of code, figures, and nested challenge blocks

::::::::::::::::::::::::::::::::::::::::::::::::


## Why R?

The `R` language is one of the most commonly used languages in bioinformatics, and data science more generally.  It's a great choice for you because:

 - Reproducibility: Scripting your analysis makes it easier for someone else to repeat and for you to re-use and extend
 - Power: `R` can be used to work with datasets larger than you can in Prism or Excel
 - [Open source](https://en.wikipedia.org/wiki/Open_source): So it's free!
 - Community:  `R` is a popular choice for data science, so there are many resources available for [learning](https://swcarpentry.github.io/r-novice-gapminder/) and [debugging](https://stackoverflow.com/questions/tagged/r)
 - Packages:  Since the community is large, many people have written helpful packages that can help you do tasks more easily than if you'd had to start from scratch

## Introduction to RStudio

`RStudio` is an [integrated development environment](https://en.wikipedia.org/wiki/Integrated_development_environment) that makes it much easier to work with the `R` language.  It's free, cross-platform and provides many benefits such as project management and version control integration.

When you open it, you'll see something like this:


![](episodes/fig/rstudio1.png)

The four main panes are:

 - Top left: editor. For editing scripts and other source code
 - Bottom left: console.  For running code
 - Top right: environment. Information about objects you create will appear here
 - Bottom right: plots (amongst other things). Some output (like plots) from the console appears here.  Also helpful for browsing files and getting help


 
### Using the editor

Use the editor to write scripts and `Rmarkdown` documents.  Although you can also type commands directly into the console, keeping your commands together in a script helps organise your analysis.


The editor also helps you identify issues with your code by placing a cross where it doesn't understand something.

![](episodes/fig/rstudio2.png)

Hover over the cross to get more information

![](episodes/fig/rstudio3.png)


 
### Using the console

The console is where you can type in `R` commands and see their output. You can type R commands directly in here, or press <kbd>Ctrl</kbd>/<kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>Enter</kbd> to 'send' them from the editor to the console


#### As a calculator

The most basic way we can use R is as a calculator:


```r
1 + 1
```

```{.output}
[1] 2
```


If you type an incomplete command, you'll see a `+`:

```r
1 +
```
```output
+
```

Finish typing the command to get back to the prompt (`>`).


The order of operations is as you would expect:

 - Parentheses `(`, `)`
 - Exponents `^` or `**`
 - Multiply `*`
 - Divide `/`
 - Add `+`
 - Subtract `-`
 

::::::::::::::::::::::::::::::::::::: challenge 

## Challenge 1: Operators


How would you use R to compute $\frac{9}{3 + 6}$?

:::::::::::::::::::::::: solution 

## Show me the solution
 

```r
3 / (3 + 6)
```

```{.output}
[1] 0.3333333
```

:::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::


### Comments

Anything that comes after a `#` character will be ignored by `R`: use this to annotate your code.  


```r
# this is a comment
1 + 2 # this is also a comment
```

```{.output}
[1] 3
```

```r
# the line below won't be executed
# 1 + 1
```


This is very important!!!  A key part of reproducibility is knowing what code does.  Make it easier for others and your future self by adding lots of comments to your code.

### Functions

A function is just something that takes zero or more inputs, does something with it, and gives you back an output.  `R` comes with many functions that someone else wrote.

For example, the `getwd` function takes no inputs, and returns the current working directory. When working in RStudio, this should be the path to your project root.

```r
# a function that takes no inputs
getwd()
```

R also has many mathematical functions:


```r
# natural logarithm
log(1)
```

```{.output}
[1] 0
```

```r
# rounding
round(0.555555, digits=3)
```

```{.output}
[1] 0.556
```

```r
# statistical analysis
t.test(c(1, 2.5, 8, 1), c(1000, 1001, 3000, 5000))
```

```{.output}

	Welch Two Sample t-test

data:  c(1, 2.5, 8, 1) and c(1000, 1001, 3000, 5000)
t = -2.6085, df = 3, p-value = 0.07979
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -5543.6641   549.4141
sample estimates:
mean of x mean of y 
    3.125  2500.250 
```

You don't need to memorize all these functions: Google is your friend.

Rstudio can also help you with function usage. If you know what the name of a function is but can't remember how to use it, you can type `?` before the function name in the console to get help on that function.

```r
?sin
```

If you don't know what the name of a function is, you can type `??` before a key word to search the documentation for that key word.

```r
??trig
```


You can even write your own functions:


```r
# function to add two numbers
my_add <- function(num1, num2) {
  return(num1 + num2)
}
my_add(1,1)
```

```{.output}
[1] 2
```

::::::::::::::::::::::::::::::::::::: challenge 

## Challenge 2: Functions


Use the R console to get help on the `rnorm` function

:::::::::::::::::::::::: solution 

## Show me the solution
 
```r
?rnorm
```

:::::::::::::::::::::::::::::::::

Use the `rnorm` function to generate 5 numbers from a normal distribution with a mean of 1 and a standard deviation of 2.

:::::::::::::::::::::::: solution 

## Show me the solution
 

```r
rnorm(5, mean=1, sd=2)
```

```{.output}
[1] -0.8220397  0.5628253  2.8217088 -2.4859333 -2.0476399
```

:::::::::::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: callout

Function arguments can be *named* or *unnamed*.

::::::::::::::::::::::::::::::::::::::::::::::::

## Best practices

Now you know the basics of `R`, there are a few best practices that you should follow on your journey.  These aren't hard and fast rules, but principles that you should aim to follow to make your code better and more reproducible.



### Formatting and readability matters

You should always be able to come back to your code after a long break (months, years) and easily understand what it does.

One thing that helps with this is to follow a style guide like [this one for the tidyverse](https://style.tidyverse.org/)

This covers things like:

 - Commenting:  do this a lot!  It's better to have more comments than fewer
 - Each script should start with a description of what it does or what it's for
 - When you have to name something, use a name that makes sense.  You're more likely to understand what is contained in variable `my_peptide` than you are if it was called `p` or `x` or `owobljldfibllkmb`
 - Syntax and spacing: use spaces and newlines to make your code more readable, not less
 - Line length: try to make horizontal scrolling unnecssary, which usually means lines are less than 80 characters

 

### Don't copy/paste code

Try to avoid copy-pasting blocks of code.  If you find you need to make a change to that code, you'll need to edit all the copies. If you do this, it's  easy to miss somewhere that you copied it, or make a mistake when you change it.  If you find yourself needing to do the same task many times, it's usually better to write a function instead.  


### Test your expectations

Try to frequently test your code to see that it does what you expect it to do.  Getting into this habbit helps guard against bugs.  

There are lots of different ways to do this, from just trying out the code with a few different inputs to automated [unit testing](https://en.wikipedia.org/wiki/Unit_testing)

Don't forget also to test that your code doesn't do things that you don't expect it to do as well!

```r
# define a function
plus_three <- function(num) {
  return( num + 3 )
}

# should return 11
plus_three(8)

# should return 2
plus_three(-1)

# should raise an error
plus_three("ten")

```

You can use the [function `stopifnot`](https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/stopifnot) to help you check things automatically.

### Project management

Aim to keep your data, scripts and output organized.  `RStudio` helps you with this with Projects, which can be used to store all of the files related to a particular piece of analysis.  People write [whole papers](https://github.com/swcarpentry/good-enough-practices-in-scientific-computing/blob/gh-pages/good-enough-practices-for-scientific-computing.pdf) about this, but here are a few suggestions:

 - Treat raw data and metadata as read-only.  Put it in a folder called `data` and don't write anything to that folder except for more raw data
 - Put source code in a folder called `src`
 - Put files generated during analysis in a folder called `out` or `results`.  It shouldn't matter if this folder gets deleted, since you should be able to re-create its contents using your data and scripts
 - A `README` file can be useful for a broad overview of the project, and for explaning how to run the analysis
 - Keep track of the packages required for your analysis using [`renv`](https://rstudio.github.io/renv/articles/renv.html) (for `R` projects only), or `conda` (more general but has a few gotchas for `R` packages)
 
That is, an organized project might look something like this:

```
my_great_project
├── README.md
├── data
│   ├── dataset_1
│   │   ├── dataset_1.R1.fq.gz
│   │   └── dataset_1.R2.fq.gz
│   ├── dataset_2
│   │   ├── dataset_2_1.R1.fq.gz
│   │   ├── dataset_2_1.R2.fq.gz
│   │   ├── dataset_2_2.R1.fq.gz
│   │   └── dataset_2_2.R2.fq.gz
│   └── metadata
│       ├── metadata_1.tsv
│       └── metadata_2.tsv
├── renv
│   └── activate.R
├── results
│   ├── analyse
│   │   └── fold_change.tsv
│   ├── plot
│   │   ├── phylogeny.pdf
│   │   └── taxa.pdf
│   └── preprocess
│       ├── intermediate_result.tsv
│       ├── mapped.bam
│       └── mapped.bam.bai
└── scripts
    ├── 01_preprocess.R
    ├── 02_analyse.R
    └── 03_plot.R
```
 





::::::::::::::::::::::::::::::::::::: keypoints 

- Use `.md` files for episodes when you want static content
- Use `.Rmd` files for episodes when you need to generate output
- Run `sandpaper::check_lesson()` to identify any issues with your lesson
- Run `sandpaper::build_lesson()` to preview your lesson locally

::::::::::::::::::::::::::::::::::::::::::::::::

[r-markdown]: https://rmarkdown.rstudio.com/

## Acknowledgments

This lesson is inspired by and draws on material from [Software Carpentries introduction to R](https://swcarpentry.github.io/r-novice-gapminder/01-rstudio-intro/index.html), [Intro to R and Rstudio for Genomics](https://datacarpentry.org/genomics-r-intro/00-introduction/index.html).


