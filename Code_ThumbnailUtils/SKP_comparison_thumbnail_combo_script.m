rootpath = 'F:\SKP-SC analysis\';

section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

MRI_thumbname = {'imADC.png'; ...
                'imAlpha.png'; ...
                'imCPMG_echo10.png'; ...
                'imDlong.png'; ...
                'imDn.png'; ...
                'imDtrans.png'; ...
                'imFA.png'; ...
                'imMisfit.png'; ...
                'imMWF.png'; ...
                'imSNR.png'; ...
                'imTrW'};
             
MRI_matname = {'ADC.mat'; ...
                'CPMG_flipangle.mat'; ...
                'CPMG_echo10.mat'; ...
                'Dlong.mat'; ...
                'CPMG_dn.mat'; ...
                'Dtrans.mat'; ...
                'FA.mat'; ...
                'CMPG_misfit.mat'; ...
                'CPMG_MWF.mat'; ...
                'CPMG_SNR.mat'; ...
                'TrW.mat'};

n_MRI = length(MRI_matname);            
            
% flipLR flipUD transpose
MRI_orientation{1} = [1 0 0];
MRI_orientation{2} = [1 0 0];
MRI_orientation{3} = [1 0 0];
MRI_orientation{4} = [0 0 0];
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

for j=14:14

    id = matchkey{j}.id

    src_basepath = [rootpath id '04-Preprocessing\07-MRI initial flip alignment\01-Source data'];
    dest_basepath = [rootpath id '04-Preprocessing\07-MRI initial flip alignment\02-Results'];

    for i=1:5 %iterate MRI slice position
        dest_path = [dest_basepath section_path{i}];
        for k=1:n_MRI
            MRI_im{k} = imread([src_MRI_path MRI_thumbname{k}]);
            orientation = MRI_orientation{j};
            if orientation(1)
                MRI_im{k} = flipdim(MRI_im{k},2);
            end
            if orientation(2)
                MRI_im{k} = flipdim(MRI_im{k},1);
            end
            if orientation(3)
                try
                    MRI_im{k} = MRI_im{k}';
                catch exception
                    MRI_im{k} = imrotate(MRI_im{k},90);
                    MRI_im{k} = flipdim(MRI_im{k},1);
                end
            end
        end
        
        n_im = n_histo+n_MRI;
        for p=1:n_histo
            figure(h); subplot_tight(n_disprows,n_im,(z-1)*n_im+p); imshow(histo_im{p}); title(num2str(startindex-1+p));
        end
        
        for p=1:n_MRI
            figure(h); subplot_tight(n_disprows,n_im,(z-1)*n_im+p+n_histo); imshow(MRI_im{p}); title(MRI_filename{z}{p}(1:(end-4)));
        end
        %             set(h,'Position',[0 0 3280 4000])
        
        tightfig;
        
        dest_filename = ['MRIvshisto_' id '_' section_path{i}(1:(end-1)) '.tif'];
        saveas(h,[dest_basepath dest_filename], 'tif');
        
        
    end
end


