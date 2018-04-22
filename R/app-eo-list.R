#' Retieve a data frame of metadata about Executive Orders issues in a given year
#'
#' @md
#' @param year a value > 1826 and less then last month's year
#' @return data frame (tibble) of `potus`, `eo_date`, `eo_title` and `eo_id`;
#'         Use `eo_id` for calls to [app_get_eo()].
#' @export
#' @references <http://www.presidency.ucsb.edu/data/orders.php>
#' @examples
#' app_eo_list(1826)
#' app_eo_list(2014)
app_eo_list <- function(year) {

  # only handle one year
  year <- year[1]

  # none before!
  stopifnot(year >= 1826)

  # read the page
  xml2::read_html(
    sprintf("http://www.presidency.ucsb.edu/executive_orders.php?year=%s&Submit=DISPLAY", year)
  ) -> pg

  # yank out the table
  tab <- html_nodes(pg, xpath=".//form/following-sibling::table[tr[contains(td, 'President')]]")

  data_frame(

    potus = html_nodes(tab, xpath=".//td[1]") %>%       # POTUS name
      html_text() %>%
      .[-1],

    eo_date = html_nodes(tab, xpath=".//td[2]") %>%     # EO release date
      html_text() %>%
      .[-1] %>%
      lubridate::mdy(),

    eo_title = html_nodes(tab, xpath=".//td[3]/a") %>%  # Title
      html_text(),

    eo_id = html_nodes(tab, xpath=".//td[3]/a") %>%     # APP ID
      html_attr("href") %>%
      stringi::stri_replace_all_regex("^.*=","")

  )

}

