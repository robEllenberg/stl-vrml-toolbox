function processSTL(filelist,mir,geomtype,check,stlout)
%% Process STL files exported from SolidWorks URDF Exporter
% Read in a listing of files and process them for OpenRAVE by adding color
% data, and optionally mirroring and finding the convex hulls of each.
% Usage:
%   processVRML(filelist,mir,hull,check,stlout,reduce)
%       filelist is a string that the "dir" command uses to find matching
%           files. Thus, '*.wrl' will return all VRML files, while
%          'Body_L*.wrl' will return only left sides
%       mir is a string indicating what mirror operation to do:
%           'RL' means right to left, 'LR' means left to right
%       hull is a flag to export the convex hull of the body, prefixed with
%           'convhull'
%       check is a flag which optionally shows the processed surfaces.
%       stlout is a flag that optionally exports the finished shape to stl
%           format
%       reduce is a percentage volume preservation tolerance. Usually this
%          should be greater than .99 to minimize distortion. The reduction
%          method is fast but not gauranteed to preserve shape for more
%          drastic reductions.

if ~exist('stlout','var')
    stlout='';
end

if ~exist('check','var')
    check=0;
end

if ~exist('mir','var')
    mir='';
end

if ~exist('geomtype','var')
    geomtype=0;
end

listing = dir(filelist);

tic;
for k=1:length(listing)
    
    if listing(k).isdir
        continue
    end
    
    fname=listing(k).name;
    processFile(fname,mir,geomtype,check,stlout)
end
end

function processFile(fname,mir,geomtype,check,stlout)
fprintf('Processing file %s\n',fname);
[vertices,faces]=stlread(fname);

% if check>=1
%     eztrisurf(faces,vertices);
%     drawnow;
%     if check>=2
%         pause()
%     else
%         pause(3-toc)
%     end
% end
tic;
V=vertices;
newName=fname;
F=faces;

%Mirror VRML if specified
rmatch=strfind(fname,'_R');
lmatch=strfind(fname,'_L');
if ~isempty(lmatch) && strcmp(mir,'LR')
    %Read in the string for the mirror operation and choose the
    %output character
    %newName=fname(1:end-4);
    newName(lmatch+1)=mir(2);
    V(:,2)=-V(:,2);
    F=faces(:,[1,3,2]);
elseif ~isempty(rmatch) && strcmp(mir,'RL')
    newName(rmatch+1)=mir(2);
    V(:,2)=-V(:,2);
    F=faces(:,[1,3,2]);
end

if strcmp(geomtype,'hull')
    F=convhull(V);
    [V,F]=shrinkPointCloud(V,F);
    suffixstart=strfind(newName,'_');
    newName=['convhull' newName(suffixstart:end)];
elseif strcmp(geomtype,'shrink')
    newName=['shrink_' newName];
    [V,F]=removeCoplanarHullFaces(V,F);
end

if ~isempty(stlout) && stlout
    if stlout(1)=='b'
        fmt='binary';
    else
        fmt='ascii';
    end
    outname=[newName(1:end-4),'.stl'];
    fprintf('Mesh has %d faces\n',size(F,1))
    cloud2stl(outname,V,F,fmt)
    
    if check && fmt(1)=='b'
        [v,f]=stlread(outname);
        disp('Showing re-imported STL')
        clf
        eztrisurf(f,v)
        drawnow;
    end
end
end
