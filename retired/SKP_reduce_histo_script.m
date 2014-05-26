rootpath = 'F:\SKP-SC analysis\'

load([rootpath 'SKP-IDtag'])

for j=1:14
    id = IDtag{j}.id;
    
    src_im_path = [rootpath id '\' '04-Preprocessing\03-Histology downsampling\01-Source data\01_Set 1 - P0_GFAP_GFP_10x\']
    dest_im_path = [rootpath id '\' '04-Preprocessing\03-Histology downsampling\02-Results\01_Set 1 - P0_GFAP_GFP_10x\']
    
    im_filelist = rdir([src_im_path '*.tif']);
    n_im = length(im_filelist);
    for i=1:n_im
        [pathstr basename extname versn] = fileparts(im_filelist(i).name);
        im_filename = im_filelist(i).name
        im = imread(im_filename);
        im_lowres = reduce_im_fourier(im,256,3);
        imwrite(im_lowres,[dest_im_path basename '.tif'],'tif','Compression','none');
    end
end