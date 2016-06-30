function CoMatrix=GetCoMatrix(A,B)
% Calculating the  GrayCoMatrix
% INPUT:   A   3*3*3
%              a subset of normalized images
%          B   normalized images
% OUTPUT: CoMatrix     16*16*13
%                         in 13 directions
%
% Copyright <huangxu@edu.cn>
% $Revision: 1.1 $  $Date: 2016/06/27 12:09:15 $


%% Get Gray Co Matrix
[M,N,L]=size(A);
CoMatrix=zeros(16,16,13);
for m=1:16
    for n=1:16
        for y=1:M
            for x=1:N
                for z=1:L
                    if (x<N && A(y,x,z)==m-1 && A(y,x+1,z)==n-1 )||(x>1 && A(y,x,z)==m-1 && A(y,x-1,z)==n-1 )    %1. x+   ||    x-
                       CoMatrix(m,n,1)=CoMatrix(m,n,1)+1;
                    end
                    if (x<N && y<M && A(y,x,z)==m-1 && A(y+1,x+1,z)==n-1)||(x>1 && y>1 && A(y,x,z)==m-1 && A(y-1,x-1,z)==n-1) %2. x+,y+  ||    x-,y-
                       CoMatrix(m,n,2)=CoMatrix(m,n,2)+1;
                    end
                    if (y<M && A(y,x,z)==m-1 && A(y+1,x,z)==n-1)||(y>1 && A(y,x,z)==m-1 && A(y-1,x,z)==n-1) %3. y+  ||   y-
                       CoMatrix(m,n,3)=CoMatrix(m,n,3)+1;
                    end
                    if (x>1 && y<M && A(y,x,z)==m-1 && A(y+1,x-1,z)==n-1)||(x<N && y>1 && A(y,x,z)==m-1 && A(y-1,x+1,z)==n-1) %4. x-,y+  ||    x+,y-
                       CoMatrix(m,n,4)=CoMatrix(m,n,4)+1;
                    end
                    if (x>1 && y<M && z<L && A(y,x,z)==m-1 && A(y+1,x-1,z+1)==n-1)||(x<N && y>1 && z>1 && A(y,x,z)==m-1 && A(y-1,x+1,z-1)==n-1) %5.x-,y+,z+  ||  x+,y-,z-  
                       CoMatrix(m,n,5)=CoMatrix(m,n,5)+1;
                    end
                    if (z<L && y<M && A(y,x,z)==m-1 && A(y+1,x,z+1)==n-1)||(z>1 && y>1 && A(y,x,z)==m-1 && A(y-1,x,z-1)==n-1) %6. y+,z+  ||  y-,z-  
                       CoMatrix(m,n,6)=CoMatrix(m,n,6)+1;
                    end
                    if (x<N && y<M && z<L && A(y,x,z)==m-1 && A(y+1,x+1,z+1)==n-1)||(x>1 && y>1 && z>1 && A(y,x,z)==m-1 && A(y-1,x-1,z-1)==n-1) %7. x+,y+,z+  ||  x-,y-,z-  
                       CoMatrix(m,n,7)=CoMatrix(m,n,7)+1;
                    end
                    if (x>1 && z<L && A(y,x,z)==m-1 && A(y,x-1,z+1)==n-1)||(x<N && z>1 && A(y,x,z)==m-1 && A(y,x+1,z-1)==n-1) %8.x-,z+  ||    x+,z-
                       CoMatrix(m,n,8)=CoMatrix(m,n,8)+1;
                    end
                    if (z<L && A(y,x,z)==m-1 && A(y,x,z+1)==n-1)||(z>1 && A(y,x,z)==m-1 && A(y,x,z-1)==n-1) %9. z+  ||    z-
                       CoMatrix(m,n,9)=CoMatrix(m,n,9)+1;
                    end
                    if (x<N && z<L && A(y,x,z)==m-1 && A(y,x+1,z+1)==n-1)||(x>1 && z>1 && A(y,x,z)==m-1 && A(y,x-1,z-1)==n-1) %10. x+,z+  ||    x-,z-
                       CoMatrix(m,n,10)=CoMatrix(m,n,10)+1;
                    end
                    if (x>1 && y>1 && z<L && A(y,x,z)==m-1 && A(y-1,x-1,z+1)==n-1)||(x<N && y<M && z>1 && A(y,x,z)==m-1 && A(y+1,x+1,z-1)==n-1) %11. x-,y-,z+  ||    x+,y+,z-
                       CoMatrix(m,n,11)=CoMatrix(m,n,11)+1;
                    end
                    if (y>1 && z<L && A(y,x,z)==m-1 && A(y-1,x,z+1)==n-1)||(y<M && z>1 && A(y,x,z)==m-1 && A(y+1,x,z-1)==n-1) %12. y-,z+  ||    y+,z-
                       CoMatrix(m,n,12)=CoMatrix(m,n,12)+1;
                    end
                    if (x<N && y>1 && z<L && A(y,x,z)==m-1 && A(y-1,x+1,z+1)==n-1)||(x>1 && y<M && z>1 && A(y,x,z)==m-1 && A(y+1,x-1,z-1)==n-1) %13. x+,y-,z+  ||    x-,y+,z-
                       CoMatrix(m,n,13)=CoMatrix(m,n,13)+1;
                    end
                end
            end
        end
    end
end
%% Normalized the Matrix
[M,N,L]=size(B);
CoMatrix(:,:,1)=CoMatrix(:,:,1)/(2*M*(N-1)*L);
CoMatrix(:,:,2)=CoMatrix(:,:,2)/(2*(M-1)*(N-1)*L);
CoMatrix(:,:,3)=CoMatrix(:,:,3)/(2*(M-1)*N*L);
CoMatrix(:,:,4)=CoMatrix(:,:,4)/(2*(M-1)*(N-1)*L);
CoMatrix(:,:,5)=CoMatrix(:,:,5)/(2*(M-1)*(N-1)*(L-1));
CoMatrix(:,:,6)=CoMatrix(:,:,6)/(2*(M-1)*N*(L-1));
CoMatrix(:,:,7)=CoMatrix(:,:,7)/(2*(M-1)*(N-1)*(L-1));
CoMatrix(:,:,8)=CoMatrix(:,:,8)/(2*M*(N-1)*(L-1));
CoMatrix(:,:,9)=CoMatrix(:,:,9)/(2*M*N*(L-1));
CoMatrix(:,:,10)=CoMatrix(:,:,10)/(2*M*(N-1)*(L-1));
CoMatrix(:,:,11)=CoMatrix(:,:,11)/(2*(M-1)*(N-1)*(L-1));
CoMatrix(:,:,12)=CoMatrix(:,:,12)/(2*(M-1)*N*(L-1));
CoMatrix(:,:,13)=CoMatrix(:,:,13)/(2*(M-1)*(N-1)*(L-1));