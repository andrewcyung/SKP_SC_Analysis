function CreateViewframeLegend(h_series,h_legend,requested_members,dimension_order,mode,location,fontsize,R)
if h_series == 0
   figure(h_legend);
   clf;
   legend('no data defined');
   return;
end

[n_hue,n_shade,n_marker] = size(h_series);
h_series_vec = [];
txt_vec = {};
counter = 1;
for i_hue=1:n_hue
    for i_shade=1:n_shade
        for i_marker=1:n_marker
            if h_series(i_hue,i_shade,i_marker) ~= 0
                if strcmp(dimension_order{1},'')
                    txt1 = '';
                else
                    txt1 = requested_members.(dimension_order{1}){i_hue};
                end
                if strcmp(dimension_order{2},'')
                    txt2 = '';
                else
                    txt2 = requested_members.(dimension_order{2}){i_shade};
                end
                if strcmp(dimension_order{3},'')
                    txt3 = '';
                else
                    txt3 = requested_members.(dimension_order{3}){i_marker};
                end

                txt_vec{counter} = [txt1 ' ' txt2 ' ' txt3 ' R=' num2str(R{i_hue,i_shade,i_marker})];
                counter = counter + 1;
                h_series_vec = [h_series_vec h_series(i_hue,i_shade,i_marker)];
            end
        end
    end
end
h = legend(h_series_vec,txt_vec,'Location',location,'FontSize',fontsize);
set(h,'units','pixels');
legend_position = get(h,'position');
legend_width = legend_position(3);
legend_height = legend_position(4);

if strcmp(mode,'separateFigure');
     hf=figure(h_legend);
    h_new = copyobj(h,hf);
    set(gca,'units','pixels');
    set(gca,'position',[0 0 legend_width legend_height]);
    tightfig;
    set(gcf,'MenuBar','None');
    %     set(gca,'units','normalized');
%     set(gca,'Position',[0 0 1 1]);

    seriesinfo = get(h_series,'UserData');
    figtext = [seriesinfo.parname_x ' vs. ' seriesinfo.parname_y];
    set(h_legend,'Name',figtext,'NumberTitle','off');
    

    h_scatterplot_fig = ancestor(h_series(1,1,1),'figure');
    figure(h_scatterplot_fig);
    legend off;

end