rootpath = 'F:\SKP-SC analysis\';

section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

load(['F:\SKP-SC analysis\' 'SKP-IDtag']) %loads IDtag
load(['F:\SKP-SC analysis\' 'SKP_matchkey_ay_original']) %loads matchkey
load(['F:\SKP-SC analysis\' 'SKP-histomap_id']) %loads histomap_id
load(['F:\SKP-SC analysis\' 'SKP_status']) %loads status

i_TRE = 1;
for j=1:14
    id = IDtag{j}.id
    src_basepath = [rootpath id '\' '05-Registration\04-MRI_AxonSum_MI_Affine\02-Results\'];
    if status{j}.isTREcalc
        for i=1:5
            src_path = [src_basepath section_path{i}];
            TRE_histo_filename = rdir([src_path 'TRE_histo.fcsv']);
            TRE_MRI_filename =  rdir([src_path 'TRE_MRI.fcsv']);
            if length(TRE_histo_filename)==1 && length(TRE_MRI_filename)==1
                histo_fid = read_fcsv_file(TRE_histo_filename.name);
                MRI_fid = read_fcsv_file(TRE_MRI_filename.name);
                n_pts = length(histo_fid);
                for k=1:n_pts
                    TRE(i_TRE) = sqrt((histo_fid{k}(1)-MRI_fid{k}(1))^2 + (histo_fid{k}(2)-MRI_fid{k}(2))^2);
                    i_TRE = i_TRE+1;
                end
            end
        
        end
        
    end

end

TRE = TRE/80/10;
TRE_avg = mean(TRE)
TRE_std = std(TRE)