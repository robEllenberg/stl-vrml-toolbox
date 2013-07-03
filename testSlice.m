pt=[];
h=eztrisurf(K,P);
clicked=false;
ax=axis();
h_control=uicontrol('Style', 'pushbutton', 'Callback', @placeButtonCallback);
set(h_control,'UserData',2);
while ishandle(h)
    if isempty(get(gcf,'WindowButtonDownFcn'))
    pt=select3d(gca)
    end
    if ~isempty(pt) && ~clicked
        p=get(h_control,'UserData');
        ind=mod(p,3)+1;
        Pc=P(P(:,ind)>pt(ind),:);
        Kcut=K(sum(reshape(P(K,ind)>pt(ind),[],3),2)==3,:);
        Kc=convhull(Pc);
        [az,el]=view;
        
        h=eztrisurf(Kcut,P,1);
        hold on
        h=eztrisurf(Kc,Pc,.5);
        hold off
        clicked=~clicked;
        view(az,el)
        axis(ax)
    elseif clicked && ~isempty(pt) 
        clicked=~clicked;
        [az,el]=view;
        h=eztrisurf(K,P);
        view(az,el)
        axis(ax)
    end
    pause(.1)
end
