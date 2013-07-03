function [Pout,Ks]=trimeshReduce2(P,K,check,ax)

if ~exist('check','var')
    check=false;
end

if check
    eztrisurf(K,P);
    title('Original model');
end

%First, find the convex hull of all the points

K_conv=convhull(P(:,1),P(:,2),P(:,3));
cent=polyhedronCentroid(P,K_conv);
bb=boundingBox3d(P);
bmin=bb([1:2:5])+cent;
bmax=bb([2:2:6])+cent;
radius=1.2*max(abs([bmin,bmax]));

[Ps,Ks]=makeSphereWrapper(cent,radius,30,ax);

if check
    hold on
    eztrisurf(Ks,Ps,.5);
    ezscatter(cent)
    hold off
    title('Sphere wrapper');
end

Pout=Ps;
ball_radius=0;
min_rad=radius/20;
for j=1:size(Ps,1)
    pj=Ps(j,:);
    h = pj-cent;
    direc = h / norm(h);
    int_line=[cent,direc];
    %Find intersections along line to conv-hull point from center
    inters=intersectLineMesh3d(int_line,P,K);
    %knowing that distance >= 0, find min distance and scale 
    [d,ind]=minDistanceToBody(pj,inters);
    %minimum distance prevents degenerate geometry
    if isempty(d) || isempty(inters)
        d=min_rad;
    else
        d=min(d,radius-min_rad);
    end
    %should move point towards surface
    
    pnew=-direc*(d-ball_radius)+pj;
    Pout(j,:)=pnew;
end

if check
    eztrisurf(K,P);
    hold on
    eztrisurf(Ks,Pout,.5);
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
    [d,ind]=min(dists);
end
