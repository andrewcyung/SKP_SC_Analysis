rootpath = 'F:\SKP-SC analysis\'

load([rootpath 'SKP-IDtag'])

mask_colour = cell(6,1);

% mask_colour{1} = [0 0 0]; %black
% mask_colour{2} = [0 1 0]; %green
% mask_colour{3} = [1 0 0]; %red
% mask_colour{4} = [1 1 0]; %yellow

mask_colour{1} = [0 0 0]; %black
mask_colour{2} = [0 0 0]; %black
mask_colour{3} = [0 1 0]; %green
mask_colour{4} = [1 0 0]; %red
mask_colour{5} = [1 1 0]; %yellow
% mask_colour{6} = [1 1 0]; %yellow


% mask_colour{4} = [1 1 0]; %yellow
% mask_colour{1} = [0 0 0]; %black
% mask_colour{6} = [1 0 1]; %magenta
% mask_colour{3} = [1 0 0]; %red
% mask_colour{2} = [0 1 0]; %green
% mask_colour{5} = [0 1 1]; %cyan
% mask_colour{4} = [0 0 1]; %blue

ROIdispmode = 'overlay';
% ROIdispmode = 'outline';
transparency = 0.5;
dimming_factor = 0.5;

for j=1:14
    id = IDtag{j}.id;
     
%     src_path = [rootpath id '\' '03-Segmentation\02_Histology\01_Set 1 - P0_GFAP_GFP_10x\07-Inclusion Areas for Analysis\01-GFAP_blue\']
%     src_path = [rootpath id '\' '03-Segmentation\02_Histology\03_Set 3 - Eriochrome_10x\07-Inclusion Areas for Analysis\']
%     src_path = [rootpath id '\' '03-Segmentation\02_Histology\02_Set 2 - MBP_Axons_10x\07-Inclusion Areas for Analysis\02-Axons_blue\']

      src_path = [rootpath id '\' '03-Segmentation\02_Histology\02_Set 2 - MBP_Axons_10x\16-Axons thresholded Otsu\']

%     src_path = [rootpath id '\' '03-Segmentation\02_Histology\02_Set 2 - MBP_Axons_10x\15-MBP thresholded Otsu\']
%     src_path = [rootpath id '\' '03-Segmentation\02_Histology\03_Set 3 - Eriochrome_10x\15-EC thresholded Otsu\']
%     dest_basepath = [rootpath id '\' '03-Segmentation\02_Histology\01_Set 1 - P0_GFAP_GFP_10x\07-Inclusion Areas for Analysis\03-P0_red\']
%     dest_basepath = [rootpath id '\' '03-Segmentation\02_Histology\02_Set 2 - MBP_Axons_10x\07-Inclusion Areas for Analysis\03-GFP_green\']
    dest_basepath = src_path;
    im_filelist = rdir([src_path '*.tif']);
    n_im = length(im_filelist);
    for i=1:n_im
        [pathstr basename extname versn] = fileparts(im_filelist(i).name);
        dest_path = [dest_basepath basename extname];
        im_filename = im_filelist(i).name
        ov_filelist = rdir([src_path basename '.ov*']);
        n_ov = length(ov_filelist);
        if n_ov > 0
            SKP_make_ROI_thumbnail(ov_filelist,im_filename,ROIdispmode,mask_colour,dimming_factor,transparency,5,dest_path);
%             SKP_make_ROI_thumbnail(ov_filelist,im_filename,ROIdispmode,mask_colour,dimming_factor,transparency,1,dest_path);
        end
    end
end