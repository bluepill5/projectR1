###################################################################################################
#  
#  NOTAS:
#
###################################################################################################

- El c�digo fue creado en R versi�n 3.0.0.

- El c�digo principal est� en el archivo "final_code.R".

- Para la extracci�n de los datos, se asume que se tiene conexi�n a internet.

- Se necesita cambiar las variables: "directoryForImages" y 
  "directoryForCodes" en el c�digo con las rutas completas en que se desea 
  guardar las imagenes, y la ruta donde se van a cargar las dem�s partes del 
  c�digo, respectivamente.

- En el caso de series multivariadas, para la estimaci�n de los par�metros
  se usa el paquete "KFAS" versi�n 0.6.1, por lo que entre los archivos se
  encuentra c�digo fuente, as� que solo es necesario correr el siguiente 
  comando: install.packages("KFAS_0.6.1.tar.gz", type="source"), y cargar el
  paquete.

- Se pueden cambiar las fechas usadas en las variables: "start.date", 
  "end.date" y "horizont", por las preferentes, matiendo el hecho de que
  "start.date" < "end.date" < "horizont".

- Se pueden cambiar las acciones usadas en la variable: "symbols.equities", 
  solo con la condici�n de que sean al menos dos, y la primera represente al
  �ndice del mercado.

- En el caso univariado , la variable "gibbsOut.1" que es de las simulaciones
  MCMC, se ha cargado de un archivo, por lo que si se desea realizar las 
  simulaciones con distintos par�metros se debe comentar 
  "gibbsOut.1 <- readRDS(file)" y quitar el comentario a la parte de la 
  simulaci�n.
