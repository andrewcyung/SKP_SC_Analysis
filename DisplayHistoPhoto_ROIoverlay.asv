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
    for i=1:n_boundaries
        plot(outline{i}(:,2), outline{i}(:,1), 'Color', 'y', 'LineWidth', 2)
        if strcmp(viewmode,'zoomed')
            xmin = min(outline{i}(:,2));
            xmax = max(outline{i}(:,2));
            ymin = min(outline{i}(:,1));
            ymax = max(outline{i}(:,1));
            ylength = ymax-ymin;
            xlength = xmax-xmin;
            zoomlength = max(ylength,xlength);
            xctr = 0.5*(xmin+xmax);
            yctr = 0.5*(ymin+ymax);
            xlimits = [round(xctr-zoomlength/2) round(xctr+zoomlength/2)];
            ylimits = [round(yctr-zoomlength/2) round(yctr+zoomlength/2)];
        else
            xlimits = [1 size(curr_ROIgrid,2)];
            ylimits = [1 size(curr_ROIgrid,1)];
        end
        xlim(xlimits);
        ylim(ylimits);
    end
    hold off
    hManager = uigetmodemanager(hfig);
    set(hManager.WindowListenerHandles,'Enable','off');
    set(hfig,'KeyPressFcn',@change_overlay);

        function change_overlay(src,event)
        switch event.Character
            case {'z'}
                
               
%             case {','}
%                 if (ov_index==1)
%                     disp('reached 1st overlay');
%                 else
%                     ov_index=ov_index-1;
%                     ov = zeros(dim(1),dim(2),3);
%                     mask = imread([ovfilename{ov_index}]);
%                     curr_color = colors{ov_index};
%                     ov(:,:,1) = curr_color(1) & mask;
%                     ov(:,:,2) = curr_color(2) & mask;
%                     ov(:,:,3) = curr_color(3) & mask;
%                     set(hi2_overlay,'CData',ov);
%                     title(ovfilename{ov_index});
%                 end
%             case {'.'}
%                 if (ov_index==n_ov)
%                     disp('reached end overlay');
%                 else
%                     ov_index=ov_index+1;
%                     ov = zeros(dim(1),dim(2),3);
%                     mask = imread([ovfilename{ov_index}]);
%                     curr_color = colors{ov_index};
%                     ov(:,:,1) = curr_color(1) & mask;
%                     ov(:,:,2) = curr_color(2) & mask;
%                     ov(:,:,3) = curr_color(3) & mask;
%                     set(hi2_overlay,'CData',ov);
%                     title(ovfilename{ov_index});
%                 end
%             case {'/'}
%                 toggle = -1*toggle; setOverlay(toggle,hi2_overlay,0.5);
        end
    end
    
    
end