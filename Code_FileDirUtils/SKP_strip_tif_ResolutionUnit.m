section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

rootpath = 'F:\SKP-SC analysis\';

load([rootpath 'SKP_matchkey_ay_original'])

for j=1:14

    id = matchkey{j}.id
    dest_basepath = [rootpath id '\' '04-Preprocessing\05-Histology-CropforIntersetReg\03_Set 3 - Eriochrome_10x\'];
    dest_path = dest_basepath;
    filelist = rdir([dest_path '*.tif']);
    for r=1:length(filelist)
        im = imread(filelist(r).name);
        imwrite(im,filelist(r).name,'tif','Resolution',25.4);
    end

%     for i=1:5
%         dest_path = [dest_basepath section_path{i}];
% 
%         filelist = rdir([dest_path '*.tif']);
%         for r=1:length(filelist)
%             im = imread(filelist(r).name);
%             imwrite(im,filelist(r).name,'tif','Resolution',25.4);
%         end
%     end
    
end


