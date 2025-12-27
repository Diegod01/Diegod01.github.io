---
title: "Trabajo Final Series Cronologicas"
format: 
  pdf:
    keep-md: true
editor: visual
execute:
  echo: false
  warning: false
  message: false
  results: false
  output: true
  fig-show: "hide"
---

# Resumen Ejecutivo:

En este documento lo que hacemos es analizar la serie de tiempo del IMAE siguiendo una metodología de Descripción, Identificación, Estimación, Validación, Predicción. En cada uno de los pasos detallamos los pasos seguidos y los resultados obtenidos. El propósito de nuestro trabajo es poder identificar un modelo apropiado para realizar predicciones a futuro sobre la serie del IMAE. Realizamos una serie de técnicas con distintos fines como aplicar la transformación logarítmica a la serie, la identificación y filtrar la tendencia y la estacionalidad con el fin de plantear un posible modelo. Con base en la FAC y la FACP de nuestra serie transformada, planteamos un posible modelo SARIMA que podría adaptarse a nuestra serie, observamos que la significación de los coeficientes asociados al modelo planteado se reducía al aplicar la transformación logarítmica, por lo que descartamos su uso. Luego verificamos los residuos de este modelo planteado, obteniendo que algunos supuestos sobre los residuos se cumplían y otros no, con base en esto consideramos reajustar los puntos atípicos que podía tener el modelo para volver a verificar el cumplimiento de los residuos, donde si bien pasaron a eliminarse los problemas de no cumplimiento de los supuestos sobre los residuos del modelo, obtuvimos nuevos problemas en relación con la significación de los coeficientes asociados a este modelo ajustado por considerar los valores atípicos, por lo que decidimos considerar otro modelo posible realizando de nuevo los pasos de verificación del cumplimiento de los residuos y ajuste de valores atípicos de este nuevo modelo considerado. Finalmente, realizamos una predicción a 8 meses a futuro y validamos el rendimiento predictivo de nuestro modelo considerado predicciones dentro y fuera de la muestra utilizando la técnica de partición de los datos en train-test, obtuvimos las respectivas métricas predictivas asociadas.

# Antecedentes sobre la variable:

En este documento lo que hacemo es analizar la serie de tiempo de el IMAE (Indicador Mensual de Actividad Economica), que es un indicador economico sintetico, construido a partir de otros indicadores individuales combinados derivados de distintos sectores de actividad economica, como Agropecuario, Minería, Manufactura, Energía, Salud, Finanzas, etc. El IMAE es un indicador de corto plazo reportado mensualmente. Se basa en estadisticas y metodos contables. El IMAE es un índice de Laspeyres mensual con base 100 en el año 2016, indica la actividad económica con una frecuencia mensual a precios constantes de 2016. Para calcular el IMAE vemos el valor agregado a precios básicos de cada una de las actividades económicas agregando los impuestos netos de subsidios a los productos, utilizando las ponderaciones de las cuentas nacionales base 2016. La razon de usar indicadores mensuales es para ver el valor agregado de las industrias y de los impuestos netos de subsidios sobre los productos. La publicacion del IMAE se hace a los 60 días de que termina el mes.

Fuente de contexto sobre el IMAE. https://www.bcu.gub.uy/Estadisticas-e-Indicadores/Documents/Metodolog%C3%ADa%20IMAE.pdf


::: {.cell}

:::



::: {.cell}

:::


ㅤ

ㅤ

# Metodologia:

### PreProcesamiento de Datos: Los datos que tenemos los obtuvios de la pagina del Banco Central Del Uruguay. Los datos van desde Enero de 2016 hasta Marzo de 2025 y son mensuales, mostrando el valor del IMAE para el primer dia de cada mes. No hay valores nulos en nuestros datos. Un paso que hicimos fue convertir los datos a tipo ts (time series) para poder operar mejor con ellos en el R.


::: {.cell}
::: {.cell-output .cell-output-stdout}

```
# A tibble: 6 x 4
  Fecha       IMAE Desestacionalizado Tendencia.Ciclo
  <chr>      <dbl>              <dbl>           <dbl>
1 01/01/2016  96.0               95.9            98.9
2 01/02/2016  97.7              101.             99.2
3 01/03/2016  97.7              100.             99.5
4 01/04/2016  97.4               99.8            99.7
5 01/05/2016 103.                99.8            99.8
6 01/06/2016 102.               101.             99.9
```


:::

::: {.cell-output .cell-output-stdout}

```
tibble [111 x 4] (S3: tbl_df/tbl/data.frame)
 $ Fecha             : chr [1:111] "01/01/2016" "01/02/2016" "01/03/2016" "01/04/2016" ...
 $ IMAE              : num [1:111] 96 97.7 97.7 97.4 103 ...
 $ Desestacionalizado: num [1:111] 95.9 100.7 100.5 99.8 99.8 ...
 $ Tendencia.Ciclo   : num [1:111] 98.9 99.2 99.5 99.7 99.8 ...
```


:::

::: {.cell-output .cell-output-stdout}

```
[1] 0
```


:::

::: {.cell-output .cell-output-stdout}

```
[1] "C:/Users/diego/OneDrive/Escritorio/Trabajo/Portafolio_Web/Diegod01.github.io"
```


:::
:::



::: {.cell}
::: {.cell-output .cell-output-stdout}

```
         Jan     Feb     Mar     Apr     May     Jun     Jul     Aug     Sep
2016  96.016  97.734  97.706  97.395 103.041 101.765  97.375  96.356  96.774
2017 103.331  99.159 100.150  99.237 105.121 101.691  98.299  99.030  97.649
2018 103.052  99.677  99.252  99.205 103.740 103.078  99.426  98.925  96.618
2019 103.529  99.897  98.791 103.624 107.453 102.115 101.021 100.939  98.682
2020 102.275  99.040  92.519  85.025  89.886  92.113  92.567  92.605  94.161
2021  95.551  90.787  96.835  95.200 101.489 102.393 100.946  99.379 100.518
2022 103.821 101.019 102.154 104.425 111.242 110.282 102.622 103.237 102.357
2023 107.343 101.218 104.689 102.845 107.553 109.058 102.153 104.425 101.729
2024 107.106 103.512 102.783 109.550 114.388 109.847 106.304 108.016 107.479
2025 109.956 105.882 107.153                                                
         Oct     Nov     Dec
2016  96.746 108.717 110.374
2017 100.197 106.056 110.965
2018 104.438 106.647 108.838
2019 101.227 107.511 109.460
2020  96.856 101.309 105.085
2021 102.002 111.469 113.698
2022 102.399 107.258 113.746
2023 107.275 112.730 112.928
2024 112.285 116.734 115.539
2025                        
```


