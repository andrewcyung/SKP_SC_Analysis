rootpath = 'F:\SKP-SC analysis\';

section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

MRI_varname = {'imADC'; ...
                'imAlpha'; ...
                'CPMG_echo10'; ...
                'imDlong'; ...
                'imDn'; ...
                'imDtrans'; ...
                'imFA'; ...
                'imMisfit'; ...
                'imMWF'; ...
                'imSNR'; ...
                'imTrW'};
             
MRI_matname = {'ADC.mat'; ...
                'CPMG_flipangle.mat'; ...
                'CPMG_echo10.mat'; ...
                'Dlong.mat'; ...
                'CPMG_dn.mat'; ...
                'Dtrans.mat'; ...
                'FA.mat'; ...
                'CPMG_misfit.mat'; ...
                'CPMG_MWF.mat'; ...
                'CPMG_SNR.mat'; ...
                'TrW.mat'};

load(['F:\SKP-SC analysis\' 'SKP-IDtag'])
           
n_MRI = length(MRI_matname);            
            
for j=7:7

    id = IDtag{j}.id

    src_basepath = [rootpath id '\' '04-Preprocessing\07-MRI initial flip alignment\02-Results\'];
    dest_basepath = [rootpath id '\' '04-Preprocessing\04-MRI upsampling\02-Results\'];
    
    for i=1:5 %iterate MRI slice position
        src_path = [src_basepath section_path{i}];
        dest_path = [dest_basepath section_path{i}];
        mkdir(dest_path);
        for k=1:n_MRI
            load([src_path MRI_matname{k}]);
            eval(['curr_MRImap = ' MRI_varname{k} ';']);
            interp_MRImap = imresize(curr_MRImap,2,'bilinear');
            interp_MRImap = imresize(interp_MRImap,40,'nearest');
            eval([MRI_varname{k} ' = interp_MRImap;']);
            save([dest_path MRI_matname{k}],MRI_varname{k});
            
            dest_filename = [dest_path MRI_varname{k} '.png'];
            if strcmp(MRI_varname{k},'imDlong') || ...
                    strcmp(MRI_varname{k},'imDtrans') || ...
                    strcmp(MRI_varname{k},'imADC')
                
                h=figure(2);imagesc(interp_MRImap);colormap(jet);caxis([0 1.5e-3]);axis off
                set(gca,'position',[0 0 1 1],'units','normalized')
                saveas(h,dest_filename);
            else
                imwrite(mat2gray(interp_MRImap), dest_filename);
            end

            
        end
        
    end
end


