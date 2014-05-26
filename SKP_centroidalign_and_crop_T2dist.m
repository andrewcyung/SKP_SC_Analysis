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

n_parmap = length(MRImap_id);

cropwidth = [20 20];
fulldim = [256 256];

for j=1:14
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
        
        for k=12
            load([src_path '\' MRImap_id{k}.filename '.mat'])
            eval(['im = ' MRImap_id{k}.varname ';']);
         
            imCentred = circshift(im,[(fulldim/2-centroid) 0]);

%             figure(1);imagesc(imCentred);axis image;colormap gray
            centre = fulldim/2;
            imCropped = imCentred(centre(1)-cropwidth(1):centre(1)+cropwidth(1), ...
                                  centre(2)-cropwidth(2):centre(2)+cropwidth(2), :);
%             h=figure(2);imagesc(imCropped);axis image;colormap gray

            orientation = MRI_orientation{j};
            if orientation(1)
                imFlipped = flipdim(imCropped,2);
            end
            if orientation(2)
                imFlipped = flipdim(imCropped,1);
            end
            if orientation(3)
                imFlipped = permute(imCropped,[2 1 3]);
            end

            eval([MRImap_id{k}.varname '= imFlipped;']);

            save([dest_path '\' MRImap_id{k}.filename '.mat'], MRImap_id{k}.varname);

        end
    end
end


cd(origdir);