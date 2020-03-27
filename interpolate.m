function value = interpolate(a,b,x,y,rightX,rightY,value1,value2)
    dx = rightX - x;
    dy = rightY - y;
    
    weight = ((a - x)^2 + (b - y)^2)/(dx^2 + dy^2);
    weight = sqrt(weight);
    
    value = value1*(1-weight) + value2*weight;
    
end

