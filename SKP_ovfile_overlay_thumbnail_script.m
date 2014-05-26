rootpath = 'F:\SKP-SC analysis\';

section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

load(['F:\SKP-SC analysis\' 'SKP-IDtag']) %loads IDtag
load(['F:\SKP-SC analysis\' 'SKP_matchkey_ay_original']) %loads matchkey
load(['F:\SKP-SC analysis\' 'SKP-histomap_id']) %loads histomap_id

% for j=1:14
for j=[8 12]
    id = IDtag{j}.id

    src_basepath{1} = [rootpath id '\' '03-Segmentation\02_Histology\02_Set 2 - MBP_Axons_10x\15-MBP thresholded Otsu\'];
    src_basepath{2} = [rootpath id '\' '03-Segmentation\02_Histology\02_Set 2 - MBP_Axons_10x\16-Axons thresholded Otsu\'];
    src_basepath{3} = [rootpath id '\' '03-Segmentation\02_Histology\03_Set 3 - Eriochrome_10x\15-EC thresholded Otsu\'];
    src_basepath{4} = [rootpath id '\' '03-Segmentation\02_Histology\01_Set 1 - P0_GFAP_GFP_10x\11-P0 thresholded\'];

%     for k=1:3
      for k=1  
        filelist = rdir([src_basepath{k} '*.tif']);
        n_im = length(filelist)
        for i=1:n_im
            im = imread(filelist(i).name);
            
            [path imname ext] = fileparts(filelist(i).name);
            ovfilelist = rdir([src_basepath{k} '\' imname '.ov*']);
            n_ov = length(ovfilelist);
            for j=1:n_ov
                [path ovname ext] = fileparts(ovfilelist(j).name);
                ov_im = imread(ovfilelist(j).name);
                imwrite(ov_im, [src_basepath{k} ovname '_' ext(end) '.jpg'],'jpg');
            end
            
        end
        
    end
end