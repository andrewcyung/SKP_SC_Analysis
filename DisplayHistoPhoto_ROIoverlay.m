function DisplayHistoPhoto_ROIoverlay(h_fig,row,col,im2src_tfm,histoImage,options)

figure(h_fig);
imshow(histoImage,'parent',gca);%extra gca parameters prevent the image from moving to main monitor if it is dual monitor setup
ROIgrid_variable = load(options('ROIGrid_path'));
segmap_variable = load(options('segmask_path'));
section_indices = cell2mat(ROIgrid_variable.goodSection_index);
curr_section_index = find(section_indices==options('sectionindex'));
viewmode = options('viewmode');
curr_ROIgrid = ROIgrid_variable.ROIgrid{curr_section_index};
grid_index = intersect(find(ROIgrid_variable.ROIgrid_i==row),find(ROIgrid_variable.ROIgrid_j==col));
ROI_mask = false(size(curr_ROIgrid));
ROI_mask(find(curr_ROIgrid==grid_index)) = true;
outline = bwboundaries(ROI_mask);
n_boundaries = length(outline);
hold on
plot(outline{1}(:,2), outline{1}(:,1), 'Color', 'y', 'LineWidth', 2)

% Make the outline box invisible to hit tests so that it doesn't interfere
% with zoom clicks
h_rect = findobj(gca,'Type','rectangle');
set(h_rect,'HitTest','off');
hold off

viewmode = 'unzoomed';
set(imhandles(gca),'ButtonDownFcn',{@changeZoom})

    function changeZoom(src,event)
        click_type = get(h_fig,'SelectionType');
        if strcmp(click_type,'alt')
            if strcmp(viewmode,'zoomed')
                viewmode = 'unzoomed';
            elseif strcmp(viewmode,'unzoomed')
                viewmode = 'zoomed';
            end
            
            hold on
            if strcmp(viewmode,'zoomed')
                xmin = min(outline{1}(:,2));
                xmax = max(outline{1}(:,2));
                ymin = min(outline{1}(:,1));
                ymax = max(outline{1}(:,1));
                ylength = ymax-ymin;
                xlength = xmax-xmin;
                zoomlength = max(ylength,xlength);
                xctr = 0.5*(xmin+xmax);
                yctr = 0.5*(ymin+ymax);
                xlimits = [round(xctr-zoomlength/2) round(xctr+zoomlength/2)];
                ylimits = [round(yctr-zoomlength/2) round(yctr+zoomlength/2)];
            elseif strcmp(viewmode,'unzoomed')
                xlimits = [1 size(curr_ROIgrid,2)];
                ylimits = [1 size(curr_ROIgrid,1)];
            end
            xlim(xlimits);
            ylim(ylimits);
            hold off
        end
    end
end