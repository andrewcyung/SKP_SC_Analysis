function val = graphCorrelations(h,style,class_info,colour_catlist,tint_catlist,marker_catlist,data_label,xdata,ydata)

% style: a structure describing the colours, tints, and marker shapes for visualization of the correlation
% class_info: cell array of labels describing the primary (colour) class, secondary class (tint) and tertiary (marker) class
% colour_catlist: cell array denoting data categories enumerated by colour (the HSV "hue") 
% tint_catlist: cell array denoting the data categories enumerated by tint (the HSV "luminance")
% marker_catlist: cell array denoting the data categories enumerated by marker shape
% data_label: labels describing the xdata and ydata
% xdata: data values along the x coordinate (a cell array, with dimensions consistent with category lists
% ydata: data values along the y coordinate (a cell array, with dimensions consistent with category lists

n_colour = length(style.colours);
n_tint = length(style.tint);
n_marker = length(style.marker);

n_colour_cat = length(colour_catlist);
n_tint_cat = length(tint_catlist);
n_marker_cat = length(marker_catlist);

if n_colour_cat > n_colour
    disp('number of categories denoted by colour exceeds available colours');
    return;
end

if n_tint_cat > n_tint
    disp('number of categories denoted by tint exceeds available tints');
    return;
end

if n_marker_cat > n_marker
    disp('number of categories denoted by marker exceeds available markers');
    return;
end

if ~isequal(size(xdata),size(ydata),[n_colour_cat n_tint_cat n_marker_cat])
    disp('xdata size not same as ydata size');
    return;
end

figure(h); hold on
for i=1:n_colour_cat
    for j=1:n_tint_cat
        for k=1:n_marker_cat
            colour = hsv2rgb([style.colour{i} 240 style.tint{j}*120]);
            n_pts = length(xdata{i}{j}{k});

            hline=plot(xdata{i}{j}{k},ydata{i}{j}{k});
            
            if style.marker{k}.type == 'n'
                marker = style.marker{k}.shape;
                markersize = style.marker{k}.size;
                set(hline,'MarkerSize',markersize, ...
                    'MarkerFaceColor',colour, ...
                    'MarkerEdgeColor',colour);
            elseif style.marker{k}.type == 't'
                marker = '.';
                set(hline,'Marker',marker,'MarkerFaceColor','none', ...
                    'MarkerEdgeColor','none');
                textsize = stype.marker{k}.size;
                for q=1:n_pts
                    text(xdata{i}{j}{k}(q),ydata{i}{j}{k}(q),...
                         marker{k}.shape,'FontSize',textsize,...
                         'FontColor',colour,...
                         'HorizontalAlignment','center');
                end
            end
        end
    end
end
hold off

    