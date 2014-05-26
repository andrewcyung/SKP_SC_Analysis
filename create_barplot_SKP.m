function [h_plotseries_x,h_plotseries_y] = create_barplot_SKP(viewframe_x,viewframe_y,parname_x,parname_y,disp_attributes,h_fig,requested_members,dimension_order)

figure(h_fig);
clf(h_fig);
hold on;

[n_hue,n_shade,n_barcat] = size(viewframe_x);

h_plotseries_x = zeros(n_hue*n_shade,n_barcat);
h_plotseries_y = zeros(n_hue*n_shade,n_barcat);
means_x = zeros(n_hue*n_shade,n_barcat);
stdevs_x = zeros(n_hue*n_shade,n_barcat);
means_y = zeros(n_hue*n_shade,n_barcat);
stdevs_y = zeros(n_hue*n_shade,n_barcat);

for i_hue=1:n_hue
    for i_shade=1:n_shade
        for i_barcat=1:n_barcat
            %           check consistency between viewframe_x and viewframe_y.  In other words,
            %           check that all non-empty elements in viewframe_x are also non-empty
            %           elements in viewframe_y.
            xcontents = viewframe_x{i_hue}{i_shade}{i_barcat};
            ycontents = viewframe_y{i_hue}{i_shade}{i_barcat};
            n_pts = 0;
            
            if isempty(xcontents) || isempty(ycontents)
                if ~isempty(xcontents)
                    xcontents = [];
                elseif ~isempty(ycontents)
                    ycontents = [];
                end
                h_plotseries_x((i_hue-1)*n_shade+i_shade) = 0;
                h_plotseries_y((i_hue-1)*n_shade+i_shade) = 0;
                
                continue;
            else
                n_x = length(xcontents); n_y = length(ycontents);
                if n_x ~= n_y
                    x_id = cellfun(@(element)element.id,xcontents);
                    y_id = cellfun(@(element)element.id,ycontents);
                    [common_id,index_x,index_y] = intersect(x_id,y_id);
                    viewframe_x{i_hue}{i_shade}{i_barcat} = xcontents(index_x);
                    viewframe_y{i_hue}{i_shade}{i_barcat} = ycontents(index_y);
                end
            end
            
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
            
            n_pts = n_pts + length(xcontents{i_vec}.data);
            if n_pts>0
                means_x((i_hue-1)*n_shade+i_shade,i_barcat) = mean(dataseries_x);
                stdevs_x((i_hue-1)*n_shade+i_shade,i_barcat) = std(dataseries_x);
                means_y((i_hue-1)*n_shade+i_shade,i_barcat) = mean(dataseries_y);
                stdevs_y((i_hue-1)*n_shade+i_shade,i_barcat) = std(dataseries_y);
            else
                means_x((i_hue-1)*n_shade+i_shade,i_barcat) = 0;
                stdevs_x((i_hue-1)*n_shade+i_shade,i_barcat) = 0;
                means_y((i_hue-1)*n_shade+i_shade,i_barcat) = 0;
                stdevs_y((i_hue-1)*n_shade+i_shade,i_barcat) = 0;
            end
        end
    end
end

figure(h_fig);
subplot(1,2,1);
h_plotseries_x = bar(means_x');
set(gca,'XTickLabel',requested_members.(dimension_order{3}));
hx=ylabel(parname_x);
set(hx,'Interpreter','none');

subplot(1,2,2);
h_plotseries_y = bar(means_y');
set(gca,'XTickLabel',requested_members.(dimension_order{3}));
hy=ylabel(parname_y);
set(hy,'Interpreter','none');

bar_dim = size(h_plotseries_x);
for i_hue=1:n_hue
    for i_shade=1:n_shade
        barcolour = hsl2rgb([disp_attributes.hue(i_hue) 1 disp_attributes.shade(i_shade)]);
        set(h_plotseries_x((i_hue-1)*n_shade+i_shade),'EdgeColor',barcolour,'FaceColor',barcolour);
        set(h_plotseries_y((i_hue-1)*n_shade+i_shade),'EdgeColor',barcolour,'FaceColor',barcolour);
    end
end



end