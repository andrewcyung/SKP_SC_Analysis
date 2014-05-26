section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

rootpath = 'F:\SKP-SC analysis\';


load([rootpath 'SKP_matchkey_ay_original'])

for j=2:2

    id = matchkey{j}.id
    src_basepath = [rootpath id '\' '05-Registration\05-Axon_BtwnSectionSmooth_Rigid\01-Source data\'];
      
    dest_basepath = [rootpath id '\' '05-Registration\05-Axon_BtwnSectionSmooth_Rigid\02-Results\'];
    
    for i=1:1
        dest_path = [dest_basepath section_path{i}];
        mkdir(dest_path);
        startindex = matchkey{j}.histoextent(i,1);
        endindex = matchkey{j}.histoextent(i,2);
        n_histo = endindex-startindex+1;

        for q=1:n_histo
            filename_base = [num2str(startindex-1+q)];
            filelist = rdir([src_basepath filename_base '.*']);
            for r=1:length(filelist)
                copyfile(filelist(r).name,dest_path);
            end
        end
        
    end


    
end


