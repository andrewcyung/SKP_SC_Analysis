rootpath = 'F:\SKP-SC analysis\';

section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

slice_name{1} = '1EdgeCaudal';
slice_name{2} = '2MidCaudal';
slice_name{3} = '3Epicentre';
slice_name{4} = '4MidCranial';
slice_name{5} = '5EdgeCranial';


load(['F:\SKP-SC analysis\' 'SKP-IDtag']) %loads IDtag
load(['F:\SKP-SC analysis\' 'SKP_matchkey_ay_original']) %loads matchkey
load(['F:\SKP-SC analysis\' 'SKP_status']) %loads status
load(['F:\SKP-SC analysis\' 'SKP_histo_stain']) %loads histo_stain

% for j=[1:14]
for j=[1]

    id = IDtag{j}.id;
    disp(['id =' id]);
    
    HistoSrc_basepath = [rootpath id '\' '04-Preprocessing\05-Histology-CropforIntersetReg\'];
    src_basepath = [rootpath id '\' '06-Transformation\01-HistologyParMaps\02-Results\'];
    seg_basepath = [rootpath id '\' '03-Segmentation\02_Histology\'];
    seg_incl_subpath = '08-Exclusion Areas\';
    seg_whole_subpath = '07-Inclusion Areas for Analysis\'; 
    MRIsrc_basepath = [rootpath id '\' '04-Preprocessing\07-MRI initial flip alignment\02-Results\'];
    
%     for i=4
    for i=status{j}.isReg.AxonSum2MRI

        disp(['MRI slice = ' slice_name{i}]);

        MRIsrc_path = [MRIsrc_basepath section_path{i}];
        load([MRIsrc_path 'TrW.mat']); %loads original imTrW
        
        n_stain = length(histo_stain);
        for k=1:n_stain
%           for k=7
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
                HistoSrc_path = [HistoSrc_basepath histo_stain{k}.setdir '\' histo_stain{k}.dirname '\'];
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
                        segmap{r} = imread([threshold_seg_pathname num2str(curr_index) '.ov' num2str(histo_stain{k}.seg_ovnum)]);
                        wholemask = imread([wholesection_seg_pathname num2str(curr_index) '.ov1']);
                        inclmask = imread([incl_seg_pathname num2str(curr_index) '.ov1']);
                        exclmask{r} = xor(inclmask,wholemask);
                        segmap{r} = segmap{r} & inclmask;
                        segmap_with_exclmask{r} = uint8(segmap{r} & ~exclmask{r});
                    end
                end
            end
            
            [AreaFraction, AvgOD_Whole, AvgOD_AboveThresh] = makeHistoParmaps(section_im,segmap,exclmask,ROIgrid,ROIgrid_i,ROIgrid_j,size(imTrW));
            h3=figure(3);
            set(h3,'Position',[0 0 2000 800])
            h3=figure(3);subplot_tight(1,3,1);imagesc(AreaFraction); axis off; axis image; caxis([0 1]); title([histo_stain{k}.name ' Area Fraction'])
            h3=figure(3);subplot_tight(1,3,2);imagesc(AvgOD_Whole); axis off; axis image; caxis([0 255]); title([histo_stain{k}.name ' AvgOD Whole'])
            h3=figure(3);subplot_tight(1,3,3);imagesc(AvgOD_AboveThresh); axis off; axis image; caxis([0 255]); title([histo_stain{k}.name ' AvgOD Thresh'],'Color','g')
            tightfig;
            fig_filename = ['HistoParMap_' id '_' slice_name{i} '_' histo_stain{k}.name '.jpg'];
            saveas(h3,[src_basepath '\' fig_filename],'jpg');
            
            HistoParmap_matfilename = ['HistoParMap_' id '_' slice_name{i} '_' histo_stain{k}.name '.mat'];
            save([src_basepath HistoParmap_matfilename],'AreaFraction','AvgOD_Whole','AvgOD_AboveThresh');
            save([src_basepath 'Segmap_with_exclmask_' id '_' slice_name{i} '_' histo_stain{k}.name '.mat'],'segmap_with_exclmask');
            
            HistoParmap_thumbnailname{1} = ['HistoParMap_' id '_' slice_name{i} '_' histo_stain{k}.name '_AvgOD_Whole.tif'];
            HistoParmap_thumbnailname{2} = ['HistoParMap_' id '_' slice_name{i} '_' histo_stain{k}.name '_AvgOD_AboveThresh.tif'];
            HistoParmap_thumbnailname{3} = ['HistoParMap_' id '_' slice_name{i} '_' histo_stain{k}.name '_AreaFraction.tif'];
            
            im = mat2gray(AvgOD_Whole); imwrite(im,[src_basepath HistoParmap_thumbnailname{1}]);
            im = mat2gray(AvgOD_AboveThresh); imwrite(im,[src_basepath HistoParmap_thumbnailname{2}]);
            im = mat2gray(AreaFraction); imwrite(im,[src_basepath HistoParmap_thumbnailname{3}]);

        end
    end
end