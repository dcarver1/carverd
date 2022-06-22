---
layout: post
title: "Translation Shiny"
permalink: "translate"
image: translation/flowerRock.jpg
tags: [R, shiny]
categories: R, shiny
---


I've been working on a large shiny application for the past six months. Our team finalized the product about a month before the public release. The last task was the convert the application for English to Spanish. The project partners were required to provide a human-translated product so we could not utilize automated resources like shi18ny that change the front-end presentation of the text. This meant two things.

  - New input datasets with new naming nomenclature

  - Second instance of the application

Making these changes took much more than just copying and pasting, though there was a tremendous amount of that. In the text below, I'll describe a few conceptual steps that help the translation effort.

### 1. dplyr::select() to set input names.
  I've created the code base for generating all the input datasets connected to this project. As part of that effort, I've developed a script to compile and format the dataset before sending it off to the shiny environment. Using the dplyr select function to rename input just before export allowed me to
  keep simplified variable names throughout the processing code base replicated the process to implement the generation of the Spanish language version

*provide link to code
~~~R
if(isFALSE(spanish)){
  # select to define order and rename features
  df <- df %>%
    dplyr::select(
      "EnviroScreen Score"=  "finalScore"
      ,"EnviroScreen Score Percentile"="finalScore_Pctl"
    )
  }else{
  # select to define order and rename features
  df <- df %>%
    dplyr::select(
      ,"Puntaje de Colorado EnviroScreen"=  "finalScore"
      ,"Percentil del puntaje de Colorado EnviroScreen"="finalScore_Pctl"
  )
~~~

### 2. Comment out the server function and get the app function to run.
Shiny apps require an ui and server function. The ui function sets the structure and most of the application's inputs. The server function renders any processing and reactive requests. Looking at these features in unison is needed to build out an application, but once it's built, the ui function can stand alone as the visual template of the application. To do this, comment out all the content within the server function but include the empty function call.

{% highlight R %}
ui <- fluidPage(...)

server <- function(input,output,session){
# comment out all the code
}
shinyApp(ui, server)
{% endhighlight %}

Errors are far less likely to arise in the ui function, so it's easier to get running. Pushing the app to the end server without the server function performing any tasks allows for troubleshooting of the input data sets and visualization.

### 3. Add reactive functionality one step at a time.
Everything should work after the text substitution, but that was not my experience. I tried troubleshooting the whole but moving from one error message to the other led me to question if my edits were actually fixes or just passing the error onward.
Once I decided to move through the application one reactive element at a time, things went much smoother. You get something to work, and you can test it on the app. This stepwise process also helped get a feel for the interactivity of reactive elements, which can be difficult to parse when looking at the whole.

### 4. Errors come from the structure of the language.
Every language uses a different structure to construct words, statements, and sentences. One of the structural different that I dealt with during the English/Spanish translation was as follows

- Colorado EnviroScreen score Percentile
- Percentil del puntaje de Colorado EnviroScreen

In English, the percentile description is attached to the end of the feature.
In Spanish, the percentile description is on the front, and there is an intermediate word to connect the words.

Thoughout the code I was constructing the percentile term( Colorado EnviroScreen score Percentile) based on the user selecting the stand alone element from a drop down box (Colorado EnviroScreen score). For the Spanish verison, I needed to rework this method to account for the different posistion of the words. To add to this spanish does allways use the same connector (del or de).

English
```{r}
# indicator
in1 <- input$Indicator
indicator1 <- in1
indicator2 <- paste0(in1," Percentile")
if(input$Percentile == "Measured Value"){
indicator <- indicator1 }
if(input$Percentile == "Percentile Rank"){
indicator <- indicator2}
```
Spanish
```{r}
# indicator
in1 <- input$Indicator
# need to lower the first letter in the string but nothing else
# grab first letter and set to lower
t1 <- tolower(str_sub(in1, 1, 1))
# subset out first letter
t2 <- str_sub(in1, 2, nchar(in1))
# construct new string
ndicator1 <- in1
# sometimes it's del sometimes it de
if(in1 %in% c("Puntaje de Colorado EnviroScreen","Indicador de descargas de aguas residuales" ,"Indicador de salud mental","Porcentaje de discapacidades")){
indicator2 <- paste0("Percentil del ", t1,t2)}
else{
indicator2 <- paste0("Percentil de ", t1,t2)}
if(input$Percentile == "Valor medido"){
indicator <- indicator1}
if(input$Percentile == "Rango percentil"){
indicator <- indicator2}
```
### 5. Special Character Rendering via functions
The English version of the application utilizes multiple server-side functions to generate content. I did this to keep the volume of code within the app.r file down. It worked well.
Some of the Spanish variables names contain special characters, accents on specific letters. Saving the files with UTF-8 encoded seemed to do the trick for the most part. The exception being that when a variable name with an accent was passed to a function, R was unable to render that variable name correctly in the function.

I could run the code from the function if I defined varaibles in the local environment, but when that name was passed in the execution of the function within the application, it broke down. This is likely a problem with an answer, but I did not find one. I only tested this in the local environment, so it might perform differently on a server.

The result was that I had to drop all processing functions from the code base and work with some redundant but functioning code. To combat the number of lines of text in the app.r script, I created functions for the text fluid rows that only contained descriptive text. This is a practice I plan on continuing when working on future shiny applications.

English
- app function : 885
- server function : 230

Spanish
- app function : 255
- server function : 992

Obviously, the length of the app.r script is mostly just a cosmetic feature. That said, a clean and less redundant code base fundamentally impacts the application's usability.

## Takeaway

Translation work presents a unique set of challenges. The benefit of the process is that it forces you to reevaluate the structure and function of your application. If you find your partners asking for a translation, push hard for the use of automated translation services, or you will end up maintaining two applications that take very different routes to get to the same place.
