rootpath = 'F:\SKP-SC analysis\'

load([rootpath 'SKP-IDtag'])


for j=1:14
    id = IDtag{j}.id;
    
    cavity_path = [rootpath id '\' '03-Segmentation\02_Histology\01_Set 1 - P0_GFAP_GFP_10x\04-Cavity\']
    section_path = [rootpath id '\' '03-Segmentation\02_Histology\01_Set 1 - P0_GFAP_GFP_10x\02-Whole section\']
    dest_path = [rootpath id '\' '03-Segmentation\02_Histology\01_Set 1 - P0_GFAP_GFP_10x\05-Whole tissue\']

    ovnum1 = 3;
    ovnum2 = 3;
    
    im_filelist = rdir([cavity_path '*.tif']);
    n_im = length(im_filelist);

    for i=1:n_im
        cavity_ROI_found=1;
        section_ROI_found=1;
        
        [pathstr basename extname versn] = fileparts(im_filelist(i).name);
        im_filename = im_filelist(i).name
        iminfo = imfinfo(im_filename);
        ov_filelist_cav = rdir([cavity_path basename '.ov*']);
        n_ov_cav = length(ov_filelist_cav);
        if n_ov_cav >= 1
            if n_ov_cav > 1
                disp('more than 1 ROI found for cavity');
            end
            roi_cavity = imread(ov_filelist_cav(1).name);
        elseif n_ov_cav == 0
            disp('no ROI found for cavity');
            cavity_ROI_found = 0;
        end

        ov_filelist_section = rdir([section_path basename '.ov*']);
        n_ov_sect = length(ov_filelist_section);
        if n_ov_sect >= 1
            if n_ov_sect > 1
                disp('more than 1 ROI found for whole section');
            end
            roi_sect = imread(ov_filelist_section(1).name);
        elseif n_ov_sect == 0
            disp('no ROI found for whole section');
            section_ROI_found=0;
        end
        
        if section_ROI_found && cavity_ROI_found
            dest_roi = roi_sect&(~roi_cavity);
            imwrite(dest_roi,[dest_path '\' basename '.ov1'],'bmp');
        elseif ~cavity_ROI_found && section_ROI_found
            dest_roi = roi_sect;
            imwrite(dest_roi,[dest_path '\' basename '.ov1'],'bmp');
        end
        
    end
end