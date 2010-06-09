# point : num, num -> num
point = [x, y|
  {point: x, y}]

# pointx : point -> num
point_x = [{point: x, y}|
  x]

# pointy : point -> num
point_y = [{point: x, y}|
  y]

# pointsum : point, point -> point
point_sum = [{point: x1, y1}, {point: x2, y2}|
  {point: x1+x2, y1+y2}]
  
p1 = point(1,2) # create a new point
p2 = point(3,4) # create a new point

pointx(p1) # => 1
pointy(p1) # => 2
pointx(p2) # => 3
pointy(p2) # => 4

pointsum(p1, p2) # => {point: 4, 6}

# obj constructions :
{obj: 1+2, x=1}
{obj: 1, 2}
{obj: x, 2, 'a', "aaaa", {other}}
