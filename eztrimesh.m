function h=eztrimesh(K,P)
    h=trimesh(K,P(:,1),P(:,2),P(:,3));
    axis equal
end