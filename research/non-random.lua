a=1.4
b=0.3
x=-1.0
x1=-1.0
x2=0
i = 50
while (i>=0)
do
  x2=1-a*x^2+b*x1
  print(x2,"\n")
  x1=x
  x=x2
  i=i-1
end
