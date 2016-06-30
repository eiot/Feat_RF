function feature=featextract(A,type)
% output: row: the number of points in A
%         col: the number of feature 27 or 143
        
A=im2uint8(mat2gray(A));

if strcmp(type,'gradient') % 27 features
    G=cmputgrad(A);
    [m,n,l]=size(G);
    B=MatrixExpand(G);
    feature=zeros(m*n*l,27);
    i=1;
    for y=2:m+1
        for x=2:n+1
            for z=2:l+1
                feature(i,:)=reshape(B(y-1:y+1,x-1:x+1,z-1:z+1),1,27);
                %feature(i,1)=B(y-1,x-1,z-1);
                i=i+1;
            end
        end
    end
end

if strcmp(type,'gray') % 27 features
    [m,n,l]=size(A);
    B=MatrixExpand(A);
    feature=zeros(m*n*l,27);
    %feature=zeros(m*n*l,1);
    i=1;
    for y=2:m+1
        for x=2:n+1
            for z=2:l+1
                feature(i,:)=reshape(B(y-1:y+1,x-1:x+1,z-1:z+1),1,27);
                %feature(i,1)=B(y-1,x-1,z-1);
                i=i+1;
            end
        end
    end
end

if strcmp(type,'texture') % 11(single features)*13(directions) features
    [M,N,L]=size(A);
    feature=zeros(M*N*L,14*2);
    B=MatrixExpand(A);
    for y=1:M+2
        for x=1:N+2
            for z=1:L+2
                for n=1:16
                    if(n-1)*16<=B(y,x,z) && B(y,x,z)<=(n-1)*16+15
                       B(y,x,z)=n-1;
                    end
                end
            end
        end
    end
    i=1;
    for y=2:M+1
        for x=2:N+1
            for z=2:L+1
                GrayCoMatrix=GetCoMatrix(B(y-1:y+1,x-1:x+1,z-1:z+1),A); % output:16*16*13
                feature(i,:)=GetFeatFromCoMatrix(GrayCoMatrix);
                i=i+1;               
            end
        end
    end    
end