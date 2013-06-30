function [d,ind] = minDistanceToBody(pj,inters)
    PJ=repmat(pj,size(inters,1),1);
    deltas=inters-PJ;
    dists=sqrt(sum(deltas.^2,2));
    [d,ind]=min(dists);
end