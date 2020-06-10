# Input parameters
# Mean job arrival rate (lambda) and Mean job service time (mu)
lambda = 2
mu = 1

# Expected stats
rho = mu/lambda
numInQueue = (rho*rho)/(1 - rho)
waitInQueue = numInQueue*lambda
waitInSystem = (numInQueue * lambda)/rho

# Total time 
time = 5000

t = 0
arrival = c()

# generate event arrival times
while(t <= time){
  arrival = c(arrival, t)
  t = t + rexp(1, rate=1/lambda)
}

queue = c()

i = 1
t = 0

sumJobsWaiting = 0
jobWaitingTime = 0
jobDelayTime = 0

# Process each event and collect stats
while(i <= length(arrival)){
  
  if(length(queue) > 0)
    queue = queue[-1]
  
  if(t < arrival[i])
    t = arrival[i]
  
  jobWaitingTime = jobWaitingTime + (t - arrival[i])
  departure = t + rexp(1, rate=1/mu)
  
  if(departure > time)
    break
  
  jobDelayTime = jobDelayTime + (t - arrival[i]) + (departure-t)
  
  j = i+1
  if(length(queue) > 0 && queue[length(queue)] >= j)
    j = queue[length(queue)] + 1
  
  last = t
  while(j <= length(arrival) && arrival[j] < departure){
    sumJobsWaiting = sumJobsWaiting + length(queue)*(arrival[j] - last)
    queue = c(queue, j)
    last = arrival[j]
    j = j + 1
  }
  
  sumJobsWaiting = sumJobsWaiting + length(queue)*(departure - last)
  
  t = departure
  i = i + 1
}

print("STATISTICS (observed) :")
print("------------------------------------------------------------")
print(paste("Avg job waiting time = ", jobWaitingTime/length(arrival)))
print(paste("Avg job delay time = ", jobDelayTime/length(arrival)))
print(paste("Avg number of jobs waiting = ", sumJobsWaiting/time))
cat("\n")

print("STATISTIC (calculated) :")
print("------------------------------------------------------------")
print(paste("Avg job waiting time = ", waitInQueue))
print(paste("Avg job delay time = ", waitInSystem))
print(paste("Avg number of jobs waiting = ", numInQueue))
