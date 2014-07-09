function UpdatePointViews(h_scatter_list,h_parMap_list,h_upstreamView_list,clicked_parMap_point,clicked_scatterplot_point_index,clicked_scatterplot_lineseries,rootpath,vf_index)

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
        lineseries1_vecindex = get(h_lineseries1(clicked_scatterplot_lineseries),'ZData');
        chosen_parvec = lineseries1_vecindex(clicked_scatterplot_point_index);
        
        
        userdata = get(h_parMap_list{i},'UserData');
        vf = userdata.vf;
%         vf_index = userdata.vf_index;
        if length(vf_index)==3
            chosen_series = vf{vf_index(1)}{vf_index(2)}{vf_index(3)};
        elseif length(vf_index)==2
            chosen_series = vf{vf_index(1)}{vf_index(2)};
        elseif length(vf_index)==1
            chosen_series = vf{vf_index(1)};
        end

        
        h_im = findobj(gca,'Type','image');
        buttondownfcn = get(h_im,'ButtonDownFcn');

        
        impath = [rootpath chosen_series{chosen_parvec}.thumbnail_path];

        if exist(impath,'file')
            im = imread(impath);
            h_new_im = imagesc(im); colormap gray;
            axis equal; axis off;
            set(h_new_im,'ButtonDownFcn',buttondownfcn);
        else
            disp([impath ' does not exist']);
        end

        userdata.upstreamData = chosen_series{chosen_parvec}.upstreamDataStruct;
        set(h_parMap_list{i},'UserData',userdata);
        
%         h_im = findobj(gca,'Type','image');
%         set(h_im,'ButtonDownFcn',{@ParMapViewClickCallback,h_scatter_list,h_parMapView_list,h_upstreamView_list,rootpath});
        h_ParmapHighlightBox = NaN; % highlight box erased
        highlight_imPosition(gcf,h_ParmapHighlightBox,row,col);

    elseif strcmp(click_source,'parMap')
        h_ParmapHighlightBox = findobj(gca,'Type','rectangle','Tag','cursor');
        row = clicked_parMap_point(2);
        col = clicked_parMap_point(1);
        highlight_imPosition(gcf,h_ParmapHighlightBox,row,col);
    end
    userdata = get(h_parMap_list{i},'UserData');
    upstreamData = userdata.upstreamData;
    if ~isempty(upstreamData)
        displayUpstreamData(upstreamData,row,col,h_upstreamView_list{i},'',rootpath)
 
    end
end