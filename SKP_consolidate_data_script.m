% rootpath = 'F:\SKP-SC analysis\';

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
load(['F:\SKP-SC analysis\' 'SKP-MRImap_id']) %loads MRImap_id
load(['F:\SKP-SC analysis\' 'SKP_histo_stain']) %loads histo_stain

%             parx_names = {'GFAP_AvgOD','GFAP_AvgODThresh','GFAP_AreaFraction', ...
%                 'P0_AvgOD','P0_AvgODThresh','P0_AreaFraction', ...
%                 'GFPSet1_AvgOD','GFPSet1_AvgODThresh','GFPSet1_AreaFraction', ...
%                 'MBP_AvgOD','MBP_AvgODThresh','MBP_AreaFraction', ...
%                 'Axon_AvgOD','Axon_AvgODThresh','Axon_AreaFraction', ...
%                 'GFPSet2_AvgOD','GFPSet2_AvgODThresh','GFPSet2_AreaFraction', ...
%                 'EC_AvgOD','EC_AvgODThresh','EC_AreaFraction', ...
%                 'FA','ADC','Dlong','Dtrans','TrW', ...
%                 'CPMG_echo10','CPMG_So','CPMG_flipangle','MWF','CPMG_SNR', ...
%                 'CPMG_misfit'};
%             


n_MRImap = length(MRImap_id);
n_stain = length(histo_stain);
% for i_subject=[1]
% for i_subject=[1:3 5:7 9:14]
% for i_subject=[5]

for i_subject=[1:14]
    id = IDtag{i_subject}.id;
    disp(['id =' id]);
    SliceDatasets = cell([1,5]);
    
    HistoSrc_basepath = [id '\' '06-Transformation\01-HistologyParMaps\02-Results\'];
    MRIsrc_basepath = [id '\' '04-Preprocessing\07-MRI initial flip alignment\02-Results\'];
    
    seg_basepath = [id '\' '04-Preprocessing\07-MRI initial flip alignment\02-Results\'];
    
    dest_basepath = [rootpath id '\' '06-Transformation\02-ConsolidatedData\'];
    
    for i_slice=status{i_subject}.isReg.AxonSum2MRI

        disp(['MRI slice = ' slice_name{i_slice}]);
        %initialize SKP_CollatedDataset object array element for current animal and MRI slice
        SliceDatasets{i_slice} = SkpCollatedDataset(id,slice_name{i_slice});
        
        for i_map=1:n_MRImap
%         for i_map=12
            disp(MRImap_id{i_map}.filename);
            MRIsrc_path = [MRIsrc_basepath section_path{i_slice} MRImap_id{i_map}.filename '.mat'];
            load([rootpath MRIsrc_path]);
            thumbnail_path = [MRIsrc_basepath section_path{i_slice} MRImap_id{i_map}.varname '.png'];
            eval(['data = ' MRImap_id{i_map}.varname ';']);
            curr_datasetobj_name = MRImap_id{i_map}.datasetobj_name;
            SliceDatasets{i_slice} = SliceDatasets{i_slice}.updateParxDataset('MRIPixelGrid',curr_datasetobj_name,data,thumbnail_path);
            if isfield(MRImap_id{i_map},'upstreamData')
                n_upstreamData = length(MRImap_id{i_map}.upstreamData);
                curr_upstreamData = MRImap_id{i_map}.upstreamData;
                for i_upstream=1:n_upstreamData
                    curr_upstreamData{i_upstream}.dirpath = [MRIsrc_basepath section_path{i_slice}];
                end
                SliceDatasets{i_slice} = SliceDatasets{i_slice}.addUpstreamDataStruct('MRIPixelGrid',curr_datasetobj_name,curr_upstreamData);
            end
                  
        end
        
        for i_stain=1:n_stain
            disp(['stain = ' histo_stain{i_stain}.name]);
            if ~histo_stain{i_stain}.runParMaps
                continue; % go to next iteration in for loop
            end
            
            dataset_objname = {[histo_stain{i_stain}.name '_AvgOD'], [histo_stain{i_stain}.name '_AvgODThresh'], [histo_stain{i_stain}.name '_AreaFraction'], [histo_stain{i_stain}.name '_IntegODThresh'], [histo_stain{i_stain}.name '_incl_mask']};
            histo_varname = {'AvgOD_Whole','AvgOD_AboveThresh','AreaFraction','IntegOD_AboveThresh','InclMask'};
            histo_varname_CollatedDataset = {'AvgOD','AvgODThresh','AreaFraction','IntegODThresh','incl_mask'};
            for i_map=1:5
                HistoSrc_path = [rootpath HistoSrc_basepath 'HistoParMap_' id '_' slice_name{i_slice} '_' histo_stain{i_stain}.name '.mat'];
                load([HistoSrc_path]);
                thumbnail_path = [HistoSrc_basepath 'HistoParMap_' id '_' slice_name{i_slice} '_' histo_stain{i_stain}.name '_' histo_varname{i_map} '.tif'];
                eval(['data = ' histo_varname{i_map} ';']);
                SliceDatasets{i_slice} = SliceDatasets{i_slice}.updateParxDataset('MRIPixelGrid',dataset_objname{i_map},data,thumbnail_path);
                section_range = matchkey{i_subject}.histoextent(i_slice,:);
                setindex = histo_stain{i_stain}.setindex;
                ROIgrid_path = [rootpath HistoSrc_basepath 'ROIGrid_' id '_' slice_name{i_slice} '_' histo_stain{i_stain}.name '.mat'];
                load(ROIgrid_path); %loads goodSection_index
%                 section_indices = setdiff(section_range(1):section_range(2),matchkey{i_subject}.excludelist{setindex});
                section_indices = goodSection_index;
                n_section = length(section_indices);
                curr_upstreamData = cell(1,n_section);
                for i_section=1:n_section
                    curr_upstreamData{i_section} = struct;
                    curr_upstreamData{i_section}.name = [histo_stain{i_stain}.name ' section ' num2str(section_indices{i_section}) ' w/ROIgrid'];
                    curr_upstreamData{i_section}.srcfile = num2str(section_indices{i_section});
                    curr_upstreamData{i_section}.filetype = '.tif';
                    curr_upstreamData{i_section}.im2src_tfm = NaN;
                    curr_upstreamData{i_section}.dirpath = [id '\04-Preprocessing\05-Histology-CropforIntersetReg\' histo_stain{i_stain}.setdir '\' histo_stain{i_stain}.dirname];
                    ROIgrid_filename = ['ROIGrid_' id '_' slice_name{i_slice} '_' histo_stain{i_stain}.name '.mat'];
                    ROIgrid_dir = [id '\06-Transformation\01-HistologyParMaps\02-Results\'];
                    segmask_filename = ['Segmap_with_exclmask_' id '_' slice_name{i_slice} '_' histo_stain{i_stain}.name '.mat'];
                    curr_upstreamData{i_section}.options = containers.Map({'sectionindex','ROIGrid_path','segmask_path','viewmode'},...
                                                                          {section_indices(i_section),[ROIgrid_dir ROIgrid_filename],[ROIgrid_dir segmask_filename],'zoomed'});
                    curr_upstreamData{i_section}.dispFcnName = 'DisplayHistoPhoto_ROIoverlay';
                    SliceDatasets{i_slice} = SliceDatasets{i_slice}.addUpstreamDataStruct('MRIPixelGrid',[histo_stain{i_stain}.name '_' histo_varname_CollatedDataset{i_map}],curr_upstreamData);
                end
            end
        end
        
        seg_path = [seg_basepath section_path{i_slice}];
        segzone_names = {'Dorsal','Ventral','Lateral'};
        n_seg = length(segzone_names);
        label_file = 'imFA-label.png';
        origlabelmap = imread([rootpath seg_path label_file]);
        for i_seg=1:n_seg
            labelmap = origlabelmap;
            mask = find(labelmap~=i_seg);
            labelmap(mask)=0;
            labelmap = logical(labelmap);
            SliceDatasets{i_slice} = SliceDatasets{i_slice}.updateSegZone('MRIPixelGrid','Sectors',segzone_names{i_seg},labelmap);
        end
        
        if exist(dest_basepath) ~= 7
            mkdir(dest_basepath);
        end
    end
    
    matfilename = [dest_basepath 'SKP_CollatedData_' id '.mat']
    save(matfilename,'SliceDatasets');
    
end