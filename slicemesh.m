function [xyzp]=slicemesh(p0,p1,XYZ,tri,check)
% Algorithm by: John D'Errico
% http://www.mathworks.cn/matlabcentral/newsreader/view_thread/29075

% Inputs:
% p0: point on the slice plane
% p1: normal vector to the slice plane
% p0 and p1 are (1x3) row vectors.
% XYZ: (nx3) array of vertices of isosurface data
% TRI: (mx3) integer array of connectivity matrix
% check:  0 - show no debug output
%         1 - show plot of slice vertices (default)
%         2 - show plot of object and slice vertices
% Outputs:
% Edgelist: list of pairs of endpoints of line segments in the slice plane.
% It refers to rows of the array xyzp. These edges are in no special order.

% -------------------------------------------------------------------------

if ~exist('check','var')
    check=1;
end

% first, determine which triangles cross the plane.

% vertices 1, 2 and 3 of each triangle are:

% on which side of the plane are each of a,b,c?
% use a dot product (either the function dot or a matrix multiply will do)
M=size(tri,1);
P0=repmat(p0,M,1);
a = XYZ(tri(:,1),:)-P0;
b = XYZ(tri(:,2),:)-P0;
c = XYZ(tri(:,3),:)-P0;

da=a*p1';
db=b*p1';
dc=c*p1';

% if exactly 1 or 2 of the corners are on the "positive" side of the plane,
% then this face crosses the plane. k will be a list of the triangles the plane
% crosses.

test=(da>0)+(db>0)+(dc>0);

% if k is not empty, then the plane had some intersection with the object.
% I'll be lazy here and loop over the faces crossed, although the loop is
% easily vectorized.

%edgelist=[];
%xyzp=[];
% j=0;
% count=1;
% for i=k(1):k(end)
%     %edgei=[];
% 
%     % did we cross edge ab?
%     if (da(i)*db(i))<=0
%         j=j+1;
%         %edgei=j; 
%         t=abs(da(i))/(abs(da(i))+abs(db(i)));
%         xyz0=[XYZ(tri(i,1),:).*(1-t)+XYZ(tri(i,2),:).*t];
%         xyzp=[xyzp;xyz0];
%     end
% 
%     % did we cross edge ac?
%     if (da(i)*dc(i))<=0
%         j=j+1;
%         %edgei=[edgei,j];
%         t=abs(da(i))/(abs(da(i))+abs(dc(i)));
%         xyz0=[XYZ(tri(i,1),:).*(1-t)+XYZ(tri(i,3),:)*t];
%         xyzp=[xyzp;xyz0];
%     end
% 
%     % did we cross edge bc?
%     if (db(i)*dc(i))<=0
%         t=abs(db(i))/(abs(db(i))+abs(dc(i)));
%         xyz0=[XYZ(tri(i,2),:)*(1-t)+XYZ(tri(i,3),:)*t];
%         xyzp=[xyzp;xyz0];
%     end
% %     edgei
% %     edgelist
%     %edgelist=[edgelist;edgei];
% end
K=find(test==1|test==2);
if ~isempty(K)
    C=da(K).*db(K)<=0;
    ind=K(C);
    
    t_ab=repmat(abs(da(ind))./(abs(da(ind))+abs(db(ind))),1,3);
    xyz_ab=XYZ(tri(ind,1),:).*(1-t_ab)+XYZ(tri(ind,2),:).*t_ab;
    
    C=da(K).*dc(K)<=0;
    ind=K(C);
    
    t_ac=repmat(abs(da(ind))./(abs(da(ind))+abs(dc(ind))),1,3);
    xyz_ac=XYZ(tri(ind,1),:).*(1-t_ac)+XYZ(tri(ind,3),:).*t_ac;
    
    C=db(K).*dc(K)<=0;
    ind=K(C);
    
    t_bc=repmat(abs(db(ind))./(abs(db(ind))+abs(dc(ind))),1,3);
    xyz_bc=XYZ(tri(ind,2),:).*(1-t_bc)+XYZ(tri(ind,3),:).*t_bc;
    xyzp=[xyz_ab;xyz_ac;xyz_bc];
else
    keyboard
    xyzp=[];
end

if check>=1 && ~isempty(xyzp)
    if check>=2
        eztrisurf(tri,XYZ);
    end
    
    hold on
    plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'.')
    plot3(p0(1),p0(2),p0(3),'ms')
    plot3(xyzp(:,1),xyzp(:,2),xyzp(:,3),'r.')
    
    hold off
end
return