:::

::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-4-1.pdf)
:::

::: {.cell-output .cell-output-stdout}

```
[1] 12
```


:::
:::


### Medidas de Resumen de la serie:

Algunas medidas de resumen de la serie del IMAE son: Los valores minimos y maximos que alcanza la serie y en que mes los alcanza, ademas de el primer y tercer cuartil, la media y la mediana, la varianza y el desvio, el rango intercuartilico. Vemos que el minimo valor que toma la serie es 85.03 y se alcanza en Abril de 2020 y el maximo valor que toma la serie es 116.73 y se alcanza en octubre de 2024. La mediana vale 102.36 y la media 102.76.


::: {.cell}
::: {.cell-output .cell-output-stdout}

```
[1] "Resumen del objeto time series:"
```


:::

::: {.cell-output .cell-output-stdout}

```
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  85.03   99.10  102.36  102.76  107.21  116.73 
```


:::

::: {.cell-output .cell-output-stdout}

```
[1] "Momento donde se dio el mínimo,  2020.25"
```


:::

::: {.cell-output .cell-output-stdout}

```
[1] "Momento donde se dio el máximo: 2024.83333333333"
```


:::

::: {.cell-output .cell-output-stdout}

```
[1] "La varianza es: 34.7189940851761"
```


:::

::: {.cell-output .cell-output-stdout}

```
[1] "La desviación estándar es: 5.89228258700956"
```


:::

::: {.cell-output .cell-output-stdout}

```
[1] "El rango intercuartílico es: 8.10599999999999"
```


:::
:::


### Visualizacion:


::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-6-1.pdf)
:::
:::


Realizamos la FAC y la FACP de la serie del IMAE


::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-7-1.pdf)
:::
:::


En la FAC observamos que hay varios rezagos significativos al inicio y si bien a partir del rezago 14 dejan de serlo, luego algunos como el rezago 24 y 36 si lo son, hay una convergencia lenta hacia el cero. En el caso de la FACP tenemos un patron de rezagos significativos y no significativos desde el 0 hasta el 13 y luego los demas se mantienen dentro de la banda de confianza. Podemos plantear inicialmente que nuestra serie no es estacionaria.

### Logaritmo:

Logaritmizar la serie: Aplicamos logaritmo a la serie por dos razones, la primera fue volver a la varianza mas homogenea y la segunda para linealizar la tendencia. Al comparar la varianza de la serie original con la de la serie logaritimizada, vimos que se redujo de 34.71899 a 0.0033, en cuanto a la tendencia lo veremos mas adelante, el grafico de la serie original y de la serie logaritmizada son muy similares. Luego realizamos la FAC y la FACP de la serie original y de la serie logaritimizada, en ambas vemos un comportamiento no estacionario, con rezagos significativos para valores altos.


::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-8-1.pdf)
:::

::: {.cell-output .cell-output-stdout}

```
[1] "La varianza de la serie original es:"
```


:::

::: {.cell-output .cell-output-stdout}

```
[1] 34.71899
```


:::

::: {.cell-output .cell-output-stdout}

```
[1] "La varianza de la serie logaritmizada es:"
```


:::

::: {.cell-output .cell-output-stdout}

```
[1] 0.003320585
```


:::
:::


FAC y FACP de la serie logaritmizada


::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-9-1.pdf)
:::
:::


La FAC y la FACP de la serie logartimizada no cambio nada con respecto a la serie original.

### Tendencia:

En esta seccion intentamos identificar si nuestra serie presentaba una tendencia creciente o decreciente. Usamos la funcion ndiffs forecast que nos indica el numero de diferencia regulares que debemos aplicar a nuestra serie para filtrarse la tendencia y pasar de una serie no estacionaria a una estacionaria y obtuvimos un 1 como resultado. Luego realizamos el mk.test que es una funcion de R que contrasta la hipotesis: Ho) No hay tendencia vs H1) Hay tendencia. Con este test obtuvimos un p valor menor a 0.05, por lo que rechazamos Ho y nuestra serie presenta tendencia.


::: {.cell}
::: {.cell-output .cell-output-stdout}

```
[1] "Numero de diferencia regulares que debemos aplicar a la serie para obtener una serie estacionaria"
```


:::

::: {.cell-output .cell-output-stdout}

```
[1] 1
```


:::
:::


### Test de Dicky-Fuller:

Utilizamos el test de Dicky-Fuller para testear la existencia de raices unitarias regulares que nos indican tendencia estocastica en nuestra serie, lo que implica no estacionariedad. El contraste de hipotesis que se realiza es el siguiente: Ho) Existe raiz unitaria (serie no estacionaia)\
H1) No Existe raiz unitaria (serie estacionaria).

Utilizamos la funcion ur.df, con nuestra serie de datos original y marcando type=trend para indicar que nuestros datos presentaban tendencia, seleccionando los rezagos con el criterio BIC, el problema que encontramos (que se repitio tambien para el criterio AIC) fue habia autocorrelacion en los residuos, especificamente en los rezagos 6 y 12, por eso decidimos seleccionar el numero de rezagos manualmente poniendo 6, obteniendo asi que la correlacion de los residuos desaparecia. Al aplicar este test en nuestra serie original obtuvimos un valor t de -2.462, los valores criticos asociados a distintos niveles de significacion observados en tau3 son: -3.99 al 1%, -3.43 al 5%, -3.13 al 10%. Notamos que nuestro valor -2.462 es mayor a todos los valores tau3 para todos los niveles de significacion, por lo que no Rechazamos Ho, existen raices unitarias, por lo que la serie presenta tendencia estocastica y no es estacionaria.


