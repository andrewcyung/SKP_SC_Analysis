rootpath = 'F:\SKP-SC analysis\'
load([rootpath 'SKP-IDtag'])
load([rootpath 'SKP-MRImap_id'])
load([rootpath 'SKP-histomap_id'])
load([rootpath 'SKP_matchkey_ay_original'])


for j=1:14
    id = IDtag{j}.id;
    
    src_path = [rootpath id '\03-Segmentation\02_Histology\03_Set 3 - Eriochrome_10x\01-Source data\'];
    filelist = rdir([src_path '0*.*']);
    n_files = length(filelist);
    for i=1:n_files
       [pathstr name ext versn] = fileparts(filelist(i).name);
       new_name = [pathstr '\' name(2:end) ext];
       movefile(filelist(i).name, new_name);
    end
     
end
