SKP_GenerateInfostruct;

for j=1:14
    id = IDtag{j}.id;
    
    src_basepath = [rootpath id '\' '03-Segmentation\01_MRI\01-ManualWholeSection\02-Results\']
    dest_basepath = [rootpath id '\' '04-Preprocessing\07-MRI initial flip alignment\02-Results\'];
    for k=status{j}.isReg.AxonSum2MRI
        ROI_path = [src_basepath section_path{k}];
        dest_path = [dest_basepath section_path{k}];
%         basename = 'CPMG_echo10';
        basename = 'imTrW-label*';
        ov_filelist = rdir([ROI_path basename '.ov1']);
        n_ov = length(ov_filelist);
        if n_ov >= 1
            ov_filename = ov_filelist(1).name;
            MRI_incl_mask = imread(ov_filename);
            
            if MRI_orientation{j}(1)
                MRI_incl_mask = flipdim(MRI_incl_mask,2);
            end
            if MRI_orientation{j}(2)
                MRI_incl_mask = flipdim(MRI_incl_mask,1);
            end
            if MRI_orientation{j}(3)
                MRI_incl_mask = MRI_incl_mask';
            end

            
            save([dest_path 'MRI_incl_mask.mat'],'MRI_incl_mask');
            imwrite(MRI_incl_mask,[dest_path 'MRI_incl_mask' '.png'],'png','Compression','none');
        else
            disp('no ROI found');
        end
        
    end
    
end