rootpath = 'F:\SKP-SC analysis\';

section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

load(['F:\SKP-SC analysis\' 'SKP-IDtag'])
load(['F:\SKP-SC analysis\' 'SKP_MRI_orientation']) %loads MRI_orientation

png_name = 'imTrW-label';

for j=14:14
    
    id = IDtag{j}.id
    
    dest_basepath = [rootpath id '\' '04-Preprocessing\07-MRI initial flip alignment\02-Results\'];
    
    for i=status{j}.isReg.AxonSum2MRI
        dest_path = [dest_basepath section_path{i}];
        srcfile = [dest_path png_name '.png'];
        destfile = [dest_path png_name '_flip.png'];
        curr_im = imread(srcfile);
        orientation = MRI_orientation{j};

        if orientation(1)
            curr_im = flipdim(curr_im,2);
        end
        if orientation(2)
            curr_im = flipdim(curr_im,1);
        end
        if orientation(3)
            curr_im = curr_im';
        end
        imwrite(mat2gray(curr_im), destfile);
    end
end


