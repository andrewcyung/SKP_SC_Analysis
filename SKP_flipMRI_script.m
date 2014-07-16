rootpath = 'F:\SKP-SC analysis\';

section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

load(['F:\SKP-SC analysis\' 'SKP-IDtag'])
load(['F:\SKP-SC analysis\' 'SKP-CPMGDTImatch'])
load(['F:\SKP-SC analysis\' 'SKP-MRImap_id'])
load(['F:\SKP-SC analysis\' 'SKP_MRI_orientation'])
           
n_MRI = length(MRImap_id);            
            

% for j=[1:3 5:7 9:14]

for j=1:14

    id = IDtag{j}.id
    src_basepath = ['F:\SKP-SC analysis\' id '\04-Preprocessing\01-rough MRI centroid alignment and cropping\02-Results\'];

%     src_basepath = [rootpath id '\' '04-Preprocessing\07-MRI initial flip alignment\01-Source data\'];
    dest_basepath = [rootpath id '\' '04-Preprocessing\07-MRI initial flip alignment\02-Results\'];
    
    for i=1:5 %iterate MRI slice position
        src_path = [src_basepath section_path{i}];
        dest_path = [dest_basepath section_path{i}];
        if ~exist(dest_path,'dir')
            mkdir(dest_path);
        end
%         for k=1:n_MRI
        for k=13:16

            
            load([src_path MRImap_id{k}.filename]);
            eval(['curr_MRImap = ' MRImap_id{k}.varname ';']);
            orientation = MRI_orientation{j};
            if strcmp(curr_MRImap,'imT2dist')
                n_elements = size(curr_MRImap,3);
            else
                if orientation(1)
                    curr_MRImap = flipdim(curr_MRImap,2);
                end
                if orientation(2)
                    curr_MRImap = flipdim(curr_MRImap,1);
                end
                if orientation(3)
                    curr_MRImap = curr_MRImap';
                end
            end
            eval([MRImap_id{k}.varname ' = curr_MRImap;']);
            save([dest_path MRImap_id{k}.filename],MRImap_id{k}.varname);
            
            dest_filename = [dest_path MRImap_id{k}.varname '.png'];
            if strcmp(MRImap_id{k}.varname,'imDlong') || ...
                    strcmp(MRImap_id{k}.varname,'imDtrans') || ...
                    strcmp(MRImap_id{k}.varname,'imADC')
                im = mat2gray(curr_MRImap);
                imwrite(im,dest_filename);
%                 h=figure(2);imagesc(curr_MRImap),colormap(jet);caxis([0 1.5e-3]);axis off
%                 set(gca,'position',[0 0 1 1],'units','normalized')
%                 saveas(h,dest_filename);
            else
                imwrite(mat2gray(curr_MRImap), dest_filename);
            end

            
        end
        
    end
end


