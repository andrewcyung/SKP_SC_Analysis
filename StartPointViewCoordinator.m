function StartPointViewCoordinator(storageframe, storage_layout, view_categories, requested_members, disp_attributes, h_scatter_list, h_scatterlegend_list, scatter_parxname_list,h_parMapView_list,parMapView_name_list,h_upstreamView_list,rootpath)

% StartPointViewCoordinator creates figures which visualize the parameter
% maps in storageframe, and sets up the callback functions that updates the
% windows in response to user interaction.  We assume that all parameter
% maps are defined in the same physical grid (i.e. a pixel(i,j) in Parmap1
% is in the same location as pixel(i,j) in Parmap2).
% 
% The following views of the data are supported: 
% 1. Scatterplots of two parameter maps 
% 2. 2D image of a parameter map
% 3. upstream views which are connected a parameter map (could be a
% collection of images, graphs, etc.).   These views are "attached" when
% the parameter maps are created, prior to being put into the storageframe
% 
% Several visual cursors need to be coordinated across all the various
% views.  The scatterplot shows a black box around the currently selected
% (parX,parY) data point, and a green box shows the currently selected
% pixel in the parameter map.  The upstream data may also have cursors to
% update (e.g. box in raw histology image).  The user should be able to
% update his point of interest on either the scatterplot or the parameter
% map, and have the cursors update across all views.
% 
% figure handles must be specified so we know where to put the
% plots/images.  The choice of scatterplots and parameter maps are given in
% cell arrays of parameter names, as referenced by the storage frame.

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create the scatterplots
n_scatterplots = length(h_scatter_list);
h_series = cell(1,n_scatterplots);
for i=1:n_scatterplots
    axisextents = [];
    plotmode = 'auto';
    aggregation = 'points';
    parname_x = scatter_parxname_list{i}{1};
    parname_y = scatter_parxname_list{i}{2};
    vf_x = MakeViewframe(parname_x,view_categories,storageframe,storage_layout,requested_members);
    vf_y = MakeViewframe(parname_y,view_categories,storageframe,storage_layout,requested_members);
    
    h_series{i} = CreateViewframeScatterplot2(vf_x,vf_y,parname_x,parname_y,disp_attributes,view_categories,requested_members,h_scatter_list{i},aggregation,plotmode,axisextents,rootpath)
    ti = get(gca,'TightInset');
    set(gca,'Tag','scatterplot');
    set(gca,'Position',[ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);
    % ScatterplotClickCallback.m sets up a right-click to highlight a data
    % point on the scatterplot and a call to UpdateViews to make the other
    % views consistent with the chosen value.
    set(gca,'ButtonDownFcn',{@ScatterplotClickCallback,h_scatter_list,h_parMapView_list,h_upstreamView_list,rootpath})
    % HACK:  set the HitTest property to off for the current lineseries, so
    % that clicking on the point will activate the ButtownDownFcn of the
    % axis (which is the object directly "beneath" the point)
    h_children = get(gca,'Children');
    n_axis_children = length(h_children);
    for i_child=1:n_axis_children
        set(h_children(i_child),'HitTest','off');
    end    
    
    % test for existence of highlight box on first scatterplot.  If none,
    % we assume that all scatterplot highlight cursors need to be
    % initialized.  Initial highlight point is at the (par_x,par_y) value
    % in the middle of the first scatterplot.
    if i==1
        h_ScatterplotHighlightBox = findobj(gca,'Type','rectangle','Tag','cursor');
        if isempty(h_ScatterplotHighlightBox)
            initializationNeeded = true;
            clicked_point = [mean(xlim) mean(ylim) 1; mean(xlim) mean(ylim) 1];
        else
            initializationNeeded = false;
            clicked_point = get(gca,'CurrentPoint');
        end
        [chosen_x,chosen_y,chosen_lineseries,chosen_parvec,chosen_ptindex,vf_index, current_point] = getNearestDataPoint(clicked_point,gca,h_series{i});

    end
    
    if initializationNeeded
        h_ScatterplotHighlightBox = NaN;
    end

    series_info = get(h_series{i}(chosen_lineseries),'UserData');
    parX_data = get(h_series{i}(chosen_lineseries),'XData');
    parY_data = get(h_series{i}(chosen_lineseries),'YData');
    chosen_x = parX_data(chosen_ptindex);
    chosen_y = parY_data(chosen_ptindex);
    HighlightScatterplotPoint(gcf,h_ScatterplotHighlightBox,chosen_x,chosen_y);
    
    % create related legend window with correlation coefficient information     
    [R,R_upperCI,R_lowerCI,pval] = CalcCorrcoeffViewframe(vf_x,vf_y,'Pearson');
    fontsize = 8;
    CreateViewframeLegend(h_series{i},h_scatterlegend_list{i},requested_members,view_categories,'','SouthEast',fontsize,R);
end

% display the chosen parameter maps.  The work boils down to constructing
% the right pathname for the thumbnail image that was created to display
% the parameter map.  
n_parmaps = length(h_parMapView_list);
for i=1:n_parmaps
    hfig_parMap = h_parMapView_list{i};
    figure(hfig_parMap);
    parname = parMapView_name_list{i};
    vf = MakeViewframe(parname,view_categories,storageframe,storage_layout,requested_members);
    if length(vf_index)==3
        chosen_series = vf{vf_index(1)}{vf_index(2)}{vf_index(3)};
    elseif length(vf_index)==2
        chosen_series = vf{vf_index(1)}{vf_index(2)};
    elseif length(vf_index)==1
        chosen_series = vf{vf_index(1)};
    end
    
    impath = [rootpath chosen_series{chosen_parvec}.thumbnail_path];
    
    if exist(impath,'file')
        im = imread(impath);
        imagesc(im); colormap gray;
        axis equal; axis off;
    else
        disp([impath ' does not exist']);
    end

    set(gcf,'Name',parname,'NumberTitle','off');

    h_ParmapHighlightBox = findobj(gca,'Type','rectangle','Tag','cursor');
    if isempty(h_ParmapHighlightBox)
        h_ParmapHighlightBox = NaN;
    end
    highlight_imPosition(gcf,h_ParmapHighlightBox,current_point{1}.row,current_point{1}.col);

    h_im = findobj(gca,'Type','image');
    set(h_im,'ButtonDownFcn',{@ParMapViewClickCallback,h_scatter_list,h_parMapView_list,h_upstreamView_list,rootpath,vf_index});
    
    
    userdata.vf = vf;
    userdata.vf_index = vf_index;
    if ~isempty(h_upstreamView_list{i})
        upstreamData = chosen_series{chosen_parvec}.upstreamDataStruct;
        displayUpstreamData(upstreamData,current_point{1}.row,current_point{1}.col,h_upstreamView_list{i},'',rootpath)
        userdata.upstreamData = upstreamData;
    else
        userdata.upstreamData = [];
    end
    set(hfig_parMap,'UserData',userdata);
    
    
end

end