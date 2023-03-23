library(tools)

args <- commandArgs(trailingOnly = TRUE)

# Test if a package destination directory was passed as an argument
if (length(args) == 0 & dir.exists(args[1])) {
  stop("Usage: R -f write_descriptions.R destination_directory", \
        call. = FALSE)
}

tools::write_PACKAGES(dir = args[1], fields = NULL,
               type = c("source"),
               verbose = FALSE, unpacked = FALSE, subdirs = FALSE,
               latestOnly = TRUE, addFiles = FALSE, rds_compress = "xz",
               validate = FALSE)
