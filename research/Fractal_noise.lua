 
--Fractal_Noise.lua
--generates fractal noise
--based on the bicubic example

function get_rgb_cubic_row(x,y,offset)
  local r0,g0,b0, r1,g1,b1, r2,g2,b2, r3,g3,b3
  r0,g0,b0 = get_rgb(x,y)
  r1,g1,b1 = get_rgb(x+1,y)
  r2,g2,b2 = get_rgb(x+2,y)
  r3,g3,b3 = get_rgb(x+3,y)
  return cubic(offset,r0,r1,r2,r3), cubic(offset,g0,g1,g2,g3), 
cubic(offset,b0,b1,b2,b3)
end

function get_rgb_bicubic (x,y)
  local xi,yi -- integer coordinates
  local dx,dy -- offset from coordinates
  local r,g,b

  xi=math.floor(x)
  yi=math.floor(y)
  dx=x-xi
  dy=y-yi

  r0,g0,b0 = get_rgb_cubic_row(xi-1,yi-1,dx)
  r1,g1,b1 = get_rgb_cubic_row(xi-1,yi,  dx)
  r2,g2,b2 = get_rgb_cubic_row(xi-1,yi+1,dx)
  r3,g3,b3 = get_rgb_cubic_row(xi-1,yi+2,dx)

  return cubic(dy,r0,r1,r2,r3),
         cubic(dy,g0,g1,g2,g3),
         cubic(dy,b0,b1,b2,b3)
end



function scale(ratio, shmeh)
  for y=0, (height*shmeh)-1 do
    for x=0, (width*shmeh)-1 do
      -- calculate the source coordinates (u,v)
      u = x * (1.0/ratio)
      v = y * (1.0/ratio)
      r,g,b=get_rgb_bicubic(u,v)
      if r<0 then r=0 elseif r>1 then r=1 end
      if g<0 then g=0 elseif g>1 then g=1 end
      if b<0 then b=0 elseif b>1 then b=1 end
      set_rgb(x,y,r,g,b)
    end
  end
  flush()
end

function clear()
  for y=0, height-1 do
    for x=0, width-1 do
     set_rgb(x,y,.5,.5,.5)
   end
end
  flush()
end

function noise(value,shmeh)
  for y=0, (height*shmeh)-1 do
    for x=0, (width*shmeh)-1 do
     r,g,b=get_rgb(x,y)
     r=r+((math.random()-.5)*value)
     g=g+((math.random()-.5)*value)
     b=b+((math.random()-.5)*value)
      if r<0 then r=0 elseif r>1 then r=1 end
      if g<0 then g=0 elseif g>1 then g=1 end
      if b<0 then b=0 elseif b>1 then b=1 end
     set_rgb(x,y,r,g,b)
   end
end
  flush()
end

function cubic(offset,v0,v1,v2,v3)
  -- offset is the offset of the sampled value between v1 and v2
   return   (((( -7 * v0 + 21 * v1 - 21 * v2 + 7 * v3 ) * offset +
               ( 15 * v0 - 36 * v1 + 27 * v2 - 6 * v3 ) ) * offset +
               ( -9 * v0 + 9 * v2 ) ) * offset + (v0 + 16 * v1 + v2) ) / 18.0;
end


local itterations
itterations = Dog_ValueBox("Noise","Itterations", 2, 12, 6)-1

if itterations>0 then

progress(0.01)
clear()

local d,d2
  for n=0, itterations do

d=1/(((itterations+1)-n) )
d2=1/(((itterations+1)-n) )/2
    noise(1/n,d2  )
    scale(2, d )

progress (n/itterations)
  end
end

 