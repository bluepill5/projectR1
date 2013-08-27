###################################################################################################
#  
#  NOTAS:
#
###################################################################################################

- El código fue creado en R versión 3.0.0.

- El código principal está en el archivo "final_code.R".

- Para la extracción de los datos, se asume que se tiene conexión a internet.

- Se necesita cambiar las variables: "directoryForImages" y 
  "directoryForCodes" en el código con las rutas completas en que se desea 
  guardar las imagenes, y la ruta donde se van a cargar las demás partes del 
  código, respectivamente.

- En el caso de series multivariadas, para la estimación de los parámetros
  se usa el paquete "KFAS" versión 0.6.1, por lo que entre los archivos se
  encuentra código fuente, así que solo es necesario correr el siguiente 
  comando: install.packages("KFAS_0.6.1.tar.gz", type="source"), y cargar el
  paquete.

- Se pueden cambiar las fechas usadas en las variables: "start.date", 
  "end.date" y "horizont", por las preferentes, matiendo el hecho de que
  "start.date" < "end.date" < "horizont".

- Se pueden cambiar las acciones usadas en la variable: "symbols.equities", 
  solo con la condición de que sean al menos dos, y la primera represente al
  índice del mercado.

- En el caso univariado , la variable "gibbsOut.1" que es de las simulaciones
  MCMC, se ha cargado de un archivo, por lo que si se desea realizar las 
  simulaciones con distintos parámetros se debe comentar 
  "gibbsOut.1 <- readRDS(file)" y quitar el comentario a la parte de la 
  simulación.
