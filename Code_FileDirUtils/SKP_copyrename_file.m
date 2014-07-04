rootpath = 'F:\SKP-SC analysis\'

load([rootpath 'SKP-IDtag'])
section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';


for j=1:14
    id = IDtag{j}.id;
    dest_basepath = [rootpath id '\' '06-Transformation\01-HistologyParMaps\02-Results\'];
    src_basepath = dest_basepath;

    filelist = rdir([src_basepath 'ROIGrid*P0.mat']);
    n_files = length(filelist);
    for i=1:n_files
       filename = filelist(i).name;
       [pathname,filename,ext] = fileparts(filename);
       newfilename = [filename(1:end-2) 'GFPSet1' ext];
       src_path = [src_basepath filename ext];
       dest_path = [dest_basepath newfilename];
       copyfile(src_path,dest_path);
    end
%     
%     for i=status{j}.isReg.AxonSum2MRI
%         src_path = [src_basepath section_path{i} 'imTrW-label_flip.png']; 
%         dest_path = [dest_basepath section_path{i} 'imFA-label.png'];
%         copyfile(src_path,dest_path);
%     end            
%             
end