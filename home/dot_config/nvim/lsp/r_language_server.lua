return {
  cmd = { "R", "--no-echo", "-e", "languageserver::run()" },
  filetypes = { "r", "rmd", "quarto" },
  root_markers = {".git", ".Rproj"}
}
