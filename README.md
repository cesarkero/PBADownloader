PBADownloader 0.1.0
================
2021-02-01

-----

# Description

# Installation

This packages has been tested in:

  - Ubuntu 20.04 with R 4.0.3
  - Windows 10 with R 4.0 + Rtools40

Install dependencies (libraries) in R:

``` r
# install libraries to install packages from github
install.packages("devtools"); library(devtools)

install_github("cesarkero/PBADownloader")
```

# Before try out

Please, use this library using your brain. Download just what you need
and avoid constant masive downloads as it will produce overload in
public servers and this can lead to restrictions for the general public.
So please, be kind with the service and let us all enjoy this data. For
sure, don’t try parallel for masive downloads until you have checked
that this is a useful tool to you.

Moreover, if you just need the layers for a single or a few
municipalities, just use the web [Plan Básico
Autonómico](http://mapas.xunta.gal/visores/descargas-pba/).

[![Plan Básico
Autonómico](./man/figures/I00.png)](http://mapas.xunta.gal/visores/descargas-pba/)

Enjoy.

-----

# Examples

## Single Province download

The library already contains the data with the names and composed urls.
Just load it and show it to get the name of the desired municipality. It
works also with a list of municipalities. Be patient as the function
contains an sleep of 60s between executions in order to avoid crushing
server.

``` r
#-------------------------------------------------------------------------------
# PARAMETERS
# read data
data("pbaurls")
outdir <- '../02_OUTPUT/'

# show municipalities available
pbaurls$Concello

#-----------------------------------------------------------------------
# Single execution
PBADownloader("Beade", outdir)

# Single execution in a serie of municipalities (on by one)
concellos <- c("Paderne", "Pol","A Peroxa", "Sarria",
               "Taboada", "Parada De Sil", "Vedra")
lapply(concellos, PBADownloader, outdir)

# Download all
concellos <- pbaurls$Concello
lapply(concellos, PBADownloader, outdir)
```

<div class="figure" style="text-align: center">

<img src="./man/figures/I00.png" alt="Screenshots of generated files (.gpkg) for several excutions" width="100%" />

<p class="caption">

Screenshots of generated files (.gpkg) for several excutions

</p>

</div>

## Parallel process for several municipalities

``` r
# execute in parallel
pbaurls$Concello # show municipalities available
concellos <- c("Paderne", "Pol","A Peroxa", "Sarria")
parPBADownloader(concellos, outdir, ncores = 5)

# DOWNLOAD ALL IN PARALLEL  (BE CAREFUL...)
concellos <- pbaurls$Concello
parPBADownloader(concellos, outdir, ncores = 6)
```

<div class="figure" style="text-align: center">

<img src="./man/figures/I00.png" alt="Some example of buildingparts" width="100%" />

<p class="caption">

Some example of
buildingparts

</p>

</div>

## PBAmixer: this allows the user to condense all the downloaded layers into a single file

``` r
#' outdir <- '../02_OUTPUT/'
#' PBAmixer(outdir)
```

<div class="figure" style="text-align: center">

<img src="./man/figures/I00.png" alt="Some example of buildingparts" width="100%" />

<p class="caption">

Some example of buildingparts

</p>

</div>

## Screenshots of the results

<p align="center">

<img width="300" src="./man/figures/I00.png">

</p>

#### Screenshot of Ceuta

<p align="center">

<img width="800" src="./man/figures/I00.png">

</p>

#### Detail of Ceuta

<p align="center">

<img width="800" src="./man/figures/I00.png">

</p>

#### Screenshot of Orense (somewhere)

<p align="center">

<img width="800" src="./man/figures/I00.png">

</p>

# Notes for the future:

-----

# Corrections:

  - It could be interesting to mix the layers into a single layer by
    categorie.
