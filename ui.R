# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
# This interface has been modified to be used specifically on Sage Bionetworks Synapse pages
# to log into Synapse as the currently logged in user from the web portal using the session token.
#
# https://www.synapse.org

ui <- fluidPage(
  titlePanel("The NF Data Curator App Has Moved"),
  # Main panel for displaying outputs ----
  mainPanel(
    h3("New home"),
    div(
      "Please use and bookmark our new official app instance at: ",
      tags$strong(
        tags$a("https://dca.app.sagebionetworks.org/", href = "https://dca.app.sagebionetworks.org/")
      )
    ),
    br(),
    br(),
    h3("Other Resources for Annotation"),
    tags$ul(
      tags$li(
        tags$a("How to Annotate Data Docs", href = "https://help.nf.synapse.org/NFdocs/how-to-annotate-data#HowtoAnnotateData-3.NavigatetotheNFDataCuratorapp")
    ),
    tags$li(
      tags$a("NF Metadata Dictionary", href = "https://nf-osi.github.io/nf-metadata-dictionary/")
    ))
  )
)
