function displayRelatedImages(h_ax,event,parname_x,parname_y,h_fig_thumbnail_x,h_fig_thumbnail_y,h_fig_upstreamData_x,h_fig_upstreamData_y)
h_fig = ancestor(h_ax,'figure');
click_type = get(h_fig,'SelectionType');

% initialize or get handle for cursor highlight box
h_highlightBox = findobj(h_ax,'Type','rectangle');
if isempty(h_highlightBox)
    xlimits = xlim;
    ylimits = ylim;
    factor = 50;
    height = (ylimits(2)-ylimits(1))/factor;
    width = (xlimits(2)-xlimits(1))/factor;
    centerLocation = [mean(xlimits) mean(ylimits)];
    h_highlightBox = rectangle('Position',[centerLocation(1)-width/2 centerLocation(2)-height width height],'EdgeColor','k');
end
h_lineseries = findobj(h_ax,'Type','line');
if strcmp(click_type,'alt')
    clicked_point = get(h_ax,'CurrentPoint');
    [chosen_x,chosen_y,chosen_lineseries,chosen_parvec,chosen_ptindex] = getNearestDataPoint(clicked_point,h_ax,h_lineseries);
    boxPosition = get(h_highlightBox,'Position');
    width = boxPosition(3);
    height = boxPosition(4);
    set(h_highlightBox,'Position',[chosen_x-width/2,chosen_y-height/2,width,height]);
    series_info = get(h_lineseries(chosen_lineseries),'UserData');
    thumbnailpath_x = series_info.thumbnailpath_x{chosen_parvec};
    thumbnailpath_y = series_info.thumbnailpath_y{chosen_parvec};
    upstreamData_x = series_info.upstreamData_x{chosen_parvec};
    upstreamData_y = series_info.upstreamData_y{chosen_parvec};
    
    row = series_info.coord{chosen_ptindex}.row;
    col = series_info.coord{chosen_ptindex}.col;
    
    figsize=300;
    
    if exist(thumbnailpath_x,'file')
        figure(h_fig_thumbnail_x);
        imshow(thumbnailpath_x,'parent',gca);
        set(imhandles(gca),'ButtonDownFcn',{@updateHighlightBoxes,h_fig_thumbnail_y,h_ax,h_fig_upstreamData_x,h_fig_upstreamData_y})
        set(gca,'units','normalized');
        set(gca,'Position',[0 0 1 1]);
        set(gca,'units','pixels');
        position = get(gcf,'position');
        set(gcf,'position',[position(1) position(2) figsize figsize]);
        h_rect_x=NaN;
        highlight_imPosition(h_fig_thumbnail_x,h_rect_x,row,col);
    else
        disp([thumbnailpath_x ' does not exist']);
    end
    
    if exist(thumbnailpath_y,'file')
        figure(h_fig_thumbnail_y);
        imshow(thumbnailpath_y,'parent',gca);
        set(imhandles(gca),'ButtonDownFcn',{@updateHighlightBoxes,h_fig_thumbnail_x,h_ax,h_fig_upstreamData_x,h_fig_upstreamData_y})
        set(gca,'units','normalized');
        set(gca,'Position',[0 0 1 1]);
        set(gca,'units','pixels');
        position = get(gcf,'position');
        set(gcf,'position',[position(1) position(2) figsize figsize]);
        h_rect_y=NaN;
        highlight_imPosition(h_fig_thumbnail_y,h_rect_y,row,col);
    else
        disp([thumbnailpath_y ' does not exist']);
    end
    
    disp([parname_x ' value = ' num2str(chosen_x), ' ' parname_y ' value = ' num2str(chosen_y) ' row = ' num2str(row) ' col = ' num2str(col)]);
%     disp(thumbnailpath_x);
%     disp(thumbnailpath_y);
    
    % display upstreamData for x and y parameter maps
    displayUpstreamData(upstreamData_x,row,col,h_fig_upstreamData_x,parname_x);
    displayUpstreamData(upstreamData_y,row,col,h_fig_upstreamData_y,parname_y);

    
end
end


