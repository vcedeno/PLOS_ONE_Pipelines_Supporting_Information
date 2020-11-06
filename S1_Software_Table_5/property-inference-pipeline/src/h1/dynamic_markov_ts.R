#! /usr/bin/Rscript
require(foreign)
require(nnet)
library(foreign)
require(stats)

#Read data
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) 
{
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} 

DM<-read.csv(args[1],header=TRUE)

#DM<-read.csv("/Users/huzhihao/Documents/STAT/NDSSL/git_NDSSL/experiment-analytics/results/n15k8/tsData.csv",header=TRUE)
#DM[1:5,1:10]
n<-length(DM[,1]) #5000
m<-length(DM[1,])-3 #300


#rearrange data
x<-NULL
num.x<-NULL
for (ii in 1:4){
  for (jj in 1:4){
    count<-0
    for (i in 1:(n/5)*5-4){
      for (j in 1:(m-1)+3){
        if (DM[i,j]==ii & DM[i,(j+1)]==jj){
          x<-rbind(x,c(ii,jj,DM[(i+1:4),j]))
          count<-count+1
        }
      }
    }
    num.x<-c(num.x,count)
  }
}  
#dim(x)

# ncount summarize the number of data for 16 transitions.
ncount<-data.frame(matrix(num.x,nrow=4))
colnames(ncount)<-c('initial 1','initial 2','initial 3','initial 4')
rownames(ncount)<-c('final 1','final 2','final 3','final 4')
ncount<-t(ncount)
datasum<-data.frame(matrix(c(rep(NA,16)),nrow=4))
for (i in 1:4){
  datasum[i,]<-ncount[i,]/sum(ncount[i,])
}
rownames(datasum)<-c('initial 1','initial 2','initial 3','initial 4')
colnames(datasum)<-c('final 1','final 2','final 3','final 4')
#print(getwd())
dir=paste(getwd(),"property-inference-pipeline/test/results/h1/static_markov/",sep = "/")
filename=paste(dir,"transition_probability_static.csv",sep = "")
write.csv(datasum,filename)

data<-data.frame(x)

#first column is the initial state (at t second)
#second column is the final state (at t+1 second)
#3-6 column is four x variables ('buffer','letter','word','constant').
colnames(data)<-c('initial','final','buffer','letter','word','constant')
data1<-data[which(data$initial==1),-1] #data1=intial state is 1
data2<-data[which(data$initial==2),-1] #data2=intial state is 2
data3<-data[which(data$initial==3),-1] #data3=intial state is 3
data4<-data[which(data$initial==4),-1] #data4=intial state is 4
#dim(data1);dim(data2);dim(data3);dim(data4)

#multinomial logistic regression
mlog1<-multinom(final~buffer+letter+word+constant,family=multinomial,data=data1)
#summary(mlog1)
betam.m1<-coef(mlog1)

mlog2<-multinom(final~buffer+letter+word+constant,family=multinomial,data=data2)
#summary(mlog2)
betam.m2<-coef(mlog2)


mlog3<-multinom(final~buffer+letter+word+constant,family=multinomial,data=data3)
#summary(mlog3)
betam.m3<-coef(mlog3)

mlog4<-multinom(final~buffer+letter+word+constant,family=multinomial,data=data4)
#summary(mlog4)
betam.m4<-coef(mlog4)


###beta coefficients matrix
v0<-rep(0,5)
vinf<-c(-Inf,0,0,0,0)
B<-c()

for (i in 1:length(datasum))
{
  counter=0
  B<-rbind(B,v0)
  for (j in 1:length(datasum[i,]))
  {
    if (datasum[i,j]==0)
    {
      B<-rbind(B,vinf)
    }
    else
    {
      if (i==1 && counter>0)
      {
        B<-rbind(B,betam.m1[counter,])
      }
      if (i==2 && counter>0)
      {
        B<-rbind(B,betam.m2[counter,])
      }
      if (i==3 && counter>0)
      {
        B<-rbind(B,betam.m3[counter,])
      }
      if (i==4 && counter>0)
      {
        #B<-rbind(B,betam.m4[counter,])
      }
      counter=counter+1
    }
  }
}

dir=paste(getwd(),"property-inference-pipeline/test/results/h1/dynamic_markov/",sep = "/")
filename=paste(dir,"transition_probability_dynamic.csv",sep = "")
write.csv(B,filename)

