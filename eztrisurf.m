function h=eztrisurf(K,P,alpha,color)
    if ~exist('alpha','var')
        alpha=1;
    end
    if ~exist('color','var')
        color=[.5,.5,.5];
    end
    h=trisurf(K,P(:,1),P(:,2),P(:,3),'FaceAlpha',alpha,'FaceColor',color);
    axis equal
end
