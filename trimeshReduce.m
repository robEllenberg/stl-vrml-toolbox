function [P,K]=trimeshReduce(Pin,Kin,rplimit,check)

if ~exist('check','var')
    check=false;
end

[P,K]=shrinkModel(Pin,Kin);
if check
    figure()
    subplot(1,2,1)

    eztrisurf(K,P);
    title('Original model');
    axis equal
end

%Hack--10 passes seems to smooth out most gaps
step=rplimit^(1/10);
for k=1:10
   [P,K]=reductionPass(P,K,step);
end

if check
    subplot(1,2,2)
    eztrisurf(K2,P2)
    title(sprintf('Removed %d points from %d total, Volume ratio %f',numremove,N,rp));
    axis equal
end

end

function [P2,K2]=reductionPass(P,K,rplimit)
N=size(P,1);
V=zeros(N,1);
SA=zeros(N,1);
for k=1:size(P,1)
    [V(k),SA(k)]=getSlice(k,P,K);
end

metric=V./SA;
[~,ix]=sort(metric);

lower=1;
upper=N;
numremove=lower;
V1=meshVolume(P,K);
rp=1;
while (upper-lower)>2
    if rp<=rplimit
        upper=numremove;
    else
        lower=numremove;
    end
    numremove=floor((lower+upper)/2);
    
    P2=P(ix(numremove:end),:);
    
    try
        K2=convhull(P2(:,1),P2(:,2),P2(:,3));
         V2=meshVolume(P2,K2);
    catch err
        V2=0;
    end
    
    rp=V2/V1;
    
end

end

function A=triangleAreas(P,K)
A=zeros(size(K,1),1);
for r=1:size(K,1)
    A(r)=triangleArea3d(P(K(r,1),:),P(K(r,2),:),P(K(r,3),:));
end
end



function [V,SA]=getSlice(ind,P,K)

[r,~]=find(K==ind);
kslice=K(unique(r),:);
pslice=P(kslice(:),:);
try
    K2=convhull(pslice);
    V=meshVolume(pslice,K2);
    SA=sum(triangleAreas(pslice,K2));
catch err
    if strcmp(err.identifier,'MATLAB:convhull:EmptyConvhull3DErrId')
%         fprintf('Found %d co-planar faces at point %d\n',length(r),ind)
        V=0;
        SA=0;
    elseif strcmp(err.identifier,'MATLAB:convhull:NotEnoughPtsConvhullErrId')
        disp('not enough points?')
        V=1000;
        SA=1;
    else
        disp(err)
    end
end

end


