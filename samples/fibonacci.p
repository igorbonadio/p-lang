fib = [1|1];
      [2|1];
      [n|fib(n-1)+fib(n-2)]
      
print(fib(7))