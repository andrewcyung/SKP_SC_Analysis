rootpath = 'F:\SKP-SC analysis\'

load([rootpath 'SKP-IDtag'])

for j=6:6
    id = IDtag{j}.id;
    src_im_path = [rootpath id '\' '03-Segmentation\02_Histology\02_Set 2 - MBP_Axons_10x\07-Inclusion Areas for Analysis\02-Axons_blue\']
    dest_im_path = [rootpath id '\' '04-Preprocessing\05-Histology-CropforIntersetReg\02_Set 2 - MBP_Axons_10x\02-Axons_blue\']
    mkdir(dest_im_path);
    im_filelist = rdir([src_im_path '*.tif']);
    ROI_path = [rootpath id '\' '03-Segmentation\02_Histology\02_Set 2 - MBP_Axons_10x\07-Inclusion Areas for Analysis\02-Axons_blue\']
    n_im = length(im_filelist);
    for i=1:n_im
        [pathstr basename extname versn] = fileparts(im_filelist(i).name);
        im_filename = im_filelist(i).name
        im = imread(im_filename);
        ov_filelist = rdir([ROI_path basename '.ov*']);
        n_ov = length(ov_filelist);
        if n_ov >= 1
            ov_filename = ov_filelist(1).name;
            ROI = imread(ov_filename);
%             im = 255-im;
            im(~ROI) = 0;
            imwrite(im,[dest_im_path basename '.tif'],'tif','Compression','none');
            imwrite(im,[dest_im_path basename '.jpg'],'jpg');
            
        else
            disp('no ROI found');
        end
    end
end