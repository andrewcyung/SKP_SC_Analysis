section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

load(['F:\SKP-SC analysis\' 'SKP_matchkey_ay_original'])

filename_ay = cell(5,1);
filename_lw = cell(5,1);

for j=1:14

    id = matchkey{j}.id
%     src_lw_basepath = ['F:\SKP-SC analysis\' id '\02-Image Correspondences\01-MRI-HistologySet1-3Leo_10x\01-MRIvsSet1_original\'];
%     src_ay_basepath = ['F:\SKP-SC analysis\' id '\02-Image Correspondences\02-MRI-HistologySet1-3Andrew_10x\01-MRIvsSet1_original\'];
    src_lw_basepath = ['F:\SKP-SC analysis\' id '\02-Image Correspondences\01-MRI-HistologySet1-3Leo_10x\03-MRIvsSet3_original\'];
    src_ay_basepath = ['F:\SKP-SC analysis\' id '\02-Image Correspondences\02-MRI-HistologySet1-3Andrew_10x\03-MRIvsSet3_original\'];
    
    
    dest_basepath = ['F:\SKP-SC analysis\Group Results\01-MRIhisto-AYvsLeo\'];

    
    for i=1:5
        filename_ay{i} = [src_ay_basepath 'MRIvshisto_' section_path{i}(1:(end-1)) '.tif'];
        filename_lw{i} = [src_lw_basepath 'MRIvshisto_' section_path{i}(1:(end-1)) '.tif'];
    end

    h=figure(1);
    subplot_tight(6,2,1); imshow(filename_lw{1}); title('edge caudal');
    subplot_tight(6,2,2); imshow(filename_lw{2}); title('mid caudal');
    subplot_tight(6,2,3); imshow(filename_ay{1});
    subplot_tight(6,2,4); imshow(filename_ay{2});
    subplot_tight(6,2,5); imshow(filename_lw{3});title('epicentre');
    subplot_tight(6,2,6); imshow(filename_lw{4});title('mid cranial');
    subplot_tight(6,2,7); imshow(filename_ay{3});
    subplot_tight(6,2,8); imshow(filename_ay{4});
    subplot_tight(6,2,9); imshow(filename_lw{5});title('edge cranial');
    subplot_tight(6,2,11); imshow(filename_ay{5});
    
    
    tightfig;
    set(h,'Position',[0 0 2000 1000])
    
%     dest_filename = ['MRIhisto_LWvsAY_Set1_' id '.tif'];
    dest_filename = ['MRIhisto_LWvsAY_Set3_' id '.tif'];
    saveas(h,[dest_basepath dest_filename], 'tif');

    
end


