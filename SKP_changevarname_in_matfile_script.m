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
    src_basepath = [rootpath id '\' '04-Preprocessing\07-MRI initial flip alignment\02-Results\'];
    src_basepath = [rootpath id '\' '01-Original Images\01-MRI\'];
    
    for i=1:5 %iterate MRI slice position
        src_path = [src_basepath section_path{i}];
        load([src_path 'CPMG_T2dist_fixedmisfit005']);
        load([src_path 'CPMG_MWF_fixedmisfit005']);
        load([src_path 'CPMG_GoF_fixedmisfit005']);

        imT2dist_fixedmisfit005 = imT2dist_fixedmisfit;
        imMWF_fixedmisfit005 = imMWF_fixedmisfit;
        imGoF_fixedmisfit005 = imGoF_fixedmisfit;
        
        save([src_path 'CPMG_T2dist_fixedmisfit005'],'imT2dist_fixedmisfit005');
        save([src_path 'CPMG_MWF_fixedmisfit005'],'imMWF_fixedmisfit005');
        save([src_path 'CPMG_GoF_fixedmisfit005'],'imGoF_fixedmisfit005');
        
    end
end


