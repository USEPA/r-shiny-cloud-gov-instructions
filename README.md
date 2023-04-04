# How to deploy R Shiny apps to cloud.gov

1. Install the Cloud Foundry CLI (Command Line Interface):
  - [Cloud.gov setup documentation](https://cloud.gov/docs/getting-started/setup/)

2. Add an r.yml file that lists all of the packages your app needs (typically, anything called in a library command). For example, with an app that used shinyjs, ggpubr, readr, dplyr, and shinyWidgets, the r.yml would look like:
```
packages:
- packages:
    - name: shinyjs
    - name: ggpubr
    - name: readr
    - name: dplyr
    - name: shinyWidgets
```
3. Copy the .github/workflows/vendor_r.yml file and the scripts folder from this repo into your GitHub repo, and run the vendor_r workflow. This should create a vendor_r directory; (possibly) an r-lib directory; and if they are missing shiny.R, manifest.yml, and .cfignore files necessary for cloud.gov.
4. Log into cloud.gov on Windows
  - In the Windows command line, log into cloud.gov with the command (Note: you may need to replace the cf with cf7 or cf8 depending on your CLI version):
    - `cf login -a api.fr.cloud.gov  --sso`
  - Go to https://login.fr.cloud.gov/passcode, log in, and copy the passcode
  - Back in the command line, left-click to paste the passcode and login
5. Navigate to your project's directory (in Windows, the cd command followed by the folder name will move to a folder; the tab key will complete the folder's name to save some typing) and then push your app to cloud.gov with the command:
```
cf push -s cflinuxfs4
```
6. For EPA Projects, you will most likely need to use the [One EPA Template for R](https://github.com/USEPA/webcms/blob/main/utilities/r/OneEPA_template.R).
## Missing packages
If a package you need is missing, use the [issues here to request it](https://github.com/USEPA/cflinuxfs3-CRAN/issues)

# Disclaimer
The United States Environmental Protection Agency (EPA) GitHub project code is provided on an "as is" basis and the user assumes responsibility for its use.  EPA has relinquished control of the information and no longer has responsibility to protect the integrity , confidentiality, or availability of the information.  Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by EPA.  The EPA seal and logo shall not be used in any manner to imply endorsement of any commercial product or activity by EPA or the United States Government.
