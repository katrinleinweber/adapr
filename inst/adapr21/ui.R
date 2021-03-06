library(plotly)
library(shinydashboard)


header <- dashboardHeader(
  disable = FALSE,
  title = "ADAPR"
)


sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Select Project", tabName = "selectproject", icon = icon("bars")),
    menuItem("Run Report", tabName = "report", icon = icon("file")),
    menuItem("Synchronize", tabName = "synch", icon = icon("glyphicon glyphicon-refresh", lib = "glyphicon"))#,
  )
)      


body <- dashboardBody(
  
  tags$style(HTML("#shiny-notification-panel {
                    width: 300px;
                  position: absolute;
                  margin: auto;
                  top: 0;
                  right: 0;
                  bottom: 0;
                  left: 0;
                  height: 200px;
                  }
                  .shiny-notification { opacity: 0.95; }
                  h2 { padding-left: 15px; }")),
  
  tabItems(
    tabItem("selectproject", 
      fluidRow(
        column(width=6,
          box(title = "Choose an Existing Project", status = "info", width = 12, collapsible = FALSE, solidHeader = TRUE,
            htmlOutput("selectUI")
          )
        ),
        column(width=6,
          h3(strong(uiOutput("projectselected")))
        )    
      ) 
    ),#TABITEMA
    
    tabItem("programslib",
      fluidRow(
        column(width=3,
          box(title = "1. Make Program", status = "info", width = 12, height = NULL, collapsible = FALSE, solidHeader = TRUE,
            textInput('filename', "Filename:", value = "MyProgram.R"),
            br(),
            textInput("description", label = "Program description:", value = "Description of your program..."),
            br(),br(),
            actionButton("submit","Create program")
          )#,
          #box(title = "2. Manage Libraries", status = "info", width = 12, height = NULL, collapsible = FALSE, solidHeader = TRUE,
          #  textInput("library.name", label = "Library Name", value = "mylibrary"),
          #  textInput("library.install", label = "Install Command (bioC or '' for CRAN)", value = ""),
          #  selectInput('library.specific', label="Library for specific program?", c("FALSE","TRUE"),"FALSE"),                                                                            
          #  br(),br(),
          #  actionButton("submitLibrary","List/Add Library")
          #)
        ),
        #column(width=1,
        #  tags$img(src='arrow.png',height='60',width='130')
          #helpText(h1("-------->"))
        #),
        column(width=9,
        h3(strong(htmlOutput("projectselected2"))),
          box(status = "info", width = 12, height = 635, collapsible = FALSE, solidHeader = FALSE,
            tableOutput("myChart"),
            tableOutput('text1'),
            tableOutput('libraryTable'),
            tableOutput('addLibraryTable')
          )
        )
      )
    ),
    tabItem("report",
      fluidRow(
        column(width=2,
          box(title = "Report", status = "info", width = 12, height = NULL, collapsible = FALSE, solidHeader = TRUE,
            actionButton("submitReport","Create report")            
          ),
        #),
        #column(width=3,
          box(title = "App", status = "info", width = 12, height = NULL, collapsible = FALSE, solidHeader = TRUE,
            actionButton("submitRunApp","Run App"),br(),br(),
            htmlOutput("selectAppUI")
          ),
        
        box(title = "Check File Provenance", status = "info", width = 12, height = NULL, collapsible = FALSE, solidHeader = TRUE,
            actionButton("IDfile","Identify file"),br(),br()
        )
                  ),  
        column(width=10,
          h3(strong(htmlOutput("projectselected3"))),
          box(status = "info", width = 12, height = 260, collapsible = FALSE, solidHeader = FALSE,
              h4(tableOutput("projectus")),
              h4(tableOutput("runApp"),verbatimTextOutput("selectIDfile"))
           )
          
          
        )
      )
    ),  
    tabItem("synch",
      fluidRow(
        column(width=3,
          box(title = "Program Graph", status = "info", width = 12, height = NULL, collapsible = FALSE, solidHeader = TRUE,
            actionButton("make_report_graph","Examine Program Graph")
          ),
          box(title = "Synchronize", status = "info", width = 12, height = NULL, collapsible = FALSE, solidHeader = TRUE,
            actionButton("submitSyncTest","Check Sync"),
            br(),br(),
            actionButton("submitSyncRun","Synchronize Now"),
            br(),br(),br(),
            textInput('commit.message', "Commit Message", value = "Message"),
            helpText("Version Control Snapshot:"),
            actionButton("submitCommitRun","Commit Project")
          )
          ,
          box(status = "info", width = 12, height = 300, collapsible = FALSE, solidHeader = FALSE,
            tableOutput("syncTest"),
            br(),h4(textOutput("syncText")),
            br(),h4(textOutput("progressbar")),
            br(),h4(textOutput("CommitOut"))
         )
        ),
        column(width=9,
        h3(strong(htmlOutput("projectselected4"))),
          box(title = NULL, status = "info", width = 12, height = 500, collapsible = FALSE, solidHeader = FALSE,
              #plotOutput("ProgramDAG_report", click = "ProgramDAG_click_report"),
              plotOutput("ProgramDAG_report",width="100%",
                         # Equivalent to: click = clickOpts(id = "plot_click")
                         click = "ProgramDAG_click_report",
                         brush = brushOpts(
                           id = "ProgramDAG_brush_report",
                           resetOnNew = TRUE
                         )),
              #verbatimTextOutput("ProgramDAG_report_info_1"),
              verbatimTextOutput("ProgramDAG_report_info")
              
          ),
          box(title = NULL, status = "info", width = 12, height = 500, collapsible = FALSE, solidHeader = FALSE,
                       
            plotOutput("ProgramDAG_report_select_graph", width="100%",
                         # Equivalent to: click = clickOpts(id = "plot_click")
                         click = "ProgramDAG_click_report_browse",
                         brush = brushOpts(
                           id = "ProgramDAG_brush_report_browse",
                           resetOnNew = TRUE
                         )),
                         #HTML('<style>.rChart {width: 100%; height: 400px}</style>'),
            verbatimTextOutput("brush_info_select")
              
          )
      )
    ))
  )
)
shinyUI(dashboardPage(header, sidebar, body, skin = 'black'))