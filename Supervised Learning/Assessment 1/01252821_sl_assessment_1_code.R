# "Joana Levtcheva, CID 01252821"

# data loading
dat <- read.csv("dat.csv")
head(dat)
summary(dat)

# The data consist of two numerical variables - response, dose
# and one binary variable - variant


### Exploratory Data Analysis

# Pair plot for the whole observed data:

library(ggplot2)
library(GGally)
ggpairs(dat)


# - In the lower left part we have scatter plots

#    - In the scatter plot showing the relation between response and dose 
#    we can observe two distinct clusters. The left one has a cloud like structure, with 
#    no distinct relationship. Whereas, in the right cluster there is a strong linear relation 
#    between the response and the dose.

#    - The response-variant scatter plot again shows two groups, the variant with value 1 is 
#    located mainly in the left part, under the left cluster in the response-dose scatter plot. 
#    Analogically for the varaiant with value 0 and the right cluster.
   
#    - The dose-variant scatter plot shows two groups, but the groups here are reversed:
#    the variant with value 1 corresponds to the right cluster in the response-dose plot, 
#    and the variant 0 to the left cluster.

# - The diagonal shows the density plots
#    - The response density plot shows a multimodal distribution, with peaks above the two distinct clusters

# - In the upper left part there are the correlation coefficients
#    - Variant-response - There is an inverse proportion between the variant and the response, and the correlation coefficient (around -0.91) 
#    is big, so the variant has a big impact on the response.
#    - Response-dose - again we have an inverse proprtion, but with significantly less impact on the response (the coefficient is -0.48), 
#    which means either the relation between the response and dose is not very strong, or it's not linear.


# Scatter plot showing the relation between response and dose with colour indication of the 
# variant - red for variant = 1, black for variant = 0:
plot(dat$response, 
     dat$dose,
     col = 1 + dat$variant,
     pch = 20)

# This confirms the observations that the left cluster corresponds to the variant with value 1, and 
# the right cluster to the variant with values 0.

# Boxplot plot considering the variant and response variables:
boxplot(response ~ variant, data = dat)

# The behaviour of the response of the groups is very different. There are a few outliers.


### Model Fitting

# Fitting the clinicians' initial model, explaining the response only with dose:
fit0 <- lm(response ~ dose, data = dat)

summary(fit0)
# - dose is significant (Pr(>|t|) is 4.3e-06)
# - the model is explaining around 22% (adjusted R-squared) of the variance of the data 
# - dose - negative relationship with the response (the estimate is -2.6889)
# - the higher the dose, the smaller the reduction in inflammation


# Diagnostic plots:
plot(fit0)

# - The first plot, **Residuals vs Fitted**: The model hasn't successfully captured the systematic relationship between the dependent 
# variable and independent variables, because  there are two obvious patterns, indicating a modelled relationship between them.

# - The second plot, **Normal QQ-plot**: The line is not straight, so the assumptions of the 
# model are not satisfied. (Expected given the multimodal distribution from the pair plot.). The residurals are not normally distributed.

# - The third plot, **SCale-Location plot**: There is a clear relationship between the spread of the residuals and the fitted values. Therefore, 
# there is a violation of the assumption that the errors have constant variance.

# - The fourth plot, **Residuals vs Leverage**: There is at least one high influence point, distorting the fit of the remaining points. 
# This also might be a clue that outlier removal might be necessary.

# Plot regression line
plot(dat$dose,
     dat$response,
     col = 1 + dat$variant,
     pch = 20)
abline(a = fit0$coefficients[1], b = fit0$coefficients[2], col="blue")


# Fit the second model, explaining the response with dose and variant:
fit1 <- lm(response ~ dose + variant, data = dat)

summary(fit1)
# - Both dose and variant are significant (p-values 5.98e-16 and < 2e-16).
# - The model is explaining about 92% (adjusted R-squared) of the variance of of the data. 
# - Residual standard error - the actual response deviates from the true regression line by approximately 3.042 units, on average
# - The rate of change in response with a unit change in dose is below the clinically meaningful level of 3mmol/L per unit change in dose.


# Diagnostic plots:
plot(fit1)

# - First plot: There is still a visible pattern
# - Second plot: Closer to a line than in the previous model
# - Third plot: There is still a visible pattern
# - Fourth plot: high influence points, but there is improvement

# Regression lines for both cases variant = 0 and variant = 1:
plot(dat$dose,
     dat$response,
     col = 1 + dat$variant,
     pch = 20)
# variant 0
abline(a = fit1$coefficients[1], b = fit1$coefficients[2], col="black")
# variant 1
abline(a = fit1$coefficients[1] + fit1$coefficients[3],
       b = fit1$coefficients[2],
       col="red")


# It doesn't seem that the variant groups have the same slope. So, let's fit 
# a model which encodes the difference in slope between the line for variant = 1 and variant = 0.

# Fit a model with interaction term:
fit2 <- lm(response ~ dose * variant, data = dat)

summary(fit2)

# - when variant = 0 the dose is above 3 -> significant
# - when variant = 1 the dose is 4.2607 + (-2.6579) < 3 -> not significant

# - 11.5049 for Intercept -> response in mmol when the dose and variants are 0 
# - 4.2607 for dose ->  4.2607 change of response per unit change of dose, significant

# - -11.068 for variant -> the change in the intercept value when changing from variant 0 to variant 1,
# meaning that the intercept value for the model when we have variant 1 is 11.5049 - 11.0687 = 0.4362 which 
# is very small, so when there is no dose there is almost no response 

# - -2.6579 for dose:variant (variant = 1) -> 4.26 - 2.65 = 1.6 which is not significant 

# - 2.546 Residual standard error - decreased 

# In the two cases there is a positive change in dose-response. Simpson's paradox.

# Diagnostic plots:
plot(fit2)

# - First and third plot -> no visible pattern 
# - QQ-plot -> approximately a line 

# Regression lines considering variant = 0 and variant = 1
plot(dat$dose,
     dat$response,
     col = 1 + dat$variant,
     pch = 20)
# abline for variant 0
abline(a = fit2$coefficients[1], b = fit2$coefficients[2], col="black")
# abline for variant 1 
abline(a = fit2$coefficients[1] + fit2$coefficients[3],
       b = fit2$coefficients[2] + fit2$coefficients[4],
       col="red")
