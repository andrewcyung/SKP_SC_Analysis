rootpath = 'F:\SKP-SC analysis\';

section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

load(['F:\SKP-SC analysis\' 'SKP-IDtag']) %loads IDtag
load(['F:\SKP-SC analysis\' 'SKP_matchkey_ay_original']) %loads matchkey
load(['F:\SKP-SC analysis\' 'SKP-histomap_id']) %loads histomap_id

MRImask_filename = 'imTrW-label.nrrd';
HistoSum_filename = 'sum_image.tif';
srcMRI = 'imTrW';
tfm_filename_MRI2HistoSum = 'imTrW_tfm1.tfm';
MRI_interpscale = 80;

AxonSection_pixsize = 0.35278;

SeeResults = 0;

tfm_identity = maketform('affine',[1 0; 0 1; 0 0]);

for j=8:8
    
    id = IDtag{j}.id;
    MRImask_basepath = [rootpath id '\' '03-Segmentation\01_MRI\01-ManualWholeSection\02-Results\'];
    MRIsrc_basepath = [rootpath id '\' '04-Preprocessing\07-MRI initial flip alignment\02-Results\'];
    HistoSrc_basepath = [rootpath id '\' '01-Original Images\02-Optical Histology\'];
    AxonTfm_basepath = [rootpath id '\' '05-Registration\05-Axon_BtwnSectionSmooth_Rigid\02-Results\'];
    HistoSum_basepath = [rootpath id '\' '05-Registration\06-MRI_Axon_MI_BSpline\02-Results\'];
    MRI2Histo_basepath = [rootpath id '\' '05-Registration\06-MRI_Axon_MI_BSpline\02-Results\'];
    HistoAxonSection_basepath = [rootpath id '\' '05-Registration\05-Axon_BtwnSectionSmooth_Rigid\02-Results\'];
    HistoDestSection_basepath = [rootpath id '\' '05-Registration\03-Histo_InterSet_MI_Rigid\'];
    dest_basepath = [rootpath id '\' '06-Transformation\01-HistologyParMaps\02-Results\'];
    seg_basepath = [rootpath id '\' '03-Segmentation\02_Histology\'];
    
    
    for i=1:1
        MRImask_path = [MRImask_basepath section_path{i}];
        MRIsrc_path = [MRIsrc_basepath section_path{i}];
        HistoSum_path = [HistoSum_basepath section_path{i}];
        AxonTfm_path = [AxonTfm_basepath section_path{i}];
        HistoDestSection_path = [HistoDestSection_basepath section_path{i}];
        MRI2Histo_path = [MRI2Histo_basepath section_path{i}];
        dest_path = [dest_basepath section_path{i}];
        
        % show warping of MRI pixel grid to the composite histology image
        MRI_ROI = fliplr(logical(nrrdread([MRImask_path MRImask_filename])));
        load([MRIsrc_path 'TrW.mat']); %loads original imTrW
        srcMRI = imTrW;
        interpMRI = imresize(srcMRI,2,'bilinear');
        interpMRI = imresize(interpMRI,40,'nearest');
        
        tfm_MRI2HistoSum = load_tfm_b([MRI2Histo_path tfm_filename_MRI2HistoSum],1);
        
        MRIpix_index = find(MRI_ROI);
        [MRIpix_i MRIpix_j] = ind2sub(size(MRI_ROI),MRIpix_index);
        n_MRIpix = length(MRIpix_index);
        
        MRIpix_boundx = cell(1,n_MRIpix);
        MRIpix_boundy = cell(1,n_MRIpix);
        for q=1:n_MRIpix
            [MRIpix_boundx{q} MRIpix_boundy{q}] = getMRpixelboundaries(MRIpix_j(q),MRIpix_i(q),MRI_interpscale,MRI_interpscale);
        end
        
        HistoSum = imread([HistoSum_path HistoSum_filename]);
        HistoSum_boundx = cell(1,n_MRIpix);
        HistoSum_boundy = cell(1,n_MRIpix);
        if SeeResults
%             figure(1); subplot(1,4,1); hold off; imagesc(interpMRI); colormap gray; axis image; axis off; hold on;
%             figure(1); subplot(1,4,2); hold off; imagesc(HistoSum); colormap gray; axis image, axis off; hold on;
        end
        for q=1:n_MRIpix
            [HistoSum_boundx{q}, HistoSum_boundy{q}] = MR_to_SingleHist_xy(MRIpix_boundx{q},MRIpix_boundy{q},tfm_MRI2HistoSum,tfm_identity,tfm_identity);
            if SeeResults
%                 figure(1); subplot(1,4,1); hold on; line(MRIpix_boundx{q},MRIpix_boundy{q}); hold off;
%                 figure(1); subplot(1,4,2); hold on; line(HistoSum_boundx{q},HistoSum_boundy{q}); hold off;
            end
        end
        
        
        % now warp the MRI pixel grid into the individual stains
        startindex = matchkey{j}.histoextent(i,1);
        endindex = matchkey{j}.histoextent(i,2);
        n_sections = endindex-startindex+1;
        
        n_histoSet = 3;
        
        for k=1:n_histoSet
            for q=1:histomap_id{k}.n_stain
                if histomap_id{k}.runAnalysis{q}
                    HistoSrc_path = [HistoSrc_basepath histomap_id{k}.setdir '\' histomap_id{k}.stain_dir{q} '\'];
                    threshold_seg_pathname = [seg_basepath histomap_id{k}.setname '\' histomap_id{k}.stain_segmapname{q} '\'];
                    segmap = [];
                    i_foundsection = 1;
                    for r=1:n_sections
                        % read histology image data
                        section_basename = num2str(startindex-1+r);
                        filename = [HistoSrc_path section_basename '.tif'];
                        if exist(filename, 'file') == 2
                            section_im{r} = imread(filename);
                            i_foundsection = i_foundsection + 1;
                            segmap{r} = imread([threshold_seg_pathname section_basename '.ov1']);

                        end
                        n_foundsection = i_foundsection-1;
                        
                        % read axon-section to HistoSum transformation
                        tfm_filelist = rdir([AxonTfm_path section_basename '_transform*.tfm']);
                        if length(tfm_filelist)>0
                            %if multiple tfm files found for a section use the one with the higher number
                            AxonSection2HistoSum_tfm_filepath = tfm_filelist(end).name;
                            AxonSection2HistoSum_tfm = load_tfm_b(AxonSection2HistoSum_tfm_filepath,1);
                        else
                            AxonSection2HistoSum_tfm = tfm_identity; 
                            %no transform file was found, so assume that this was the fixed image during inter-section registraiton
                        end
                        
                        % read Interset to axon-section transformation
                        if strcmp(histomap_id{k}.stain_shortname{q},'Axon') || strcmp(histomap_id{k}.stain_shortname{q},'MBP')
                            DestSection2AxonSection_tfm = tfm_identity;
                            % if stain is Axon or MBP, no transform is needed
                        else
                            tfm_filelist = rdir([HistoDestSection_path section_basename '_transform*.tfm']);
                            if length(tfm_filelist)>0
                                DestSection2AxonSection_tfm_filepath = tfm_filelist(end).name;
                                DestSection2AxonSection_tfm = load_tfm_b(DestSection2AxonSection_tfm_filepath,1);
                            else
                                DestSection2AxonSection_tfm = tfm_identity;
                            end
                        end                            
                        DestSection_boundx{r} = cell(1,n_MRIpix);
                        DestSection_boundy{r} = cell(1,n_MRIpix);
                        if SeeResults
%                             if strcmp(histomap_id{k}.stain_shortname{q},'Axon')
%                                 figure(1); subplot(1,4,3); hold off; imagesc(section_im{r}); colormap gray; axis image, axis off; hold on;
%                             end
                            figure(1); subplot(1,n_sections,r); hold off; imagesc(section_im{r}); colormap gray; axis image, axis off; hold on;
                        end
                        Dest_sectionSize = size(section_im{r});
                        ROIgrid{r} = int16(zeros(Dest_sectionSize));
                        for s=1:n_MRIpix
                            [DestSection_boundx{r}{s}, DestSection_boundy{r}{s}] = MR_to_SingleHist_xy(MRIpix_boundx{s},MRIpix_boundy{s},tfm_MRI2HistoSum,AxonSection2HistoSum_tfm,DestSection2AxonSection_tfm);
                            if SeeResults
%                                 if strcmp(histomap_id{k}.stain_shortname{q},'Axon')
%                                     figure(1); subplot(1,4,3); hold on; line(DestSection_boundx{r}{s},DestSection_boundy{r}{s}); hold off;
%                                 end
                                figure(1); subplot(1,n_sections,r); hold on; line(DestSection_boundx{r}{s},DestSection_boundy{r}{s}); hold off;
                            end
                            mask = poly2mask(DestSection_boundx{r}{s},DestSection_boundy{r}{s},Dest_sectionSize(1),Dest_sectionSize(2));
                            ROIgrid{r}(mask) = s;
                        end
                    end
                    [AreaFraction, AvgOD_Whole, AvgOD_AboveThresh] = makeHistoParmaps(section_im,segmap,ROIgrid,ROIgrid_i,ROIgrid_j,size(imTrW));
                    figure(1);imagesc(AreaFraction); axis off; axis image
                    figure(2);imagesc(AvgOD_Whole); axis off; axis image
                    figure(3);imagesc(AvgOD_AboveThresh); axis off; axis image
                    
                    % save ROIgrid variables
                    
                    ROIgrid_matfilename = [id '_' slice_name{i} '_' histomap_id{k}.stain_shortname{q} '_HistoParMapVars.mat'];
                    ROIgrid_i = MRIpix_i;
                    ROIgrid_j = MRIpix_j;
                    save([dest_path ROIgrid_matfilename],'ROIgrid','ROIgrid_i','ROIgrid_j','AreaFraction','AvgOD_whole','AvgOD_AboveThresh');
                        
                end
            end
        end
    end
end