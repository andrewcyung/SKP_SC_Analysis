rootpath = 'F:\SKP-SC analysis\'

load([rootpath 'SKP-IDtag'])

mask_colour{4} = [1 0 0]; %red
mask_colour{5} = [0 1 0]; %green
mask_colour{6} = [0 0 1]; %blue
mask_colour{1} = [1 1 0]; %yellow
mask_colour{2} = [1 0 1]; %magenta
mask_colour{3} = [0 1 1]; %cyan

% ROIdispmode = 'overlay';
ROIdispmode = 'outline';
transparency = 0.5;
dimming_factor = 0.5;

for j=1:14
    id = IDtag{j}.id;
    
    src_im_path = [rootpath id '\' '04-Preprocessing\02-Histology pad background\01-Source data\01_Set 1 - P0_GFAP_GFP_10x\']
    dest_im_path = [rootpath id '\' '04-Preprocessing\02-Histology pad background\02-Results\01_Set 1 - P0_GFAP_GFP_10x\']
    
    im_filelist = rdir([src_im_path '*.tif']);
    ROI_path = [rootpath id '\' '03-Segmentation\02_Histology\01_Set 1 - P0_GFAP_GFP_10x\05-Whole tissue\']
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
            im(~ROI) = 0;
            imwrite(im,[dest_im_path basename '.tif'],'tif','Compression','none');
            imwrite(im,[dest_im_path basename '.jpg'],'jpg');
            
        else
            disp('no ROI found');
        end
    end
end