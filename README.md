# firstdestinations
A visualization dashboard for First Destinations, UCSD

Purpose: To provide a versatile and useful data exploration tool regarding the first destinations of UCSD undergraduates post-graduation. 

This repo contains the code for an R Shiny Web application for the annual First Destinations Project. 
The app is currently deployed on a shinyapps.io server: https://ucsdataresrch.shinyapps.io/firstdestinations.

Development currently in progress - features to implement/fix:
  - Overall summary visualizations and stats for entire graduating class
  - Department report generation via RMarkdown
  - Interactive Data tables for user-selected subsets of graduates (by major, dept, college, grad.date, etc.)
    - Dynamic visualizations and statistics generated based on these given subsets
    - Basic query functionality
  - Ability to download subsets of data in convenient .csv format
  - etc...
  
Data used by the shiny app is accessed and stored via Dropbox API (use login specified in the logins document).

Tools and Packages used:
  - R, Shiny, RMarkdown, Leaflet, DT (datatables), rdrop2 (Dropbox API), etc..  
  
    
    
DOCUMENTATION:  

(1) Setting up for Development on your machine.  

For the best development experience, install and use RStudio for free (https://www.rstudio.com/) to code, test, and eventually deploy the Shiny Web app. Shiny is a separate packge you'll need to download, which you can do so using the following command from the R Terminal:

`install.packages("shiny")`

For tutorials on how Shiny works, see (https://shiny.rstudio.com/tutorial/).

You will need to likely install various more packages in the same way as you develop and add more features.  

(2) Connecting to Shinyapps.io  

Shiny apps can be hosted on private servers, but for our purposes, ours is currently hosted on a free platform provided by RStudio themselves called shinyapps. To connect from R on your machine to Shinyapps.io, you will need the rsconnect package:

`install.packages("rsconnect")`

Complete the following steps to setup the login to Shinyapps to your machine:

  (a) Login to shinyapps.io.

  (b) On the sidebar, click Account -> Tokens

  (c) Add Token

  (d) Click "Show" on the new token you just added

  (e) Copy the command that pops up into your R Terminal

  (f) You are now connected to the Shinyapps.io Account.  
  
(3) Deploying the App  

Using Shiny + Rstudio will let you develop the app on your machine independently. When you've implemented some significant changes and want to update the app in realtime, head to the directory on your machine where this git repository is located, and type in the terminal:

`rsconnect::deployApp()`

You may be prompted asking if you want to overwrite the pre-existing app - enter "y".  

(4) The app will now be uploaded, and the latest version will be live at https://ucsdataresrch.shinyapps.io/firstdestinations.
