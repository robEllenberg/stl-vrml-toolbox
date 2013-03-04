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
if check
    figure(3)
end
bounds=[min(P)';max(P)'];

K_init=convhull(P);
V_init=meshVolume(P,K_init);

if  ax=='I'
    %Interactive
    eztrisurf(K,P);
    ax=input('Enter 1 (X), 2 (Y), or 3 (Z) to choose direction:');
    ax
end

if ax=='x' ||  ax==1
    j=1;
    p1=[1,0,0]
elseif ax=='y' || ax==2
    j=2;
    p1=[0,1,0]
else
    %assume Z by default
    j=3;
    p1=[0,0,1]
end

%Start of iter loop?
heights=linspace(bounds(j),bounds(j+3),slices+2);
heights=heights(2:end-1); %throw out end slices since they do nothing

for k=1:slices
    %TODO: bisection algorithm?
    
    %TODO: keep track of source points so that we can map back to original
    %P and remove duplicate points at the slice plane?
    %Define simple slice plane
    h=heights(k);
    p0=p1*h;
    
    [P_lower,K_lower,P_upper,K_upper]=divideSolid(p0,p1,P,K,check);
    
    V_lower=meshVolume(P_lower,K_lower);
    V_upper=meshVolume(P_upper,K_upper);
    
    reduction(k)=V_init-V_lower-V_upper;
end


%TODO: recursive divide

[~,ind]=max(reduction);
h_max=heights(ind);
p0=p1*h_max;
%TODO: function

%Calculate slice points
[P1,K1,P2,K2]=divideSolid(p0,p1,P,K,check);
[P_merged,K_merged]=mergeFacetSolids(P1,K1,P2,K2);
if check
    figure(1)
    plot(reduction)
    figure(2)
    eztrisurf(K_merged,P_merged)
end
cloud2stl(['output/',file],P_merged,K_merged,'b')

end

function [P1,K1,P2,K2]=divideSolid(p0,p1,P,K,check)

p_slice=slicemesh(p0,p1,P,K,check);
if check
    drawnow
    pause(.01)
end

[~,j]=max(p1);
%divide point cloud at slice
above_ind=P(:,j)>p0*p1';
P_above=P(above_ind,:);
P_below=P(~above_ind,:);

P_upper=[P_above;p_slice];
P_lower=[P_below;p_slice];

K_upper=convhull(P_upper);
K_lower=convhull(P_lower);

[P1,K1]=shrinkPointCloud(P_lower,K_lower);
[P2,K2]=shrinkPointCloud(P_upper,K_upper);

end