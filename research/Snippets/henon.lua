
function henonN(alpha,beta,x0,x1,N)
  -- alpha=1.9231
  -- beta=-0.1332
  -- x0=0.35
  -- y0=0.9837
  -- N=100
  -- takes Nth value of a Henon map with those parameters
x2=0
x1=0
  for i=0,N do
  print ("value after  ",i," cicli  e' ",x1)
    if ( x2>2e+30 or x2<-2e+30) then
      print ("escapes to infinity after ", i, " iteratons", " use ", x1)
      return
    end
    x2=1-alpha*x0^2+beta*x1
    x1=x0
    x0=x2
  end
  print ("================================")
  print ("value after  ",N," cicli  e' ",x1)
end
print(henonN(1.9231,0.1332,0.35,.9837,9),"\t",N)
