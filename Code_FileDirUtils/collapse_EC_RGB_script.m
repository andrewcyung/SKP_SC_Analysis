rootpath = 'F:\SKP-SC analysis\'
load([rootpath 'SKP-IDtag'])
load([rootpath 'SKP-MRImap_id'])
load([rootpath 'SKP-histomap_id'])
load([rootpath 'SKP_matchkey_ay_original'])


for j=6:6
    id = IDtag{j}.id;
    
%     src_path = [rootpath id '\03-Segmentation\02_Histology\03_Set 3 - Eriochrome_10x\07-Inclusion Areas for Analysis\'];
    src_path = [ rootpath id '\05-Registration\02-Histo_InterSet_MI_Rigid\01-edge_caudal\'];
    filelist = rdir([src_path '*.tif']);
    n_files = length(filelist);
    for i=1:n_files
        im=imread(filelist(i).name);
        dim = size(im);
        if length(dim)==3
            im = mat2gray(squeeze(im(:,:,2)));
            imwrite(im,filelist(i).name);
            disp(filelist(i).name);
        end
    end
     
end
