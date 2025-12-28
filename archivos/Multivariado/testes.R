Box <- function(datos, grupo) {
  # Número total de observaciones
  N <- nrow(datos)
  
  # Convertir grupos a factor
  grupo <- as.factor(grupo)
  
  # Número de grupos
  ng <- length(levels(grupo))
  
  # Grados de libertad internos (resta de observaciones menos grupos)
  v <- N - ng
  
  # Número de variables (columnas)
  p <- length(datos)
  
  # Grados de libertad del estadístico
  df <- ((ng - 1) * p * (p + 1)) / 2
  
  # Calcular matrices de varianzas por grupo
  Si <- by(datos, grupo, var)
  
  # Calcular tamaños de grupo
  ni <- by(datos, grupo, nrow)
  ni <- as.vector(unlist(ni))
  
  # Inicializar matriz de covarianza agrupada
  S <- matrix(0, p, p)
  
  # Suma de matrices de covarianza ponderadas por grupo
  for (j in 1:length(ni)) {
    S <- S + (ni[j] - 1) * matrix(unlist(Si[j]), p, p)
  }
  
  # Covarianza agrupada
  S <- S / v
  
  # Parte log-determinante de las covarianzas individuales
  suma <- 0
  for (j in 1:length(ni)) {
    suma <- suma + (ni[j] - 1) * log(det(matrix(unlist(Si[j]), p, p)))
  }
  
  # Estadístico Q de Box
  Q <- log(det(S)) * v - suma
  
  # Corrección de Box (ajuste por tamaño de muestra)
  c1 <- (p * (2 * p + 3) - 1) / (6 * (ng - 1) * (p + 1)) * (sum(1 / (ni - 1)) - 1 / v)
  
  # Estadístico corregido
  Q <- c(Box.M = Q, adj.M = (1 - c1) * Q)
  
  # Repetir los grados de libertad para ambos estadísticos
  df <- rep(df, 2)
  
  # Valor p asociado a cada estadístico
  chi <- data.frame(
    Statistic = Q,
    df = df,
    Pr = 1 - pchisq(Q, df),
    row.names = c("Box.M", "adj.M")
  )
  
  print(chi)
}




testM <- function(y) {
  n <- nrow(y)  # número de observaciones
  p <- ncol(y)  # número de variables
  
  dfchi <- p * (p + 1) * (p + 2) / 6  # grados de libertad
  
  q <- diag(n) - (1 / n) * matrix(1, n, n)  # matriz centradora
  
  y <- as.matrix(y)
  
  # Matriz de covarianza
  s <- t(y) %*% q %*% y
  s <- (1 / n) * s
  
  sinv <- ginv(s)  # inversa generalizada (en caso de singularidad)
  
  # Matriz g asociada a normalidad
  gmatriz <- q %*% y %*% sinv %*% t(y) %*% q
  
  # Coeficientes de Mardia
  beta1hat <- sum(gmatriz * gmatriz * gmatriz) / (n * n)  # asimetría
  beta2hat <- sum(diag(gmatriz * gmatriz)) / n           # curtosis
  
  # Estadísticos kappa
  kappa1 <- n * beta1hat / 6
  kappa2 <- (beta2hat - p * (p + 2)) / sqrt(8 * p * (p + 2) / n)
  
  # p-valores
  pvalsim <- 1 - pchisq(kappa1, dfchi)
  pvalkurt <- 2 * (1 - pnorm(abs(kappa2)))
  
  res <- c("kappa1" = kappa1, "pvalsim" = pvalsim,
           "kappa2" = kappa2, "pvalkurt" = pvalkurt, "n" = n)
  return(res)
}
 
 

