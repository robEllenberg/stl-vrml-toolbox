function [Pout,Kout]=removeCoplanarHullFaces(P,K)
close all
facenormals=faceNormal(P,K);
normals=facenormals./repmat(sqrt(sum(facenormals.^2,2)),1,3);

tol=1e-10;
%Crude unique normal finder
[~,~,N]=unique(round(normals/tol)*tol,'rows');

ind=hist(N,unique(N));
% figure(1)
% hist(N,unique(N));

dupes=find(ind>1);

remove_inds=[];
for k=dupes
    faces=find(N==k);
    
    % create supporting plane (assuming first 3 points are not colinear...)
    plane = createPlane(P(K(faces(1),:),:));
    
    % project points onto the plane
    pt_inds=K(faces,:);
    
    
    pts = planePosition(P(pt_inds,:), plane);
    
    K2d=unique(convhull(pts));
    
    check= true(size(pts,1),1);
    check(K2d)=false;
    remove_inds=[remove_inds;pt_inds(check)];
end

keep_inds=true(size(P,1),1);
keep_inds(remove_inds)=false;

Pout=P(keep_inds,:);
Kout=convhull(Pout);

% figure(2)
% drawMesh(Pout,Kout)

