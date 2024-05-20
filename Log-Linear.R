library(MASS)
"detg" <-
  structure(list(Brand = structure(c(1, 2, 1, 2, 1, 2, 1, 2, 1, 
                                     2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2), .Label = c("X", 
                                                                                              "M"), class = "factor"), Temp = structure(c(1, 1, 2, 2, 1, 1, 
                                                                                                                                          2, 2, 1, 1, 2, 2, 1, 1, 2, 2, 1, 1, 2, 2, 1, 1, 2, 2), .Label = c("Low", 
                                                                                                                                                                                                            "High"), class = "factor"), M.user = structure(c(1, 1, 1, 1, 
                                                                                                                                                                                                                                                             2, 2, 2, 2, 1, 1, 1, 1, 2, 2, 2, 2, 1, 1, 1, 1, 2, 2, 2, 2), .Label = c("N", 
                                                                                                                                                                                                                                                                                                                                     "Y"), class = "factor"), Soft = structure(c(3, 3, 3, 3, 3, 3, 
                                                                                                                                                                                                                                                                                                                                                                                 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1), .Label = c("Soft", 
                                                                                                                                                                                                                                                                                                                                                                                                                                                   "Medium", "Hard"), class = c("ordered", "factor")), Fr = c(68, 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              42, 42, 30, 37, 52, 24, 43, 66, 50, 33, 23, 47, 55, 23, 47, 63, 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              53, 29, 27, 57, 49, 19, 29)), .Names = c("Brand", "Temp", "M.user", 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       "Soft", "Fr"), row.names = c("1", "2", "3", "4", "5", "6", "7", 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    "19", "20", "21", "22", "23", "24"), class = "data.frame")
"detg1" <-
  structure(list(Temp = structure(c(1, 2, 1, 2, 1, 2, 1, 2, 1, 
                                    2, 1, 2), class = "factor", .Label = c("Low", "High")), M.user = structure(c(1, 
                                                                                                                 1, 2, 2, 1, 1, 2, 2, 1, 1, 2, 2), class = "factor", .Label = c("N", 
                                                                                                                                                                                "Y")), Soft = structure(c(3, 3, 3, 3, 2, 2, 2, 2, 1, 1, 1, 1), class = c("ordered", 
                                                                                                                                                                                                                                                         "factor"), .Label = c("Soft", "Medium", "Hard")), M = c(42, 30, 
                                                                                                                                                                                                                                                                                                                 52, 43, 50, 23, 55, 47, 53, 27, 49, 29), X = c(68, 42, 37, 24, 
                                                                                                                                                                                                                                                                                                                                                                66, 33, 47, 23, 63, 29, 57, 19)), .Names = c("Temp", "M.user", 
                                                                                                                                                                                                                                                                                                                                                                                                             "Soft", "M", "X"), row.names = c("1", "3", "5", "7", "9", "11", 
                                                                                                                                                                                                                                                                                                                                                                                                                                              "13", "15", "17", "19", "21", "23"), class = "data.frame")
options(contrasts=c("contr.treatment","contr.treatment"))
detg.m0<-glm(Fr~M.user*Temp*Soft+Brand,poisson,detg)
detg1.m0<-glm(cbind(X,M)~1,family=binomial,data=detg1)
detg.step<-step(detg.m0,scope=list(lower=~.,upper=~.^2))
detg1.step<-step(detg1.m0,trace=F,
                 scope=list(upper=~M.user*Temp*Soft))
summary(detg.step)
detg.log<-glm(terms(Fr~M.user*Temp*Soft+Brand*M.user*Temp,
                    keep.order=T),family=poisson, data=detg)
summary(detg.log)
detg.lgt<-update(detg1.m0,~+M.user*Temp)
summary(detg.lgt)
options(contrasts=c("contr.sum","contr.sum"))
summary(update(detg.log)); summary(update(detg.lgt))
# fit the model
detg.mm<-glm(terms(Fr~Temp*Soft+Brand*M.user+Temp:Brand,keep.order=TRUE),poisson,detg)

# obtain the expected
detg.xpec <- predict(detg.mm,type="res")

# cast the observed and expected as a 2x2x2x3 tables
obsv <- array(detg$Fr,c(2,2,2,3))
xpec <- array(detg.xpec,c(2,2,2,3))

# add marginal labels
dimnames(obsv)<-dimnames(xpec)<-list(Brand=c("X","M"),
                                     Temp=c("Low","High"),M.user=c("N","Y"),Soft=c("Hard","Medium","Soft"))

# switch Temp & M.user
obsv <- aperm(obsv,c(1,3,2,4))
xpec <- aperm(xpec,c(1,3,2,4))

# double check equivalence
apply(obsv,c(3,4),sum)->total
apply(xpec,c(3,4),sum)

# expected cell probabilities
prob.xpec <- array(as.vector(xpec)/rep(as.vector(total),rep(4,6)),c(2,2,2,3))
dimnames(prob.xpec) <- dimnames(xpec)

# odds ratio
my.fun<-function(x){x[1,1]*x[2,2]/x[1,2]/x[2,1]}
apply(prob.xpec,c(3,4),my.fun)




data(minn38)
is.na(minn38)
str(minn38)
head(minn38)

