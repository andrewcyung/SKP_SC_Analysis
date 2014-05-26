origdir = pwd;

section_path{1} = '01-edge_caudal';
section_path{2} = '02-mid_caudal';
section_path{3} = '03-epicentre';
section_path{4} = '04-mid_cranial';
section_path{5} = '05-edge_cranial';

load(['F:\SKP-SC analysis\' 'SKP-IDtag'])
load(['F:\SKP-SC analysis\' 'SKP-parmap_id'])

n_parmap = length(parmap_id);

for j=1:14
    id = IDtag{j}.id
    src_basepath = ['F:\SKP-SC analysis\' id '\03-Segmentation\01_MRI\02-ManualPieSlices\01-Source data\'];
    dest_basepath = ['F:\SKP-SC analysis\' id '\03-Segmentation\01_MRI\02-ManualPieSlices\02-Results\'];
    
    for i=1:5
        dest_path = [dest_basepath section_path{i} '\'];
        src_path = [src_basepath section_path{i} '\'];
        mkdir(dest_path);
        
        symlinker_file('imTrW.png',src_path,dest_path);
        symlinker_file('CPMG_echo10.png',src_path,dest_path);
        symlinker_file('imADC.png',src_path,dest_path);
        symlinker_file('imMWF.png',src_path,dest_path);
        symlinker_file('imFA.png',src_path,dest_path);
        symlinker_file('imTrW-label.nrrd',src_path,dest_path);

        
%         
%         cd(src_path);
%         
%         for k=1:n_parmap
%             load([src_path '\' parmap_id{k}.filename '.mat'])
%             eval(['im = ' parmap_id{k}.varname ';']);
% 
%             if parmap_id{k}.isDisplayed
%                 figure(4); imagesc(im); axis image; colormap gray
%             end
%             
%             imCentred = circshift(im,fulldim/2-centroid);
% 
%             figure(1);imagesc(imCentred);axis image;colormap gray
%             centre = fulldim/2;
%             imCropped = imCentred(centre(1)-cropwidth(1):centre(1)+cropwidth(1), ...
%                                   centre(2)-cropwidth(2):centre(2)+cropwidth(2));
%             h=figure(2);imagesc(imCropped);axis image;colormap gray
% 
%             if parmap_id{k}.isDisplayed
%                 imwrite(mat2gray(imCropped), [dest_path '\' parmap_id{k}.varname '.png'],'png');
%             end
%             
%             eval([parmap_id{k}.varname '= imCropped;']);
% 
%         save([dest_path '\' parmap_id{k}.filename '.mat'], parmap_id{k}.varname);

%         end
    end
end


cd(origdir);