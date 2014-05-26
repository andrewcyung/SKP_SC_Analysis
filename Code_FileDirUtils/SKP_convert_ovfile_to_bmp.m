rootpath = 'F:\SKP-SC analysis\'

load([rootpath 'SKP-IDtag'])

src_subpath = '03-Segmentation\02_Histology\01_Set 1 - P0_GFAP_GFP_10x\02-Whole section\';

for j=1:14
    id = IDtag{j}.id;
    
    src_basepath = [rootpath id '\' src_subpath];

    ov_filelist = rdir([src_basepath '*.ov3']);
    n_ov = length(ov_filelist);
    for i=1:n_ov
        [pathstr basename extname versn] = fileparts(ov_filelist(i).name);
        ov_filepath = ov_filelist(i).name
        bmp_filename = [pathstr '\' basename '.bmp'];
        status =ov2bmpfile(ov_filepath);
    end


end