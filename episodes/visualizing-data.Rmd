---
title: 'Data visualization'
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions 

- How do you visualize data using `ggplot2`?
- How can you combine individual plots?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Understand how to use aesthetics to create plots
- Use geoms to create visualizations
- Know how to facet to split by grouping variables
- Modify visual elements using themes
- Combine plots using `patchwork`


::::::::::::::::::::::::::::::::::::::::::::::::


After all of that data manipulation perhaps you, like me, are a bit sick of looking at tables.  Using visualizations is essential for communicating your results, especially in large datasets.  

There is lots of thinking about the best way to represent a given dataset, but one popular framework is the ['grammar of graphics' approach](http://vita.had.co.nz/papers/layered-grammar.pdf).  The idea here is to build up a graphic from multiple layers of components, including:

 - data and aesthetic mappings
 - geometric objects
 - scales
 - facets
 
 


::::::::::::::::::::::::::::::::::::: keypoints 

- Use `.md` files for episodes when you want static content
- Use `.Rmd` files for episodes when you need to generate output
- Run `sandpaper::check_lesson()` to identify any issues with your lesson
- Run `sandpaper::build_lesson()` to preview your lesson locally

::::::::::::::::::::::::::::::::::::::::::::::::

