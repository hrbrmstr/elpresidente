
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
  - `app_get_inaugurals`: Retrieve metadata and full text for
    Presidential Inaugural Addresses

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
```

``` r
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

``` r
app_get_inaugurals()
```

    ## # A tibble: 58 x 5
    ##    potus             date       word_count ia_id content                                                               
    ##    <chr>             <date>          <int> <chr> <chr>                                                                 
    ##  1 George Washington 1789-04-30       1431 25800 "Fellow-Citizens of the Senate and of the House of Representatives:\n…
    ##  2 George Washington 1793-03-04        135 25801 "Fellow Citizens:\nI AM again called upon by the voice of my country …
    ##  3 John Adams        1797-03-04       2321 25802 "WHEN it was first perceived, in early times, that no middle course f…
    ##  4 Thomas Jefferson  1801-03-04       1730 25803 "Friends and Fellow-Citizens:\nCALLED upon to undertake the duties of…
    ##  5 Thomas Jefferson  1805-03-04       2166 25804 "PROCEEDING, fellow-citizens, to that qualification which the Constit…
    ##  6 James Madison     1809-03-04       1177 25805 "Unwilling to depart from examples of the most revered authority, I a…
    ##  7 James Madison     1813-03-04       1211 25806 "About to add the solemnity of an oath to the obligations imposed by …
    ##  8 James Monroe      1817-03-04       3375 25807 "I should be destitute of feeling if I was not deeply affected by the…
    ##  9 James Monroe      1821-03-04       4472 25808 "Fellow-Citizens:\nI shall not attempt to describe the grateful emoti…
    ## 10 John Quincy Adams 1825-03-04       2915 25809 "In compliance with an usage coeval with the existence of our Federal…
    ## # ... with 48 more rows
