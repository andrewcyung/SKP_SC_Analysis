

function [h_plotseries,corrcoeff,corrcoeff_all] = create_scatterplot_viewframe(viewframe_x,viewframe_y,parname_x,parname_y,disp_attributes,view_categories,h_fig_scatter,h_fig_thumbnail_x,h_fig_thumbnail_y,h_fig_upstreamData_x,h_fig_upstreamData_y,requested_members,dimension_order,aggregation,corrmode,plotmode,axisextents)
% produce a scatterplot using viewframe data (viewframe_x and viewframe_y)
% according to the hue, shade and marker selections given in disp_attributes.
% h_fig denotes the handle of the figure to output the scatterplot.

% The HSL colour model is used to differentiate two dimensions of the
% viewframe:  The first dimension is denoted by the "hue" (the "H" i.e.
% the "main perceived colour") and the second dimension denoted by the 
% "shade" (the "L" in HSL, i.e. how dark or light the main shade is.  We
% make the choice of setting the S-value (saturation) to 100%, and allow
% the L shade to vary between 0.2 to 0.8 (beyond this range, the resultant
% colour will look either too white or too black).  The third dimension in
% the viewframe will be denoted by the marker symbol.  These may be the
% standard MATLAB marker symbols, or an alphanumeric symbol.

% If the number of elements in the viewframe dimension exceed the number of
% values in the corresponding display attribute list, the function will
% abort.

figure(h_fig_scatter);
figtext = ['Hue = ' view_categories{1} ' Shade = ' view_categories{2} ...
           ' Marker = ' view_categories{3}];
set(h_fig_scatter,'Name',figtext,'NumberTitle','off');
clf(h_fig_scatter);
hold on;

[n_hue,n_shade,n_marker] = size(viewframe_x);
h_plotseries = zeros(n_hue,n_shade,n_marker);
corrcoeff =cell(n_hue,n_shade,n_marker);
hx=xlabel(parname_x); hy=ylabel(parname_y);
set(hx,'Interpreter','none'); set(hy,'Interpreter','none');
for i_hue=1:n_hue
    for i_shade=1:n_shade
        for i_marker=1:n_marker
%           check consistency between viewframe_x and viewframe_y.  In other words,
%           check that all non-empty elements in viewframe_x are also non-empty
%           elements in viewframe_y. 
            xcontents = viewframe_x{i_hue}{i_shade}{i_marker};
            ycontents = viewframe_y{i_hue}{i_shade}{i_marker};
            vec_index = [];
            n_pts = 0;
            
            if isempty(xcontents) || isempty(ycontents)
                if ~isempty(xcontents)
                    xcontents = [];
                elseif ~isempty(ycontents)
                    ycontents = [];
                end
                h_plotseries(i_hue,i_shade,i_marker) = 0;
                continue;
            else
                n_x = length(xcontents); n_y = length(ycontents);
                if n_x ~= n_y
                    disp('danger');
                    x_id = cellfun(@(element)element.id,xcontents);
                    y_id = cellfun(@(element)element.id,ycontents);
                    [~,index_x,index_y] = intersect(x_id,y_id);
                    viewframe_x{i_hue}{i_shade}{i_marker} = xcontents(index_x);
                    viewframe_y{i_hue}{i_shade}{i_marker} = ycontents(index_y);
                end
            end
            
            marker = disp_attributes.marker(i_marker);
            markercolour = hsl2rgb([disp_attributes.hue(i_hue) 1 disp_attributes.shade(i_shade)]);
            n_vec = length(xcontents);
            x_length = cellfun(@(parvec)length(parvec.data),xcontents);
            y_length = cellfun(@(parvec)length(parvec.data),xcontents);
            if ~isequal(x_length,y_length)
                disp('number of x values inconsistent with y values');
                return;
            end
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
            
            if ~isempty(axisextents)
                axis(axisextents)
            end
            
            if strcmp(aggregation,'points')
                n_pts = n_pts + length(xcontents{i_vec}.data);
                if n_pts>0
                    if ~strcmp(corrmode,'off')
                        [rho,pval] = corr(dataseries_x,dataseries_y,'rows','complete','type',corrmode);
                        corrcoeff{i_hue,i_shade,i_marker}.rho = rho;
                        corrcoeff{i_hue,i_shade,i_marker}.pval = pval;
                    end
                    h_plotseries(i_hue,i_shade,i_marker) = plot(dataseries_x,dataseries_y,marker,'Color',markercolour);
                    set(h_plotseries(i_hue,i_shade,i_marker),'ZData',vec_index);
                    if length(dataseries_x) ~= length(vec_index)
                       disp('unequal length between series_index and dataseries_x'); 
                    end
                    if strcmp(plotmode,'interactive')
                        hold off
                        hx=xlabel(parname_x); hy=ylabel(parname_y);
                        set(hx,'Interpreter','none'); set(hy,'Interpreter','none');
                        title([requested_members.(dimension_order{1}){i_hue} ' ' ...
                            requested_members.(dimension_order{2}){i_shade} ' ' ...
                            requested_members.(dimension_order{3}){i_marker} ' rho=' num2str(rho) ' pval=' num2str(pval)]);
                        pause;
                        
                    end
                end
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
            
            info.coord = coordseries;
            for i_vec=1:n_vec
                info.thumbnailpath_x{i_vec} = xcontents{i_vec}.thumbnail_path;
                info.thumbnailpath_y{i_vec} = ycontents{i_vec}.thumbnail_path;
                info.tfm_x{i_vec} = xcontents{i_vec}.tfm_parx2srcim;
                info.tfm_y{i_vec} = ycontents{i_vec}.tfm_parx2srcim;
                info.upstreamData_x{i_vec} = xcontents{i_vec}.upstreamDataStruct; 
                info.upstreamData_y{i_vec} = ycontents{i_vec}.upstreamDataStruct; 
            end
            
            set(h_plotseries(i_hue,i_shade,i_marker),'UserData',info);
        end
    end
end

all_data_x = zeros(n_pts,1);
all_data_y = zeros(n_pts,1);
startindex = 1;
for i_hue=1:n_hue
    for i_shade=1:n_shade
        for i_marker=1:n_marker
            if h_plotseries(i_hue,i_shade,i_marker)==0
                continue;
            end
            curr_x_data = get(h_plotseries(i_hue,i_shade,i_marker),'XData');
            curr_y_data = get(h_plotseries(i_hue,i_shade,i_marker),'YData');
            endindex = startindex+length(curr_x_data)-1;
            all_data_x(startindex:endindex) = curr_x_data;
            all_data_y(startindex:endindex) = curr_y_data;
            startindex = endindex+1;
        end
    end
end

vec_size = size(all_data_x);
if vec_size(1) == 1
    all_data_x = all_data_x';
    all_data_y = all_data_y';
end

if ~isempty(all_data_x) || ~isempty(all_data_y)
    
    [rho,pval] = corr(all_data_x,all_data_y,'rows','complete','type',corrmode);
    
    corrcoeff_all.rho = rho;
    corrcoeff_all.pval = pval;
%     title([dimension_order{1} ' ' dimension_order{2} ' ' dimension_order{3} ' rho=' num2str(rho) ' p=' num2str(pval)]);
else
    corrcoeff_all.rho = 0;
    corrcoeff_all.pval = 1;
    disp('warning: no data has been loaded.  Did you choose a subject that is not in the chosen group?  Do the requested members exist in your storage frame?')

end

figure(h_fig_scatter);
hold off
h_ax = gca;
set(h_ax,'ButtonDownFcn',{@displayRelatedImages,parname_x,parname_y,h_fig_thumbnail_x,h_fig_thumbnail_y,h_fig_upstreamData_x,h_fig_upstreamData_y})

% set the HitTest property to off for the current lineseries,
% so that clicking on the point will activate the
% ButtownDownFcn of the axis (which is the object directly
% "beneath" the point
h_children = get(h_ax,'Children');
n_axis_children = length(h_children);
for i_child=1:n_axis_children
    set(h_children(i_child),'HitTest','off');
end

figure(h_fig_thumbnail_x);
set(h_fig_thumbnail_x,'Name',parname_x,'NumberTitle','off');
set(gca,'ButtonDownFcn',{@updateHighlightBoxes,h_fig_thumbnail_y,h_ax,h_fig_upstreamData_x,h_fig_upstreamData_y})

figure(h_fig_thumbnail_y);
set(h_fig_thumbnail_y,'Name',parname_y,'NumberTitle','off');
set(gca,'ButtonDownFcn',{@updateHighlightBoxes,h_fig_thumbnail_x,h_ax,h_fig_upstreamData_x,h_fig_upstreamData_y})

figure(h_fig_upstreamData_x);
set(h_fig_upstreamData_x,'NumberTitle','off');
figure(h_fig_upstreamData_y);
set(h_fig_upstreamData_y,'Name',[parname_y ' upstreamData'],'NumberTitle','off');



end