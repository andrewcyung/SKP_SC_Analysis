function ParMapViewClickCallback(src,event,h_scatter_list,h_parMap_list)
    clicked_point = get(gca,'CurrentPoint');
    clicked_parMap_point = [round(clicked_point(1,1)) round(clicked_point(1,2))];
    UpdatePointViews(h_scatter_list,h_parMap_list,clicked_parMap_point,[]);
end