TestMED <- function(datos, grupo) {
  grupo <- as.factor(grupo)
  ng <- length(levels(grupo))  # número de grupos
  p <- length(datos)           # número de variables
  N <- nrow(datos)             # total de observaciones
  v <- N - ng                  # grados de libertad internos
  
  # Matriz de medias por grupo
  means <- matrix(0, ng, p)
  for (j in 1:p) {
    means[, j] <- by(datos[, j], grupo, mean)
  }
  
  # Tamaño de cada grupo
  ni <- as.vector(unlist(by(datos, grupo, nrow)))
  props <- matrix(ni / sum(ni), ng, 1)  # proporciones
  
  # Media ponderada global
  M <- matrix(unlist(means), ng, p)
  h <- crossprod(M, props)
  
  # Centro de cada grupo menos media global
  sca <- scale(M, h, FALSE)
  SSB <- crossprod(sca * sqrt(ni))  # suma de cuadrados entre grupos
  
  # Centrar los datos restando su grupo
  X <- datos
  for (i in 1:N) {
    k <- grupo[i]
    X[i, ] <- X[i, ] - M[k, ]
  }
  
  # Matriz de covarianza común
  X <- as.matrix(X)
  Si <- by(datos, grupo, var)
  S <- matrix(0, p, p)
  for (j in 1:length(ni)) {
    S <- S + (ni[j] - 1) * matrix(unlist(Si[j]), p, p)
  }
  S <- S / v
  Cov.p <- S
  
  # Escalamiento
  di <- sqrt(diag(Cov.p))
  Si <- diag(1 / di, p)
  
  # Descomposición en valores singulares
  qx <- svd(X %*% Si)
  singular.tol <- sqrt(.Machine$double.eps)
  r <- sum(qx$d > singular.tol * qx$d[1])
  
  scaling.p <- sqrt(v) * (qx$v[, 1:r, drop = FALSE] %*% diag(1 / qx$d[1:r], r))
  if (r < p) scaling.p <- scaling.p %*% t(qx$v[, 1:r, drop = FALSE])
  scaling.p <- Si %*% scaling.p
  
  # Cálculo de estadísticas multivariadas
  esto <- crossprod(t(scaling.p) / sqrt(v))
  aquello <- SSB
  lbda <- Re(eigen(esto %*% aquello)$values)
  lbda <- lbda[abs(lbda) > sqrt(.Machine$double.eps)]
  
  stat <- c(prod(1 / (1 + lbda)), sum(lbda / (1 + lbda)), sum(lbda), lbda[1])
  
  # Estadísticos F y grados de libertad
  q <- length(lbda)
  s <- min(p, q)
  m <- (abs(p - q) - 1) / 2
  n <- (v - p - 1) / 2
  r <- v - (p - q + 1) / 2
  u <- (p * q - 2) / 4
  p2 <- p^2
  q2 <- q^2
  pq5 <- p2 + q2 - 5
  .t <- if (pq5 > 0) sqrt((p2 * q2 - 4) / pq5) else 1
  lt <- stat[1]^(1 / .t)
  
  n1 <- 2 * n + s + 1
  m1 <- 2 * m + s + 1
  n2 <- 2 * (s * n + 1)
  sm1 <- s * m1
  r1 <- max(p, q)
  r2 <- v - r1 + q
  
  v1 <- c(p * q, sm1, sm1, r1)
  v2 <- c(r * .t - 2 * u, s * n1, n2, r2)
  
  .F <- c(
    (v2[1] * (1 - lt)) / (lt * v1[1]),
    (n1 / m1 * stat[2]) / (s - stat[2]),
    (n2 * stat[3]) / (s * sm1),
    (stat[4] * r2) / r1
  )
  
  stats <- data.frame(
    Statistics = stat,
    F = .F,
    df1 = v1,
    df2 = v2,
    Pr = 1 - pf(.F, v1, v2),
    row.names = c("Wilks Lambda", "Pillai Trace", "Hoteling-Lawley Trace", "Roy Greatest Root")
  )
  
  return(stats)
}              
    


testes <- function(datos, grupo) {
  grupos <- as.factor(grupo)
  
  cat('\n~~Test de Igualdad de Medias~~\n\n')
  print(TestMED(datos, grupos))
  cat('\n\n')
  
  cat('\n~~Test de Homogeneidad de Varianzas~~\n\n')
  Box(datos, grupos)
  cat('\n\n')
  
  cat('\n~~Test de Mardia de Multinormalidad por grupos~~\n\n')
  print(by(datos, grupos, testM))
  cat('\n\n')
}
