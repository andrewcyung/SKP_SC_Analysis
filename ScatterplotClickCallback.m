function ScatterplotClickCallback(h_ax,event,h_scatter_list,h_parMap_list,h_upstreamView_list,rootpath)

h_fig = ancestor(h_ax,'figure');
click_type = get(h_fig,'SelectionType');
if strcmp(click_type,'alt')
    clicked_scatterplot_point = get(h_ax,'CurrentPoint');
    h_series = findobj(gca,'Type','line','Tag','scatterplot');
    [chosen_x,chosen_y,chosen_lineseries,chosen_parvec,chosen_ptindex,vf_index, current_point] = getNearestDataPoint(clicked_scatterplot_point,gca,h_series);

    UpdatePointViews(h_scatter_list,h_parMap_list,h_upstreamView_list,[],chosen_ptindex,chosen_lineseries,rootpath);
end