% sf = make_SKP_storageframe('MRIPixelGrid','Sectors','F:\SKP-SC analysis\','06-Transformation\02-ConsolidatedData\',IDtag);
% view_categories = {'group','slice','segzone'};
view_categories = {'group','slice','subject'};

storage_layout = {'group','subject','slice','segzone'};

requested_members.('group') = {'Media','Cells','8wk'};
requested_members.('subject') = {'11','16','18','20','36','39','41','51','54','55','56','58','61','62'};
requested_members.('slice') = {'1EdgeCaudal','2MidCaudal','3Epicentre','4MidCranial','5EdgeCranial'};
requested_members.('segzone') = {'Dorsal','Ventral','Lateral'};

parname_x = 'Dlong';
parname_y = 'Axon_AvgOD';
vf_x = make_viewframe(parname_x,view_categories,sf,storage_layout,requested_members);
vf_y = make_viewframe(parname_y,view_categories,sf,storage_layout,requested_members);

disp_attributes.hue = [0 6 1 7 2 8 3 9 4 10 5 11]/12;
disp_attributes.shade = [0.5 0.4 0.3 0.6 0.7]; 
disp_attributes.marker = ['+','o','*','.','x','s','d','p','h','^','v','>','<','+'];
h=figure(1);

[h_series corrcoeff corrcoeff_all]= create_scatterplot_viewframe(vf_x,vf_y,parname_x,parname_y,disp_attributes,h,requested_members,view_categories,'mean','Pearson','auto');
h_legend = legend_viewframe(h_series,requested_members,view_categories,'standard');

