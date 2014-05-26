function h=legend_viewframe(h_series,requested_members,dimension_order,mode,location,fontsize)

[n_hue,n_shade,n_marker] = size(h_series);
h_series_vec = [];
txt_vec = {};
counter = 1;
for i_hue=1:n_hue
    for i_shade=1:n_shade
        for i_marker=1:n_marker
            if h_series(i_hue,i_shade,i_marker) ~= 0
                txt = [requested_members.(dimension_order{1}){i_hue} ' ' ...
                       requested_members.(dimension_order{2}){i_shade} ' ' ...
                       requested_members.(dimension_order{3}){i_marker}];
                txt_vec{counter} = txt;
                counter = counter + 1;
                h_series_vec = [h_series_vec h_series(i_hue,i_shade,i_marker)];
            end
        end
    end
end
h = legend(h_series_vec,txt_vec,'Location',location,'FontSize',fontsize);
if strcmp(mode,'separateFigure');
    hf=figure(4);
    h_new = copyobj(h,hf);
    set(gca,'units','normalized');
    set(gca,'Position',[0 0 1 1]);
%     tightfig;
    h_scatterplot_fig = ancestor(h_series(1,1,1),'figure');
    figure(h_scatterplot_fig);
    legend off;

end