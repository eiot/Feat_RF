function lable=LableGet(A)
[m,n,l]=size(A);
lable=zeros(m*n*l,1);
i=1;
for y=1:m
    for x=1:n
        for z=1:l
            lable(i,1)=A(y,x,z);
            i=i+1;
        end
    end
end