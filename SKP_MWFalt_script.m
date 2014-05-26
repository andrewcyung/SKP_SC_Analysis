rootpath = 'F:\SKP-SC analysis\';

section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

% dest_subdir = '01-MRIvsSet1_original\';
% dest_subdir = '02-MRIvsSet2_original\';
dest_subdir = '03-MRIvsSet3_original\';

% correspondence_dir = '01-MRI-HistologySet1-3Leo_10x\';
% load(['F:\SKP-SC analysis\' 'SKP_matchkey_leo_original'])
correspondence_dir = '02-MRI-HistologySet1-3Andrew_10x\';
load(['F:\SKP-SC analysis\' 'SKP_matchkey_ay_original'])

% src_histo_subpath = '01_Set 1 - P0_GFAP_GFP_10x\04-Merged\';
% src_histo_subpath = '02_Set 2 - MBP_Axons_10x\04-merged\';
src_histo_subpath = '03_Set 3 - Eriochrome_10x\';
MRI_filename{1} = 'imTrW.png';
MRI_filename{2} = 'CPMG_echo10.png';
MRI_filename{3} = ''


% flipLR flipUD transpose
MRI_orientation{1} = [1 0 0];
MRI_orientation{2} = [1 0 0];
MRI_orientation{3} = [1 0 0];
MRI_orientation{4} = [1 0 0];
MRI_orientation{5} = [0 0 1];
MRI_orientation{6} = [0 1 1];
MRI_orientation{7} = [1 0 0];
MRI_orientation{8} = [1 0 0];
MRI_orientation{9} = [0 1 0];
MRI_orientation{10} = [1 1 1];
MRI_orientation{11} = [0 0 1];
MRI_orientation{12} = [0 0 0];
MRI_orientation{13} = [0 1 0];
MRI_orientation{14} = [1 1 0];



dummyim = zeros(256);
TE=6.738/1000;
n_echoes = 32;
te_temp = (TE*1000):(TE*1000):(TE*1000*n_echoes);
T2Times=te_temp(1)+exp(((0:100)+1)/101*log(1500)); % 7T way



for j=1:14


    id = matchkey{j}.id
    
    src_MRI_basepath = [rootpath id '\01-Original Images\01-MRI\'];
    load([src_MRI_basepath 'MWFgen_ROI_' id '.mat']);

    for i=1:5
        src_MRI_path = [src_MRI_basepath section_path{i}];  
        load CPMG_T2dist.mat %loads imT2dist
        imMWF_alt = zeros(256);
        imShortT2 = zeros(256);
        imLongT2 = zeros(256);
        
        for m=1:256
            for n=1:256
              if ROI{i}(m,n)
                    [imShortT2(m,n) imLongT2(m,n) imMWF_alt(m,n)] = calc_CPMG_alt(squeeze(imT2dist(m,n,:)),T2Times);
                end
            end
        end
        
        save([src_MRI_path 'CPMG_MWF_alt'], 'imMWF_alt');
        save([src_MRI_path 'CPMG_shortT2'], 'imShortT2');
        save([src_MRI_path 'CPMG_longT2'], 'imLongT2');
        

    end
end