::: {.cell}
::: {.cell-output .cell-output-stdout}

```

############################################### 
# Augmented Dickey-Fuller Test Unit Root Test # 
############################################### 

Test regression trend 


Call:
lm(formula = z.diff ~ z.lag.1 + 1 + tt + z.diff.lag)

Residuals:
     Min       1Q   Median       3Q      Max 
-10.5109  -1.9118   0.2532   1.9475   8.8023 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)  
(Intercept) 23.75890    9.68605   2.453   0.0160 *
z.lag.1     -0.24257    0.09853  -2.462   0.0156 *
tt           0.02310    0.01350   1.710   0.0905 .
z.diff.lag1  0.12770    0.12580   1.015   0.3126  
z.diff.lag2 -0.21714    0.12386  -1.753   0.0828 .
z.diff.lag3 -0.08017    0.11353  -0.706   0.4818  
z.diff.lag4 -0.26699    0.10924  -2.444   0.0164 *
z.diff.lag5 -0.01066    0.10114  -0.105   0.9163  
z.diff.lag6  0.26104    0.09982   2.615   0.0104 *
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 3.379 on 95 degrees of freedom
Multiple R-squared:  0.455,	Adjusted R-squared:  0.4091 
F-statistic: 9.912 on 8 and 95 DF,  p-value: 6.198e-10


Value of test-statistic is: -2.462 2.2091 3.1001 

Critical values for test statistics: 
      1pct  5pct 10pct
tau3 -3.99 -3.43 -3.13
phi2  6.22  4.75  4.07
phi3  8.43  6.49  5.47
```


:::
:::


Para ver la significacion de cada lag miro el p-valor

-2.462 es el valor t. 2.2091 es el F del phi2, que testeaba raiz unitaria y tendencia.

Para el phi3 miro el 3.1001, el phi3 me testea tendencia igual cero, hay raiz unitaria y puede existir constante. Como es el caso de mi serie. Esto porque 3.1001 es menor que todos los valores asociados a phi3 para todos los niveles de significacion. Luego 2.2091 testea la existencia de raiz unitaria y de tendencia, en este este valor es menor que todos los valores asociados a phi2 para distintos niveles de significacion, lo que indica que hay raiz unitaria.

Otra prueba que podemos hacer es un ajuste lineal a la serie para detectar tendencia. En el summary de esta prueba, vemos que el p-valor es menor a 0.05, por lo que hay una tendencia. Tambien podemos verlo en la recta de regresion que tiene una pendiente positiva, lo que es indicio de una tendencia creciente en la serie.

Es importante aclarar que esto NO es una prueba de tendencia deterministica, solo es una forma de detectar un comportamiento creciente en la serie.


::: {.cell}
::: {.cell-output .cell-output-stdout}

```

Call:
lm(formula = im_ts ~ time(im_ts))

Residuals:
     Min       1Q   Median       3Q      Max 
-17.3973  -2.4160  -0.5336   3.0934  11.3662 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept) -1967.0143   376.1056  -5.230 8.27e-07 ***
time(im_ts)     1.0243     0.1861   5.503 2.50e-07 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 5.236 on 109 degrees of freedom
Multiple R-squared:  0.2174,	Adjusted R-squared:  0.2103 
F-statistic: 30.29 on 1 and 109 DF,  p-value: 2.497e-07
```


:::

::: {.cell-output .cell-output-stdout}

```

Call:
lm(formula = y ~ t, data = df)

Residuals:
     Min       1Q   Median       3Q      Max 
-17.3973  -2.4160  -0.5336   3.0934  11.3662 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept) -1967.0143   376.1056  -5.230 8.27e-07 ***
t               1.0243     0.1861   5.503 2.50e-07 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 5.236 on 109 degrees of freedom
Multiple R-squared:  0.2174,	Adjusted R-squared:  0.2103 
F-statistic: 30.29 on 1 and 109 DF,  p-value: 2.497e-07
```


:::

::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-12-1.pdf)
:::
:::


El utlimo test de tendencia que hicimos fue el alisis del espectro de la serie que es otra forma de detectar tendencia es las series, cuando se cumple que la frecuencia cero explica gran parte de la varianza (area debajo del espectro), es un indicador de posible tendencia, que es lo que ocurre en nuestra serie.


::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-13-1.pdf)
:::
:::


Filtrar esa tendencia: Realizamos una diferencia regular con la funcion diff para filtrar la tendencia


::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-14-1.pdf)
:::
:::


Realizamos test de vuelta para ver si la filtracion de la tendencia fue efectiva:


::: {.cell}
::: {.cell-output .cell-output-stdout}

```
[1] "Numero de diferencia regulares que debemos aplicar a la serie para obtener una serie estacionaria"
```


:::

::: {.cell-output .cell-output-stdout}

```
[1] 0
```


:::
:::


Si volvemos a hacer el test de dicky-fuller para la serie con la serie regular obtenemos que el valor t de -9.973, los valores criticos asociados a distintos niveles de significacion observados en tau3 son: -3.99 al 1%, -3.43 al 5%, -3.13 al 10%. Notamos que nuestro valor -9.973 es menor a todos los valores tau3 para todos los niveles de significacion, por lo que rechazamos Ho, existen raices unitarias, por lo que la serie no presenta tendencia estocastica y es estacionaria.


::: {.cell}
::: {.cell-output .cell-output-stdout}

```

############################################### 
# Augmented Dickey-Fuller Test Unit Root Test # 
############################################### 

Test regression trend 


Call:
lm(formula = z.diff ~ z.lag.1 + 1 + tt + z.diff.lag)

Residuals:
    Min      1Q  Median      3Q     Max 
-8.7793 -2.6800 -0.3871  2.9859 12.0004 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.132668   0.802791   0.165    0.869    
z.lag.1     -1.204619   0.120785  -9.973  < 2e-16 ***
tt          -0.000176   0.012609  -0.014    0.989    
z.diff.lag   0.372732   0.091452   4.076 8.99e-05 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 4.085 on 104 degrees of freedom
Multiple R-squared:  0.5162,	Adjusted R-squared:  0.5022 
F-statistic: 36.99 on 3 and 104 DF,  p-value: 2.381e-16


Value of test-statistic is: -9.9732 33.1553 49.733 

Critical values for test statistics: 
      1pct  5pct 10pct
tau3 -3.99 -3.43 -3.13
phi2  6.22  4.75  4.07
phi3  8.43  6.49  5.47
```


