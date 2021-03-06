library(shiny)

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Chronic Kidney Disease Prediction"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      
      radioButtons(inputId="gen", label="Gender", 
                   choices=c("Male","Female")), 
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "age",
                  label = "Enter Age",
                  min = 0,
                  max = 70,
                  value = 32),
      
      radioButtons(inputId="race", label="Choose Race Group", 
                   choices=c("White","Black", "Hispanic", "Others")), 
      
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "gc",
                  label = "Good Cholestrol(HDL - Unit mg/dL)",
                  min = 1,
                  max = 111,
                  value = 50),
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "bc",
                  label = "Bad Cholestrol(LDL - Unit mg/dL)",
                  min = 1,
                  max = 111,
                  value = 50),
      
      
      radioButtons(inputId="pvd", label="Peripheral Vascular Disease", 
                   choices=c("Yes","No")),
      
      radioButtons(inputId="hyp", label="Hypertension", 
                   choices=c("Yes","No")),
      
      radioButtons(inputId="dia", label="Diabetes", 
                   choices=c("Yes","No")),
      
      radioButtons(inputId="chf", label="Has the doctor ever told you that you had congestive heart failure ?", 
                   choices=c("Yes","No")),
      
      filename <- file.choose(),
     
      #model <- readRDS(file = "C:/Users/bvsba/Desktop/UIC/Summer Semester/Chronic Kidney Disease/New model/CKD_v1.rds"),
      
      actionButton("run", "Submit")
      #global filename
      #filename <- "C:\Users\bvsba\Desktop\UIC\Summer Semester\Chronic Kidney Disease\New model\CKD_v1.rds"
      
    ),
   # ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      verbatimTextOutput("result"), #%>% withSpinner(color="#0dc5c1"),
      verbatimTextOutput("prediction"),
      # Output: Histogram ----
      #plotOutput(outputId = "distPlot")
      
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  #Reading Gender Input
  observeEvent(input$gen, {
    gen <- input$gen
    x1 <- print(gen)
    if (x1 == "Male"){
      x1 = 0 
    }
    if (x1 == "Female"){
      x1 = 1 
    }
    assign('gen',x1,envir=.GlobalEnv)
  })
  
  #Reading Age Input
  observeEvent(input$age, {
    age <- input$age
    x2 <- print(age)
    assign('age',x2,envir=.GlobalEnv)
  })
  
  
  #Reading Race Input
  observeEvent(input$race, {
    race <- input$race
    x3 <- print(race)
    if (x3 == "White"){
      x3 = "white" 
    }
    if (x3 == "Black"){
      x3 = "black" 
    }
    if (x3 == "Hispanic"){
      x3 = "hispa" 
    }
    if (x3 == "Others"){
      x3 = "other" 
    }
    print(x3)
    assign('race',x3,envir=.GlobalEnv)
  })
  
  
  #Reading Good Cholestrol Input
  observeEvent(input$gc, {
    gc <- input$gc
    x4 <- print(gc)
    assign('gc',x4,envir=.GlobalEnv)
  })
  
  #Reading Bad Cholestrol Input
  observeEvent(input$bc, {
    bc <- input$bc
    x5 <- print(bc)
    assign('bc',x5,envir=.GlobalEnv)
  })
  
  #Reading PVD Input
  observeEvent(input$pvd, {
    pvd <- input$pvd
    x6 <- print(pvd)
    if (x6 == "Yes"){
      x6 = 1 
    }
    if (x6 == "No"){
      x6 = 0 
    }
    assign('pvd',x6,envir=.GlobalEnv)
  })
  
  #Reading Hypertension Input
  observeEvent(input$hyp, {
    hyp <- input$hyp
    x7 <- print(hyp)
    if (x7 == "Yes"){
      x7 = 1 
    }
    if (x7 == "No"){
      x7 = 0 
    }
    assign('hyp',x7,envir=.GlobalEnv)
  })
  
  #Reading Diabetes Input
  observeEvent(input$dia, {
    dia <- input$dia
    x8 <- print(dia)
    if (x8 == "Yes"){
      x8 = 1 
    }
    if (x8 == "No"){
      x8 = 0 
    }
    assign('dia',x8,envir=.GlobalEnv)
  })
  
  #Reading CHF Input
  observeEvent(input$chf, {
    chf <- input$chf
    x9 <- print(chf)
    if (x9 == "Yes"){
      x9 = 1 
    }
    if (x9 == "No"){
      x9 = 0 
    }
    assign('chf',x9,envir=.GlobalEnv)
  })
  
  
  model <- readRDS(filename)
  
  observeEvent(input$run,{
    
    print("entered")
    
    df <- data.frame(Age= c(age), Female= as.factor(c(gen)), Racegrp = as.factor(c(race)), 
                     HDL= c(gc), LDL= c(bc), PVD= as.factor(c(pvd)),
                     Hypertension= as.factor(c(hyp)), Diabetes= as.factor(c(dia)), 
                     CHF= as.factor(c(chf)))
    
    
    pred <- predict(model, type='response', newdata = df)
    print(pred)
    
    if (pred > 0.5){
      prob <- "Patient has high risk of getting a Chronic Disease\n"
    }
    if (pred < 0.5){
      prob <- "Patient does not have risk of getting a Chronic Disease\n"
    }
    
    output$result <- renderPrint({
      cat("RESULT -")  
    })
    
    output$prediction <- renderPrint({
      cat("Risk (Probability) of having a Chronic disease -", pred)
      #cat(pred)
      cat("\n")
      cat(prob)
    })
    
  }) 
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)




