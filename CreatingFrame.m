function [frame]=CreatingFrame(A,r,px,sigmax,m,n)

frame=zeros(px,px);

for k = 1:r
    for i = 1:px
        for j=1:px
        frame0(i,j)=A*exp(-((i-m(k))^2/(2*sigmax^2)+(j-n(k))^2/(2*sigmax^2)))*randi([9000 11000])/10000;
            if k==1
                frame(i,j)=frame0(i,j);
            else
                frame(i,j)=frame0(i,j)+frame(i,j);
            end
        end
    end
end
