rootpath = 'F:\SKP-SC analysis\';
basepath = '03-Segmentation\02_Histology\01_Set 1 - P0_GFAP_GFP_10x\';


% section_path{1} = '01-edge_caudal';
% section_path{2} = '02-mid_caudal';
% section_path{3} = '03-epicentre';
% section_path{4} = '04-mid_cranial';
% section_path{5} = '05-edge_cranial';


load([rootpath 'SKP-IDtag'])
origdir = pwd;

for j=1:14
    id = IDtag{j}.id
    cd([rootpath id '\' basepath]);
    [status,message,messageid] = copyfile('07-Inclusion Areas for Analysis','08-Exclusion Areas');
    disp(message);
end

cd(origdir);