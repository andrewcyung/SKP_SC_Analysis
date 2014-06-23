

function h_plotseries = create_scatterplot_viewframe(viewframe_x,viewframe_y,parname_x,parname_y,disp_attributes,view_categories,requested_members,h_fig_scatter,h_fig_thumbnail_x,h_fig_thumbnail_y,h_fig_upstreamData_x,h_fig_upstreamData_y,aggregation,plotmode,axisextents,rootpath)
% produce a scatterplot using viewframe data (viewframe_x and viewframe_y)
% to differentiate up to three dimensions in the data.  Colour hue, shade
% and marker type will be used to represent the three dimensions (given in
% disp_attributes).  In other words, a specific combination of data dimensions
% will produce a lineseries with a particular hue, shade and marker type.
% The scatterplot also sets up and initializes figures which will show 
% images/data related to a specified data point on the scatterplot.

% The HSL colour model is used to differentiate the first two dimensions of the
% viewframe:  The first dimension is denoted by the "hue" (the "H" i.e.
% the "main perceived colour") and the second dimension denoted by the 
% "shade" (the "L" in HSL, i.e. how dark or light the main colour is.  We
% make the choice of setting the S-value (saturation) to 100%, and allow
% the L shade to vary between 0.2 to 0.8 (beyond this range, the resultant
% colour will look either too white or too black).  The third dimension in
% the viewframe will be denoted by the marker symbol.  These may be the
% standard MATLAB marker symbols, or an alphanumeric symbol (to be implemented).

% Inputs:
%   h_fig_scatter = handle of figure used to display scatterplot
%   viewframe_x, viewframe_y
% 
% Outputs:
%   h_plotseries = three-dimensional cell array (hue,shade,marker) which
%   contains the handles to the Lineseries object (each lineseries represents
%   a specific choice across the displayed dimensions, as displayed by a 
%   specified hue/shade/marker type combination).  Each Lineseries contains 
%   the following data:
%       - XData: concatenated vector of par_x data
%       - YData: concatenated vector of par_y data
%       - ZData: vector of the index of the subvector in the viewframe entry
%       - UserData: structure with the following fields:
%           - coord: spatial coordinate of the par_x and par_y data
%           - parname_x, parname_y
%           - thumbnailpath_x, thumbnailpath_y: file path to PointView image
%           - upstreamData_x, upstreamData_y:  a structure which provides
%           the necessary information to display the underlying raw data
%           that was used to calculate a queried data point (e.g. raw
%           histology image, T2 distribution, diffusion ellipsoid, etc.)

[n_hue,n_shade,n_marker] = size(viewframe_x);
h_plotseries = zeros(n_hue,n_shade,n_marker);

% Set up scatterplot figure and axes
figure(h_fig_scatter);
figtext = ['Hue = ' view_categories{1} ' Shade = ' view_categories{2} ...
           ' Marker = ' view_categories{3} ' | Query point: right-click'];
set(h_fig_scatter,'Name',figtext,'NumberTitle','off');
clf(h_fig_scatter);
hold on;
hx=xlabel(parname_x); hy=ylabel(parname_y);
set(hx,'Interpreter','none'); set(hy,'Interpreter','none');

% iterate through the viewframes on the x and y axes.  
for i_hue=1:n_hue
    for i_shade=1:n_shade
        for i_marker=1:n_marker
% xcontents and ycontents encapsulates a single entry in the 
% viewframe array.  Each entry corresponds to a specific choice
% of data dimension (as given by view_categories), and contains
% vectors of the data corresponding to the requested_members.
            xcontents = viewframe_x{i_hue}{i_shade}{i_marker};
            ycontents = viewframe_y{i_hue}{i_shade}{i_marker};
            vec_index = [];
            n_pts = 0;
          
            
            
% enforce consistency between viewframe_x and viewframe_y:
            % In other words,if a viewframe entry is empty then make the
            % corresponding entry in the other viewframe empty as well, and
            % set the current LineSeries handle to zero
            if isempty(xcontents) || isempty(ycontents)
                if ~isempty(xcontents)
                    xcontents = [];
                elseif ~isempty(ycontents)
                    ycontents = [];
                end
                h_plotseries(i_hue,i_shade,i_marker) = 0;
                continue;
            else
            % Or if the requested members in lineseries of xcontents is not
            % the same as in ycontents, then only keep the common ones;
                n_x = length(xcontents); n_y = length(ycontents);
                if n_x ~= n_y
                    disp(['different set of requested members in ' parname_x ' and ' parname_y]);
                    x_id = cellfun(@(element)element.id,xcontents);
                    y_id = cellfun(@(element)element.id,ycontents);
                    [~,index_x,index_y] = intersect(x_id,y_id);
                    if isempty(index_x)
                        disp(['no common requested members']);
                        h_plotseries(i_hue,i_shade,i_marker) = 0;
                        continue;
                    else
                        viewframe_x{i_hue}{i_shade}{i_marker} = xcontents(index_x);
                        viewframe_y{i_hue}{i_shade}{i_marker} = ycontents(index_y);
                    end
                end
            end

            % Or if the vectors in each lineseries are not the same length,
            % abort the routine.
            n_vec = length(xcontents);
            x_length = cellfun(@(parvec)length(parvec.data),xcontents);
            y_length = cellfun(@(parvec)length(parvec.data),xcontents);
            if ~isequal(x_length,y_length)
                disp('number of x vectors inconsistent with number of y values');
                h_plotseries(i_hue,i_shade,i_marker) = 0;
                continue;
            end
            
% Plot the data and store related information in the generated LineSeries.
% Each enty of the viewframe (xcontents and ycontents) may have more than
% one data vector (e.g. one vector for each MRI slice). We concatenate all
% the data in the viewframe entry (dataseries_x and dataseries_y) and store
% it in the h_plotseries Xdata and Ydata properties.  The index of the data
% vector within the viewframe is stored for each data point in the Zdata
% property.

            %Concatenate the data in the viewframe entry
            series_length = sum(x_length);
            dataseries_x = zeros(series_length,1);
            dataseries_y = zeros(series_length,1);
            coordseries = cell(series_length,1);
            startindex = 1;
            for i_vec=1:n_vec
                endindex = startindex+length(xcontents{i_vec}.data)-1;
                dataseries_x(startindex:endindex) = xcontents{i_vec}.data;
                dataseries_y(startindex:endindex) = ycontents{i_vec}.data;
                coordseries(startindex:endindex) = xcontents{i_vec}.coord;
                vec_index(startindex:endindex) = i_vec;
                startindex = endindex+1;
            end
            
            % Set the axis and marker colour and type (according to the
            % disp_attributes
            if ~isempty(axisextents)
                axis(axisextents)
            end
            marker = disp_attributes.marker(i_marker);
            markercolour = hsl2rgb([disp_attributes.hue(i_hue) 1 disp_attributes.shade(i_shade)]);

            % Plot the individual data points and store the vector index
            % into Zdata
            if strcmp(aggregation,'points')
                n_pts = n_pts + length(xcontents{i_vec}.data);
                if n_pts>0
                    h_plotseries(i_hue,i_shade,i_marker) = plot(dataseries_x,dataseries_y,marker,'Color',markercolour);
                    set(h_plotseries(i_hue,i_shade,i_marker),'ZData',vec_index);
                    if length(dataseries_x) ~= length(vec_index)
                       disp('unequal length between series_index and dataseries_x'); 
                    end
                    % for debug purposes, an interactive plot mode can be 
                    % turned on for iterative construction of the plot,
                    % one viewframe entry at a time
                    if strcmp(plotmode,'interactive')
                        hold off
                        hx=xlabel(parname_x); hy=ylabel(parname_y);
                        set(hx,'Interpreter','none'); set(hy,'Interpreter','none'); %avoid underscore character interpret as subscript
                        title([requested_members.(dimension_order{1}){i_hue} ' ' ...
                            requested_members.(dimension_order{2}){i_shade} ' ' ...
                            requested_members.(dimension_order{3}){i_marker} ' rho=' num2str(rho) ' pval=' num2str(pval)]);
                        pause;
                    end
                end
                % In the UserData property of the current LineSeries, store
                % the coordinates and information necessary for graphical
                % query of the data points
                info.coord = coordseries;
                for i_vec=1:n_vec
                    info.parname_x = parname_x;
                    info.parname_y = parname_y;
                    info.thumbnailpath_x{i_vec} = xcontents{i_vec}.thumbnail_path;
                    info.thumbnailpath_y{i_vec} = ycontents{i_vec}.thumbnail_path;
                    info.tfm_x{i_vec} = xcontents{i_vec}.tfm_parx2srcim;
                    info.tfm_y{i_vec} = ycontents{i_vec}.tfm_parx2srcim;
                    info.upstreamData_x{i_vec} = xcontents{i_vec}.upstreamDataStruct;
                    info.upstreamData_y{i_vec} = ycontents{i_vec}.upstreamDataStruct;
                end
                set(h_plotseries(i_hue,i_shade,i_marker),'UserData',info);
         
            % Or alternatively to point by point plotting, the mean or
            % median of each viewframe entry can be plotted.  In this case,
            % there are no hooks for graphical query of the parameter maps
            % or underlying raw data
            elseif strcmp(aggregation,'mean')
                x_data = mean(dataseries_x);
                y_data = mean(dataseries_y);
                n_pts = n_pts + 1;
                h_plotseries(i_hue,i_shade,i_marker) = plot(x_data,y_data,marker,'Color',markercolour);
                set(h_plotseries(i_hue,i_shade,i_marker),'LineWidth',1.5,'MarkerSize',9);
            elseif strcmp(aggregation,'median')
                x_data = median(dataseries_x);
                y_data = median(dataseries_y);
                n_pts = n_pts + 1;
                h_plotseries(i_hue,i_shade,i_marker) = plot(x_data,y_data,marker,'Color',markercolour);
                set(h_plotseries(i_hue,i_shade,i_marker),'LineWidth',1.5,'MarkerSize',9);
            end

        end
    end
end


% If a point-by-point scatterplot was selected, set up the figure windows
% and related GUI trigger fuctions that will display the graphical
% parameter maps (thumbnail_x and thumbnail_y) and the "upstream" data that
% correspond to a queried data. point
if strcmp(aggregation,'points')
    figure(h_fig_scatter);
    hold off
    h_ax = gca;
    % displayRelatedImages.m sets up a right-click to highlight a data
    % point on the scatterplot which will also update the parmap
    % (thumbnail) views and "upstream" views
    set(h_ax,'ButtonDownFcn',{@displayRelatedImages,parname_x,parname_y,h_fig_thumbnail_x,h_fig_thumbnail_y,h_fig_upstreamData_x,h_fig_upstreamData_y,rootpath})
    
    % HACK:  set the HitTest property to off for the current lineseries, so
    % that clicking on the point will activate the ButtownDownFcn of the
    % axis (which is the object directly "beneath" the point
    h_children = get(h_ax,'Children');
    n_axis_children = length(h_children);
    for i_child=1:n_axis_children
        set(h_children(i_child),'HitTest','off');
    end
    
    % updateHighlightBoxes.m sets up the mouse click to update the location
    % of the pixel selection box and call for an update of the upstream
    % data views
    figure(h_fig_thumbnail_x);
    set(h_fig_thumbnail_x,'Name',parname_x,'NumberTitle','off');
    set(gca,'ButtonDownFcn',{@updateHighlightBoxes,h_fig_thumbnail_y,h_ax,h_fig_upstreamData_x,h_fig_upstreamData_y})
    figure(h_fig_thumbnail_y);
    set(h_fig_thumbnail_y,'Name',parname_y,'NumberTitle','off');
    set(gca,'ButtonDownFcn',{@updateHighlightBoxes,h_fig_thumbnail_x,h_ax,h_fig_upstreamData_x,h_fig_upstreamData_y})

    % 
    figure(h_fig_upstreamData_x);
    set(h_fig_upstreamData_x,'Name',[parname_x ' upstreamData'],'NumberTitle','off');
    figure(h_fig_upstreamData_y);
    set(h_fig_upstreamData_y,'Name',[parname_y ' upstreamData'],'NumberTitle','off');
end

end