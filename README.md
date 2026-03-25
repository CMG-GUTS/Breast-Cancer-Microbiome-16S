# Introduction
Data analysis of **Impact of neoadjuvant chemotherapy on local breast microbiota and macrophages in ER-positive breast cancer: shifts in density, composition, and links to treatment response**

The current data analysis was performed with an R version of 4.3.3, the `renv` will try to sync the R package versions with your current R version. Unfortunately, using a `conda` environment doesn't work with all R packages, therefore I will leave the R version restrictions to the users end.

You can install all required R packages via `renv::restore()` or you might be prompted to do so at the beginning, see the [docs](https://rstudio.github.io/renv/articles/renv.html) for more information.

## Running the data-analysis workflow
Make sure you have the folders `data` with the neccessary input files from the [paper]().
```bash
Rscript R/00_main.R
```