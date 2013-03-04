function [P_merged,K_merged] = reduceMeshBySlices(file,ax,slices,chooseslices,check)
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
heights=linspace(bounds(j),bounds(j+3),slices+2)
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

[~,loc]=findpeaks(reduction);

%single refinement step
newheights=[heights(loc)+max(diff(heights))/3,heights(loc)-max(diff(heights))/3]
for k=1:length(newheights)
    %TODO: bisection algorithm?
    
    %TODO: keep track of source points so that we can map back to original
    %P and remove duplicate points at the slice plane?
    %Define simple slice plane
    h=newheights(k);
    p0=p1*h;
    
    [P_lower,K_lower,P_upper,K_upper]=divideSolid(p0,p1,P,K,check);
    
    V_lower=meshVolume(P_lower,K_lower);
    V_upper=meshVolume(P_upper,K_upper);
    
    reduction=[reduction,V_init-V_lower-V_upper];
end

%TODO: recursive divide
heights=[heights,newheights];
[heights,ind]=sort(heights);
[~,loc]=findpeaks(reduction(ind));
if check
    figure(1)
    plot(reduction(ind))
end
Ptemp=P;
Ktemp=K;
P_merged=[];
K_merged=[];
hvec=[bounds(j)-.001,heights,bounds(j+3)+.001];
peaks=[1,loc+1,length(hvec)];
t0=[];
for p=1:length(peaks)-1
    p0=p1*hvec(peaks(p));
    p2=p1*hvec(peaks(p+1));
    %TODO: function
    %Calculate slice points
    [Ps,Ks,b,t]=sliceSolid(p0,p2,p1,P,K,check);
    size(Ps)
    %Remove faces?
%     ind=1:size(Ks,1);
%     
%     
%     for k=ind
%         if sum(Ks(k,1)==[t,b]) && sum(Ks(k,2)==[t,b]) && sum(Ks(k,3)==[t,b])
%             ind(k)=0;
%         end
%     end
    [Ps,Ks]=trimeshReduce(Ps,Ks,.999,0);
    
    %eztrisurf(Ks,Ps)
    %pause()
    [P_merged,K_merged]=mergeFacetSolids(P_merged,K_merged,Ps,Ks);
    
end

if check
    figure(2)
    eztrisurf(K_merged,P_merged)
end

%[P_out,K_out]=trimeshReduce(P_shrunk,K_shrunk,.999,check);
cloud2stl(['output/',file],P_merged,K_merged,'b')
%cloud2stl(['output/','raw_',file],P_shrunk,K_shrunk,'b')
end

function [Pout,Kout,bottom,top]=sliceSolid(p0,p1,n,P,K,check)

p_slice1=slicemesh(p0,n,P,K,check);
p_slice2=slicemesh(p1,n,P,K,check);

[~,j]=max(n);
between_ind=P(:,j)>=p0*n' & P(:,j)<=p1*n';
Pout=[P(between_ind,:);p_slice1;p_slice2];
size(Pout)
start=size(P(between_ind,:),1)+1;
bottom=start:start+size(p_slice1,1);
top=bottom(end)+1:bottom(end)+1+size(p_slice2,1);

if ~isempty(Pout)
    Kout=convhull(Pout);
    %eztrisurf(Kout,Pout);
    %pause()
    [Pout,Kout]=shrinkPointCloud(Pout,Kout);
    size(Pout)
    
else
    disp('empty')
    p0
    p1
    n
    Pout=[];
    Kout=[];
end



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

P2=[P_above;p_slice];
P1=[P_below;p_slice];

K2=convhull(P2);
K1=convhull(P1);

%[P1,K1]=shrinkPointCloud(P_lower,K_lower);
%[P2,K2]=shrinkPointCloud(P_upper,K_upper);

end

