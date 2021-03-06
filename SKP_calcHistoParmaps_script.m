load(['F:\SKP-SC analysis\' 'SKP-IDtag']) %loads IDtag
load(['F:\SKP-SC analysis\' 'SKP_matchkey_ay_original']) %loads matchkey
load(['F:\SKP-SC analysis\' 'SKP_status']) %loads status
load(['F:\SKP-SC analysis\' 'SKP_histo_stain']) %loads histo_stain

% for j=[3]
for j=[1:14]

    id = IDtag{j}.id;
    disp(['id =' id]);
    
    HistoSrc_basepath = [rootpath id '\' '04-Preprocessing\05-Histology-CropforIntersetReg\'];
    src_basepath = [rootpath id '\' '06-Transformation\01-HistologyParMaps\02-Results\'];
    seg_basepath = [rootpath id '\' '03-Segmentation\02_Histology\'];
    seg_incl_subpath = '08-Exclusion Areas\';
    seg_whole_subpath = '07-Inclusion Areas for Analysis\'; 
    MRIsrc_basepath = [rootpath id '\' '04-Preprocessing\07-MRI initial flip alignment\02-Results\'];
    
    for i=status{j}.isReg.AxonSum2MRI

        disp(['MRI slice = ' slice_name{i}]);

        MRIsrc_path = [MRIsrc_basepath section_path{i}];
        load([MRIsrc_path 'TrW.mat']); %loads original imTrW
        
        n_stain = length(histo_stain);
        for k=1:n_stain
            disp(['stain = ' histo_stain{k}.name]);
            if ~histo_stain{k}.runParMaps
                continue; % go to next iteration in for loop
            end
            
            ROIgrid_matfilename = ['ROIGrid_' id '_' slice_name{i} '_' histo_stain{k}.name '.mat'];
            ROIgrid_filelist = rdir([src_basepath ROIgrid_matfilename]);
            if length(ROIgrid_filelist)==0
                continue; %mat file not found; go to next for loop iteration
            else
                load([src_basepath ROIgrid_matfilename]); %loads ROIgrid,ROIgrid_i,ROIgrid_j,goodSection_index
                HistoSrc_path = [HistoSrc_basepath histo_stain{k}.setdir '\' histo_stain{k}.dirname];
                threshold_seg_pathname = [seg_basepath histo_stain{k}.setdir '\' histo_stain{k}.segmapdir '\'];
                segmap = {};
                wholemask = {};
                inclmask = {};
                exclmask = {};
                section_im = {};
                wholesection_seg_pathname = [seg_basepath histo_stain{k}.setdir '\' seg_whole_subpath histo_stain{k}.main_ROI_staindir '\']
                incl_seg_pathname = [seg_basepath histo_stain{k}.setdir '\' seg_incl_subpath histo_stain{k}.main_ROI_staindir '\'];
                
                goodSection_index = num2cell(setdiff(cell2mat(goodSection_index),matchkey{j}.excludelist{histo_stain{k}.setindex}));
                n_sections = length(goodSection_index);
                for r=1:n_sections
                    curr_index = goodSection_index{r};
                    disp(['section # =' num2str(curr_index)]); 
                    section_im{r} = imread([HistoSrc_path num2str(curr_index) '.tif']);
                    if histo_stain{k}.runParMaps
                        threshold_seg_filename = [threshold_seg_pathname num2str(curr_index) '.ov' num2str(histo_stain{k}.seg_ovnum)];
                        if exist(threshold_seg_filename,'file')
                            segmap{r} = imread(threshold_seg_filename);
                        else
                            segmap{r} = false(size(section_im{r}));
                        end
                        wholemask{r} = imread([wholesection_seg_pathname num2str(curr_index) '.ov1']);
                        inclmask = imread([incl_seg_pathname num2str(curr_index) '.ov1']);
                        exclmask{r} = xor(inclmask,wholemask{r});
                        segmap{r} = segmap{r} & inclmask;
                        segmap_with_exclmask{r} = uint8(segmap{r} & ~exclmask{r});
                    end
                end
            end
            
            [AreaFraction, AvgOD_Whole, AvgOD_AboveThresh, IntegOD_AboveThresh, InclMask] = makeHistoParmaps(section_im,segmap,exclmask,wholemask,ROIgrid,ROIgrid_i,ROIgrid_j,size(imTrW));
            h3=figure(3);
            set(h3,'Position',[0 0 2000 800])
            colormap gray
            h3=figure(3);subplot_tight(1,5,1);imagesc(AreaFraction); axis off; axis image; caxis([0 1]); title([histo_stain{k}.name ' Area Fraction'])
            h3=figure(3);subplot_tight(1,5,2);imagesc(AvgOD_Whole); axis off; axis image; caxis([0 255]); title([histo_stain{k}.name ' AvgOD Whole'])
            h3=figure(3);subplot_tight(1,5,3);imagesc(AvgOD_AboveThresh); axis off; axis image; caxis([0 255]); title([histo_stain{k}.name ' AvgOD Thresh'])
            h3=figure(3);subplot_tight(1,5,4);imagesc(IntegOD_AboveThresh); axis off; axis image; title([histo_stain{k}.name ' IntegOD Thresh'])
            h3=figure(3);subplot_tight(1,5,5);imagesc(InclMask); axis off; axis image; title([histo_stain{k}.name ' InclMask'])
            tightfig;
            fig_filename = ['HistoParMap_' id '_' slice_name{i} '_' histo_stain{k}.name '.jpg'];
            saveas(h3,[src_basepath '\' fig_filename],'jpg');
            
            HistoParmap_matfilename = ['HistoParMap_' id '_' slice_name{i} '_' histo_stain{k}.name '.mat'];
            save([src_basepath HistoParmap_matfilename],'AreaFraction','AvgOD_Whole','AvgOD_AboveThresh','IntegOD_AboveThresh','InclMask');
            save([src_basepath 'Segmap_with_exclmask_' id '_' slice_name{i} '_' histo_stain{k}.name '.mat'],'segmap_with_exclmask');
            
            HistoParmap_thumbnailname{1} = ['HistoParMap_' id '_' slice_name{i} '_' histo_stain{k}.name '_AvgOD_Whole.tif'];
            HistoParmap_thumbnailname{2} = ['HistoParMap_' id '_' slice_name{i} '_' histo_stain{k}.name '_AvgOD_AboveThresh.tif'];
            HistoParmap_thumbnailname{3} = ['HistoParMap_' id '_' slice_name{i} '_' histo_stain{k}.name '_AreaFraction.tif'];
            HistoParmap_thumbnailname{4} = ['HistoParMap_' id '_' slice_name{i} '_' histo_stain{k}.name '_IntegOD_AboveThresh.tif'];
            HistoParmap_thumbnailname{5} = ['HistoParMap_' id '_' slice_name{i} '_' histo_stain{k}.name '_InclMask.tif'];
            
            im = mat2gray(AvgOD_Whole); imwrite(im,[src_basepath HistoParmap_thumbnailname{1}]);
            im = mat2gray(AvgOD_AboveThresh); imwrite(im,[src_basepath HistoParmap_thumbnailname{2}]);
            im = mat2gray(AreaFraction); imwrite(im,[src_basepath HistoParmap_thumbnailname{3}]);
            im = mat2gray(IntegOD_AboveThresh); imwrite(im,[src_basepath HistoParmap_thumbnailname{4}]);
            im = mat2gray(InclMask); imwrite(im,[src_basepath HistoParmap_thumbnailname{5}]);

        end
    end
end