# cspell:disable

library(shiny)
library(bslib)
library(rmarkdown)
library(bio3d)
library(Rpdb)

light <- bs_theme()

# interface do usuário
ui <- fluidPage(
  theme = light,
  tags$title("Software"),
  titlePanel("INSILICO"),
  includeCSS("../html/style.css"),
  includeHTML("../html/index.html"),


  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Insira um PDB",
        multiple = FALSE,
        accept = ".pdb",
        width = NULL,
        buttonLabel = "Browse...",
        placeholder = "No file selected"
      ),
      textInput("pdb1", "Insira um PDB",
        value = NULL, width = 75, placeholder = "PDB ID"
      ),
      actionButton("action", "Submeter", class = "btn-success"),
    ),
    mainPanel(
      tableOutput("contents")
    ),
  ),
)

# onde vai rodar
server <- function(input, output, session) {
  output$contents <- renderTable({
    file <- input$file1
    if (is.null(file)) {
      stop("Entrada Vazia!")
    } else {
      ext <- tools::file_ext(file$datapath)
      req(file)
      validate(need(ext == "pdb", "Please upload a pdb file!"))
      x <- read.pdb(file$datapath)
      visualize(x, mode = NULL)
      input$action
    }
  })

}



shinyApp(ui = ui, server = server)
