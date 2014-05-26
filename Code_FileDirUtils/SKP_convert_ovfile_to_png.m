rootpath = 'F:\SKP-SC analysis\'

load([rootpath 'SKP-IDtag'])
section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';


for j=14:14
    id = IDtag{j}.id;
    src_basepath = [rootpath id '\' '03-Segmentation\01_MRI\01-ManualWholeSection\02-Results\'];
%     dest_basepath = src_basepath;
    dest_basepath = [rootpath id '\' '04-Preprocessing\07-MRI initial flip alignment\02-Results\'];

    
    
%     ov_filelist = rdir([src_basepath '*.ov1']);
%     n_ov = length(ov_filelist);
%     for i=1:n_ov
%         [pathstr basename extname] = fileparts(ov_filelist(i).name);
% %         ov_filepath = ov_filelist(i).name
%         ov_filepath = [pathstr basename '-label' extname];
%         status =ov2pngfile(ov_filepath);
%     end
    
    for i=status{j}.isReg.AxonSum2MRI
        src_path = [src_basepath section_path{i} '\']; 
        dest_path = [dest_basepath section_path{i}];
        ov_filelist = rdir([src_path '*.ov1']);
        n_ov = length(ov_filelist);
        for i=1:n_ov
            [pathstr basename extname] = fileparts(ov_filelist(i).name);
            movefile(ov_filelist(i).name,[pathstr '\' basename '-label' extname]);
            ov_filepath = [pathstr '\' basename '-label' extname];
            outmsg =ov2pngfile(ov_filepath);
            srcpngpath = [pathstr '\' basename '-label.png'];
            destpngpath = [dest_path basename '-label.png'];
            movefile(srcpngpath,destpngpath);
        end
    end            
            
end