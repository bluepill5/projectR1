---
title : Modelos Dinamicos Lineales
subtitle : Aplicados a Series de Tiempo Lineales
author : Alexandro Mayoral Teran
job :
framework : io2012 # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js # {highlight.js, prettify, highlight}
hitheme : zenburn #
widgets : [mathjax] # {mathjax, quiz, bootstrap}
mode : selfcontained # {standalone, draft}
---





## Ideas Principales

* __Modelos Din&aacute;micos Lineales__
  * Modelos de Espacio de Estados
  * Modelos Din&aacute;micos Lineales
  * Estimaci&oacute;n y Predici&oacute;n de los Estados
  * Paquete _dlm_
* __Implementaci&oacute;n__
  * Descripci&oacute;n de los Datos
  * Ajuste del Modelo
  * Resultados  


---

## Modelos de Espacio de Estados

La idea de los _Modelos de Espacio de Estados_ surge en los 70's, al buscar formas modelar sistemas din&aacute;micos (es decir, sistemas que varian con el tiempo), como ejemplo de un sistema din&aacute;mico se puede considerar los rendimientos de alguna acci&oacute;n, donde el valor de los rendimiento se consideran la salida del sistema.

<img class=center src=assets/img/AAPL.svg height='80%' width='80%'/>


---

## &#191;Como modelar el sistema?

Sabemos que el comportamieto de una sucesi&oacute;n de variables aleatorias ($Y_t$) queda especificado por su distribuci&oacute;n conjunta, pero obtenerla en el caso de una serie de tiempo puede llegar a ser muy complicado, _&#191;Qu&eacute; podemos hacer?_.

* De este problema surge la idea de usar una sucesi&oacute;n de variables aleatorias ($\theta_t$), que sirvan como auxiliares en el modelamiento de la distribuci&oacute;n conjunta de la serie.

* Para ello esta sucesi&oacute;n debe cumplir con la propiedad de _Markov_.

* Con este planteamiento el modelo quedar&iacute; espec&iacute;ficado con la distribuci&oacute;n inicial de $latex \theta_0$.

Entonces, un __modelo de espacio de estados__ consiste de las series de tiempo real valuadas $(\theta_t : t=0,1, \ldots ) \in R^p$  y $(y_t : t=0,1, \ldots ) \in R^m$  que satisfacen:

1. ($\theta_t$) es una cadena de Markov.
2. Condicionando sobre $\theta_t$ las $Y_t^\prime s$ son independientes, es decir $Y_t$ depende solamente de $\theta_t$.


---
## Un caso particular: Los Modelos Din&aacute;micos Lineales

Un __Modelo Din&aacute;mico Lineal__ queda determinado por la distribuci&oacute;n inicial de $\theta_0$, es decir:
$$
\theta_0 \sim\mathcal{N}_p(m_0,C_0)
$$
junto con el par de ecuaciones para cada tiempo $t\geq1$,
$$
Y_t=F_t\theta_t+v_t,\hspace{12mm} v_t \sim\mathcal{N}_m(0,V_t)\\
\theta_t=G_t\theta_{t-1}+w_t,\hspace{12mm} w_t \sim\mathcal{N}_P(0,W_t)
$$

La primera ecuaci&oacute;n es conocida como la __ecuaci&oacute;n de las observaciones__, mientras que la segunda, se le conoce como la __ecuaci&oacute;n de los estados__ o __sistema de ecuaciones__. Se asume adem&aacute;s, que $\theta_0$ es independiente de $(v_t)$ y $(w_t)$.


---

## Estimaci&oacute;n y predicci&oacute;n de los estados

Si disponemos de una serie de tiempo hasta el tiempo $t$, es decir $y_{1:t}$, si buscamos hacer inferencia de los estados, necesitamos conocer la densidad condicional $\pi(\theta_s\mid y_{1:t})$, de lo cual podemos observar tres casos: 
  * __Filtraci&oacute;n__ cuando $s=t$
  * __Predicci&oacute;n__ cuando $s>t$
  * __Suavizamiento__ o __an&aacute;lisis retrospectivo__ cuando $s&#60;t$

---

## Filtraci&oacute;n (Filtering)

__Idea:__

1. Se obtiene la distribuci&oacute;n predectiva del estado $\theta_t$, dada las observaciones $y_{1:t-1}$, (i.e. $\pi(\theta_t\mid y_{1:t-1}))$, usando la densidad _filtrada_ $\pi(\theta_{t-1}\mid y_{1:t-1})$ y la distribuci&oacute;n condicional $\pi(\theta_t\mid \theta_{t-1})$

