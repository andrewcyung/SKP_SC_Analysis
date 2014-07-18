origdir = pwd;

section_path{1} = '01-edge_caudal';
section_path{2} = '02-mid_caudal';
section_path{3} = '03-epicentre';
section_path{4} = '04-mid_cranial';
section_path{5} = '05-edge_cranial';

load(['F:\SKP-SC analysis\' 'SKP-IDtag'])
load(['F:\SKP-SC analysis\' 'SKP-CPMGDTImatch'])
load(['F:\SKP-SC analysis\' 'SKP-MRImap_id'])
load(['F:\SKP-SC analysis\' 'SKP_MRI_orientation'])
load(['F:\SKP-SC analysis\' 'SKP-upstream_info'])

n_parmap = length(MRImap_id);

cropwidth = [20 20];
fulldim = [256 256];

for j=1:14
% for j=[1:3 5:7 9:14]

% for j=[5]
    
    id = IDtag{j}.id
    src_basepath = ['F:\SKP-SC analysis\' id '\01-Original Images\01-MRI\'];
    dest_basepath = ['F:\SKP-SC analysis\' id '\04-Preprocessing\07-MRI initial flip alignment\02-Results\'];
    load([src_basepath 'MWFgen_ROI_' id]); %contains ROI cell array
    
    for i=1:5
        dest_path = [dest_basepath section_path{i}];
        src_path = [src_basepath section_path{i}];  
        
        % find centroid
        if strcmp(IDtag{j}.DTIdir,'cranial2caudal')
            [x,y] = find(ROI{6-i});
            figure(3); imagesc(ROI{6-i}); colormap gray; axis image;
        else
            [x,y] = find(ROI{i});
            figure(3); imagesc(ROI{i}); colormap gray; axis image;
        end
            
        centroid = round([mean(x) mean(y)]);
        
        cd(src_path);
        
%         for k=1:length(upstream_info)
        for k=17
            disp(upstream_info{k}.filename)
            load([src_path '\' upstream_info{k}.filename '.mat'])
            eval(['im = ' upstream_info{k}.varname ';']);
            if iscell(im)
                im = im{1};
            end
         
            imCentred = circshift(im,[(fulldim/2-centroid) 0]);

%             figure(1);imagesc(imCentred);axis image;colormap gray
            centre = fulldim/2;
            imCropped = imCentred(centre(1)-cropwidth(1):centre(1)+cropwidth(1), ...
                                  centre(2)-cropwidth(2):centre(2)+cropwidth(2), :);
%             h=figure(2);imagesc(imCropped);axis image;colormap gray

            orientation = MRI_orientation{j};

%             curr_MRI_map = imCropped;
%             n_elem = size(curr_MRI_map,3);
%             for i_elem = 1:n_elem
%                 curr_MRImap_elem = squeeze(curr_MRI_map(:,:,i_elem));
%                 
%                 if orientation(1)
%                     curr_MRImap(:,:,i_elem) = flipdim(curr_MRImap_elem,2);
%                 end
%                 if orientation(2)
%                     curr_MRImap(:,:,i_elem) = flipdim(curr_MRImap_elem,1);
%                 end
%                 if orientation(3)
%                     curr_MRImap(:,:,i_elem) = curr_MRImap_elem';
%                 end
%             end
%             imFlipped = curr_MRImap;
            imFlipped = imCropped;
            if orientation(1)
                imFlipped = flipdim(imFlipped,2);
            end
            if orientation(2)
                imFlipped = flipdim(imFlipped,1);
            end
            if orientation(3)
                if upstream_info{k}.n_dim == 2
                    imFlipped = permute(imFlipped,[2 1]);
                else
                    imFlipped = permute(imFlipped,[2 1 3]);
                end
            end

            eval([upstream_info{k}.varname '= imFlipped;']);

            filename = [dest_path '\' upstream_info{k}.filename '.mat'];
            if exist(filename,'file')
                save(filename, upstream_info{k}.varname, '-append');
            else
                save(filename, upstream_info{k}.varname);
            end

            if upstream_info{k}.n_dim == 2
                dest_filename = [dest_path '\' upstream_info{k}.varname '.png'];
                imwrite(mat2gray(imFlipped), dest_filename,'png');
            end
        end
    end
end


cd(origdir);