
# elpresidente

## Description

Methods are provided that let you search and extract corpus elements
from ‘The American Presidency Project’ <http://www.presidency.ucsb.edu>.

## What’s Inside The Tin

The following functions are implemented:

  - `app_eo_list`: Retieve a data frame of metadata about Executive
    Orders issues in a given year
  - `app_get_eo`: Retrieve metadata and full text of an executive order
    by APP id

## Installation

``` r
devtools::install_github("hrbrmstr/elpresidente")
```

## Usage

``` r
library(elpresidente)

# current verison
packageVersion("elpresidente")
```

    ## [1] '0.1.0'

## Example

``` r
library(purrr)
library(tidyr)
library(dplyr)

app_eo_list(1826) %>%
  mutate(eo_info = map(eo_id, app_get_eo)) %>%
  unnest() %>%
  glimpse()
```

    ## Observations: 1
    ## Variables: 9
    ## $ potus    <chr> "John Quincy Adams"
    ## $ eo_date  <date> 1826-07-11
    ## $ eo_title <chr> "Executive Order"
    ## $ eo_id    <chr> "66658"
    ## $ date     <date> 1826-07-11
    ## $ eo_num   <lgl> NA
    ## $ title    <chr> NA
    ## $ potus1   <chr> "John Quincy Adams"
    ## $ eo_text  <chr> "ADJUTANT-GENERAL'S OFFICE,\n GENERAL ORDERS.\nThe General in Chief has received from the Departme...

``` r
app_eo_list(2014) %>%
  mutate(eo_info = map(eo_id, app_get_eo)) %>%
  unnest() %>%
  glimpse()
```

    ## Observations: 31
    ## Variables: 9
    ## $ potus    <chr> "Barack Obama", "Barack Obama", "Barack Obama", "Barack Obama", "Barack Obama", "Barack Obama", "B...
    ## $ eo_date  <date> 2014-01-17, 2014-02-10, 2014-02-12, 2014-02-19, 2014-03-06, 2014-03-16, 2014-03-20, 2014-03-20, 2...
    ## $ eo_title <chr> "Executive Order 13656—Establishment of the Afghanistan and Pakistan Strategic Partnership Office ...
    ## $ eo_id    <chr> "104627", "104736", "104737", "104775", "104791", "104855", "104854", "104911", "104910", "104909"...
    ## $ date     <date> 2014-01-17, 2014-02-10, 2014-02-12, 2014-02-19, 2014-03-06, 2014-03-16, 2014-03-20, 2014-03-20, 2...
    ## $ eo_num   <chr> "13656", "13657", "13658", "13659", "13660", "13661", "13662", "13663", "13664", "13665", "13666",...
    ## $ title    <chr> "Establishment Of The Afghanistan And Pakistan Strategic Partnership Office And Amendment To Execu...
    ## $ potus1   <chr> "Barack Obama", "Barack Obama", "Barack Obama", "Barack Obama", "Barack Obama", "Barack Obama", "B...
    ## $ eo_text  <chr> "By the authority vested in me as President by the Constitution and the laws of the United States ...
