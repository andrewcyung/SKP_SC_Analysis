function highlight_imPosition(h_fig,h_rect,row,col)
    pixelwidth = 1;
    pixelheight = 1;
    box_position = [col-pixelwidth/2,row-pixelheight/2,pixelwidth,pixelheight];
    figure(h_fig);
    if isnan(h_rect)
        rectangle('Position',box_position,'EdgeColor','g');
    else
        set(h_rect,'Position',box_position);
    end
end