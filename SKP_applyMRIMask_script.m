rootpath = 'F:\SKP-SC analysis\'

load([rootpath 'SKP-IDtag'])

section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

dilate_struct = [0 1 0; 1 1 1; 0 1 0];

for j=7:7
    id = IDtag{j}.id;
    
    src_basepath = [rootpath id '\' '04-Preprocessing\08-interpMRI-CropforReg\02-Results\']
    dest_basepath = [rootpath id '\' '04-Preprocessing\08-interpMRI-CropforReg\02-Results\']
    ROI_path = [rootpath id '\' '04-Preprocessing\08-interpMRI-CropforReg\02-Results\']
    
    for k=1:5
        src_path = [src_basepath section_path{k}];
        ROI_path = [src_basepath section_path{k}];
        dest_path = [dest_basepath section_path{k}];
        basename = 'CPMG_echo10';
%         basename = 'imTrW';
        basename2 = 'imTrW';
        im_filename = [src_path basename '.png'];
        im = imread(im_filename);
        ov_filelist = rdir([ROI_path basename2 '.ov1']);
        n_ov = length(ov_filelist);
        if n_ov >= 1
            ov_filename = ov_filelist(1).name;
            ROI = imread(ov_filename);
            edge = ~ROI & imdilate(ROI,dilate_struct);
            background_val = uint8(mean(im(edge)));
            im(~ROI) = background_val;
            figure(1); imagesc(im);
            imwrite(im,[dest_path basename '.png'],'png','Compression','none');
        else
            disp('no ROI found');
        end
        
    end
    
end