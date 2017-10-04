-- autoscale
-- a function that takes a value in an interval and maps it into a different one

function autoscale(n,old_top,old_bottom,new_top,new_bottom)

-- =IF((F30-E30)>0,ROUNDUP(((D30-E30)/(F30-E30))*(H30-G30)+G30,6),0)
-- example autoscale (0.234, 1, -1, 0, 1)
-- control: C	temperatura	22	-15	 50	 0	  1	  0.569231
-- (mappo una temperatura presa in un range tra -15 e 50 celsius nello spazio unitario)

det = (old_top - old_bottom)
if (det ~= 0) then -- evitare divisioni per zero
  new_value = (n - old_bottom) / (old_top - old_bottom) * (new_top - new_bottom) + new_bottom;
  else
    return ("division by zero is not allowed!")
end
return (new_value)
end

autoscale(22,-15,50,0,1)
