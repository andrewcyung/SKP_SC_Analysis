rootpath = 'F:\SKP-SC analysis\'

load([rootpath 'SKP-IDtag'])
section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

for j=11:11
    id = IDtag{j}.id;
    
%     src_basepath = [rootpath id '\' '03-Segmentation\02_Histology\02_Set 2 - MBP_Axons_10x\07-Inclusion Areas for Analysis\02-Axons_blue\'];
    src_basepath = [rootpath id '\' '03-Segmentation\02_Histology\01_Set 1 - P0_GFAP_GFP_10x\07-Inclusion Areas for Analysis\01-GFAP_blue\'];
%     src_basepath = [rootpath id '\' '03-Segmentation\02_Histology\03_Set 3 - Eriochrome_10x\07-Inclusion Areas for Analysis\'];

%     src_basepath = [rootpath id '\' '03-Segmentation\02_Histology\02_Set 2 - MBP_Axons_10x\08-Exclusion Areas\02-Axons_blue\'];
%     src_basepath = [rootpath id '\' '03-Segmentation\02_Histology\01_Set 1 - P0_GFAP_GFP_10x\08-Exclusion Areas\01-GFAP_blue\'];
%     src_basepath = [rootpath id '\' '03-Segmentation\02_Histology\03_Set 3 - Eriochrome_10x\08-Exclusion Areas\'];

%     src_basepath = [rootpath id '\' '04-Preprocessing\08-interpMRI-CropforReg\02-Results\'];

%     src_basepath = [rootpath id '\' '03-Segmentation\01_MRI\01-ManualWholeSection\02-Results\'];


%     nrrd_filelist = rdir([src_basepath '*.nrrd']);
%     n_nrrd = length(nrrd_filelist);
%     for i=1:n_nrrd
%         [pathstr basename extname] = fileparts(nrrd_filelist(i).name);
%         nrrd_filepath = nrrd_filelist(i).name
%         if strcmp(nrrd_filepath((end-6):end),'_1.nrrd')
%             new_filename = [nrrd_filepath(1:end-7) '-label.nrrd'];
%             movefile(nrrd_filepath,new_filename);
%         end
%         if strcmp(nrrd_filepath((end-10):end),'-label.nrrd')
%             status = slicerlabel2ovfile(nrrd_filepath,1);
%         end
%     end

     for i=status{j}.isReg.AxonSum2MRI
%         src_path = [src_basepath section_path{i}]; 
        src_path = src_basepath; 
        
        nrrd_filelist = rdir([src_path '*.nrrd']);
        n_nrrd = length(nrrd_filelist);
        for i=1:n_nrrd
            [pathstr basename extname] = fileparts(nrrd_filelist(i).name);
            nrrd_filepath = nrrd_filelist(i).name;
            if strcmp(nrrd_filepath((end-7):end),'_1.nrrd')
                new_filename = [nrrd_filepath(1:end-8) '-label.nrrd'];
                movefile(nrrd_filepath,new_filename);
            end
            ov_filename = [nrrd_filepath(1:(end-11)) '.ov1'];
            outmsg = slicerlabel2ovfile(nrrd_filepath,1);
        end
    end

end