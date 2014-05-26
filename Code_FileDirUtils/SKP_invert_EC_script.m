section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

rootpath = 'F:\SKP-SC analysis\';

load([rootpath 'SKP_matchkey_ay_original'])

for j=3:3

    id = matchkey{j}.id
    
    dest_basepath = [rootpath id '\' '05-Registration\02-Histo_InterSet_MI_Rigid\'];
    
    for i=1:1
        dest_path = [dest_basepath section_path{i}];
        
        
        filelist = rdir([dest_path  '*_EC.tif']);
        for r=1:length(filelist)
            im = imread(filelist(r).name);
            im =  255-im;
            imwrite(im,filelist(r).name);
        end
    end
    
end


