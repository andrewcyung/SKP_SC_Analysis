function updateHighlightBoxes(h_im,event,h_fig_thumbnail_other,h_scatterPlot,h_fig_upstreamData_x,h_fig_upstreamData_y)
% update the highlight boxes in the other thumbnail figure and the two
% upstreamData figures
h_currentHighlightBox = findobj(gca,'Type','rectangle');
clicked_point = get(gca,'CurrentPoint');
origPosition = get(h_currentHighlightBox,'Position');
width = origPosition(3);
height = origPosition(4);
clicked_point_x = round(clicked_point(1,1));
clicked_point_y = round(clicked_point(1,2));

newPosition = [clicked_point_x-width/2 clicked_point_y-height/2 width height];
set(h_currentHighlightBox,'Position',newPosition);
h_otherThumbnailHighlightBox = findobj(h_fig_thumbnail_other,'Type','rectangle');

set(h_otherThumbnailHighlightBox,'Position',newPosition);
h_scatterPlotLineSeries = findobj(h_scatterPlot,'Type','line');
n_series = length(h_scatterPlotLineSeries);

coordsFound = false;
selectedIndex = NaN;
for i_series=1:n_series
    info = get(h_scatterPlotLineSeries(i_series),'UserData');
    coords = info.coord;
    n_coords = length(coords);
    for i_coord = 1:n_coords
        if (coords{i_coord}.row == clicked_point_y) && (coords{i_coord}.col == clicked_point_x)
            coordsFound = true;
            selectedSeries = i_series;
            selectedIndex = i_coord;
        end
    end
end

if coordsFound == false
    disp('the selected point not within the analysis ROI');
    return;
end

selectedVec = get(h_scatterPlotLineSeries(selectedSeries),'ZData');
selectedXVec = get(h_scatterPlotLineSeries(selectedSeries),'XData');
selectedYVec = get(h_scatterPlotLineSeries(selectedSeries),'YData');
selectedPointX = selectedXVec(selectedIndex);
selectedPointY = selectedYVec(selectedIndex);
selectedSeriesSubset = selectedVec(selectedIndex);

disp([info.parname_x ' value = ' num2str(selectedPointX), ' ' info.parname_y ' value = ' num2str(selectedPointY) ' row = ' num2str(clicked_point_y) ' col = ' num2str(clicked_point_x)]);


h_scatterPlotHighlightBox = findobj(h_scatterPlot,'Type','rectangle');
scatterBoxPosition = get(h_scatterPlotHighlightBox,'Position');
scatterBoxWidth = scatterBoxPosition(3);
scatterBoxHeight = scatterBoxPosition(4);
set(h_scatterPlotHighlightBox,'Position',...
    [selectedPointX-scatterBoxWidth/2  selectedPointY-scatterBoxHeight/2 scatterBoxWidth scatterBoxHeight]);

upstreamData = info.upstreamData_x{selectedSeriesSubset};
displayUpstreamData(upstreamData,clicked_point_y,clicked_point_x,h_fig_upstreamData_x,'')
upstreamData = info.upstreamData_y{selectedSeriesSubset};
displayUpstreamData(upstreamData,clicked_point_y,clicked_point_x,h_fig_upstreamData_y,'');
end