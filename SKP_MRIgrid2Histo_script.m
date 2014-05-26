id = '51';
rootpath = 'F:\SKP-SC analysis\';

section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

load(['F:\SKP-SC analysis\' 'SKP-IDtag']) %loads IDtag
load(['F:\SKP-SC analysis\' 'SKP_matchkey_ay_original']) %loads matchkey

MRImask_filename = 'imTrW-label.nrrd';
HistoSum_filename = 'sum_image.tif';
srcMRI = 'imTrW';
tfm_filename_MRI2HistoSum = 'imTrW_tfm1.tfm';
MRI_interpscale = 80;
isInterSet = 1;

AxonSection_pixsize = 0.35278;

destHisto = 'EC';
tfm_identity = maketform('affine',[1 0; 0 1; 0 0]);

for j=8:8
    
    id = IDtag{j}.id;
    MRImask_basepath = [rootpath id '\' '03-Segmentation\01_MRI\01-ManualWholeSection\02-Results\'];
    MRIsrc_basepath = [rootpath id '\' '04-Preprocessing\07-MRI initial flip alignment\02-Results\'];
    
    HistoSum_basepath = [rootpath id '\' '05-Registration\06-MRI_Axon_MI_BSpline\02-Results\'];
    MRI2Histo_basepath = [rootpath id '\' '05-Registration\06-MRI_Axon_MI_BSpline\02-Results\'];
    HistoAxonSection_basepath = [rootpath id '\' '05-Registration\05-Axon_BtwnSectionSmooth_Rigid\02-Results\'];
    HistoDestSection_basepath = [rootpath id '\' '05-Registration\03-Histo_InterSet_MI_Rigid\'];
    dest_basepath = [rootpath id '\' '06-Transformation\01-HistologyStatMaps\02-Results\'];
    
    
    for i=1:1
        MRImask_path = [MRImask_basepath section_path{i}];
        MRIsrc_path = [MRIsrc_basepath section_path{i}];
        HistoSum_path = [HistoSum_basepath section_path{i}];
        HistoAxonSection_path = [HistoAxonSection_basepath section_path{i}];
        HistoDestSection_path = [HistoDestSection_basepath section_path{i}];
        MRI2Histo_path = [MRI2Histo_basepath section_path{i}];
        dest_path = [dest_basepath section_path{i}];
        
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
        %        figure(1); subplot(1,4,1); hold off; imagesc(interpMRI); colormap gray; axis image; hold on;
        %        figure(1); subplot(1,4,2); hold off; imagesc(HistoSum); colormap gray; axis image, hold on; %axis([-2000 2000 -2000 2000]);
        for q=1:n_MRIpix
            [HistoSum_boundx{q}, HistoSum_boundy{q}] = MR_to_SingleHist_xy(MRIpix_boundx{q},MRIpix_boundy{q},tfm_MRI2HistoSum,tfm_identity,tfm_identity);
            %            figure(1); subplot(1,4,1); hold on; line(MRIpix_boundx{q},MRIpix_boundy{q}); hold off;
            %            figure(1); subplot(1,4,2); hold on; line(HistoSum_boundx{q},HistoSum_boundy{q}); hold off;
        end
        
        startindex = matchkey{j}.histoextent(i,1);
        endindex = matchkey{j}.histoextent(i,2);
        n_histo = endindex-startindex+1;
        
        DestSection = cell(1,n_histo);
        AxonSection = cell(1,n_histo);
        for k=1:n_histo
            section_basename = num2str(startindex-1+k);
            im_filelist = rdir([HistoAxonSection_path section_basename '.tif']);
            if length(im_filelist)>0
                AxonSection{k} = imread(im_filelist(1).name);
            end
            
            tfm_filelist = rdir([HistoAxonSection_path section_basename '_transform*.tfm']);
            if length(tfm_filelist)>0
                AxonSection2HistoSum_tfm_filepath = tfm_filelist(end).name;
                AxonSection2HistoSum_tfm = load_tfm_b(AxonSection2HistoSum_tfm_filepath,1);
            end
            
            
            AxonSection_boundx{k} = cell(1,n_MRIpix);
            AxonSection_boundy{k} = cell(1,n_MRIpix);
            figure(1); subplot(1,4,3); hold off; imagesc(AxonSection{k}); colormap gray; axis image, hold on;
            Axon_sectionSize = size(AxonSection{k});
            Axon_ROIGrid{k} = int16(zeros(Axon_sectionSize));
            
            
            for q=1:n_MRIpix
                [AxonSection_boundx{k}{q}, AxonSection_boundy{k}{q}] = MR_to_SingleHist_xy(MRIpix_boundx{q},MRIpix_boundy{q},tfm_MRI2HistoSum,AxonSection2HistoSum_tfm,tfm_identity);

                mask = poly2mask(AxonSection_boundx{k}{q},AxonSection_boundy{k}{q},Axon_sectionSize(1),Axon_sectionSize(2));
                Axon_ROIGrid{k}(mask) = q;
                
                %                figure(1); subplot(1,4,3); hold on; line(AxonSection_boundx{k}{q},AxonSection_boundy{k}{q}); hold off;
            end
            
            if isInterSet
                im_filelist = rdir([HistoDestSection_path section_basename '_EC' '.tif']);
                if length(im_filelist)>0
                    DestSection{k} = imread(im_filelist(1).name);
                end
                
                tfm_filelist = rdir([HistoDestSection_path section_basename '_transform*.tfm']);
                if length(tfm_filelist)>0
                    DestSection2AxonSection_tfm_filepath = tfm_filelist(end).name;
                    DestSection2AxonSection_tfm = load_tfm_b(DestSection2AxonSection_tfm_filepath,1);
                end
                
                DestSection_boundx{k} = cell(1,n_MRIpix);
                DestSection_boundy{k} = cell(1,n_MRIpix);
%                 figure(1); subplot(1,4,4); hold off; imagesc(DestSection{k}); colormap gray; axis image, hold on;
 
                Dest_sectionSize = size(DestSection{k});
                EC_ROIGrid{k} = int16(zeros(Dest_sectionSize));
                for q=1:n_MRIpix
                    [DestSection_boundx{k}{q}, DestSection_boundy{k}{q}] = MR_to_SingleHist_xy(MRIpix_boundx{q},MRIpix_boundy{q},tfm_MRI2HistoSum,AxonSection2HistoSum_tfm,DestSection2HistoSum_tfm);
%                     figure(1); subplot(1,4,4); hold on; line(DestSection_boundx{k}{q},DestSection_boundy{k}{q}); hold off;
                    mask = poly2mask(DestSection_boundx{k}{q},DestSection_boundy{k}{q},Dest_sectionSize(1),Dest_sectionSize(2));
                    EC_ROIGrid{k}(mask) = q;

                end
                
                
            end
        end
        save([dest_path 'Histo_ROIGrids' id '_' section_path{i}(1:2) '.mat'],'Axon_ROIGrid', 'EC_ROIGrid');
    end
end