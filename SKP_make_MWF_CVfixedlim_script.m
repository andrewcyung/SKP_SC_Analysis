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

T2cutoff = 20;
TE=6.738/1000;
n_echoes = 32;
te_temp = (TE*1000):(TE*1000):(TE*1000*n_echoes);
T2Times=te_temp(1)+exp(((0:100)+1)/101*log(1500)); % 7T way

for j=1:14

    id = IDtag{j}.id
    src_basepath = [rootpath id '\' '04-Preprocessing\07-MRI initial flip alignment\02-Results\'];
    for i=1:5 %iterate MRI slice position
        src_path = [src_basepath section_path{i}];
        load([src_path 'CPMG_T2dist_CVvarlim']); %load imT2dist_CVvarlim
        imsize = size(imT2dist_CVvarlim);
        imT2dist = imT2dist_CVvarlim;
        imMWF_CVfixedlim = zeros(imsize(1:2));
        for i_row = 1:imsize(1)
            for i_col = 1:imsize(2)
                currT2dist = squeeze(imT2dist_CVvarlim(i_row,i_col,:));
                imMWF_CVfixedlim(i_row,i_col) = sum(currT2dist(T2Times<T2cutoff))/sum(currT2dist);
            end
        end
        imwrite(mat2gray(imMWF_CVfixedlim), [src_path 'imMWF_CVfixedlim.png'],'png');

        save([src_path 'CPMG_T2dist_CVfixedlim.mat'],'imT2dist');
        save([src_path 'CPMG_MWF_CVfixedlim.mat'],'imMWF_CVfixedlim');
    end
end


