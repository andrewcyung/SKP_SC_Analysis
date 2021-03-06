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
MRI_filename{3} = '';


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
MRI_orientation{14} = [0 0 1];



dummyim = zeros(256);

for j=14:14


    id = matchkey{j}.id
    
    src_MRI_basepath = ['F:\SKP-SC analysis\' id '\04-Preprocessing\01-rough MRI centroid alignment and cropping\02-Results\'];
    src_histo_path = ['F:\SKP-SC analysis\' id '\01-Original Images\02-Optical Histology\' src_histo_subpath];
    
    
    dest_basepath = ['F:\SKP-SC analysis\' id '\02-Image Correspondences\' correspondence_dir dest_subdir ];
    mkdir(dest_basepath);

    for i=1:5
        src_MRI_path = [src_MRI_basepath section_path{i}];  
        
        startindex = matchkey{j}.histoextent(i,1);
        endindex = matchkey{j}.histoextent(i,2);
        n_histo = endindex-startindex+1;
        
        for q=1:n_histo
            filename = [num2str(startindex-1+q) '.tif'];
            filelist = rdir([src_histo_path filename]);
            if length(filelist)==1
                histo_im{q} = imread([src_histo_path filename],'tif');
            else
                histo_im{q} = dummyim;
            end
        end
        
        n_MRI = length(MRI_filename);
        for k=1:n_MRI
           MRI_im{k} = imread([src_MRI_path MRI_filename{k}]);
            orientation = MRI_orientation{j};
           if orientation(1)
               MRI_im{k} = fliplr(MRI_im{k});
           end

           if orientation(2)
               MRI_im{k} = flipud(MRI_im{k});
           end
           
           if orientation(3)
               MRI_im{k} = MRI_im{k}';
           end
           

        end
  
        
        n_im = n_histo+n_MRI;
        h=figure(1);
        for p=1:n_histo
            figure(h); subplot_tight(1,n_im,p); imshow(histo_im{p}); title(num2str(startindex-1+p));
        end
        
        for p=1:n_MRI
            figure(h); subplot_tight(1,n_im,p+n_histo); imshow(MRI_im{p}); title(MRI_filename{p});
        end
        tightfig;
        set(h,'Position',[0 0 3280 400])
        
        dest_filename = ['MRIvshisto_' section_path{i}(1:(end-1)) '.tif'];
        saveas(h,[dest_basepath dest_filename], 'tif');
    end
end


