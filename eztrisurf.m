function h=eztrisurf(K,P,alpha)
if ~exist('alpha','var')
    alpha=1
end
    h=trisurf(K,P(:,1),P(:,2),P(:,3),'FaceAlpha',alpha);
    axis equal
end