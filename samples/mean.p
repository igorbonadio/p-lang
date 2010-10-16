mean = [xs| sum(xs)/size(xs)] : 
  (sum =  [{list: x, xs}| x + sum(xs)];
          [{empty}| 0], 
   size = [{list: x, xs}| 1 + size(xs)];
          [{empty}| 0])
       
print(mean('(1.0,2.0,3.0,4.0,5.0,6.0)))