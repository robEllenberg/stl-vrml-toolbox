function [Ps2,Ks2]=reduceMeshBySphere(P,K,check,ax)

if ~exist('check','var')
    check=false;
end

% if check
%     eztrisurf(K,P);
%     title('Original model');
% end

%First, find the convex hull of all the points

K_conv=convhull(P);
cent=polyhedronCentroid(P,K_conv);
bb=boundingBox3d(P);
bmin=bb([1:2:5])-cent;
bmax=bb([2:2:6])-cent;
radius=1.1*max(abs([bmin,bmax]));
min_radius=min(abs([bmin,bmax]))/5;
[Ps,Ks]=makeSphereWrapper(cent,radius,40,ax);
% 
% if check
%     hold on
%     eztrisurf(Ks,Ps,.5);
%     ezscatter(cent)
%     hold off
%     title('Sphere wrapper');
% end

%Project all points onto the model and find intersected faces
intersected=false(size(K,1),1);

ball_radius=0.002;
offsets=[0,0;
         1,0;
         0,1;
         -1,0;
         0,-1]*ball_radius;
    
d=zeros(5,1);
ind=zeros(5,1);
for j=1:size(Ps,1)
    
    pj=Ps(j,:);
    h = pj-cent;
    direc = h / norm(h);
    int_line=[cent,direc];
    %Find intersections along line to conv-hull point from center
    [inters,~,face_inters]=intersectLineMesh3d(int_line,P,K);
    %knowing that distance >= 0, find min distance and scale
    [d,ind]=minDistanceToBody(pj,inters);
    if d<(radius-min_radius)
        intersected(face_inters(ind))=true;
    end
    %     ind
    %     face_inters(ind)
end

%Find all points refered to by all intersected faces
pointIndices=unique(K(intersected,:));
projections=zeros(size(pointIndices,1),3);
directions=projections;
Ps2=P(pointIndices,:);

for k=1:length(pointIndices)
   h = Ps2(k,:)-cent;
   directions(k,:)= h/norm(h);
   %point on sphere along radial direction from center
   projections(k,:)=radius*directions(k,:)+cent;
end

Ks2=convhull(projections);

if check
    clf
    %eztrisurf(K,P,.2,[.5,.5,.5]);
    hold on
    %eztrisurf(Ks,Ps,.8);
    ezscatter(Ps2)
    %eztrisurf(Ks2,projections,.5);
    eztrisurf(Ks2,Ps2,.7,[.8,.5,.5]);
    hold off
    title('Shrunk convex hull towards body');
    xlabel('X')
    ylabel('Y')
end

end

function [d,ind] = minDistanceToBody(pj,inters)
    PJ=repmat(pj,size(inters,1),1);
    deltas=inters-PJ;
    dists=sqrt(sum(deltas.^2,2));
    if isempty(dists)
        d=1000;
        ind=0;
    else
    [d,ind]=min(dists);
    end
    
end
