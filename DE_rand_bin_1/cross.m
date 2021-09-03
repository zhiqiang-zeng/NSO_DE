function result=cross(x1,x2,rate)
D=length(x1);
result=zeros(D,1);
r=unidrnd(D);


for i=1:D
    if rand<rate || r==i
       
        result(i)=x1(i);
        
    else
         result(i)=x2(i);
    end
end