:::

::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-16-1.pdf)
:::
:::


Para ver la significacion de cada lag miro el p-valor

-9.9732 es el valor t. 33.1553 es el F del phi2, que testeaba raiz unitaria y tendencia.

Para el phi3 miro el 49.733 , el phi3 me testea tendencia igual cero, hay raiz unitaria y puede existir constante. Dado que 49.733 es mayor que todos los valores asociados a phi3 para todos los niveles de significacion, es un indicador de que no hay raiz unitaria ni tendencia distinta de cero, por lo que la serie seria estacionaria.

Luego 33.1553 testea la existencia de raiz unitaria y de tendencia, en este este valor es mayor que todos los valores asociados a phi2 para distintos niveles de significacion, lo que indica que NO hay raiz unitaria.

Otra prueba que podemos hacer es un ajuste lineal a la serie para detectar tendencia. En el summary de esta prueba, vemos que el p-valor es menor a 0.05, por lo que hay una tendencia. Tambien podemos verlo en la recta de regresion que tiene una pendiente positiva, lo que es indicio de una tendencia creciente en la serie.

Volvemos a realizar el ajuste de una recta de regresion, en este caso el p-valor que obtenemos es mayor a 0.05, por lo que es un indicador de no tendencia. En el grafico se ve que la recta se mantiene horizontal y la tendencia se ha filtrado.


::: {.cell}
::: {.cell-output .cell-output-stdout}

```

Call:
lm(formula = im_ts_diff ~ time(im_ts_diff))

Residuals:
    Min      1Q  Median      3Q     Max 
-9.9588 -3.2286 -0.1229  2.5545 11.8161 

Coefficients:
                  Estimate Std. Error t value Pr(>|t|)
(Intercept)       28.71956  316.87820   0.091    0.928
time(im_ts_diff)  -0.01416    0.15682  -0.090    0.928

Residual standard error: 4.352 on 108 degrees of freedom
Multiple R-squared:  7.552e-05,	Adjusted R-squared:  -0.009183 
F-statistic: 0.008157 on 1 and 108 DF,  p-value: 0.9282
```


:::

::: {.cell-output .cell-output-stdout}

```

Call:
lm(formula = y ~ t, data = df)

Residuals:
    Min      1Q  Median      3Q     Max 
-9.9588 -3.2286 -0.1229  2.5545 11.8161 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)
(Intercept)  28.71956  316.87820   0.091    0.928
t            -0.01416    0.15682  -0.090    0.928

Residual standard error: 4.352 on 108 degrees of freedom
Multiple R-squared:  7.552e-05,	Adjusted R-squared:  -0.009183 
F-statistic: 0.008157 on 1 and 108 DF,  p-value: 0.9282
```


:::

::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-17-1.pdf)
:::
:::


Si volvemos a hacer el analisis del espectro vemos que ahora la frecuencia cero explica muy poco la varianza, lo que es un indicador de que filtramos la tendencia.


::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-18-1.pdf)
:::
:::


### Estacionalidad:

Podemos empezar con la funcion nsdiffs que nos indica el numero de diferencias estacionales necesarias para que la serie sea estacionaria, en este caso nos dice que una sola.


::: {.cell}
::: {.cell-output .cell-output-stdout}

```
[1] "Numero de diferencia estacionales que debemos aplicar a la serie para obtener una serie estacionaria"
```


:::

::: {.cell-output .cell-output-stdout}

```
[1] 1
```


:::
:::


Ahora podemos detectar la estacionalidad con el grafico anterior del espectro, los picos que vemos en la frecuencia 2 y en la frecuencia 4 indican posible estacionalidad.

Otra forma de verlo es con la FAC de la serie a la que le aplicamos la diferencia regular en la cual vemos rezagos significativos en 6, 12, 18, 24, 30, 36 y asi en un patron de 6 en 6, lo que es un fuerte indicador de estacionalidad.


::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-20-1.pdf)
:::
:::


Otra forma de detectarla es con el grafico ggmonthplot, donde detectamos que las lineas negras que son los valores de la serie por mes y año muestran un patron. Observamos valores bajos en meses como Enero, valores altos para los meses de Mayo, Octubre, Noviembre y Diciembre y valores intermedios para los demas meses, esto en todos los años, por lo que nuestro modelo presenta un comportamiento estacional. Ademas las medias mensuales (lineas azules) son distintas, lo que indica que el comportamiento promedio depende del mes. Este patron se repite cada 12 meses para todos los años.


::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-21-1.pdf)
:::
:::


Podemos usar la funcion isSeasonal de la libreria forecast para ver si la serie presenta estacionalidad, obteniendo el resultado de TRUE.


::: {.cell}
::: {.cell-output .cell-output-stdout}

```
[1] "Presenta la serie estacionalidad?"
```


:::

::: {.cell-output .cell-output-stdout}

```
[1] TRUE
```


:::
:::


Diferencia Estacional: Aplicamos la diferencia estacional con la funcion diff para filtrar la estacionalidad, como es una serie mensual usamos lag=12.


::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-23-1.pdf)
:::
:::


Volvemos a hacer los test que hicimos pero ahora para la serie sin estacionalidad.

Con nsdiffs vemos ya no hay que hacer diferencias estacionales:


::: {.cell}
::: {.cell-output .cell-output-stdout}

```
[1] "Numero de diferencia estacionales que debemos aplicar para filtrar la estacionalidad"
```


:::

::: {.cell-output .cell-output-stdout}

```
[1] 0
```


:::
:::


Aplicando isSeasonal a nuestra serie logaritmizada, diferenciada regularmente y estacionalmente, vemos que ya no hay estacionalidad


::: {.cell}
::: {.cell-output .cell-output-stdout}

```
[1] "Presenta la serie estacionalidad?"
```


:::

::: {.cell-output .cell-output-stdout}

```
[1] FALSE
```


:::
:::


