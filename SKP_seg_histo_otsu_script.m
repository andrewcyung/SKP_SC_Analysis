rootpath = 'F:\SKP-SC analysis\';

section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

load(['F:\SKP-SC analysis\' 'SKP-IDtag']) %loads IDtag
load(['F:\SKP-SC analysis\' 'SKP_matchkey_ay_original']) %loads matchkey
load(['F:\SKP-SC analysis\' 'SKP-histomap_id']) %loads histomap_id

% for j=2:14
for j=[1:14]
    id = IDtag{j}.id
%     src_basepath = [rootpath id '\' '04-Preprocessing\05-Histology-CropforIntersetReg\02_Set 2 - MBP_Axons_10x\02-Axons_blue\'];
%     dest_basepath = [rootpath id '\' '03-Segmentation\02_Histology\02_Set 2 - MBP_Axons_10x\16-Axons thresholded Otsu\'];
%     src_basepath = [rootpath id '\' '04-Preprocessing\05-Histology-CropforIntersetReg\02_Set 2 - MBP_Axons_10x\01-MBP_red\'];
%     dest_basepath = [rootpath id '\' '03-Segmentation\02_Histology\02_Set 2 - MBP_Axons_10x\15-MBP thresholded Otsu\'];
%     src_basepath = [rootpath id '\' '04-Preprocessing\05-Histology-CropforIntersetReg\03_Set 3 - Eriochrome_10x\'];
%     dest_basepath = [rootpath id '\' '03-Segmentation\02_Histology\03_Set 3 - Eriochrome_10x\15-EC thresholded Otsu'];

    src_basepath = [rootpath id '\' '04-Preprocessing\05-Histology-CropforIntersetReg\01_Set 1 - P0_GFAP_GFP_10x\03-P0_red\'];
    dest_basepath = [rootpath id '\' '03-Segmentation\02_Histology\02_Set 2 - MBP_Axons_10x\15-P0 thresholded Otsu\'];
    mkdir(dest_basepath);
    filelist = rdir([src_basepath '*.tif']);
    n_im = length(filelist)
    for i=1:n_im
        im = imread(filelist(i).name);

        [path name ext] = fileparts(filelist(i).name); 
%         threshim = otsu(im,5);
% 
%         ov1 = false(size(im));
%         ov2 = false(size(im));
%         ov3 = false(size(im));
%         ov4 = false(size(im));
%         ov5 = false(size(im));
%         ov1(threshim==1) = 1;
%         ov2(threshim==2) = 1;
%         ov3(threshim==3) = 1;
%         ov4(threshim==4) = 1;
%         ov5(threshim==5) = 1;
% 
%         ov6 = ov4|ov5;
%         imwrite(im, [dest_basepath name '.tif'],'tif','Resolution',25.4); 
%         imwrite(ov1,[dest_basepath name '.ov1'],'bmp');
%         imwrite(ov2,[dest_basepath name '.ov2'],'bmp');
%         imwrite(ov3,[dest_basepath name '.ov3'],'bmp');
%         imwrite(ov4,[dest_basepath name '.ov4'],'bmp');
%         imwrite(ov5,[dest_basepath name '.ov5'],'bmp');
%         imwrite(ov6,[dest_basepath name '.ov6'],'bmp');

%         threshim = otsu(im,4);
% 
%         ov1 = false(size(im));
%         ov2 = false(size(im));
%         ov3 = false(size(im));
%         ov4 = false(size(im));
%         ov1(threshim==1) = 1;
%         ov2(threshim==2) = 1;
%         ov3(threshim==3) = 1;
%         ov4(threshim==4) = 1;
% 
%         ov5 = ov3|ov4;
%         imwrite(im, [dest_basepath name '.tif'],'tif','Resolution',25.4); 
%         imwrite(ov1,[dest_basepath name '.ov1'],'bmp');
%         imwrite(ov2,[dest_basepath name '.ov2'],'bmp');
%         imwrite(ov3,[dest_basepath name '.ov3'],'bmp');
% %         imwrite(ov4,[dest_basepath name '.ov4'],'bmp');
%         imwrite(ov5,[dest_basepath name '.ov5'],'bmp');

        threshim = otsu(im,4);

        ov1 = false(size(im));
        ov2 = false(size(im));
        ov3 = false(size(im));
        ov4 = false(size(im));

        ov1(threshim==1) = 1;
        ov2(threshim==2) = 1;
        ov3(threshim==3) = 1;
        ov4(threshim==4) = 1;


  
        imwrite(im, [dest_basepath name '.tif'],'tif','Resolution',25.4); 
        imwrite(ov1,[dest_basepath name '.ov1'],'bmp');
        imwrite(ov2,[dest_basepath name '.ov2'],'bmp');
        imwrite(ov3,[dest_basepath name '.ov3'],'bmp');
        imwrite(ov4,[dest_basepath name '.ov4'],'bmp');



        figure(1); imagesc(threshim); axis off; axis image; colormap jet

    end

end