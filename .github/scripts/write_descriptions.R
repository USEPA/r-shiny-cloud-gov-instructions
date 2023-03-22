library(tools)
tools::write_PACKAGES(dir = args[1], fields = NULL,
               type = c("source"),
               verbose = FALSE, unpacked = FALSE, subdirs = FALSE,
               latestOnly = TRUE, addFiles = FALSE, rds_compress = "xz",
               validate = FALSE)
