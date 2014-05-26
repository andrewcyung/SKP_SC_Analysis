rootpath = 'F:\SKP-SC analysis\';
basepath = '03-Segmentation\02_Histology\03_Set 3 - Eriochrome_10x\';
orig_dirname = '08-Exclusion Areas - Rips Folds MissingPortions Floppers\';
new_dirname = '08-Exclusion Areas\';

% section_path{1} = '01-edge_caudal';
% section_path{2} = '02-mid_caudal';
% section_path{3} = '03-epicentre';
% section_path{4} = '04-mid_cranial';
% section_path{5} = '05-edge_cranial';


load([rootpath 'SKP-IDtag'])

for j=1:14
    id = IDtag{j}.id;
    orig_path = [rootpath id '\' basepath orig_dirname]
    new_path = [rootpath id '\' basepath new_dirname]
    [status,message,messageid] = movefile(orig_path,new_path);
    disp(message);
end