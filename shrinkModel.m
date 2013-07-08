function [Vout,Fout]=shrinkModel(V,F)
%After convex hull calculation, a lot of points are no longer necessary. This
%function finds only the points used in the new faces, and throws away the
%rest.  It's probably balls slow, but it's not worth tweaking at this point
%
%Usage:
%   [Vout,Fout] = shrinkModel(V,F)
%
%       Vout is the new point cloud, reduced in size
%       Fout is the new set of indices referring to these new pruned
%       points
%       V is the original set of vertices in the model
%       F is the original set of faces in the model

    [V2,F2]=patchslim(V,F);
    pointsUsed=unique(F2);
    newFaces=zeros(size(F2));
    
    newind=zeros(size(V2,1),1);
    newind(pointsUsed)=1:length(pointsUsed);
    
    Fout=newind(F2);
    Vout=V2(pointsUsed,:);
end
