# How to deploy R Shiny apps to cloud.gov

1. Install the Cloud Foundry CLI (Command Line Interface):
  - [Cloud.gov setup documentation](https://cloud.gov/docs/getting-started/setup/)

2. Add a manifest.yml file to your project. This is an example for an app named "shiny-app-test" which uses 256 MB of memory:
```
applications:
- name: shiny-app-test
  memory: 256M
  routes:
    - route: shiny-app-test.app.cloud.gov
  disk_quota: 1G
  buildpacks:
     - r_buildpack
  command: R -f shiny.R
```
Note that cloud.gov charges for memory use, so it's best to find the level that your app needs without making it too high.

3. Add an r.yml file that lists all of the packages your app needs (typically, anything called in a library command). For example, with an app that used shinyjs, ggpubr, readr, dplyr, and shinyWidgets, the r.yml would look like:
```
packages:
- cran_mirror: https://raw.githubusercontent.com/USEPA/cflinuxfs3-CRAN/master/cflinuxfs3/
  num_threads: 2
  packages:
    - name: shinyjs
    - name: ggpubr
    - name: readr
    - name: dplyr
    - name: shinyWidgets
```
Note: cloud.gov already has a set of common R dependencies (shiny, forecast, Rserve, and plumber), including all of their dependencies. You do not need to include those in your r.yml. You can view a full list of what's already available by running:
```
library('miniCRAN')
pkgsInBuildpack <- sort(pkgDep(c("shiny", "forecast", "Rserve", "plumber"), suggests = TRUE, enhances = FALSE))
pkgsInBuildpack
```

4. Add a shiny.R file with settings for cloud.gov:
```
library(shiny)
runApp(host="0.0.0.0", port=strtoi(Sys.getenv("PORT")))
```

5. It's also generally a good idea to add a .cfignore file with files that cloud.gov should skip. For example:
```
*.Rproj
```

6. Log into cloud.gov on Windows
  - In the Windows command line, log into cloud.gov with the command (Note: you may need to replace the cf with cf7 or cf8 depending on your CLI version):
    - `cf login -a api.fr.cloud.gov  --sso`
  - Go to https://login.fr.cloud.gov/passcode, log in, and copy the passcode
  - Back in the command line, left-click to paste the passcode and login
7. Navigate to your project's directory (in Windows, the cd command followed by the folder name will move to a folder; the tab key will complete the folder's name to save some typing) and then push your app to cloud.gov with the command:
```
cf push
```

## Missing packages
If a package you need is missing, use the [issues here to request it](https://github.com/USEPA/cflinuxfs3-CRAN)

## Additional note about R Shiny apps with GIS/geospatial dependencies
Certain R packages (such as sp, sf, rgdal, or rgeos) depend on libraries not available within the standard cloud.gov buildpack. EPA has a [repo to provide those libraries](https://github.com/USEPA-Temp/generate-r-cloud-gov-libraries).
