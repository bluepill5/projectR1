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
  * Paquete dlm
* __Implementaci&oacute;n__
  * Descripci&oacute;n de los Datos
  * Ajuste del Modelo
  * Resultados  

---

## Modelos de Espacio de Estados
Un modelo de *Espacio de Estados* $\theta_0 \sim\mathcal{N}_p(m_0,C_0)$


---

## Modelos Din&aacute;micos Lineales
$$\theta_0 \sim\mathcal{N}_p(m_0,C_0)\\
Y_t=F_t\theta_t+v_t,\hspace{12mm} v_t \sim\mathcal{N}_m(0,V_t)\\
\theta_t=G_t\theta_{t-1}+w_t,\hspace{12mm} w_t \sim\mathcal{N}_P(0,W_t)$$

---

## Where to look for different types of questions

* R programming (see also: [http://bit.ly/Ufaadn](http://bit.ly/Ufaadn))
  * Search the archive of the class forums
  * Read the manual/help files
  * Search on the web
  * Ask a skilled friend
  * Post to the class forums
  * Post to the [R mailing list](http://www.r-project.org/mail.html) or [Stackoverflow](http://stackoverflow.com/)
* Data Analysis/Statistics
  * Search the archive of the class forums
  * Search on the web
  * Ask a skilled friend
  * Post to the class forums
  * Post to [CrossValidated](http://stats.stackexchange.com/)

---

## Some important R functions

__Access help file__

```r

?rnorm
```


__Search help files__

```r
help.search("rnorm")
```


__Get arguments__

```r
args("rnorm")
```

```
function (n, mean = 0, sd = 1) 
NULL
```


---

## Some important R functions
__See code__

```r
rnorm
```

```
function (n, mean = 0, sd = 1) 
.External(C_rnorm, n, mean, sd)
<bytecode: 0x0be8b224>
<environment: namespace:stats>
```


__R reference card__

[http://cran.r-project.org/doc/contrib/Short-refcard.pdf](http://cran.r-project.org/doc/contrib/Short-refcard.pdf)


---

## Be specific in the title of your questions

* Bad:
  * HELP! Can't fit linear model!
  * HELP! Don't understand PCA!

* Better
  * R 2.15.0 lm() function produces seg fault with large data frame, Mac OS X
10.6.3
  * Applied principal component analysis to a matrix - what are U, D, and $V^T$?

* Even better
  * R 2.15.0 lm() function on Mac OS X 10.6.3 -- seg fault on large data frame
  * Using principal components to discover common variation in rows of a matrix, should I use U, D or $V^T$?


---

## A note on Googling data analysis questions

* The best place to start for general questions is our forum
* [Stackoverflow](http://stackoverflow.com/),[R mailing list](http://www.r-project.org/mail.html) for software questions, [CrossValidated](http://stats.stackexchange.com/) for more general questions
* Otherwise Google "[data type] data analysis" or "[data type] R package"
* Try to identify what data analysis is called for your data type
  * [Biostatistics](http://en.wikipedia.org/wiki/Biostatistics) for medical data
  * [Data Science](http://en.wikipedia.org/wiki/Data_science) for data from web analytics
  * [Machine learning](http://en.wikipedia.org/wiki/Machine_learning) for data in computer science/computer vision
  * [Natural language processing](http://en.wikipedia.org/wiki/Natural_language_processing ) for data from texts
  * [Signal processing](http://en.wikipedia.org/wiki/Signal_processing) for data from electrical signals
  * [Business analytics](http://en.wikipedia.org/wiki/Business_analytics) for data on customers
  * [Econometrics](http://en.wikipedia.org/wiki/Econometrics) for economic data
  * [Statistical process control](http://en.wikipedia.org/wiki/Statistical_process_control) for data about industrial processes
  * etc.


---

## Credits

* Roger's [Getting Help Video](http://www.youtube.com/watch?v=ZFaWxxzouCY&list=PLjTlxb-wKvXNSDfcKPFH2gzHGyjpeCZmJ&index=3)
* Inspired by Eric Raymond's "How to ask questions the smart way"


---

## Una imagen

<img class=center src=assets/img/dW_Densities.svg height='60%'/>
