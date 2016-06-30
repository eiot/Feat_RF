function SegResult=GetSegResult(Xtst,Ypredict)
[m,n,l]=size(Xtst);
SegResult=zeros(m,n,l);
i=1;
for y=1:m
    for x=1:n
        for z=1:l
            SegResult(y,x,z)=Ypredict(i,1);
            i=i+1;
        end
    end
end