Graficando el espectro vemos que ya no tenemos la presencia de picos anomalos que se salgan de las frecuencias comunes en las que se mueve el espectro y tomen valores muy altos, pero el comportamiento de pico sigue apareciendo, aunque variando para valores bajos, podemos decir que logramos filtrar bastante la estacionalidad pero aun queda una parte.


::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-26-1.pdf)
:::
:::


Realizamos de nuevo el grafico de ggmonthplot y ahora vemos que las medias tienen valores similares en cada mes, por lo que podemos decir que se ha filtrado el componente estacional.


::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-27-1.pdf)
:::
:::


Por ultimo si observamos la FAC y FACP de la serie logaritmizada, diferenciada regularmente y estacionalmente vemos que han desaparecido los rezagos significativos que se daban siguiendo un patron de 6 en 6, por lo que hemos filtrado la estacionalidad.


::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-28-1.pdf)
:::
:::


Luego de estos procesos, para verificar que las diferencias que hicimos nos dieron una serie estacionaria, podemos usar el test de KPSS, que testea las siguientes hipotesis: Ho) La serie es estacionaria , H1) La serie NO es estacionaria.

Cuando lo hicimos para nuestra serie original, obtuvimos un p valor menor a 0.05, por lo que rechazamos Ho, rechazamos la estacionariedad de la serie. Cuando lo hicimos para la serie con la diferencia regular, obtuvimos un p valor de 0.1, que es mayor a 0.05, por lo que no rechazamos Ho, o sea que nuestra serie diferenciada presenta estacionariedad. Lo mismo para la serie con diferencia estacional.


::: {.cell}
::: {.cell-output .cell-output-stdout}

```

	KPSS Test for Level Stationarity

data:  im_ts
KPSS Level = 0.94481, Truncation lag parameter = 4, p-value = 0.01
```


:::

::: {.cell-output .cell-output-stdout}

```

	KPSS Test for Level Stationarity

data:  Flim_ts_diff
KPSS Level = 0.063726, Truncation lag parameter = 3, p-value = 0.1
```


:::
:::


# Eleccion de Modelo Posible:

Dada la FAC y FACP de nuestra serie logaritmizada y diferenciada regular y estacionalmente una vez, un posible modelo inicial podria ser un SARIMA(0,1,2,0,1,1) Con respecto a la parte regular del SARIMA elegimos q=2 porque hay dos rezagos significativos en la FAC, los demas rezagos son no significativos. Como no hay significancia en los primeros rezagos descartamos un AR (p=0) y usamos d=1 para aplicar una diferencia regular. Con respecto a la parte estacional del SARIMA, el rezago 12 es muy significativo y un poco el rezago 24, esto es evidencia de autocorrelación estacional. El patrón cae después del rezago 12, que ocurre en un MA estacional de orden 1, es decir Q = 1, no econtramos patrones asociados a un AR estacional, por lo que P=0, y aplicamos una diferencia estacional con D=1.


::: {.cell}
::: {.cell-output .cell-output-stdout}

```

z test of coefficients:

     Estimate Std. Error z value  Pr(>|z|)    
ma1  -0.21368    0.10200 -2.0949   0.03618 *  
ma2  -0.21248    0.10809 -1.9658   0.04932 *  
sma1 -0.99996    0.17406 -5.7450 9.193e-09 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


:::
:::


Planteamos nuestro modelo y revisamos la significancia de los coeficientes, en este momento surgio un problema derivado de que al especificar que la serie fuera con logaritmos, los coeficientes asociados a el modelo seleccionado no son significativos, por eso decidimos descartar el uso del logaritmo en nuestra serie y usar la serie original para que los coeficientes si nos quedaran significativos.

Observamos que el coeficiente asociado los dos coeficientes asociados al MA son significativos minimamente, el coeficiente sma1 es muy significativo.

# Diagnostico:

En esta parte primero obtuvimos los residuos y los residuos estandarizados del modelo, realizamos un grafico para ambos residuos.


::: {.cell}

:::



::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-32-1.pdf)
:::
:::


### Incorrelacion de los residuos

Graficamos la FAC y la FACP de los residuos donde vemos que todos los rezagos se encuentran dentro del intervalo de confianza, no son significativos, tanto en la FAC como en la FACP, lo que es un indicador grafico de incorrelacion de los residuos. Luego hicimos el test de Ljung-Box que testea la hipotesis: Ho) Residuos Incorrelacionados , H1) Residuos Correlacionados. Para este test obtuvimos un p-valor de 0.8198 que es mayor a 0.05, por lo que no rechazamos Ho, los residuos se encuentran incorrelacionados.


::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-33-1.pdf)
:::
:::



::: {.cell}
::: {.cell-output .cell-output-stdout}

```

	Box-Ljung test

data:  residuos
X-squared = 17.648, df = 24, p-value = 0.8198
```


:::
:::


### Normalidad de los residuos

Luego la siguiente prueba fue la normalidad de los residuos, primero hicimos un qqplot y un histograma donde observamos que la serie no parecia tener un comporamiento muy normal porque no la linea del qqplot no ajustaba bien a los quantiles, o en el caso del histograma, no se ajustaba del todo a los datos.


::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-35-1.pdf)
:::
:::


Ahora pasamos a hacer dos test, donde en ambos lo que se testea (de distintas formas) son las siguientes hipotesis: Ho) Residuos Distribuyen Normal , H1) Residuos No Distribuyen Normal.

Para terminar de comprobar esto, hicimos el test de Shapiro obteniendo un p valor de 0.004268 que es menor a un nivel de significacion alfa de 0.05, por lo que rechazamos Ho, o sea, rechazamos a hipotesis de normalidad. Luego

Tambien hicimos el test de Jarque-Bera el cual se divide en tres: Jarque-Bera Test Global, donde la hipotesis nula es que los residuos se distribuyen normal y la alternativa es que esto no sucede. Dado que el p valor que obtuvimos es menor a 0.05, podemos rechazar la hipotesis nula, es decir, que los residuos no provienen de una distribucion normal. **Test de Asimetria (Skewness):** En este test Ho es que la asimetria es 0, y H1 es que la asimetria es distinta de 0. En nuestro caso nos dio un p valor de 0.2303, por lo que no rechazamos Ho.\
**Test de Curtosis:** donde Ho es que la curtosis es 3 (que sucede en una distribucion normal) y H1 que no es 3, en nuestro caso el p valor fue menor a 0.05, por lo que rechazamos Ho.


::: {.cell}
::: {.cell-output .cell-output-stdout}

```

	Shapiro-Wilk normality test

