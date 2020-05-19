## app.R ##
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(readstata13)
library(highcharter)
library(maps)
library(mapproj)
library(rsconnect)
library(usmap)
library(ggplot2)
# source("helpers.R")

states <- read.dta13("data/chronicshortages.dta")
h_chart_data <- read.dta13("data/overtime_long.dta")
bystate <- read.dta13("data/bystate.dta")

ui <- dashboardPagePlus(
  dashboardHeader(title = "Teacher Shortages"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home",
               tabName = "home",
               icon = icon("fas fa-home")),
      menuItem("Shortages Over Time",
        tabName = "time",
        icon = icon("calendar")),
      menuItem("Shortages By State",
        tabName = "state",
        icon = icon("fas fa-map-pin")),
      menuItem("Shortages By Content Area",
        tabName = "content",
        icon = icon("fas fa-chalkboard-teacher")),
      menuItem("Data & Definitions",
        tabName = "data",
        icon = icon("fas fa-database")))),
  ## Body content
  dashboardBody(
    tabItems(
    # Home page
    tabItem(tabName = "home",
            fluidRow(
              box(
                width = 12,
                h1("Teacher Shortage Areas in the U.S.",
                  align = "center",
                  solidHeader = TRUE,),
                strong("Project"),
                br(),
                p("The Teacher Shortage Areas Project explores the changing
            teacher labor market from 1990-2021. The aim of this project is
            to further the U.S. Department of Education's goals to:"),
                p("1. Notify the nation that States and schools may potentially
            hire academic administrators, licensed teachers,
            other educators and school faculty of specific disciplines/subject areas,
            grade levels, and/or geographic regions."),
                p("2. Serve as a useful resource for recent graduates of Schools of Education
              and trained, experienced teaching professionals aspiring to serve school
              districts with shortages about potential opportunity areas in each State’s
              and territory’s Pre-Kindergarten through Grade 12 classrooms."),
                p( "3. Serve as a useful resource in the process of advising Federal student
              financial aid recipients of the potential to reduce, defer,
              or discharge student loan repayments by teaching in certain areas."),
                br())),
            fluidRow(
              box(
                strong("About"),
                width = 8,
                p("The project was developed by the Center for Education Data and Research (CEDR) at the University
                  of Washington. All data come from the U.S. Department of Education."),
                tags$a(href = "https://tsa.ed.gov/#/home/",
                       "U.S. Department of Education Teacher Shortage Area Data", 
                       target = "_blank"),
                br(),
                p("For comments or questions, please contact Marcelle Goggins at mgoggins@uw.edu.")),
              box(
                width = 4,
                tags$a(href = "https://www.cedr.us",
                  img(src = "CEDR_teal_rgb_nobackgrd.png",
                    align = "center",
                    # width = 150,
                    height = 100),),
                br(),
                tags$a(href = "https://www.cedr.us",
                       "Click to learn more about CEDR",
                         align = "center",
                         target = "_blank"))),),
    
    # Shortages Over Time page
    tabItem(tabName = "time",
            fluidRow(
              box(width = 12,
                  background = "yellow",
                  "Shortages Over Time"),
              box(width = 12,
                  highchartOutput("my_hc")),
              box(
                width = 12,
                checkboxGroupInput("content_area",
                  label = h4("Content Area"),
                  choices = c(
                    "Academically Advanced",
                    "Academic Intervention",
                    "Art and Music",
                    "Career and Technical Education",
                    "Core Subjects",
                    "Drivers Education",
                    "Early Childhood",
                    "English as a Second Language",
                    "General Shortages",
                    "Health and Physical Education",
                    "Language Arts",
                    "Mathematics",
                    "School Nurse",
                    "Science",
                    "Social Studies",
                    "Special Education",
                    "Support Staff",
                    "World Languages"),
                  selected = "Academically Advanced")))),
    
    #Shortages By State page
    tabItem(tabName = "state",
            fluidRow(
              box(width = 12,
                  background = "blue",
                  "Shortages By State")),
            fluidRow(
              box(
                width = 4,
                selectInput("inState",
                            "Select a State",
                            choices = sort(bystate$State)),
                selectInput("inYear",
                            "Select a School Year",
                            choices = sort(bystate$School_Year))),
              box(width = 8,
                  tableOutput("stateData")))),
    
    #Shortages by Content Area page
    tabItem(tabName = "content",
            fluidRow(
              box(width = 12,
                background = "purple",
                "Shortages by Content Area")), # end of title row
            fluidRow(
              box(width = 6,
                selectInput("subject",
                  h4("Content Area"),
                  choices = c("Academically Advanced",
                    "Academic Intervention",
                    "Art and Music",
                    "Career and Technical Education",
                    "Core Subjects",
                    "Drivers Education",
                    "Early Childhood",
                    "English as a Second Language",
                    "General Shortages",
                    "Health and Physical Education",
                    "Language Arts",
                    "Mathematics",
                    "School Nurse",
                    "Science",
                    "Social Studies",
                    "Special Education",
                    "Support Staff",
                    "World Languages"),
                  selected = "Academically Advanced")),
              box(width = 6,
                selectInput("subject_blue",
                  h4("Content Area"),
                  choices = c("Academically Advanced",
                    "Academic Intervention",
                    "Art and Music",
                    "Career and Technical Education",
                    "Core Subjects",
                    "Drivers Education",
                    "Early Childhood",
                    "English as a Second Language",
                    "General Shortages",
                    "Health and Physical Education",
                    "Language Arts",
                    "Mathematics",
                    "School Nurse",
                    "Science",
                    "Social Studies",
                    "Special Education",
                    "Support Staff",
                    "World Languages"),
                  selected = "Academically Advanced"))), 
            fluidRow(
              box(width = 6,
                  plotOutput("map")),
              box(width = 6,
                  plotOutput("map_blue")))), #End of "Content Area Page"
    tabItem(tabName = "data",
            fluidRow(
              box(width = 12,
                  background = "navy",
                  "Data and Definitions")),
            fluidRow(
              box(width = 12,
                  title = "About Teacher Shortage Areas",
                  collapsible = TRUE,
                  strong("Definition"),
                  p(" A Teacher Shortage Area is “an area of specific grade, 
                    subject matter or discipline classification, or a 
                    geographic area in which the Secretary [of Education] 
                    determines that there is an inadequate supply of elementary 
                    or secondary school teachers.” "),
                  tags$a(href = "https://www.govregs.com/regulations/expand/title34_chapterVI_part682_subpartB_section682.210",
                  p("Source: 34 CFR 682.210(q)(8)(vii)"),
                  taregt = "_blank"),
                  strong("Calculation"),
                  p("Each Chief State School officer submits annual reports of teacher shortage area to the Department of Education. 
                    A teacher shortage area is calculated as a percentage of the Full Time Equivalent (FTE) teaching positions in a 
                    state. Per the DOE report on teacher shortages areas (Cross, 2017): "),
                  p("“The Department encourages each State Chief State School officer (CSSO) office to determine its State’s proposed 
                  teacher shortage areas based on the prescribed methodology and other requirements in 34 CFR 682.210(q)(6)(iii). For 
                  the Department to consider the State specified areas as teacher shortage areas the percentage of the State’s proposed 
                  teacher shortage areas* may not exceed the automatic designated limit of five percent of all unduplicated full-time 
                  equivalent (FTE) elementary and secondary teaching positions in the State."),
                  p("However, under 34 CFR 682.210(q)(6)(iv), if the total number of proposed designated FTE elementary and secondary 
                    teaching positions in the State exceeds five percent of the total number of elementary and secondary FTE teaching 
                    positions the State’s CSSO may submit, with the list of proposed areas, supporting documentation showing the methods 
                    used for identifying the specific shortage areas, and an explanation of the reasons why the Secretary should designate
                    all of the proposed areas as teacher shortage areas.” "),
                  p("To see the full teacher shortage area report from the DOE, please click on the link below:"),
                  tags$a(href = "https://www2.ed.gov/about/offices/list/ope/pol/bteachershortageareasreport201718.pdf",
                         p("Teacher Shortage Areas Nationwide Listing 1990–1991 through 2017–2018"),
                         target = "_blank"),
                  br(),
                  p("*Calculation –– Teacher shortage areas as a percentage of the FTE teaching positions for all teachers in the State. 
                    A combination of the following unduplicated FTEs may be used to calculate teaching shortage area FTEs and the percentage 
                    of total FTEs: (a) teaching positions that are unfilled; (b) teaching positions that are filled by teachers who are 
                    certified by irregular, provisional, temporary, or emergency certification; and (c) teaching positions that are filled 
                    by teachers who are certified, but who are teaching in academic subject areas other than their area of preparation.")),
              box(width = 12,
                  title = "Data Source",
                  collapsible = TRUE,
                  p("All data used in the Teacher Shortage Areas Project come from the U.S. Department of Education. For more information, 
                  please click on the link below: "),
                  tags$a(href = "https://tsa.ed.gov/#/home/",
                         "U.S. Department of Education Teacher Shortage Area Data", 
                         target = "_blank")))
    ) #End of data and definitions page
    ) #TabItems
    ) #Dashboard Body
  ) #UI 
  
  server <- function(input, output) {
    #By Content Area
    output$map <- renderPlot({
      states_red <- switch(
        input$subject,
        "Academically Advanced" = "acadadv",
        "Academic Intervention" = "acadint",
        "Art and Music" = "artmusic",
        "Career and Technical Education" = "cte",
        "Core Subjects" = "core",
        "Drivers Education" = "driversed",
        "Early Childhood" = "earlychild",
        "English as a Second Language" = "esl",
        "General Shortages" = "general",
        "Health and Physical Education" = "health",
        "Language Arts" = "langarts",
        "Mathematics" = "math",
        "School Nurse" = "nurse",
        "Science" = "science",
        "Social Studies" = "socstudies",
        "Special Education" = "sped",
        "Support Staff" = "support",
        "World Languages" = "worldlanguages")
      
      plot_usmap("states", data = states, values = states_red, labels = TRUE) + 
        scale_fill_continuous(low = "white", 
                              high = "darkslategray",
                              guide_legend(title ="Years", 
                                           position = "right")) + 
        scale_x_continuous(expand = c(0, 0)) + 
        scale_y_continuous(expand = c(0, 0)) +
        labs(title = "Chronic Teacher Shortage  Areas 1990-2021") +
        theme(legend.position = c(.93,0))
      }) #end of map_red
    
    output$map_blue <- renderPlot({
        states_blue <- switch(input$subject_blue,
        "Academically Advanced" = "acadadv",
        "Academic Intervention" = "acadint",
        "Art and Music" = "artmusic",
        "Career and Technical Education" = "cte",
        "Core Subjects" = "core",
        "Drivers Education" = "driversed",
        "Early Childhood" = "earlychild",
        "English as a Second Language" = "esl",
        "General Shortages" = "general",
        "Health and Physical Education" = "health",
        "Language Arts" = "langarts",
        "Mathematics" = "math",
        "School Nurse" = "nurse",
        "Science" = "science",
        "Social Studies" = "socstudies",
        "Special Education" = "sped",
        "Support Staff" = "support",
        "World Languages" = "worldlanguages")
      
      plot_usmap("states", data = states, values = states_blue, labels = TRUE) + 
        scale_fill_continuous( low = "white", 
                               high = "dodgerblue4", 
                               guide_legend(title ="Years")) + 
        scale_x_continuous(expand = c(0, 0)) + 
        scale_y_continuous(expand = c(0, 0)) +
        labs(title = "Chronic Teacher Shortage Areas 1990-2021") +
        theme(legend.position = c(.93,0))
      }) #end of map_blue
    
    #Over Time Chart Output
    output$my_hc <- renderHighchart({
      hc <- subset(h_chart_data, h_chart_data$subject %in% input$content_area) %>%
        hchart(.,
               type = "line",
               hcaes(x = Year,
                     y = States,
                     group = subject)) %>%
        hc_yAxis(min = 0, max = 50) 
      hc
    }) #end of overtime graph (high chart)
    
    #By state table output
    output$stateData <- renderTable({
      yearFilter <- subset(
        bystate,
        bystate$State == input$inState &
          (bystate$School_Year == input$inYear | input$inYear == ""))
      }) #end of by state table
 
  } #end of Server
  
  shinyApp(ui, server)
  