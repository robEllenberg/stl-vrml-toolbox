clear all
[K,P]=stlread('Body_LWP.stl');
close all

bounds=[min(P)';max(P)'];

K_init=convhull(P);
V_init=meshVolume(P,K_init);

slices=10;
heights=linspace(bounds(3)+.001,bounds(6)-.001,slices);
for k=1:slices
    %TODO: bisection algorithm?
    
    %TODO: keep track of source points so that we can map back to original
    %P and remove duplicate points at the slice plane?
    %Define simple slice plane
    h=heights(k);
    p0=[0,0,h];
    p1=[0,0,1];
    
    %Calculate slice points
    [p_slice,~]=slicemesh(p0,p1,P,K,2);
    drawnow;
    pause(.01)
    %divide point cloud at slice
    above_ind=P(:,3)>h;
    P_above=P(above_ind,:);
    P_below=P(~above_ind,:);
    
    P_upper=[P_above;p_slice];
    P_lower=[P_below;p_slice];
    
    K_upper=convhull(P_upper);
    K_lower=convhull(P_lower);
    
    V_lower(k)=meshVolume(P_lower,K_lower);
    V_upper(k)=meshVolume(P_upper,K_upper);
    
    reduction(k)=V_init-V_lower(k)-V_upper(k);
end

plot(reduction)

[m,ind]=max(reduction);
h_max=heights(ind);

%TODO: function
p0=[0,0,h_max];
p1=[0,0,1];

%Calculate slice points
figure()
[p_slice,~]=slicemesh(p0,p1,P,K,2);

%divide point cloud at slice
above_ind=P(:,3)>h_max;
P_above=P(above_ind,:);
P_below=P(~above_ind,:);

P_upper=[P_above;p_slice];
P_lower=[P_below;p_slice];

K_upper=convhull(P_upper);
K_lower=convhull(P_lower);

[P1,K1]=shrinkPointCloud(P_lower,K_lower);
[P2,K2]=shrinkPointCloud(P_upper,K_upper);
[P_merged,K_merged]=mergeFacetSolids(P1,K1,P2,K2);
figure()
eztrisurf(K_merged,P_merged)
