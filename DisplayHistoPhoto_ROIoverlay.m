function DisplayHistoPhoto_ROIoverlay(h_fig,row,col,im2src_tfm,histoImage,options,rootpath)

figure(h_fig);
imshow(histoImage,'parent',gca);%extra gca parameters prevent the image from moving to main monitor if it is dual monitor setup
title('toggle mask: middle-click | zoom: right-click | previous view: "," | next view: "."');
ROIgrid_variable = load([rootpath options('ROIGrid_path')]);
segmap_variable = load([rootpath options('segmask_path')]);%loads segmap_with_exclmask
section_indices = cell2mat(ROIgrid_variable.goodSection_index);
curr_section_index = find(section_indices==cell2mat(options('sectionindex')));
viewmode = options('viewmode');
curr_ROIgrid = ROIgrid_variable.ROIgrid{curr_section_index};
curr_segmask =segmap_variable.segmap_with_exclmask{curr_section_index};
dim_segmask = size(curr_segmask);
rgb_segmask = zeros(dim_segmask(1),dim_segmask(2),3);
rgb_segmask(:,:,1) = curr_segmask;


grid_index = intersect(find(ROIgrid_variable.ROIgrid_i==row),find(ROIgrid_variable.ROIgrid_j==col));
if isempty(grid_index)
    disp('point is outside ROI grid');
    return;
end

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

hold on
h_overlay = imshow(rgb_segmask);
set(h_overlay,'AlphaData',0.5);
hold off

viewmode = 'unzoomed';
showSegmask = false;

set(imhandles(gca),'ButtonDownFcn',{@dispatchClicks_upstreamFigure})

    function dispatchClicks_upstreamFigure(src,event)
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
        elseif strcmp(click_type,'extend')
            showSegmask = ~showSegmask;
            if showSegmask
                set(h_overlay,'AlphaData',0);
            else
                set(h_overlay,'AlphaData',0.5);
            end
        end
    end
end