#Q1
#Initial model
options(contrasts=c("contr.treatment","contr.treatment"))
mn.minimal  <- glm(f  ~ hs*fol*sex + phs,
            family  =  poisson,  data  =  minn38)
summary(mn.minimal)


#Stepwise
mn.step<-step(mn.minimal,scope=list(lower=~.,upper=~.^2))

summary(mn.step)

mn.m1 <- glm(terms(f  ~ hs*fol*sex + phs + 
                fol:phs + hs:phs + sex:phs  + fol:sex:phs + hs:fol:phs,keep.order=T),
              family  =  poisson,  data  =  minn38)
summary(mn.m1)

1  - pchisq(deviance(mn.m1),  mn.m1$df.resid)

#Further selections
drop1(mn.m1)
add1(mn.m1, ~. + hs:sex:phs)
mn.add <- glm(terms(f  ~ hs*fol*sex + phs + 
                      fol:phs + hs:phs + sex:phs  + fol:sex:phs + hs:fol:phs + hs:sex:phs ,keep.order=T),
              family  =  poisson,  data  =  minn38)
summary(mn.add)

library(lmtest)
lrtest(mn.m1, mn.add)



# Cell Probabilities
mnames  <- lapply(minn38[, c(2,1,3,4)][,  -5],  levels)  #  omit  Freq 
mn.pm  <- predict(mn.m1,  expand.grid(mnames),type  =  "response")  #  poisson  means
mn.pm  <- matrix(mn.pm,  ncol  =  4,  byrow  =  T,
                    dimnames  =  list(NULL,  mnames[[1]]))
mn.pr  <-  mn.pm/drop(mn.pm  %*%  rep(1,  4))
cbind(expand.grid(mnames[-1])  ,  prob  =  round(mn.pr,  3))


# obtain the expected
mn.xpec <- predict(mn.m1,type="res")

# cast the observed and expected as a 7X4X3X2 tables
obsv1 <- array(minn38$f,c(7,4,3,2))
xpec1 <- array(mn.xpec,c(7,4,3,2))

# add marginal labels
dimnames(obsv)<-dimnames(xpec)<-list(Brand=c("X","M"),
                                     Temp=c("Low","High"),M.user=c("N","Y"),Soft=c("Hard","Medium","Soft"))
dimnames(obsv1)<-dimnames(xpec1)<-list(FatherOccupation=c("F1","F2","F3","F4","F5","F6","F7"),
                                       Posthighschool=c("College","Employeed","Non-collegiate","Other"),
                                       Highschoolrank=c("L","M","U"),
                                       Sex=c("Female","Male"))
# switch phs and hs
obsv <- aperm(obsv1,c(1,3,4,2))
xpec <- aperm(xpec1,c(1,3,4,2))

# double check equivalence
apply(obsv,c(3,4),sum)->total
apply(xpec,c(3,4),sum)

# expected cell probabilities
prob.xpec <- array(as.vector(xpec)/rep(as.vector(total),rep(21,8)),c(7,3,2,4))
dimnames(prob.xpec) <- dimnames(xpec)
prob.xpec
# odds ratio
my.fun<-function(x){x[1,1]*x[2,2]/x[1,2]/x[2,1]}
apply(prob.xpec,c(3,4),my.fun)
                    
#Q2

#Initial model
options(contrasts=c("contr.treatment","contr.treatment"))
mn.minimal2  <- glm(f  ~ fol*sex + hs + phs,
                   family  =  poisson,  data  =  minn38)
summary(mn.minimal2)


#Stepwise
mn.step2<-step(mn.minimal2,scope=list(lower=~.,upper=~.^2))

summary(mn.step2)

mn.m2 <- glm(terms(f  ~ fol*sex + hs + phs + fol:phs + 
                     hs:phs + sex:hs + sex:phs + fol:hs + fol:sex:phs, keep.order=T),
             family  =  poisson,  data  =  minn38)
summary(mn.m2)

1  - pchisq(deviance(mn.m2),  mn.m2$df.resid)

#Further selections
drop1(mn.m2)

add1(mn.m2, ~. + fol:sex:hs)
mn.add2 <- glm(terms(f  ~ fol*sex + hs + phs + fol:phs + 
                      hs:phs + sex:hs + sex:phs + fol:hs + fol:sex:phs + fol:sex:hs  ,keep.order=T),
              family  =  poisson,  data  =  minn38)
summary(mn.add2)

lrtest(mn.m2, mn.add2)

minn38$phshs = paste(minn38$phs,minn38$hs,sep="-")
minn38$phshs = as.factor(minn38$phshs)
# Cell Probabilities
mnames2  <- lapply(minn38[, c(6,3,4)][,  -5],  levels)  #  omit  Freq 
mn.pm2  <- predict(mn.m2,  expand.grid(mnames2),type  =  "response")  #  poisson  means
mn.pm2  <- matrix(mn.pm2,  ncol  =  12,  byrow  =  T,
                 dimnames  =  list(NULL,  mnames2[[1]]))
mn.pr2  <-  mn.pm2/drop(mn.pm2  %*%  rep(1,  12))
cbind(expand.grid(mnames2[-1])  ,  prob  =  round(mn.pr2,  3))

