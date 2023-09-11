## ----setup, include=FALSE-----------------------------------------------------------------
knitr::opts_chunk$set(echo=FALSE, message = FALSE)


## -----------------------------------------------------------------------------------------
library(ggplot2)
library(GGally)
#library(MASS)
library(dplyr)


## -----------------------------------------------------------------------------------------
vd <- read.csv("variola-data.csv")
summary(vd)


## -----------------------------------------------------------------------------------------
df_mean_std <- vd %>%
  group_by(x) %>%
  summarise_at(vars(y), list(mean=mean, sd=sd)) %>% 
  as.data.frame()
print(df_mean_std)


## ----Fig1, fig.height=3.5, fig.width=3.5--------------------------------------------------
par(mfrow=c(1,2))
ggplot(vd, aes(x = x,
                y = y )) +
  ylim(0, 260) + 
  geom_point() +
  ylab("Number of Lesions") +
  labs(caption = "Fig. 1")

ggplot(df_mean_std , aes(x=x, y=mean)) + 
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.3) +
  ylim(0, 260) +
  geom_line() +
  geom_point(size=2) +
  ylab("Mean Number of Lesions") + 
  labs(caption = "Fig. 2")


## ---- include=FALSE-----------------------------------------------------------------------
linear_fit <- lm(y ~ x, data = vd)
summary(linear_fit)


## ---- include=FALSE-----------------------------------------------------------------------
par(mfrow=c(2,2))
plot(linear_fit)


## ---- include = FALSE---------------------------------------------------------------------
glm_1 <- glm(
  formula = y ~ x,
  family = poisson(link = "log"), 
  data = vd) 

summary(glm_1)


## ----Fig2, fig.height=4, fig.width=10.5---------------------------------------------------
par(mfrow=c(1,2))
plot(vd$x,
     vd$y,
     pch = 20,
     bty = "n",
     xlim = c(0,4),
     xlab = "x", 
     ylab="Number of Lesions",
     sub = "Linear Model"
     )
abline(a = linear_fit$coefficients[1], b = linear_fit$coefficients[2], col="blue")

# get point estimates for lambda on a grid of evaluation points
X <- cbind(
  rep(1,301),                 # intercept column
  seq(0, 4, length.out = 301)
)
lambda_hat <- exp(X %*% coefficients(glm_1))

# plot data
plot(vd$x,
     vd$y,
     xlab = "x",
     ylab = "Number of Lesions",
     bty = "n",
     ylim = c(0,300),
     xlim = c(0, 4),
     sub = "Poisson GLM"
     )
lines(x = X[,2],
      y = lambda_hat, 
      col = "blue", 
      lwd = 2)


## ---- Fig3, fig.height=4, fig.width=10.5--------------------------------------------------
par(mfrow=c(1,2))
plot(glm_1, which = 1:2)
