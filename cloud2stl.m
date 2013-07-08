function cloud2stl(filename,cloud,mesh,mode)
%   Author: Robert Ellenberg
%       based on surf2stl by Bill McDonald, 02-20-04

if (ischar(filename)==0)
    error( 'Invalid filename');
end

if (nargin < 4)
    mode = 'binary';
elseif (strcmp(mode,'ascii')==0)
    mode = 'binary';
end

if strcmp(mode,'ascii')
    % Open for writing in ascii mode
    fid = fopen(filename,'w');
else
    % Open for writing in binary mode
    fid = fopen(filename,'wb+');
end

if (fid == -1)
    error( sprintf('Unable to write to %s',filename) );
end

title_str = sprintf('Created by surf2stl.m %s',datestr(now));

if strcmp(mode,'ascii')
    fprintf(fid,'solid %s\r\n',title_str);
else
    str = sprintf('%-80s',title_str);    
    fwrite(fid,str,'uchar');         % Title
    fwrite(fid,0,'int32');           % Number of facets, zero for now
end

N=find_normals(cloud,mesh);

if strcmp(mode,'ascii')
    write_facet=@local_write_facet;
else
    write_facet=@local_write_binary_facet;
end

if any(isnan(cloud))
    disp('Found NaN in Points, aborting!')
    return
end
for i=1:(size(mesh,1))
    
    p1 = cloud(mesh(i,1),:);
    p2 = cloud(mesh(i,2),:);
    p3 = cloud(mesh(i,3),:);
    write_facet(fid,p1,p2,p3,N(i));
end
nfacets=size(N,1);

if strcmp(mode,'ascii')
    fprintf(fid,'endsolid %s\r\n',title_str);
else
    fseek(fid,0,'bof');
    fseek(fid,80,'bof');
    fwrite(fid,nfacets,'int32');
end

fclose(fid);

disp( sprintf('Wrote %d facets',nfacets) );


% Local subfunctions

function num = local_write_facet(fid,p1,p2,p3,n)

if any( isnan(p1) | isnan(p2) | isnan(p3) )
    num = 0;
    return;
else
    num = 1;
     
    fprintf(fid,'facet normal %.7E %.7E %.7E\r\n', n(1),n(2),n(3) );
    fprintf(fid,'outer loop\r\n');
    fprintf(fid,'vertex %.7E %.7E %.7E\r\n', p1);
    fprintf(fid,'vertex %.7E %.7E %.7E\r\n', p2);
    fprintf(fid,'vertex %.7E %.7E %.7E\r\n', p3);
    fprintf(fid,'endloop\r\n');
    fprintf(fid,'endfacet\r\n');
    
end

function local_write_binary_facet(fid,p1,p2,p3,n)
data=[n,p1,p2,p3];
fwrite(fid,n,'float32');
fwrite(fid,p1,'float32');
fwrite(fid,p2,'float32');
fwrite(fid,p3,'float32');
fwrite(fid,0,'int16');  % unused


function N = find_normals(V,F)

V1 = V(F(:,2),:)-V(F(:,1),:);
V2 = V(F(:,3),:)-V(F(:,1),:);
V3 = cross(V1,V2);
N = V3 ./ repmat(sqrt(sum(V3.^2,2)),1,3);


function n = local_find_normal(p1,p2,p3)

v1 = p2-p1;
v2 = p3-p1;
v3 = cross(v1,v2);
n = v3 ./ sqrt(sum(v3.*v3));
