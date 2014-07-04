function UpdatePointViews(h_scatter_list,h_parMap_list,clicked_parMap_point,clicked_scatterplot_point_index,clicked_scatterplot_lineseries)

if isempty(clicked_parMap_point) && ~isempty(clicked_scatterplot_point_index)
    click_source = 'scatter';
else
    click_source = 'parMap';
end

n_scatterplot = length(h_scatter_list);
n_parMap = length(h_parMap_list);

for i=1:n_scatterplot
    figure(h_scatter_list{i})
    h_series = findobj(gca,'Type','line','Tag','scatterplot');
    h_ScatterplotHighlightBox = findobj(gca,'Type','rectangle','Tag','cursor');
    if strcmp(click_source,'scatter')
        parX_data = get(h_series(clicked_scatterplot_lineseries),'XData');
        parY_data = get(h_series(clicked_scatterplot_lineseries),'YData');
        chosen_x = parX_data(clicked_scatterplot_point_index);
        chosen_y = parY_data(clicked_scatterplot_point_index);
        HighlightScatterplotPoint(gcf,h_ScatterplotHighlightBox,chosen_x,chosen_y);
    elseif strcmp(click_source,'parMap')
        clicked_point_x = round(clicked_parMap_point(1,1));
        clicked_point_y = round(clicked_parMap_point(1,2));
        h_scatterPlotLineSeries = findobj(h_scatter_list{i},'Type','line','Tag','scatterplot');
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
        
        HighlightScatterplotPoint(gcf,h_ScatterplotHighlightBox,selectedPointX,selectedPointY);

    end
    
end

for i=1:n_parMap
    figure(h_parMap_list{i})
    if strcmp(click_source,'scatter')
        h_ParmapHighlightBox = findobj(gca,'Type','rectangle','Tag','cursor');

        h_lineseries1 = findobj(h_scatter_list{1},'Type','line','Tag','scatterplot');
        series_info = get(h_lineseries1(clicked_scatterplot_lineseries),'UserData');
        row = series_info.coord{clicked_scatterplot_point_index}.row;
        col = series_info.coord{clicked_scatterplot_point_index}.col;
        highlight_imPosition(gcf,h_ParmapHighlightBox,row,col);

    elseif strcmp(click_source,'parMap')
        h_ParmapHighlightBox = findobj(gca,'Type','rectangle','Tag','cursor');
        highlight_imPosition(gcf,h_ParmapHighlightBox,clicked_parMap_point(2),clicked_parMap_point(1));

    end
end