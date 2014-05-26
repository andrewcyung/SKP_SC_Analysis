rootpath = 'F:\SKP-SC analysis\'

section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

load(['F:\SKP-SC analysis\' 'SKP-IDtag'])
% filename = 'sum_image.tif';

for j=6:6
    id = IDtag{j}.id;
    
    src_basepath = [rootpath id '\' '01-Original Images\02-Optical Histology\02_Set 2 - MBP_Axons_10x\02-Axons_blue\']
%     src2_basepath = [rootpath id '\' '05-Registration\05-Axon_BtwnSectionSmooth_Rigid\02-Results\']
    dest_basepath = [rootpath id '\' '05-Registration\03-Axon_BtwnSectionSmooth_Rigid\01-Source data\']

%     src_basepath = [rootpath id '\' '04-Preprocessing\04-MRI upsampling\02-Results\']
%     dest_basepath = [rootpath id '\' '04-Preprocessing\08-interpMRI-CropforReg\02-Results\']

    mkdir(dest_basepath);
    symlinker(src_basepath,dest_basepath);

%     for i=1:5
%         dest_path = [dest_basepath section_path{i}];
%         src_path = [src_basepath section_path{i}];
%         src2_path = [src2_basepath section_path{i}];
%         mkdir(dest_path);
% %         symlinker(src_path,dest_path);
% %         symlinker_file('imTrW-label.nrrd',src_path,dest_path);
%         symlinker_file('imTrW.png',src_path,dest_path);
%         symlinker_file('CPMG_echo10.png',src_path,dest_path);
%         delete([dest_path 'sum_image.tif']);
%         symlinker_file('sum_image.tif',src2_path,dest_path);
% 
%     end
end