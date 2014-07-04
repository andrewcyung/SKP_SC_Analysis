function [xval,yval,chosen_lineseries,chosen_parvec,chosen_ptindex,vf_index, pt_coord] = getNearestDataPoint(clicked_point,h_ax,h_lineseries)

clicked_x = clicked_point(1,1);
clicked_y = clicked_point(1,2);
n_lineseries = length(h_lineseries);
if n_lineseries==0
    return;
end
lineseries_xdata = cell(1,n_lineseries);
lineseries_ydata = cell(1,n_lineseries);
lineseries_vecindex = cell(1,n_lineseries);
minDist = realmax;
chosen_ptindex = NaN;
chosen_lineseries = NaN;
for i=1:n_lineseries
    lineseries_xdata{i} = get(h_lineseries(i),'XData');
    lineseries_ydata{i} = get(h_lineseries(i),'YData');
    lineseries_vecindex{i} = get(h_lineseries(i),'ZData');
    dx=daspect(h_ax);
    [newDist,current_index] = min( ((clicked_x - lineseries_xdata{i}).*dx(2)).^2 + ((clicked_y-lineseries_ydata{i}).*dx(1)).^2 );
    if newDist < minDist
        chosen_ptindex = current_index;
        chosen_lineseries = i;
        minDist = newDist;
    end
end
seriesinfo = get(h_lineseries(chosen_lineseries),'UserData');
pt_coord = seriesinfo.coord(chosen_ptindex);
vf_index = seriesinfo.vf_index;
xval = lineseries_xdata{chosen_lineseries}(chosen_ptindex);
yval = lineseries_ydata{chosen_lineseries}(chosen_ptindex);
chosen_parvec = lineseries_vecindex{chosen_lineseries}(chosen_ptindex);