rootpath = 'F:\SKP-SC analysis\';
dest_subpath = '03-Segmentation\02_Histology\01_Set 1 - P0_GFAP_GFP_10x\'
% newdir = '09-Exclusion Areas - Spots\';
newdir = '10-Tissue outside cord\';

load([rootpath 'SKP-IDtag'])

for j=1:14
    id = IDtag{j}.id;
    dest_basepath = [rootpath id '\' dest_subpath newdir]
    mkdir(dest_basepath);
     
%     section_path{1} = '01-edge_caudal';
%     section_path{2} = '02-mid_caudal';
%     section_path{3} = '03-epicentre';
%     section_path{4} = '04-mid_cranial';
%     section_path{5} = '05-edge_cranial';
%     for i=1:5
%         dest_path = [rootpath id '\' dest_subpath section_path{i}];
%         mkdir(dest_path);
%     end
end