data:  residuos
W = 0.96392, p-value = 0.004268
```


:::




::: {.cell-output .cell-output-stdout}

```

	Jarque Bera Test

data:  residuos
X-squared = 23.597, df = 2, p-value = 7.517e-06


	Skewness

data:  residuos
statistic = 0.2789, p-value = 0.2303


	Kurtosis

data:  residuos
statistic = 5.1888, p-value = 2.511e-06
```


:::
:::


### Homocedasticidad de los residuos:

Finalmente hicimos verificamos si se cumplia la Homocedasticidad (varianza constante) de los residuos. Donde nuestra hipotesis nula es que los residuos tienen varianza constante y nuestra hipotesis alternativa es que los residuos tienen varianza no constante. Para esto usamos la funcion ArchTest de la libreria FinTS, obteniendo un p valor de 0.8215, por lo que como este valor es superior a un nivel de significacion alfa de 5%, no rechazamos Ho y los residuos tienen una varianza constante.

Finalmente testeamos la homoscedasticidad (varianza constante) de los residuos, donde la


::: {.cell}
::: {.cell-output .cell-output-stdout}

```

	Box-Ljung test

data:  residuos2
X-squared = 21.496, df = 24, p-value = 0.6093
```


:::

::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-37-1.pdf)
:::
:::


# Outliers:

Como contexto, los outliers pueden deberse a el efecto de la pandemia de Covid-19 desde inicios de 2020 hasta inicios de 2022. El shock afecto varios meses a la economía, y por consecuecia, al IMAE.

Para solucionar el problema de no normalidad de los residuos de nuestro modelo estimado, que puede estar causado por la presencia de outliers en nuestro modelo, lo que hicimos fue usar la funcion tso del paquete tsoutliers que detecta el tipo, el tiempo y la magnitud del outlier, ademas especificamos que se consideraran outliers del tipo "AO","LS","TC", estas consideraciones se almacenan en la variable xreg los efectos de estos, ademas de reestimar nuestro modelo ARIMA incluyendo esos elementos. Realizamos un grafico donde vemos la serie original contra la serie con los outliers ajustados, junto con un grafico de los efectos de los outliers. Finalmente re-estimamos nuestro modelo elegido incorporando a los outliers.


::: {.cell}
::: {.cell-output .cell-output-stdout}

```

Call:
list(method = "ML")

Coefficients:
          ma1     ma2     sma1      TC52
      -0.6110  0.0526  -0.9999  -14.2556
s.e.   0.1191  0.1217   0.3008    2.1609

sigma^2 estimated as 4.251:  log likelihood = -223.46,  aic = 456.91

Outliers:
  type ind    time coefhat  tstat
1   TC  52 2020:04  -14.26 -6.597
```


:::
:::



::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-39-1.pdf)
:::
:::


Para dar un poco de contexto, este outlier ocurre en Abril de 2020, que fue el punto donde inicio la emergencia sanitaria de Covid-19, lo que tuvo un efecto importante en la economía, y por lo tanto en el IMAE. Podemos observar en el gráfico que este outlier tuvo un efecto del tipo TC (Transitory Change), esto nos indica que la pandemia tuvo un efecto bastante fuerte en la serie del IMAE, pero vemos que fue desapareciendo poco a poco a lo largo de los años el efecto de este outlier, lo que coincide con que la economía se fue estabilizando con el paso de los años, hasta volver al valor en el que se encontraba en aproximadamente 2022, como se ve en el gráfico para el caso del IMAE.


::: {.cell}
::: {.cell-output .cell-output-stdout}

```

z test of coefficients:

       Estimate Std. Error z value  Pr(>|z|)    
ma1   -0.610954   0.119133 -5.1283 2.923e-07 ***
ma2    0.052593   0.121702  0.4321 0.6656388    
sma1  -0.999925   0.300763 -3.3246 0.0008854 ***
TC52 -14.255597   2.160914 -6.5970 4.195e-11 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


:::
:::


Ahora el problema que tenemos con este nuevo modelo que incorpora los outliers es que los coeficientes ma2 y sma1 no son significativos, por lo que vamos a plantear un nuevo modelo llamado "modelo2" quitando el ma2 que sera un SARIMA(0,1,1)(0,1,1)\[12\]


::: {.cell}
::: {.cell-output .cell-output-stdout}

```

z test of coefficients:

     Estimate Std. Error z value  Pr(>|z|)    
ma1  -0.24786    0.12218 -2.0286    0.0425 *  
sma1 -0.99989    0.17149 -5.8306 5.521e-09 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


:::

::: {.cell-output .cell-output-stdout}

```

z test of coefficients:

       Estimate Std. Error z value  Pr(>|z|)    
ma1   -0.620803   0.088326 -7.0286 2.087e-12 ***
sma1  -0.943750   0.465672 -2.0266    0.0427 *  
LS51  -7.164275   1.808824 -3.9607 7.472e-05 ***
TC52 -10.499569   2.044675 -5.1351 2.820e-07 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


:::
:::


Al nuevo modelo que propusimos le calculamos los outliers y los incorporamos a este nuevo modelo, luego al plantear la significacion de los coeficientes de esto nuevo modelo ajustado por los outliers, vimos que todos son significativos.

Podemos comparar que modelo es mejor usando criterios de AIC, AICc y BIC:


::: {.cell}
::: {.cell-output .cell-output-stdout}

```
              df      AIC
modelo1_nuevo  5 456.9145
modelo2_nuevo  5 442.8062
```


:::

::: {.cell-output .cell-output-stdout}

```
              df     AICc
modelo1_nuevo  5 457.5667
modelo2_nuevo  5 443.4584
```


:::

::: {.cell-output .cell-output-stdout}

```
              df      BIC
modelo1_nuevo  5 469.8394
modelo2_nuevo  5 455.7310
```


