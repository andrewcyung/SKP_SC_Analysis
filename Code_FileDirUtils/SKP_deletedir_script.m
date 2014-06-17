rootpath = 'F:\SKP-SC analysis\';
% basepath = '03-Segmentation\02_Histology\03_Set 3 - Eriochrome_10x\';

% basepath = '03-Segmentation\02_Histology\02_Set 2 - MBP_Axons_10x\';
basepath = '04-Preprocessing\06-Histology-GaussianSmoothing\';

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
    [status,message,messageid] = rmdir('01-Source data','s');

%     cd([rootpath id '\' basepath '02-Whole section']);
%     cd([rootpath id '\' basepath '14-LeoDamageSquareROI']);
%     
%     tif_filelist = rdir('*.tif');
%     n_tif = length(tif_filelist);
%     for k=1:n_tif
%         delete(tif_filelist(k).name);
%     end

    disp(message);
end

cd(origdir);