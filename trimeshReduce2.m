function [Pout,Kout]=trimeshReduce2(P,K,check)

if ~exist('check','var')
    check=false;
end

if check
    subplot(2,2,1)

    eztrisurf(K,P);
    title('Original model');
end

%First, find the convex hull of all the points

K_conv=convhull(P(:,1),P(:,2),P(:,3));
[P2,K2]=shrinkPointCloud(P,K_conv);

if check
    subplot(2,2,2)
    eztrisurf(K2,P2,.5)
    hold on
    eztrisurf(K,P);
    hold off
    title('Convex-hull overlay');
end


[P3,K3]=refineTrimesh(P2,K2,size(K2,1)*2,ceil(size(K2,1)/10));
%Find centroid of convex solid to estimate "normals" at points
cent=polyhedronCentroid(P3,K3);
[M,N]=size(P3);
for p=1:M
    delta=P3(p,:)-cent;
    P3(p,:)=delta*1.01+cent;
end

if check
    subplot(2,2,3)
    eztrisurf(Kout,P3,.4)
    hold on
    eztrisurf(K,P);
    hold off
    title('Refined convex hull');
    axis equal
end

Pout=P3;
for j=1:M
    pj=P3(j,:);
    h = pj-cent;
    direc = h / norm(h);
    int_line=[cent,direc];
    %Find intersections along line to conv-hull point from center
    inters=intersectLineMesh3d(int_line,P,K);
    %knowing that distance >= 0, find min distance and scale 
    d=minDistanceToBody(pj,inters);
    
    %should move point towards surface
    
    pnew=-direc*d+pj;
    Pout(j,:)=pnew;
    if check>1
        figure(2)
        ezscatter(inters)
        hold on
    eztrisurf(K,P)
    eztrisurf(K3,P3,.4)
    hold off
        pause
    end
end

if check
    subplot(2,2,4)    
    eztrisurf(Kout,Pout,.5)
    hold on
    eztrisurf(K,P);
    hold off
    title('Shrunk convex hull towards body');
    axis equal
end

end