2. Se obtiene la distribuci&oacute;n predictiva de la siguiente observaci&oacute;n $y_t$ dado las observaciones anteriores $y_{1:t-1}$, (i.e. $\pi(y_t\mid y_{1:t-1}))$

3. Se obtiene la distribuci&oacute;n filtrada $\pi(\theta_t\mid y_{1:t})$ usando la regla de Bayes con  $\pi(\theta_t\mid y_{1:t-1})$ como la distribuci&oacute;n apriori y $\pi(y_t \mid \theta_t)$ como la de m&aacute;xima verosimilitud.

Partiendo de la distribuci&oacute;n inicial $\theta_0\sim\pi(\theta_0)$, los pasos anteriores se pueden realizar de manera recursiva, para $t=1,2,\ldots$


---
## Filtro de Kalman: Filtering

Consideremos el DLM, y supongamos:
$$\theta_{t-1}\mid y_{1:t-1} \sim\mathcal{N}(m_{t-1},C_{t-1})$$
Entonces los siguientes enunciados se cumplen:
  1. La distribuci&oacute;n predictiva (del primer paso) de $\theta_t$ dado $y_{1:t-1}$ es Gaussiana con par&aacute;metros:
$$
a_t=E(\theta_t\mid y_{1:t-1})=G_tm_{t-1},
R_t=Var(\theta_t\mid y_{1:t-1})=G_tC_{t-1}G'_t+W_t
$$
  2. La distribuci&oacute;n predictiva (del primer paso) de $Y_t$ dado $y_{1:t-1}$ es Gaussiana con par&aacute;metros:
$$
f_t=E(Y_t\mid y_{1:t-1})=F_ta_t,
Q_t=Var(Y_t\mid y_{1:t-1})=F_tR_tF'_t+V_t.
$$
  3. La distribuci&oacute;n filtrada de $\theta_t$ dado $y_{1:t}$ es Gaussiana con par&aacute;metros:
$$
m_t=E(\theta_t\mid y_{1:t})=a_t+R_tF'_tQ^{-1}_te_t,
C_t=Var(\theta_t\mid y_{1:t})=R_t-R_tF'_tQ^{-1}_tF_tR_t
$$
donde $e_t=Y_t-f_t$, el error de predicci&oacute;n.


---
## Filtro de Kalman: Suavizamiento

Consideremos un DLM, si:
$$\theta_{t+1}\mid y_{1:T} \sim\mathcal{N}(s_{t+1},S_{t+1})$$
entonces:
$$\theta_{t}\mid y_{1:T} \sim\mathcal{N}(s_{t},S_{t})$$
donde:
$$
s_t = m_t+C_tG_{t+1}'R_{t+1}^{-1}(s_{t+1}-a_{t+1}),\\
S_t = C_t-C_tG_{t+1}'R_{t+1}^{-1}(R_{t+1}-S_{t+1})R_{t+1}^{-1}G_{t+1}C_t
$$


---

## Predicci&oacute;n

Considera el DLM, y supongamos que: $a_t(0)=m_t$ y $R_t(0)=C_t$.
Entonces los siguientes enunciados se cumplen:

  1. La distribuci&oacute;n predictiva de $\theta_{t+k}$ dado $y_{1:t-1}$ es Gaussiana con par&aacute;metros:
  $$
  a_t(k) = G_{t+k}a_{t}(k-1),\\
  R_t(k) = G_{t+k}R_{t}(k-1)G'_{t+k}+W_{t+k}.
  $$
  2. La distribuci&oacute;n predictiva de $Y_{t+k}$ dado $y_{1:t}$ es Gaussiana con par&aacute;metros:
  $$
  f_t(k) = F_{t+k}a_t(k),\\
  Q_t(k) = F_{t+k}R_t(k)F'_{t+k}+V_{t+k}.
  $$

Donde, para $k\geq 1$, definimos:
$$
a_{t+k}(k)=E(\theta_{t+k}\mid y_{1:t}), \hspace{5mm} R_{t+k}(k)=Var(\theta_{t+k}\mid y_{1:t}),\\
f_{t+k}(k)=E(Y_{t+k}\mid y_{1:t}), \hspace{5mm} Q_{t+k}(k)=Var(Y_{t+k}\mid y_{1:t}).
$$


---

## Paquete _dlm_

__Creaci&oacute;n de un Modelo Din&aacute;mico Lineal__

```r

?dlm
```


__Filtro de Kalman__

```r

?dlmFilter
```


__Suavizamiento__

```r

?dlmSmooth
```


---

## Paquete _dlm_

__Predicci&oacute;n__

```r

?dlmForecast
```


---

## Credits

* [bluepills89@gmail.com](https://github.com/bluepill5)


