section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

rootpath = 'F:\SKP-SC analysis\';

load([rootpath 'SKP_matchkey_ay_original'])

for j=1:14

    id = matchkey{j}.id
    src_basepath = {[rootpath id '\' '04-Preprocessing\05-Histology-CropforIntersetReg\01_Set 1 - P0_GFAP_GFP_10x\01-GFAP_blue\'], ...
        [rootpath id '\' '04-Preprocessing\05-Histology-CropforIntersetReg\01_Set 1 - P0_GFAP_GFP_10x\02-GFP_green\'], ...
        [rootpath id '\' '04-Preprocessing\05-Histology-CropforIntersetReg\01_Set 1 - P0_GFAP_GFP_10x\03-P0_red\'], ...
        [rootpath id '\' '04-Preprocessing\05-Histology-CropforIntersetReg\02_Set 2 - MBP_Axons_10x\01-MBP_red\'], ...
        [rootpath id '\' '04-Preprocessing\05-Histology-CropforIntersetReg\02_Set 2 - MBP_Axons_10x\02-Axons_blue\'], ...
        [rootpath id '\' '04-Preprocessing\05-Histology-CropforIntersetReg\02_Set 2 - MBP_Axons_10x\03-GFP_green\'], ...
        [rootpath id '\' '04-Preprocessing\05-Histology-CropforIntersetReg\03_Set 3 - Eriochrome_10x\']};
    stain_suffix = {'_GFAP', '_GFP', '_P0', '_MBP', '_Axons', '_GFPSet2', '_EC'};
        
        
    
    n_src = length(src_basepath);
    
    dest_basepath = [rootpath id '\' '05-Registration\02-Histo_InterSet_MI_Rigid\'];

    for i=1:5
        dest_path = [dest_basepath section_path{i}];
        mkdir(dest_path);

        startindex = matchkey{j}.histoextent(i,1);
        endindex = matchkey{j}.histoextent(i,2);
        n_histo = endindex-startindex+1;

        for q=1:n_histo
            filename_base = [num2str(startindex-1+q)];
   
            for z = 1:n_src
                filelist = rdir([src_basepath{z} filename_base '.*']);
                for r=1:length(filelist)
                    [path name ext versn] = fileparts(filelist(r).name);
                    new_filename = [name stain_suffix{z} ext];
                    copyfile(filelist(r).name,[dest_path new_filename]);
                end
            end
            
        end
        
    end


    
end


