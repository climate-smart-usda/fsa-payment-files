library(magrittr)
library(tidyverse)
library(furrr)
library(openxlsx2)
options("openxlsx2.maxWidth" = 64)

update_payments <- TRUE

if(update_payments){
  xml2::read_html("https://www.fsa.usda.gov/news-room/efoia/electronic-reading-room/frequently-requested-information/payment-files-information/index") %>%
    xml2::xml_find_all(".//a") %>%
    xml2::xml_attr("href") %>%
    stringr::str_subset("xls") %>%
    {tibble::tibble(
      request = file.path("https://www.fsa.usda.gov",.),
      outfile = file.path("raw-payment-files", 
                          basename(.))
    )} %$%
    curl::multi_download(urls = request,
                         destfiles = outfile,
                         resume = TRUE)
  
  plan(multisession, workers = 8)
  
  list.files("raw-payment-files",
             full.names = TRUE) %>%
    furrr::future_map_dfr(readxl::read_excel, 
                          col_types = "text") %>%
    dplyr::mutate(`Payment Date` = lubridate::as_date(as.numeric(`Payment Date`), origin = "1899-12-30"),
                  `Disbursement Amount` = as.numeric(`Disbursement Amount`),
                  `Accounting Program Year` = as.integer(`Accounting Program Year`),
                  `Accounting Program Description` = stringr::str_trim(stringr::str_squish(`Accounting Program Description`)),
                  `State FSA Code` = stringr::str_pad(`State FSA Code`, width = 2, side = "left", pad = "0"),
                  `County FSA Code` = stringr::str_pad(`State FSA Code`, width = 3, side = "left", pad = "0"),
                  `FSA Code` = paste0(`State FSA Code`, `County FSA Code`),
                  `Delivery Address Line` = ifelse(is.na(`Delivery Address Line`), `Delivery Address`, `Delivery Address Line`)
    ) %>%
    dplyr::select(`Accounting Program Year`,
                  `Accounting Program Code`,
                  `Accounting Program Description`,
                  `FSA Code`,
                  `County FSA Name`,
                  `State FSA Name`,
                  `Payment Date`,
                  `Disbursement Amount`,
                  `Formatted Payee Name`,
                  `Address Information Line`,
                  `Delivery Address Line`,
                  `City Name`,
                  `State Abbreviation`,
                  `Zip Code`,
                  `Delivery Point Bar Code`) %>%
    dplyr::arrange(`Accounting Program Year`,
                   `Accounting Program Code`,
                   `FSA Code`,
                   `County FSA Name`,
                   `State FSA Name`,
                   `Formatted Payee Name`) %>%
    dplyr::group_by( `Accounting Program Year`, `Accounting Program Code`, `FSA Code`) %>%
    arrow::write_dataset(path = "parquet",
                         format = "parquet")
  
  plan(sequential)
}
