rootpath = 'F:\SKP-SC analysis\'

load([rootpath 'SKP-IDtag'])

for j=2:2
    id = IDtag{j}.id;
    
    src_im_path = [rootpath id '\' '04-Preprocessing\06-Histology-GaussianSmoothing\01-Source data\']
    dest_im_path = [rootpath id '\' '04-Preprocessing\06-Histology-GaussianSmoothing\02-Results\']
    
    im_filelist = rdir([src_im_path '*.tif']);
    n_im = length(im_filelist);
    G=fspecial('gaussian',[100 100],10);

    for i=1:n_im
        [pathstr basename extname versn] = fileparts(im_filelist(i).name);
        im_filename = im_filelist(i).name
        im = imread(im_filename);
        im_smooth = imfilter(im,G,'same');
        figure(1); imagesc(im); colormap gray;
        figure(2); imagesc(im_smooth); colormap gray;
        imwrite(im_smooth,[dest_im_path basename '.tif'],'tif','Compression','none');
    end
end