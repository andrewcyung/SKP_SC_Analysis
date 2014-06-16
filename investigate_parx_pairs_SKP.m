sf = make_SKP_storageframe('MRIPixelGrid','Sectors','F:\SKP-SC analysis\','06-Transformation\02-ConsolidatedData\',IDtag);
rootpath = 'F:\SKP-SC analysis\';
origdir = pwd;
cd(rootpath);
% save('SKP-sf.mat','sf');
% load SKP_sf.mat
cd(origdir);


storage_layout = {'group','subject','slice','segzone'};

% view_categories = {'group','slice','segzone'};

% disp_attributes.hue = [0 6 1 7 2 8 3 9 4 10 5 11]/12;
% disp_attributes.shade = [0.5 0.4 0.3 0.6 0.7]; 
% disp_attributes.marker = ['+','o','*','.','x','s','d','p','h','^','v','>','<','+'];

% requested_members.('group') = {'Media','Cells','8wk'};
% requested_members.('subject') = {'11','16','18','20','36','39','41','51','54','55','56','58','61','62'};
% requested_members.('slice') = {'1EdgeCaudal','2MidCaudal','3Epicentre','4MidCranial','5EdgeCranial'};
% requested_members.('segzone') = {'Dorsal','Ventral','Lateral'};

% view_categories = {'subject','slice','segzone'};

view_categories = {'slice','subject','segzone'};


disp_attributes.hue = [0 1 2 3 4 5]/6;
disp_attributes.shade = [0.5 0.4 0.3 0.6 0.7]; 
disp_attributes.marker = ['+','o','*','.','x','s','d','p','h','^','v','>','<','+'];

requested_members.('group') = {'8wk','Media','Cells'};
% requested_members.('group') = {'Media'};
% requested_members.('group') = {'Cells'};

requested_members.('subject') = {'41'};
% requested_members.('slice') = {'1EdgeCaudal'};
% requested_members.('slice') = {'2MidCaudal'};
% requested_members.('slice') = {'3Epicentre'};
% requested_members.('slice') = {'4MidCranial'};
requested_members.('slice') = {'5EdgeCranial'};
requested_members.('segzone') = {'Dorsal','Ventral','Lateral'};



% parx_pairs = {{'MWF','EC_AvgODThresh'}};
% parx_pairs = {{'MWF','EC_AvgOD'}};
parx_pairs = {{'MWF','EC_AreaFraction'}};
% parx_pairs = {{'MWF','FA'}};
% parx_pairs = {{'MWF','MBP_AreaFraction'}};

% parx_pairs = {{'MWF_fixedmisfit','EC_AreaFraction'}};
% parx_pairs = {{'MWF','MWF_fixedmisfit'}};

n_pairs = length(parx_pairs);

% parx_pairs = {...
%               {'MWF','MBP_IntegODThresh'}, ...
%               {'MWF','MBP_AreaFraction'}, ...
%               {'MWF','EC_IntegODThresh'}, ...
%               {'MWF','EC_AreaFraction'}, ...
%               {'Dlong','MBP_IntegODThresh'}, ...
%               {'Dlong','MBP_AreaFraction'}, ...
%               {'Dlong','EC_IntegODThresh'}, ...
%               {'Dlong','EC_AreaFraction'}, ...
%               {'Dlong','Axon_IntegODThresh'}, ...
%               {'Dlong','Axon_AreaFraction'}, ...
%               {'Dtrans','MBP_IntegODThresh'}, ...
%               {'Dtrans','MBP_AreaFraction'}, ...
%               {'Dtrans','EC_IntegODThresh'}, ...
%               {'Dtrans','EC_AreaFraction'}, ...
%               {'Dtrans','Axon_IntegODThresh'}, ...
%               {'Dtrans','Axon_AreaFraction'}, ...
%               {'FA','MBP_IntegODThresh'}, ...
%               {'FA','MBP_AreaFraction'}, ...
%               {'FA','EC_IntegODThresh'}, ...
%               {'FA','EC_AreaFraction'}, ...
%               {'FA','Axon_IntegODThresh'}, ...
%               {'FA','Axon_AreaFraction'}};

          
% n_pairs = length(parx_pairs);
% corrcoeff_all = cell(n_pairs,1);
for i=1:n_pairs
    parname_x = parx_pairs{i}{1};
    parname_y = parx_pairs{i}{2};
    vf_x = make_viewframe(parname_x,view_categories,sf,storage_layout,requested_members);
    vf_y = make_viewframe(parname_y,view_categories,sf,storage_layout,requested_members);
    h_scatter=figure(1);
    h_thumbx=figure(2);
    h_thumby=figure(3);
    h_upstream_x=figure(5);
    h_upstream_y=figure(6);
   
    axisextents = [];
%     h_series = CreateViewframeScatterplot(vf_x,vf_y,parname_x,parname_y,view_categories,requested_members,disp_attributes,'points',axisextents,h_scatter);
    h_series = create_scatterplot_viewframe(vf_x,vf_y,parname_x,parname_y,disp_attributes,view_categories,h_scatter,h_thumbx,h_thumby,h_upstream_x,h_upstream_y,requested_members,view_categories,'points','Spearman','auto',[]);
    h_legend = legend_viewframe(h_series,requested_members,view_categories,'separateFigure','EastOutside',8);
    figure(h_scatter);
    ti = get(gca,'TightInset');
    set(gca,'Position',[ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);
%     tightfig;
%     disp([parname_x char(9) parname_y ': rho=' num2str(corrcoeff_all{i}.rho) ' p=' num2str(corrcoeff_all{i}.pval)]);
%     disp([parname_x char(9) parname_y char(9) num2str(corrcoeff_all{i}.rho) char(9) num2str(corrcoeff_all{i}.pval)]);
%     pause;
end

% disp('pairs where p<0.05:');
% rho_vec = cellfun(@(elem)elem.rho,corrcoeff_all);
% pval_vec = cellfun(@(elem)elem.pval,corrcoeff_all);
% good_index = find(pval_vec<0.05);
% rho_good = rho_vec(good_index);
% pval_good = pval_vec(good_index);
% pair_name_good = parx_pairs(good_index);
% [rho_abs_sorted order] = sort(abs(rho_good),1,'descend');
% rho_sorted = rho_good(order);
% pval_sorted = pval_good(order);
% pair_name_sorted = pair_name_good(order);
% 
% for i=1:length(pair_name_good)
% %     disp([pair_name_sorted{i}{1} ' vs. ' pair_name_sorted{i}{2} ': rho=' num2str(rho_sorted(i)) ' p=' num2str(pval_sorted(i))]);
%     disp([pair_name_sorted{i}{1} char(9) pair_name_sorted{i}{2} char(9) num2str(rho_sorted(i)) char(9) num2str(pval_sorted(i))]);
%     
% end