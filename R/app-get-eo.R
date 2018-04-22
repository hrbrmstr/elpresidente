#' Retrieve metadata and full text of an executive order by APP id
#'
#' The APP has an id for each executive order. Use [app_eo_list()] to
#' find them and then call this function with one of those `eo_id`s.
#'
#' @md
#' @param eo_id a valid APP EO id (via [app_eo_list()])
#' @return data frame (tibble) with `date`, `eo_num`, `title`, `potus`, `eo_text`;
#'         NOTE that `eo_num` will be `NA` for older EOs without actual numbers.
#'         The `title` and `potus` and `date` should match up with the metadata
#'         retrieved in [app_eo_list()]. Fields may be `NA` also due them being
#'         missing.
#' @export
#' @references <http://www.presidency.ucsb.edu/data/orders.php>
#' @examples
#' app_get_eo(104775)
app_get_eo <- function(eo_id) {

  # can only be one eo_id
  eo_id <- eo_id[1]

  # get the page
  xml2::read_html(
    sprintf("http://www.presidency.ucsb.edu/ws/index.php?pid=%s", eo_id)
  ) -> pg

  # get the ugly title that we have to break down
  rvest::html_node(pg, xpath=".//title/following-sibling::meta") %>%
    rvest::html_attr("content") -> title_combined

  # get the text of the span itself since it's super bad HTML
  rvest::html_nodes(pg, xpath="//span[@class = 'displaytext']/text()") %>%
    html_text -> span_txt

  # get the rest of the span (ugh)
  rvest::html_nodes(pg, xpath="//span[@class = 'displaytext']") %>%
    rvest::html_children() %>%
    purrr::map_chr(html_text) -> eo_text

  # smush them together
  paste0(c(span_txt, eo_text), collapse="\n") %>%
    stri_trim_both() -> eo_text

  # now try to parse the horribad title
  stringi::stri_split_regex(title_combined, "[:\u2014]| - ") %>%
    purrr::flatten_chr() %>%
    stri_trim_both() -> bits

  # older ones do not have all the info we need
  if (length(bits) == 3) {

    purrr::set_names(bits, c("potus", "title", "date")) %>%
      list() %>%
      purrr::flatten_dfc() %>%
      mutate(eo_num = NA_character_) -> eo_meta

  } else if (length(bits) == 4) { # newer ones do

    purrr::set_names(bits, c("potus", "eo_num", "title", "date")) %>%
      list() %>%
      purrr::flatten_dfc() -> eo_meta

  }

  # return a data frame

  dplyr::data_frame(
    title_combined = title_combined,
    eo_text = eo_text,
    eo_meta = list(eo_meta)
  ) %>%
    tidyr::unnest() %>%
    dplyr::mutate(title = ifelse(title == "Executive Order", NA_character_, title)) %>%
    dplyr::mutate(title = stringi::stri_trans_totitle(title)) %>%
    dplyr::mutate(eo_num = stringi::stri_replace_all_regex(eo_num, "[^[:digit:]]", "")) %>%
    dplyr::mutate(eo_num = ifelse(eo_num == "", NA_character_, eo_num)) %>%
    dplyr::mutate(date = lubridate::mdy(date)) %>%
    dplyr::select(date, eo_num, title, potus, eo_text)

}