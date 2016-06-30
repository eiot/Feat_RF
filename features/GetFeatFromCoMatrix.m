function TextureFeat =GetFeatFromCoMatrix(GrayCoMatrix)
% Calculating the textural Features from 3D GrayCoMatrix
% INPUT:   GrayCoMatrix   16*16*13
%                         grey level number:16   direction number:13
% OUTPUT: TextureFeat     14*2
%                         14 kinds of feature in metrics
% REFERENCES:Haralick, Robert M., and Karthikeyan Shanmugam. "Textural 
%            features for image classification." IEEE Transactions on 
%            systems, man, and cybernetics 6 (1973): 610-621.
%
% Copyright <huangxu@edu.cn>
% $Revision: 1.4 $  $Date: 2016/06/29 16:05:10 $

ux=zeros(1,13); % ux
uy=zeros(1,13); % uy
sigmax=zeros(1,13); % sigmax
sigmay=zeros(1,13); % sigmay
px=zeros(16,13); % px
py=zeros(16,13); % px
hx=zeros(1,13); % hx
hy=zeros(1,13); % hy
hxy1=zeros(1,13); % hxy1
hxy2=zeros(1,13); % hxy2
Q=zeros(16,16,13); % hxy2
energy=zeros(1,13); % f1
contrast=zeros(1,13); % f2
correlationtemp=zeros(1,13);
correlation=zeros(1,13); % f3
sumsquares=zeros(1,13); % f4
inverse=zeros(1,13); % f5
sumaverage=zeros(1,13); % f6
sumentropy=zeros(1,13); % f7
sumvariance=zeros(1,13); % f8
entropy=zeros(1,13); % f9
diffentropy=zeros(1,13); % f10
diffvariance=zeros(1,13); % f11
informeacorr=zeros(1,13); % f12
otherinformeacorr=zeros(1,13); % f13
maxcorrcoef=zeros(1,13); % f14

for n=1:13
    for i=1:16
        for j=1:16
            energy(n)=GrayCoMatrix(i,j,n)^2+energy(n); % f1
            entropy(n)=-GrayCoMatrix(i,j,n)*log(GrayCoMatrix(i,j,n)+eps)+entropy(n); % f9
            for k=0:15
                if (i-j)==k||(i-j)==-k
                    contrast(n)=(k^2)*sum(sum(GrayCoMatrix(i,j,n)))+contrast(n);% f2
                end
            end
            inverse(n)=GrayCoMatrix(i,j,n)/(1+(i-j)^2)+inverse(n);% f5
            for k=2:32
                if i+j==k
                    sumaverage(n)=i*GrayCoMatrix(i,j,n)+sumaverage(n); % f6
                    sumentropy(n)=-GrayCoMatrix(i,j,n)*log(GrayCoMatrix(i,j,n)+eps)+sumentropy(n); % f7
                end
            end
            for k=0:15
                if i-j==k
                    diffentropy(n)=-GrayCoMatrix(i,j,n)*log(GrayCoMatrix(i,j,n)+eps)+diffentropy(n); % f10
                end
            end            
            ux(n)=i*GrayCoMatrix(i,j,n)+ux(n);
            uy(n)=j*GrayCoMatrix(i,j,n)+uy(n);
            px(i,n)=GrayCoMatrix(i,j,n)+px(i,n);
            py(j,n)=GrayCoMatrix(i,j,n)+py(j,n);
        end
    end
    % ux,uy can be used

    for i=1:16
        for j=1:16
            sigmax(n)=(i-ux(n))^2*GrayCoMatrix(i,j,n)+sigmax(n);
            sigmay(n)=(j-uy(n))^2*GrayCoMatrix(i,j,n)+sigmay(n);
            correlationtemp(n)=i*j*GrayCoMatrix(i,j,n)+correlationtemp(n);
            sumsquares(n)=(i-ux(n))^2*GrayCoMatrix(i,j,n)+sumsquares(n); % f4
            for k=2:32
                if i+j==k
                    sumvariance(n)=(i-sumentropy(n))^2*GrayCoMatrix(i,j,n); % f8
                end
            end
            for k=0:15
                if i-j==k
                    diffvariance(n)=(i-diffentropy(n))^2*GrayCoMatrix(i,j,n)+diffvariance(n); % f11
                end
            end
            hx(n)=-GrayCoMatrix(i,j,n)*log(GrayCoMatrix(i,j,n)+eps)+hx(n);
            hy(n)=-GrayCoMatrix(i,j,n)*log(GrayCoMatrix(i,j,n)+eps)+hy(n);
            hxy1(n)=-GrayCoMatrix(i,j,n)*log(px(i,n)*py(j,n)+eps)+hxy1(n);
            hxy2(n)=-px(i,n)*py(j,n)*log(px(i,n)*py(j,n)+eps)+hxy2(n);
            for k=1:16
                Q(i,j,n)=GrayCoMatrix(i,k,n)*GrayCoMatrix(j,k,n)/(px(i,n)*py(k,n)+eps)+Q(i,j,n);
            end
        end
    end
    % sigmax,sigmay can be used
    
    correlation(n)=(correlationtemp(n)-ux(n)*ux(n))/(sigmax(n)*sigmay(n)+eps); % f3
    informeacorr(n)=(entropy(n)-hxy1(n))/(max(hx(n),hy(n))+eps); % f12
    otherinformeacorr(n)=sqrt(1-exp(-2*abs(hxy2(n)-entropy(n)))); % f13
    Q2=Q(:,:,n);
    eigen=eig(Q2);
    eigen_sort=sort(eigen);
    maxcorrcoef(n)=sqrt(eigen_sort(end-1)); % f14
end

TextureFeat=[mean(energy) std(energy) mean(contrast) std(contrast) mean(correlation) std(correlation) mean(sumsquares) std(sumsquares) mean(inverse) std(inverse) mean(sumaverage) std(sumaverage) mean(sumentropy) std(sumentropy) mean(sumvariance) std(sumvariance) mean(entropy) std(entropy) mean(diffentropy) std(diffentropy) mean(diffvariance) std(diffvariance) mean(informeacorr) std(informeacorr) mean(otherinformeacorr) std(otherinformeacorr) mean(maxcorrcoef) std(maxcorrcoef) ];