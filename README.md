# Predicción Riesgo Crediticio
Sean bienvenidos al repositorio de PrediCrédito, en el cual podrán encontrar todas las herramientas y elementos que se utilizaron en el proceso de desarrollo de este proyecto. Los apartados más importantes del proyecto se encuentran en la siguiente tabla de contenido.
## Tabla de Contenido

- [Introducción](#introducción)
- [Limpieza de Datos](#limpieza-de-datos)
- [Modelo](#modelo)
- [Informe Técnico](#informe-técnico)
- [App](#app)

### Introducción

En este proyecto se utilizó una base de datos que contiene más de 450.000 observaciones, correspondientes a préstamos a clientes de la compañía estadounidense de préstamos “Lending Club” entre los años 2007 y 2014, con 74 variables que indican desde el estado actual del préstamo hasta el comportamiento financiero del prestatario.  

Se construirá un modelo a partir de estos datos, capaz de predecir la probabilidad de que un cliente cumpla o incumpla sus obligaciones financieras en los siguientes 12 meses al préstamo realizado. Esta probabilidad de pago será representada en una ScoreCard, que permitirá saber el puntaje crediticio del cliente y lo clasificara en una de las categorías de acuerdo a su comportamiento financiero, y en un futuro poder evaluar qué tan apta es esta persona para recibir un préstamo.

Por ultimo un aplicativo web mediante ShinyApps, que permita al usuario ingresar sus datos y pueda saber cuál es su puntaje crediticio y como se ve comparado con el resto de la población.
<p align="center">
  <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7W2y3GE6lUs0-kXSqPmBvsvsDCs0XIxi6njDBvzlctQVosf8pJiFSaaisPVtA63LuRTU&usqp=CAU" width="500" height="250" />
</p>


### Limpieza de Datos

En este apartado se realizó todo lo referente a la depuración y limpieza de la base de datos, el procedimiento con los valores NA y la ingeniería de características para la creación de nuevas variables.

[Limpieza en Python](https://github.com/DanielDi/Prediccion_Riesgo_Crediticio/blob/main/procesamiento.md)

### Modelo

En la construcción del modelo se diseñó un glm para hacer la predicción de si un cliente cumplirá o incumplirá con el pago de su deuda, con base a esto se construye el scorecard el cual nos brinda el puntaje crediticio que clasificará a los mismos. 


### Informe Técnico

Aquí podrá ver todo lo referente al informe técnico del proyecto, la selección de variables, la construcción paso a paso del modelo, análisis descriptivo y argumentación del proyecto junto a las conclusiones del mismo.  

[Informe Técnico](https://rpubs.com/SebitasElCrack/907670)

### App

En este apartado podra encontrar todo lo relacionado con el desarrollo y ejecucion de la aplicacion web oficial de PrediCrédito

[App](https://sebastian-falcon.shinyapps.io/PrediCredito/)
