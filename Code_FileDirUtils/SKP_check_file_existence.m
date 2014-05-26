rootpath = 'F:\SKP-SC analysis\'

load([rootpath 'SKP-IDtag'])
section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';


for j=1:14
    id = IDtag{j}.id;
    dest_basepath = [rootpath id '\' '04-Preprocessing\07-MRI initial flip alignment\02-Results\'];
    src_basepath = dest_basepath;
    
    for i=status{j}.isReg.AxonSum2MRI
        pathname = [dest_basepath section_path{i} 'imFA-label.png'];
        if exist(pathname) ~= 2
            disp([pathname ' not found']);
        end
    end            
            
end