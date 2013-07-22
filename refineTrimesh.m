function [P,K]=refineTrimesh(P,K,maxtris,step,check)

if ~exist('check','var')
    check=false;
end

if check
    subplot(1,2,1)

    eztrisurf(K,P);
    title('Original model');
    axis equal
end

N=size(P,1);
numtris=0;

while numtris<maxtris  
    A=triangleAreas(P,K);
    
    [~,ix]=sort(A,'descend');
    
    [P,K]=refineFace(P,K,ix(1:step));
    numtris=numtris+step
end

if check
    subplot(1,2,2)
    eztrisurf(K,P)
    axis equal
end

end

function A=triangleAreas(P,K)
A=zeros(size(K,1),1);
for r=1:size(K,1)
    A(r)=triangleArea3d(P(K(r,1),:),P(K(r,2),:),P(K(r,3),:));
end
end

function [P,K]=refineFace(P,K,ix)

for x=ix'
    newpoints=[P(K(x,1),:)+P(K(x,2),:);
        P(K(x,2),:)+P(K(x,3),:);
        P(K(x,3),:)+P(K(x,1),:)]/2;
    size(P)
    inds=size(P,1)+(1:3)
    P=[P;newpoints];
    
    
    %Add 3 new faces
    Knew=[K(x,2),inds([2,1]);
        K(x,3),inds([3,2]);
        inds]
    %overwrite old face with first new face
    K(x,2:3)=inds([1,3]);
    K=[K;Knew];
    %add 3 new faces
    
end
end




