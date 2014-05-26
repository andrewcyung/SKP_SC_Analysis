% sf = make_SKP_storageframe('MRIPixelGrid','Sectors','F:\SKP-SC analysis\','06-Transformation\02-ConsolidatedData\',IDtag);
rootpath = 'F:\SKP-SC analysis\';
origdir = pwd;
cd(rootpath);
% load SKP_sf.mat
cd(origdir);

view_categories = {'group','subject','slice'};

storage_layout = {'group','subject','slice','segzone'};

disp_attributes.hue = [0 6 1 7 2 8 3 9 4 10 5 11]/12;
disp_attributes.shade = [0.5 0.4 0.3 0.6 0.7];
disp_attributes.marker = ['+','o','*','.','x','s','d','p','h','^','v','>','<','+'];

all_members.('group') = {'Media','Cells','8wk'};
all_members.('subject') = {'11','16','18','20','36','39','41','51','54','55','56','58','61','62'};
all_members.('slice') = {'1EdgeCaudal','2MidCaudal','3Epicentre','4MidCranial','5EdgeCranial'};
all_members.('segzone') = {'Dorsal','Ventral','Lateral'};

requested_members = all_members;
parx_pairs = {{'MWF','EC_AvgOD'}};
n_subject = length(requested_members.('subject'));

for i=1:n_subject
    requested_members.('subject') = {all_members.('subject'){i}};
    
    n_pairs = length(parx_pairs);
    corrcoeff_all = cell(1,n_pairs);
    for i=1:n_pairs
        parname_x = parx_pairs{i}{1};
        parname_y = parx_pairs{i}{2};
        vf_x = make_viewframe(parname_x,view_categories,sf,storage_layout,requested_members);
        vf_y = make_viewframe(parname_y,view_categories,sf,storage_layout,requested_members);
        h=figure(1);
        [h_series corrcoeff corrcoeff_all{i}]= create_scatterplot_viewframe(vf_x,vf_y,parname_x,parname_y,disp_attributes,h,requested_members,view_categories,'points','Spearman','auto');
        h_legend = legend_viewframe(h_series,requested_members,view_categories,'standard');
        %     disp([parname_x char(9) parname_y ': rho=' num2str(corrcoeff_all{i}.rho) ' p=' num2str(corrcoeff_all{i}.pval)]);
        disp([parname_x char(9) parname_y char(9) num2str(corrcoeff_all{i}.rho) char(9) num2str(corrcoeff_all{i}.pval)]);
        %     pause;
    end
    
    disp('pairs where p<0.05:');
    rho_vec = cellfun(@(elem)elem.rho,corrcoeff_all);
    pval_vec = cellfun(@(elem)elem.pval,corrcoeff_all);
    good_index = find(pval_vec<0.05);
    rho_good = rho_vec(good_index);
    pval_good = pval_vec(good_index);
    pair_name_good = parx_pairs(good_index);
    [rho_abs_sorted order] = sort(abs(rho_good),1,'descend');
    rho_sorted = rho_good(order);
    pval_sorted = pval_good(order);
    pair_name_sorted = pair_name_good(order);
    
    for i=1:length(pair_name_good)
        %     disp([pair_name_sorted{i}{1} ' vs. ' pair_name_sorted{i}{2} ': rho=' num2str(rho_sorted(i)) ' p=' num2str(pval_sorted(i))]);
        disp([pair_name_sorted{i}{1} char(9) pair_name_sorted{i}{2} char(9) num2str(rho_sorted(i)) char(9) num2str(pval_sorted(i))]);
        
    end
    pause;
    
end
