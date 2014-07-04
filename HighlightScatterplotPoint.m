function HighlightScatterplotPoint(h_fig,h_rect,chosen_x,chosen_y)

figure(h_fig);
if isnan(h_rect)
    xlimits = xlim;
    ylimits = ylim;
    factor = 50;
    height = (ylimits(2)-ylimits(1))/factor;
    width = (xlimits(2)-xlimits(1))/factor;
    centerLocation = [mean(xlimits) mean(ylimits)];
    rectangle('Position',[chosen_x-width/2 chosen_y-height/2 width height],'EdgeColor','k','Tag','cursor');
else
    scatterBoxPosition = get(h_rect,'Position');
    width = scatterBoxPosition(3);
    height = scatterBoxPosition(4);
    set(h_rect,'Position',[chosen_x-width/2  chosen_y-height/2 width height]);
end

end