:::
:::


Vemos que en todos los criterios, el modelo2 tiene un valor menor, por lo que nos quedaremos con ese modelo.

# RE-DIAGNOSTICO CON ESTE NUEVO MODELO:

Volvimos a hacer la etapa de diagnostico del modelo, pero ahora usando nuestro modelo nuevo ajustado por sus outliers. En este caso se siguio cumpliendo la incorrelacion de los residuos y la homoscedasticidad de la varianza como ocurria con el modelo anterior, pero logramos mejorar nuestro problema de no normalidad de los residuos, ya que ahora al incorporar los outliers en nuestro modelo, conseguimos que los residuos distribuyeran de forma normal. El qqplot y el histograma se ajustaban mejor y tanto para el test de Shapiro como el test de JarqueBera (global, simetria y curtosis), obtuvimos p_valores mayores a 0.05, por lo que no rechazamos la hipotesis nula que plantea normalidad de los residuos.

El grafico de los residuos y los residuos estandarizados de este nuevo modelo ajustado por sus outliers.


::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-43-1.pdf)
:::
:::


### Test de Incorrelacion:

La FAC y FACP de los residuos, donde vemos que los residuos estan incorrelacionados.


::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-44-1.pdf)
:::
:::


Hacemos el test de Ljung-Box y obtenemos un p valor de 0.7384 por lo que no rechazamos la hipotesis nula de incorrelacion de los residuos.


::: {.cell}
::: {.cell-output .cell-output-stdout}

```

	Box-Ljung test

data:  residuos_nuevo
X-squared = 19.252, df = 24, p-value = 0.7384
```


:::
:::


El test me dio correcto aunque el grafico tenga ese elemento significativo. Si el test no da ahi si dudaba

### Test de Normalidad

Grafico de qqplot y histograma


::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-46-1.pdf)
:::
:::


Ahora vemos que no rechazamos Ho, la hipotesis de la normalidad, dado que al incorporar este nuevo modelo con sus outliers ajustados, corregimos el problema de la normalidad y ahora los residuos si se distribuyen normal.


::: {.cell}
::: {.cell-output .cell-output-stdout}

```

	Shapiro-Wilk normality test

data:  residuos_nuevo
W = 0.98571, p-value = 0.2866
```


:::




::: {.cell-output .cell-output-stdout}

```

	Jarque Bera Test

data:  residuos_nuevo
X-squared = 0.9905, df = 2, p-value = 0.6094


	Skewness

data:  residuos_nuevo
statistic = 0.219, p-value = 0.3462


	Kurtosis

data:  residuos_nuevo
statistic = 2.8506, p-value = 0.748
```


:::
:::


### Testeo de Homoscedasticidad

Para este nuevo modelo con sus outliers ajustados, el p valor nos da mayor a 0.05, por lo que no rechazamos Ho, asi que la varianza es constante.


::: {.cell}
::: {.cell-output .cell-output-stdout}

```

	Box-Ljung test

data:  residuos2
X-squared = 20.07, df = 24, p-value = 0.6928
```


:::

::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-48-1.pdf)
:::
:::


# Prediccion:

Primero definimos un horizonte de prediccion con valor 10, para predecir los siguientes 8 meses, luego con la matriz outoutliers.effects generamos una matriz de los efectos (regresores) en la serie generados por los outliers detectatos usando tso, esto lo almacenamos en la variable newxreg1. Estamos viendo estos efectos de los outliers para los datos observados y para los futuros h pasos. Como solo te interesan los valores para la predicción futura, seleccionás desde t+1 hasta t+h. Queremos los valores para la prediccion futura, por eso vamos desde t+1 hasta t+h, en newxreg1 almacenamos la matriz con los valores esperados de los outliers en esos períodos futuros. Hacemos la prediccion del modelo ajustado por los outliers que teniamos, para hacer esta prediccion usamos la funcion forecast y consideramos los efectos futuros de los outliers como variables explicativas para la predicción en el parametron xreg de la funcion, pasandole newxreg1. Finalmente graficamos el resultado.


::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-49-1.pdf)
:::
:::



::: {.cell}
::: {.cell-output .cell-output-stdout}

```
          Jan Feb Mar      Apr      May      Jun      Jul      Aug      Sep
2025                  108.8157 113.7329 112.2053 108.4833 108.6379 107.7783
2026 111.7885                                                              
          Oct      Nov      Dec
2025 110.7898 116.8307 119.2311
2026                           
```


:::

::: {.cell-output .cell-output-stdout}

```
[1] 4.326058
```


:::
:::



::: {.cell}
::: {.cell-output .cell-output-stdout}

```
      fecha valores_reales_periodo_anterior predicho tasa_interanual_porcentaje
1  2025.250                         109.550 108.8157                -0.67032396
2  2025.333                         114.388 113.7329                -0.57269366
3  2025.417                         109.847 112.2053                 2.14685580
4  2025.500                         106.304 108.4833                 2.05002822
5  2025.583                         108.016 108.6379                 0.57576899
6  2025.667                         107.479 107.7783                 0.27849622
7  2025.750                         112.285 110.7898                -1.33159618
8  2025.833                         116.734 116.8307                 0.08280331
9  2025.917                         115.539 119.2311                 3.19551093
10 2026.000                         109.956 111.7885                 1.66657692
```


:::

::: {.cell-output .cell-output-stdout}

```
Tasa promedio anual de crecimiento IMAE 2025 respecto a 2024: 0.64 %
```


:::
:::


Nuestros datos los datos del IMAE van desde el 01/01/2016 hasta el 01/03/2025. Vamos a predecir 10 meses adelante, hasta el 01/01/2026.


::: {.cell}

:::


# Validacion de las Predicciones:

Dividimos la serie de datos en dos conjuntos, el conjunto de train (entrenamiento) y el conjunto de test (testeo). El conjunto de train se usa para ajustar el modelo, el conjunto de tets se usa para evaluar el rendimiento predicitivo del modelo. Al particionar asi,conocemos lo que ha ocurrido pero el modelo no lo conoce, por lo que al predecir fuera de la muestra, veremos que tan bien lo ha hecho. En la parte de entrenamiento el modelo aprende la estructura (tendencia, estacionalidad, shocks), de la serie. Y en la parte de test predice sobre los datos nuevos que no conoce. Cuando haga la prediccion, compararemos lo que predijo con lo que realmente ocurrio, calculando métricas de error como RMSE, MAE, MAPE, etc. Se analiza si el patrón de error no deja autocorrelación en los residuos.

