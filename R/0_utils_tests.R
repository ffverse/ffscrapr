#' @export
#' @noRd
.cache_path <- function() {
  file.path(
    rappdirs::user_cache_dir("ffscrapr", appauthor = "ffverse"),
    "test_cache"
  )
}

.bypass_mocks <- function() {
  identical(Sys.getenv("MOCK_BYPASS"), "true")
}

.rebuild_mocks <- function() {
  identical(Sys.getenv("MOCK_REBUILD"), "true")
}

github_online <- function(){
  !identical(curl::nslookup("github.com"),"")
}

.test_release_name <- function(){
  v <- utils::packageVersion("ffscrapr")
  # if version has four components, use devel
  if(!is.na(v[1,4])){
    v <- "devel"
  }
  paste0("tests-", as.character(v))
}

.upload_cache <- function(cache_path){
  rlang::check_installed(c("piggyback", "cli", "httptest"))
  cli::cli_inform("Uploading tests to release { .test_release_name()}")
  suppressMessages(
    withr::with_dir(
      .cache_path(),
      utils::zip("cache.zip", list.files(pattern = "[^cache.zip]", recursive = TRUE))
    )
  )
  release_name <- .test_release_name()
  suppressWarnings({
    piggyback::pb_release_create(
      repo = "ffverse/ffscrapr",
      tag = .test_release_name(),
      name = .test_release_name(),
      draft = TRUE
    )
  })
  piggyback::pb_upload(
    file.path(.cache_path(), "cache.zip"),
    repo = "ffverse/ffscrapr",
    tag = .test_release_name(),
    overwrite = TRUE
  )
  cli::cli_inform("Finished uploading tests to release { .test_release_name()}")
  invisible(TRUE)
}

#' @export
#' @noRd
.download_cache <- function(){
  rlang::check_installed(c("piggyback", "cli", "httptest"))
  cli::cli_inform("Using mocked tests")
  # unlink(.cache_path(), force = TRUE, recursive = TRUE)
  suppressWarnings(dir.create(.cache_path(), recursive = TRUE))
  cli::cli_inform("Downloading cache from { .test_release_name()}")
  tryCatch({
    piggyback::pb_download(
      "cache.zip",
      dest = .cache_path(),
      repo = "ffverse/ffscrapr",
      tag = .test_release_name()
    )
    utils::unzip(file.path(.cache_path(), "cache.zip"), overwrite = TRUE, exdir = .cache_path())
  },
  error = function(cond) {
    cli::cli_warn(cond)
    cli::cli_alert("Cleaning up download attempt")
    unlink(.cache_path(), recursive = TRUE)
  })

  httptest::.mockPaths(.cache_path())
}
