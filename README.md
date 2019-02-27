# firstdestinations
A visualization dashboard for First Destinations, UCSD

This repo contains the code for an R Shiny Web application for the annual First Destinations Project. 
The app is currently deployed on a shinyapps.io server: https://ucsdataresrch.shinyapps.io/firstdestinations.

Development currently in progress - features to implement/fix:
  - Overall summary visualizations and stats for entire graduating class
  - Department report generation via RMarkdown
  - Interactive Data tables for user-selected subsets of graduates (by major, dept, college, grad.date, etc.)
    - Dynamic visualizations and statistics generated based on these given subsets
  - etc...
  
Data used by the shiny app is accessed and stored via Dropbox API (use login specified in the logins document).
