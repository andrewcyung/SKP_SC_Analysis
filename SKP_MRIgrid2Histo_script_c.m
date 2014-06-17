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

GenerateROIGrid = 1;

load(['F:\SKP-SC analysis\' 'SKP-IDtag']) %loads IDtag
load(['F:\SKP-SC analysis\' 'SKP_matchkey_ay_original']) %loads matchkey
% load(['F:\SKP-SC analysis\' 'SKP-histomap_id']) %loads histomap_id
load(['F:\SKP-SC analysis\' 'SKP_status']) %loads status
load(['F:\SKP-SC analysis\' 'SKP_histo_stain']) %loads histo_stain
load(['F:\SKP-SC analysis\' 'SKP_MRI_orientation']) %loads histo_stain

HistoSum_filename = 'sum_image.tif';
srcMRI = 'imTrW';
tfm_filename_MRI2HistoSum = 'imTrW_tfm1.tfm';
MRI_interpscale = 80;

AxonSection_pixsize = 0.35278;

SeeResultsAxonSum = 1;
SeeResultsSection = 1;

tfm_identity = maketform('affine',[1 0; 0 1; 0 0]);

for j=[1:14]
% for j=[1 3 4 8 9 10]
% for j=[3 4 8 9 10]
    
    id = IDtag{j}.id;
    disp(['id =' id]);
    
    MRImask_basepath = [rootpath id '\' '03-Segmentation\01_MRI\01-ManualWholeSection\02-Results\'];
    MRIsrc_basepath = [rootpath id '\' '04-Preprocessing\07-MRI initial flip alignment\02-Results\'];
    HistoSrc_basepath = [rootpath id '\' '04-Preprocessing\05-Histology-CropforIntersetReg\'];
    AxonTfm_basepath = [rootpath id '\' '05-Registration\03-Axon_BtwnSectionSmooth_Rigid\02-Results\'];
    HistoSum_basepath = [rootpath id '\' '05-Registration\04-MRI_AxonSum_MI_Affine\02-Results\'];
    MRI2Histo_basepath = [rootpath id '\' '05-Registration\04-MRI_AxonSum_MI_Affine\02-Results\'];
    HistoAxonSection_basepath = [rootpath id '\' '05-Registration\05-Axon_BtwnSectionSmooth_Rigid\02-Results\'];
    HistoDestSection_basepath = [rootpath id '\' '05-Registration\02-Histo_InterSet_MI_Rigid\'];
    dest_basepath = [rootpath id '\' '06-Transformation\01-HistologyParMaps\02-Results\'];
    if ~(exist(dest_basepath) == 7)
        mkdir(dest_basepath)
    end
    seg_basepath = [rootpath id '\' '03-Segmentation\02_Histology\'];
    
    
%      for i=status{j}.isReg.AxonSum2MRI

       for i=4
           
        disp(['MRI slice = ' slice_name{i}]);
        MRImask_path = [MRImask_basepath section_path{i}];
        MRIsrc_path = [MRIsrc_basepath section_path{i}];
        HistoSum_path = [HistoSum_basepath section_path{i}];
        AxonTfm_path = [AxonTfm_basepath section_path{i}];
        HistoDestSection_path = [HistoDestSection_basepath section_path{i}];
        MRI2Histo_path = [MRI2Histo_basepath section_path{i}];
        
        if exist([MRImask_path 'imTrW-label.nrrd'])
            MRImask_fullpath = [MRImask_path 'imTrW-label.nrrd'];
        elseif exist([MRImask_path 'CPMG_echo10-label.nrrd']);
            MRImask_fullpath = [MRImask_path 'CPMG_echo10-label.nrrd'];
        else
            filelist = rdir([MRImask_path '*.nrrd']);
            if length(filelist) == 1
                MRImask_fullpath = filelist.name;
            end
        end
        
        % load and upscale MRI data
%         MRI_ROI = fliplr(logical(nrrdread(MRImask_fullpath)));
        MRI_ROI = logical(nrrdread(MRImask_fullpath));
        
        orientation = MRI_orientation{j};
        if orientation(1)
            MRI_ROI = flipdim(MRI_ROI,2);
        end
        if orientation(2)
            MRI_ROI = flipdim(MRI_ROI,1);
        end
        if orientation(3)
            MRI_ROI = MRI_ROI';
        end

        
        
        load([MRIsrc_path 'TrW.mat']); %loads original imTrW
        srcMRI = imTrW;
        interpMRI = imresize(srcMRI,2,'bilinear');
        interpMRI = imresize(interpMRI,40,'nearest');
        
        % construct pixelgrid ROI definitions 
        %       ROIgrid_i,j => MRI pixel position in grid
        %       MRIpix_boundx,y => coords of MRI pixelgrid ROI boundaries
        MRIpix_index = find(MRI_ROI);
        [ROIgrid_i ROIgrid_j] = ind2sub(size(MRI_ROI),MRIpix_index);

        n_MRIpix = length(MRIpix_index); MRIpix_boundx = cell(1,n_MRIpix); MRIpix_boundy = cell(1,n_MRIpix);
        for q=1:n_MRIpix
            [MRIpix_boundx{q} MRIpix_boundy{q}] = getMRpixelboundaries(ROIgrid_j(q),ROIgrid_i(q),MRI_interpscale,MRI_interpscale);
        end

        if exist([MRI2Histo_path 'imTrW_tfm1.tfm']) == 2
            tfm_filename_MRI2HistoSum = 'imTrW_tfm1.tfm';
        elseif exist ([MRI2Histo_path 'fid_tfm.tfm']) == 2
            tfm_filename_MRI2HistoSum = 'fid_tfm.tfm';
        else
            disp(['imTrW_tfm1.tfm nor fid_tfm.tfm could be found'])
        end
        
        % load HistoSum image and MRI->HistoSum transform
        tfm_MRI2HistoSum = load_tfm_b([MRI2Histo_path tfm_filename_MRI2HistoSum],1);
        HistoSum = imread([HistoSum_path HistoSum_filename]);

        % convert MRI pixelgrid boundaries to HistoSum image space =>
        HistoSum_boundx = cell(1,n_MRIpix);
        HistoSum_boundy = cell(1,n_MRIpix);
        for q=1:n_MRIpix
            [HistoSum_boundx{q}, HistoSum_boundy{q}] = MR_to_SingleHist_xy(MRIpix_boundx{q},MRIpix_boundy{q},tfm_MRI2HistoSum,tfm_identity,tfm_identity);
        end
        if SeeResultsAxonSum
            h1=figure(1); subplot(1,2,1); hold off; imagesc(interpMRI); colormap gray; axis image; axis off; hold on;
            h1=figure(1); subplot(1,2,2); hold off; imagesc(HistoSum); colormap gray; axis image, axis off; hold on;
            MRIpix_boundx_matrix = cell2mat(MRIpix_boundx');
            MRIpix_boundy_matrix = cell2mat(MRIpix_boundy');
            HistoSum_boundx_matrix = cell2mat(HistoSum_boundx');
            HistoSum_boundy_matrix = cell2mat(HistoSum_boundy');
            h1=figure(1);subplot(1,2,1); hold on; line(MRIpix_boundx_matrix',MRIpix_boundy_matrix','Color','b'); title('TrW'); hold off;
            h1=figure(1);subplot(1,2,2); hold on; line(HistoSum_boundx_matrix',HistoSum_boundy_matrix','Color','b'); title('Axon Sum'); hold off;
            tightfig;
            set(h1,'Position',[0 0 2000 800])
            fig_filename = ['ROIgrid_' id '_' slice_name{i} '__AxonSum.jpg'];
            saveas(h1,[dest_basepath fig_filename],'jpg');

        end
        
        % now warp the MRI pixel grid into the individual stains
        startindex = matchkey{j}.histoextent(i,1);
        endindex = matchkey{j}.histoextent(i,2);
        n_sections = endindex-startindex+1;
        
        % single-section processing
        n_stain = length(histo_stain);
        for k=1:n_stain
%         for k=7    
            h2=figure(2); clf(h2);
            disp(['stain = ' histo_stain{k}.name]);
            HistoSrc_path = [HistoSrc_basepath histo_stain{k}.setdir '\' histo_stain{k}.dirname];
            
            % load histology single section data and import pixelgrid ROI into its space
            % (some sections will be excluded on the basis of the matchkey struct)
            i_currsection = 1;
            goodSection_index = {};
            section_im = {};
            ROIgrid = {};
            for r=1:n_sections
                % read histology image data and transform
                curr_index = startindex-1+r;
                isBadSection = find(matchkey{j}.excludelist{histo_stain{k}.setindex}==curr_index,1);
                if length(isBadSection)==0 & histo_stain{k}.runROIgridImport
                    disp(['section # =' num2str(curr_index)]); 
                        
                    section_im{i_currsection} = imread([HistoSrc_path num2str(curr_index) '.tif']);
                    % read axon-section to HistoSum transformation
                    tfm_filelist = rdir([AxonTfm_path num2str(curr_index) '_transform*.tfm']);
                    if length(tfm_filelist)>0
                        %if multiple tfm files found for a section use the one with the higher number
                        AxonSection2HistoSum_tfm_filepath = tfm_filelist(end).name;
                        AxonSection2HistoSum_tfm = load_tfm_b(AxonSection2HistoSum_tfm_filepath,0.35278);
                    else
                        AxonSection2HistoSum_tfm = tfm_identity;
                        %no transform file was found, so assume that this was the fixed image during inter-section registraiton
                    end
                    
                    % read Interset to axon-section transformation
                    if histo_stain{k}.setindex == 2
                        DestSection2AxonSection_tfm = tfm_identity;
                        % if stain is from Set 2 (Axon/MBP/GFP2), no transform is needed
                    else
                        isReg_Interset = find(curr_index == status{j}.isReg.Interset,1);
                        if length(isReg_Interset)==0 
                            continue; % go to next for loop iteration
                        end
                        tfm_filename = [num2str(curr_index) '_' histo_stain{k}.interset_tfm_name '_transform*.tfm'];
                        tfm_filelist = rdir([HistoDestSection_path tfm_filename]);
                        if length(tfm_filelist)>0
                            DestSection2AxonSection_tfm_filepath = tfm_filelist(end).name;
                            DestSection2AxonSection_tfm = load_tfm_b(DestSection2AxonSection_tfm_filepath,1);
                        else
                            DestSection2AxonSection_tfm = tfm_identity;
                        end
                    end
                    
                    % import MRI pixelgrid ROI boundaries into individual section
                    DestSection_boundx{i_currsection} = cell(1,n_MRIpix);
                    DestSection_boundy{i_currsection} = cell(1,n_MRIpix);
                    Dest_sectionSize = size(section_im{i_currsection});

                    
                    [tfm_MRI2Hist{i_currsection},tfm_Hist2MRI{i_currsection}] = DefineTransform_MRIvsHistSection(tfm_MRI2HistoSum,AxonSection2HistoSum_tfm,DestSection2AxonSection_tfm);
                    
                    
                    % ROIgrid contains the masks for each pixel ROI
                    ROIgrid{i_currsection} = int16(zeros(Dest_sectionSize));
                    for s=1:n_MRIpix
                        [DestSection_boundx{i_currsection}{s}, DestSection_boundy{i_currsection}{s}] = MR_to_SingleHist_xy(MRIpix_boundx{s},MRIpix_boundy{s},tfm_MRI2HistoSum,AxonSection2HistoSum_tfm,DestSection2AxonSection_tfm);
                        if GenerateROIGrid
                            mask = poly2mask(DestSection_boundx{i_currsection}{s},DestSection_boundy{i_currsection}{s},Dest_sectionSize(1),Dest_sectionSize(2));
                            ROIgrid{i_currsection}(mask) = s;
                        end
                    end
                    if SeeResultsSection && histo_stain{k}.runROIgridImport
                        DestSection_boundx_matrix = cell2mat(DestSection_boundx{i_currsection}');
                        DestSection_boundy_matrix = cell2mat(DestSection_boundy{i_currsection}');
                        h2=figure(2);
                        set(h2,'Position',[0 0 2000 800])
                        h2=figure(2); ha=subplot_tight(3,3,i_currsection); hold off; imagesc(section_im{i_currsection}); colormap gray; axis image, axis off; hold on
                        h2=figure(2); ha=subplot_tight(3,3,i_currsection); hold on; line(DestSection_boundx_matrix',DestSection_boundy_matrix','Color','b'); hold off;
                        ht=title([num2str(curr_index) ' ' histo_stain{k}.name],'Color','g');
                        pos = get(ht,'Position');
                        pos(2) = pos(2) + 310; 
                        set(ht,'Position',pos);

                    end
                    goodSection_index{i_currsection} = curr_index;
                    
                    i_currsection = i_currsection + 1;
                end
                n_goodSections = i_currsection-1;
            end
            
            if histo_stain{k}.runROIgridImport
                if SeeResultsSection
                    fig_filename = ['ROIgrid_' id '_' slice_name{i} '_' histo_stain{k}.name '.jpg'];
                    saveas(h2,[dest_basepath '\' fig_filename],'jpg');
                end
                
                if GenerateROIGrid
                    ROIgrid_matfilename = ['ROIGrid_' id '_' slice_name{i} '_' histo_stain{k}.name '.mat'];
                    save([dest_basepath ROIgrid_matfilename],'ROIgrid','ROIgrid_i','ROIgrid_j','goodSection_index');

                    tfm_matfilename = ['tfm_' id '_' slice_name{i} '_' histo_stain{k}.name '.mat'];
                    save([dest_basepath tfm_matfilename],'tfm_MRI2Hist','tfm_Hist2MRI','goodSection_index');                    

                end
            end
        end
    end
end