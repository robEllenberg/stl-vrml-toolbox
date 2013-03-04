function [P_merged,K_merged] = reduceMeshBySlices(file,ax,slices,iters,check)
%reduceMeshBySlices Reduces mesh density by iterative slicing
%   Reduce mesh density and redundancy by repeatedly slicing along an axis
%   and checking for volume reduction in the convex hull. 
%   1) Take a convex hull of the whole mesh and record the volume.
%   2) repeatedly slice along the specified axis, creating 2 convex solids
%       from the partitioned points. Sum their volume and record the difference
%       between the sum and the original volume
%   3) Choose the maximum reduction and divide the volumes, storing the
%   results. Repeat until number of iterations is reached.
%   Arguments:
%       file: a file name containing an stl mesh
%       axis: 'X','Y','Z', or 'B' to use longest bounding box axis
%       slices: number of slices to take
%       iters: number of bisections to take (currently only works with 1)

[K,P]=stlread(file);

bounds=[min(P)';max(P)'];

K_init=convhull(P);
V_init=meshVolume(P,K_init);


if ax=='X'
    j=1;
    p1=[1,0,0];
elseif ax=='Y'
    j=2;
    p1=[0,1,0];
elseif ax=='Z'
    j=3;
    p1=[0,0,1];
end

%Start of iter loop?
heights=linspace(bounds(j),bounds(j*2),slices+2);
heights=heights(2:end-1); %throw out end slices since they do nothing

for k=1:slices
    %TODO: bisection algorithm?
    
    %TODO: keep track of source points so that we can map back to original
    %P and remove duplicate points at the slice plane?
    %Define simple slice plane
    h=heights(k);
    p0=p1*h;
    
    [P_lower,K_lower,P_upper,K_upper]=divideSolid(p0,p1,P,K,check);
    
    V_lower(k)=meshVolume(P_lower,K_lower);
    V_upper(k)=meshVolume(P_upper,K_upper);
    
    reduction(k)=V_init-V_lower(k)-V_upper(k);
end

plot(reduction)

[~,ind]=max(reduction);
h_max=heights(ind);

%TODO: function
p0=[0,0,h_max];
p1=[0,0,1];

%Calculate slice points
figure()
[P1,K1,P2,K2]=divideSolid(p0,p1,P,K,check);
[P_merged,K_merged]=mergeFacetSolids(P1,K1,P2,K2);
figure()
eztrisurf(K_merged,P_merged)

end

function [P1,K1,P2,K2]=divideSolid(p0,p1,P,K,check)

[p_slice,~]=slicemesh(p0,p1,P,K,check);
if check
    drawnow
    pause(.01)
end

%divide point cloud at slice
above_ind=P(:,3)>p0*p1';
P_above=P(above_ind,:);
P_below=P(~above_ind,:);

P_upper=[P_above;p_slice];
P_lower=[P_below;p_slice];

K_upper=convhull(P_upper);
K_lower=convhull(P_lower);

[P1,K1]=shrinkPointCloud(P_lower,K_lower);
[P2,K2]=shrinkPointCloud(P_upper,K_upper);

end