library(stringr)
args <- commandArgs(trailingOnly = TRUE)

# Test if a package destination directory was passed as an argument
if (length(args) == 0) {
  stop("Usage: R -f download_packages.R destination_directory package1,package2,package3", call. = FALSE)
}

# Create the directory
if (!dir.exists(args[1])) {
        write("Creating the directory", stdout())
        dir.create(args[1], recursive = TRUE)
}

# Split the packages into a character list
input_packs <- unlist(str_split(args[2], ","))

message(input_packs)

# Sets the default user agent for binary package downloads
write("Setting the user agent for binary package downloads", stdout())
options(HTTPUserAgent = sprintf(
        "R/%s R (%s)",
        "4.2.2",
        paste(
                "4.2.2",
                "x86_64-pc-linux-gnu",
                "x86_64",
                "linux-gnu"
        )
))

# Set the repo to the binary distro url
message("Setting the repository url")
options(repos = "https://packagemanager.rstudio.com/cran/__linux__/bionic/latest")

# Get packages function to get the packages and dependencies
get_packages <- function(packs) {
        message("Getting the package dependencies")
        packages <- unlist(
                tools::package_dependencies(packs, available.packages(),
                        which = c("Depends", "Imports"), recursive = TRUE
                )
        )
        message("...but need to skip those that already exist in the cloud.gov buildpack")
        buildpack_includes <- c("shiny", "forecast", "Rserve", "plumber")
        packages_in_buildpack <- unlist(
                tools::package_dependencies(buildpack_includes, available.packages(),
                        which = c("Depends", "Imports"), recursive = TRUE
                )
        )
        packages <- setdiff(union(packs, packages), union(packages_in_buildpack, buildpack_includes))
        packages
}

# Get the package dependencies
packages <- get_packages(input_packs)

# Download the packages from the repository
message(paste("Downloading the packages and dependencies to", args[1], sep = " "))
download.packages(packages, destdir = args[1])

message("Completed downloading packages")

library(tools)
write_PACKAGES(dir = args[1], fields = NULL,
               type = c("source"),
               verbose = FALSE, unpacked = FALSE, subdirs = FALSE,
               latestOnly = TRUE, addFiles = FALSE, rds_compress = "xz",
               validate = FALSE)
