library(MASS)
data(minn38)

mn.int = polr(hs ~ sex * fol, minn38, f, Hess = TRUE)
summary(mn.int)

mn.add = polr(hs ~ sex + fol, minn38, f, Hess = TRUE)
summary(mn.add)

library(lmtest)
lrtest(mn.int, mn.add)

data(quine)

quine_01 = quine
quine_05 = quine
quine_1 = quine

quine_01$Days[quine_01$Days == 0] = 0.01
quine_05$Days[quine_05$Days == 0] = 0.05
quine_1$Days[quine_1$Days == 0] = 0.1

qu.gm01 = glm(Days ~ Eth + Sex + Age + Lrn, Gamma(log), quine_01)
summary(qu.gm01)

qu.gm05 = glm(Days ~ Eth + Sex + Age + Lrn, Gamma(log), quine_05)
summary(qu.gm05)

qu.gm1 = glm(Days ~ Eth + Sex + Age + Lrn, Gamma(log), quine_1)
summary(qu.gm1)
par(mfrow=c(1,1))
plot(qu.gm1)
1  - pchisq(deviance(qu.gm1),  qu.gm1$df.resid)
d_f<-density(resid(qu.gm1))
par(mfrow=c(1,1))
plot(d_f,main='Residual KDE Plot',xlab='Residual value')

qu.gm1.step = step(qu.gm1,scope=list(lower=~.,upper=~.^3), k=log(146))
summary(qu.gm1.step)

qu.nb = glm.nb(Days ~ .^4, data = quine)
qu.nb.step = stepAIC(qu.nb, k=log(146))
summary(qu.nb.step)
par(mfrow=c(1,1))
plot(qu.nb.step)
1  - pchisq(deviance(qu.nb),  qu.gm1$df.resid)

qu.ln = lm(log(Days) ~ .^4, data = quine_1)
qu.ln.step = stepAIC(qu.ln, k=log(146))
summary(qu.ln.step)
par(mfrow=c(1,1))
plot(qu.ln.step)
1  - pchisq(deviance(qu.ln),  qu.gm1$df.resid)