En nuestro caso usamos dummies (xreg) para representar eventos anómalos del pasado. Al validar, esos eventos no se repiten en el futuro, por lo que esos regresores valen cero.

Nuestra serie del IMAE tiene 111 observaciones, vamos a usar 99 observaciones para el conjunto de entrenamiento, que sera lo que ocurrio desde 01/01/2016 hasta 01/03/2024. Luego usaremos 12 observaciones para evaluar el rendimiento de nuestro modelo dentro de la muestra, donde el modelo hara una prediccion de lo que ocurrio desde el 01/03/2024 hasta el 01/03/2025, donde nosotros ya sabemos lo que ocurrio y podremos comparar el rendimiento de nuestro modelo.

datos los datos del IMAE van desde el 01/01/2016 hasta el 01/03/2025. Vamos a predecir 10 meses adelante, hasta el 01/01/2026.


::: {.cell}

:::



::: {.cell}

:::



::: {.cell}
::: {.cell-output-display}
![](Series_Proyecto--7-_files/figure-pdf/unnamed-chunk-55-1.pdf)
:::
:::



::: {.cell}
::: {.cell-output .cell-output-stdout}

```
      fecha    real predicho     error error_abs
1  2024.250 109.550 104.4183 5.1317106 5.1317106
2  2024.333 114.388 109.2351 5.1528844 5.1528844
3  2024.417 109.847 108.0034 1.8436373 1.8436373
4  2024.500 106.304 104.2455 2.0584825 2.0584825
5  2024.583 108.016 104.1334 3.8825670 3.8825670
6  2024.667 107.479 103.2114 4.2676307 4.2676307
7  2024.750 112.285 105.9581 6.3268669 6.3268669
8  2024.833 116.734 112.2185 4.5155483 4.5155483
9  2024.917 115.539 115.1016 0.4374347 0.4374347
10 2025.000 109.956 107.3678 2.5882026 2.5882026
11 2025.083 105.882 104.0185 1.8635099 1.8635099
12 2025.167 107.153 104.3209 2.8320551 2.8320551
```


:::
:::



::: {.cell}
::: {.cell-output .cell-output-stdout}

```
                 [,1]        [,2]        [,3]        [,4]        [,5]
fecha     2024.250000 2024.333333 2024.416667 2024.500000 2024.583333
real       109.550000  114.388000  109.847000  106.304000  108.016000
predicho   104.418289  109.235116  108.003363  104.245517  104.133433
error        5.131711    5.152884    1.843637    2.058483    3.882567
error_abs    5.131711    5.152884    1.843637    2.058483    3.882567
                 [,6]        [,7]        [,8]         [,9]       [,10]
fecha     2024.666667 2024.750000 2024.833333 2024.9166667 2025.000000
real       107.479000  112.285000  116.734000  115.5390000  109.956000
predicho   103.211369  105.958133  112.218452  115.1015653  107.367797
error        4.267631    6.326867    4.515548    0.4374347    2.588203
error_abs    4.267631    6.326867    4.515548    0.4374347    2.588203
               [,11]       [,12]
fecha     2025.08333 2025.166667
real       105.88200  107.153000
predicho   104.01849  104.320945
error        1.86351    2.832055
error_abs    1.86351    2.832055
```


:::
:::


Evaluamos la calidad de la prediccion con distintas metricas, una es que lo observados se mantienen dentro del intervalo de confianza, es lo que esperaba, es un buen indicador de capacidad predictiva.


::: {.cell}
::: {.cell-output .cell-output-stdout}

```
                     ME     RMSE      MAE        MPE     MAPE      MASE
Training set -0.1426441 1.900697 1.422209 -0.1596252 1.395727 0.3621734
Test set      3.4083775 3.792677 3.408378  3.0839426 3.083943 0.8679621
                    ACF1 Theil's U
Training set -0.03673229        NA
Test set      0.27703844  0.997677
```


:::
:::


ME es el promedio de los errores, casi sin sesgo, pero sobreestima un poco. RMSE es la raíz cuadrada del error cuadrático medio, el modelo es más preciso en test. MAE es el promedio del valor absoluto del error, en test y train son muy similares. MPE es el promedio de los errores porcentuales, casi sin sesgo porcentual. MAPE es el promedio del valor absoluto de errores porcentuales, es muy bajo, indica un buen ajuste. MASE es el Error absoluto medio escalado que es un MAE comparado con el MAE de un modelo random walk, con los valores vemos que es mejor que ese modelo. ACF1 es la autocorrelación del primer rezago en residuos, hay algo de autocorrelación en test. Theil’s U Compara el modelo con naive, el modelo es mejor que una predicción naive. Un naive es un modelo que predice lo mismo que el ultimo valor.

# Conclusiones Finales:

Luego de haber seguido la metodología que usamos en el informe, el modelo que obtuve, si bien no es perfecto, considero que está bien seleccionado y que tiene una capacidad predictiva buena, basándome en los parámetros de error predictivo que vimos. Considero que los test para detectar la tendencia y la estacionalidad fuero claves para mejorar a nuestro modelo, junto con la consideración de outliers que podían afectar el rendimiento del mismo. Se observó que la aplicación del logaritmo no fue muy eficiente, y me pareció relevante destacar que el trabajar con series de tiempo no es una actividad automática, sino que se debe iterar una y otra vez las técnicas que usamos, verificando el rendimiento de lo que planteamos y el cumplimiento de determinados supuestos, para ir obteniendo mejores resultados, es un proceso de aprendizaje y mejoramiento continuo.

# ANEXO

Justificacion) Mejor usar modelos mas parsimoniosos (menor cantidad de parametros posibles)

Probar el rjdemetra. que da un modelo que compite con el nuestro. Para evaluarlo en prediccion contra el modelo que yo use
