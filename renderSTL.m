function renderSTL(filename)
[P,K]=stlread(filename,true,true);
eztrisurf(K,P);