function [frame]=CreatingFrame(A,r,px,sigmax,m,n,nstp)

frame=zeros(px,px);
frame0=zeros(px,px);

for k = 1:r
    for i = 1:px
        for j=1:px
        if k==1
                frame(i,j)=A(nstp,k)*exp(-((i-m(k))^2/(2*sigmax^2)+(j-n(k))^2/(2*sigmax^2)));
            else
                frame(i,j)=A(nstp,k)*exp(-((i-m(k))^2/(2*sigmax^2)+(j-n(k))^2/(2*sigmax^2)))+frame(i,j);
            end
        end
    end
end
