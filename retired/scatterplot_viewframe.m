

function [h_plotseries,corrcoeff,corrcoeff_all] = create_scatterplot_viewframe(viewframe_x,viewframe_y,parname_x,parname_y,disp_attributes,h_fig,requested_members,dimension_order,aggregation,corrmode,plotmode)
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

figure(h_fig);
clf(h_fig);
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
            n_pts = 0;
            
            if isempty(xcontents) || isempty(ycontents)
                if ~isempty(xcontents)
                    xcontents = [];
                elseif ~isempty(ycontents)
                    ycontents = [];
                end
                continue;
            else
                n_x = length(xcontents); n_y = length(ycontents);
                if n_x ~= n_y
                    x_id = cellfun(@(element)element.id,xcontents);
                    y_id = cellfun(@(element)element.id,ycontents);
                    [common_id,index_x,index_y] = intersect(x_id,y_id);
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
                startindex = endindex+1;
            end
            
            if strcmp(aggregation,'points')
                n_pts = n_pts + length(xcontents{i_vec}.data);
                if ~strcmp(corrmode,'off')
                    [rho pval] = corr(dataseries_x,dataseries_y,'rows','complete','type',corrmode);
                    corrcoeff{i_hue,i_shade,i_marker}.rho = rho;
                    corrcoeff{i_hue,i_shade,i_marker}.pval = pval;
                end
                h_plotseries(i_hue,i_shade,i_marker) = plot(dataseries_x,dataseries_y,marker,'Color',markercolour);
                if strcmp(plotmode,'interactive')
                    hold off
                    hx=xlabel(parname_x); hy=ylabel(parname_y);
                    set(hx,'Interpreter','none'); set(hy,'Interpreter','none');
                    title([requested_members.(dimension_order{1}){i_hue} ' ' ...
                        requested_members.(dimension_order{2}){i_shade} ' ' ...
                        requested_members.(dimension_order{3}){i_marker} ' rho=' num2str(rho) ' pval=' num2str(pval)]);
                    pause;
                end
            elseif strcmp(aggregation,'mean')
                x_data = mean(dataseries_x);
                y_data = mean(dataseries_y);
                n_pts = n_pts + 1;
                h_plotseries(i_hue,i_shade,i_marker) = plot(x_data,y_data,marker,'Color',markercolour);
            elseif strcmp(aggregation,'median')
                x_data = median(dataseries_x);
                y_data = median(dataseries_y);
                n_pts = n_pts + 1;
                h_plotseries(i_hue,i_shade,i_marker) = plot(x_data,y_data,marker,'Color',markercolour);
            end
            
            info.coord = coordseries;
            if x_length == 1
                info.srcimpath_x = xcontents.srcimpath;
                info.srcimpath_y = ycontents.srcimpath;
                info.tfm_x = xcontents.tfm_parx2srcim;
                info.tfm_y = ycontents.tfm_parx2srcim;
            else
                info.srcimpath_x = cellfun(@(elem)elem.srcimpath,xcontents,'UniformOutput',false);
                info.srcimpath_y = cellfun(@(elem)elem.srcimpath,ycontents,'UniformOutput',false);
                info.tfm_x = cellfun(@(elem)elem.tfm_parx2srcim,xcontents,'UniformOutput',false);
                info.tfm_y = cellfun(@(elem)elem.tfm_parx2srcim,ycontents,'UniformOutput',false);
            end
            
            set(h_plotseries(i_hue,i_shade,i_marker),'UserData',info);
        end
    end
end

all_data_x = zeros(n_pts);
all_data_y = zeros(n_pts);
startindex = 1;
for i_hue=1:n_hue
    for i_shade=1:n_shade
        for i_marker=1:n_marker
            curr_x_data = get(h_plotseries(i_hue,i_shade,i_marker),'XData');
            curr_y_data = get(h_plotseries(i_hue,i_shade,i_marker),'YData');
            endindex = startindex+length(curr_x_data)-1;
            all_data_x(startindex:endindex) = curr_x_data;
            all_data_y(startindex:endindex) = curr_y_data;
            startindex = endindex+1;
        end
    end
end
[rho pval] = corr(all_data_x',all_data_y','rows','complete','type',corrmode);
corrcoeff_all.rho = rho;
corrcoeff_all.pval = pval;
title([dimension_order{1} ' ' dimension_order{2} ' ' dimension_order{3} ' rho=' num2str(rho) ' p=' num2str(pval)]);  

figure(h_fig);
hold off

end