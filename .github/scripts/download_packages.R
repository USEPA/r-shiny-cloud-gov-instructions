library(stringr)
args <- commandArgs(trailingOnly = TRUE)

repoUrl = "https://packagemanager.rstudio.com/cran/__linux__/bionic/latest"

# Test if a package destination directory was passed as an argument
if (length(args) == 0) {
  stop("Usage: R -f download_packages.R destination_directory package1,package2,package3", call. = FALSE)
}

# Create the directory
if (!dir.exists(args[1])) {
        # message("Creating the directory")
        dir.create(args[1], recursive = TRUE)
}

# Split the packages into a character list
input_packs <- unlist(str_split(args[2], ","))

# message(input_packs)

options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), 
        paste(getRversion(), R.version["platform"], R.version["arch"], R.version["os"])))

# Get packages function to get the packages and dependencies
get_packages <- function(packs) {
        # message("Getting the package dependencies")
        packages <- unlist(
                tools::package_dependencies(packs, available.packages(),
                        which = c("Depends", "Imports"), recursive = TRUE
                )
        )
        # message("...but need to skip those that already exist in the cloud.gov buildpack")
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
# message(paste("Downloading the packages and dependencies to", args[1], sep = " "))

download.packages(setdiff(packages, c("sf")), destdir = args[1], repos = repoUrl)

if ("sf"  %in% packages) {
        dir.create("junktemp")
        download.packages(c("sf"), destdir = "junktemp", repos = repoUrl)
        sf_pkg <- list.files("junktemp")[1]
        devtools::build(pkg = paste(args[1], sf_pkg, sep = "/"), binary = TRUE)
        unlink("junktemp", recursive = TRUE)
        write("has_sf=TRUE", stdout())
} else {
        write("has_sf=FALSE", stdout())
}

# message("Completed downloading packages")

library(tools)

tools::write_PACKAGES(dir = args[1], fields = NULL,
               type = c("source"),
               verbose = FALSE, unpacked = FALSE, subdirs = FALSE,
               latestOnly = TRUE, addFiles = FALSE, rds_compress = "xz",
               validate = FALSE)
