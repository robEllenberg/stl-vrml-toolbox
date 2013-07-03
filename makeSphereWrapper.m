function [P,K]=makeSphereWrapper(center,radius,density,ax)

[X,Y,Z]=sphere(density);

%Merge spheres with X, Y, Z center axes


P=circshift([X(:),Y(:),Z(:)],[0,3-ax]);
%     Y(:),Z(:),X(:);
%     Z(:),X(:),Y(:)];

P(:,1)=P(:,1)*radius+center(1);
P(:,2)=P(:,2)*radius+center(2);
P(:,3)=P(:,3)*radius+center(3);
K=convhull(P);
[P,K]=shrinkPointCloud(P,K);
end