# How to deploy R Shiny apps to cloud.gov

1. Install the Cloud Foundry CLI (Command Line Interface):
  - [Cloud.gov setup documentation](https://cloud.gov/docs/getting-started/setup/)

2. Copy the .github/workflows/build-cloud-gov.yml file to your GitHub repo's default branch (with the same directories).

3. Create a new "cloud-gov" branch and delete everything (except for manifest files or an r.yml if you have them) out of it then copy the scripts folder from this repo. (git switch --orphan cloud-gov will create a new empty branch.)

4. Add an r.yml file that lists all of the packages your app needs (typically, anything called in a library command). For example, with an app that used shinyjs, ggpubr, readr, dplyr, and shinyWidgets, the r.yml would look like:
```
---
packages:
  - packages:
    - name: shinyjs
    - name: ggpubr
    - name: readr
    - name: dplyr
    - name: shinyWidgets
```
5. On your default branch, go to the Actions tab in GitHub and run the build-cloud-gov.yml action. The first time you will also need to check the box to also build R dependencies, which should place the R packages your R Shiny app will need on cloud.gov into the cloud-gov branch.

6. After that action completes, edit the manifest.yml file it creates in the cloud-gov branch (if you didn't already have one) to pick an appropriate app name and route for your app.

7. Pull the cloud-gov branch to your computer and log into cloud.gov on Windows
  - In the Windows command line, log into cloud.gov with the command (Note: you may need to replace the cf with cf7 or cf8 depending on your CLI version):
    - `cf login -a api.fr.cloud.gov  --sso`
  - Go to https://login.fr.cloud.gov/passcode, log in, and copy the passcode
  - Back in the command line, left-click to paste the passcode and login

8. Navigate to your project's directory (in Windows, the cd command followed by the folder name will move to a folder; the tab key will complete the folder's name to save some typing) and then push your app to cloud.gov with the command:
```
cf push
```
9. For EPA Projects, you will most likely need to use the [One EPA Template for R](https://github.com/USEPA/webcms/blob/main/utilities/r/OneEPA_template.R).

# Using GitHub devcontainers
This repository also contains a few devcontainers in the .devcontainer folder. They can be copied to your repository and used to run a GitHub devcontainer for either an R Studio Server instance or for multiple Shiny apps to support a training.

# Disclaimer
The United States Environmental Protection Agency (EPA) GitHub project code is provided on an "as is" basis and the user assumes responsibility for its use.  EPA has relinquished control of the information and no longer has responsibility to protect the integrity , confidentiality, or availability of the information.  Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by EPA.  The EPA seal and logo shall not be used in any manner to imply endorsement of any commercial product or activity by EPA or the United States Government.
