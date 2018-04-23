#' Retrieve metadata and full text for Presidential Inaugural Addresses
#'
#' @md
#' @references <http://www.presidency.ucsb.edu/inaugurals.php>
#' @export
#' @examples
#' inaug_df <- app_get_inaugurals()
app_get_inaugurals <- function() {

  .get_ia <- function(ia_id) {

    sprintf("http://www.presidency.ucsb.edu/ws/index.php?pid=%s", ia_id) %>%
      purrr::map(xml2::read_html) %>%
      purrr::map_chr(~{

        # get the text of the span itself since it's super bad HTML
        rvest::html_nodes(.x, xpath="//span[@class = 'displaytext']/text()") %>%
          rvest::html_text() -> span_txt

        # get the rest of the span (ugh)
        rvest::html_nodes(.x, xpath="//span[@class = 'displaytext']") %>%
          rvest::html_children() %>%
          purrr::map_chr(rvest::html_text) -> ia_text

        # smush them together
        paste0(c(span_txt, ia_text), collapse="\n") %>%
          stringi::stri_trim_both()

      })

  }

  pg <- xml2::read_html("http://www.presidency.ucsb.edu/inaugurals.php")

  tab <- rvest::html_node(pg, xpath=".//td/table[tr[contains(td, 'President')]]")

  rows <- rvest::html_nodes(tab, xpath=".//tr[count(td) = 3]")

  purrr::map(rows, rvest::html_nodes, "td") %>%
    purrr::map(rvest::html_text) %>%
    purrr::map(purrr::set_names, c("potus", "date", "word_count")) %>%
    purrr::map(as.list) %>%
    dplyr::bind_rows() %>%
    dplyr::mutate_all(.funs=stringi::stri_trim_both) %>%
    dplyr::mutate(potus = ifelse(potus == "", NA_character_, potus)) %>%
    tidyr::fill(potus) %>%
    tail(-1) %>%
    dplyr::mutate(date = lubridate::mdy(date), word_count=as.integer(word_count)) %>%
    dplyr::mutate(
      ia_id =
        rvest::html_nodes(rows, xpath=".//td[2]") %>%
        purrr::map_chr(~rvest::html_node(.x, "a") %>% rvest::html_attr("href")) %>%
        tail(-1) %>%
        stringi::stri_replace_all_regex("^.*=", "")
    ) %>%
    dplyr::mutate(content = .get_ia(ia_id))

}
