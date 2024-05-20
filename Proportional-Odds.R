library(MASS)
data(minn38)

mn.int = polr(hs ~ sex * fol, minn38, f, Hess = TRUE)
summary(mn.int)

mn.add = polr(hs ~ sex + fol, minn38, f, Hess = TRUE)
summary(mn.add)

library(lmtest)
lrtest(mn.int, mn.add)
