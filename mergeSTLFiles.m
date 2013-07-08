function mergeSTLFiles()
files=dir('convhull*.stl');
for f=files'
    filename=f.name();
    mergeParts(filename(1:end-4));
end

end


function mergeParts(rootname)
files=dir(['export/',rootname,'*']);

if isempty(files)
    disp('No parts found...')
else  
[P,K]=stlread(['export/',files(1).name],true,true);
for f=files(2:end)'
    [P2,K2]=stlread(['export/',f.name],true,true);
    [P,K]=mergeFacetSolids(P,K,P2,K2);
end

cloud2stl([rootname,'_merged.stl'],P,K);
end
end
