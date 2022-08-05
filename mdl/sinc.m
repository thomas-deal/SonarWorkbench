function y = sinc(x)
%#codegen
i = find(x==0);                                                              
x(i) = 1;                         
y = sin(pi*x)./(pi*x);                                                     
y(i) = 1;  
