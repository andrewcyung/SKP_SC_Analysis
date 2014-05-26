function storageframe = make_SKP_storageframe(req_datascheme,req_segtype,rootpath,SKP_srcbasedir,IDtag)
% Produces a "storage frame" structure array which includes data from all
% experimental subjects as stored in SKP_CollatedDataset objects, **FOR A
% SPECIFIC DATASCHEME and SEGMENTATION TYPE**.
% (e.g. datascheme = MRIPixelGrid; segmentation type = Sectors).  The
% organization of the structure array (with examples) is as follows:
%
% group: array
%       |
%      group(1)     ...     group(n)
%           .id: 'media'
%           .subject: array
%                  |
%                subject(1)    ... subject(n)
%                      .id: '11'
%                      .group: 'media'
%                      .slice: array
%                                 |
%                                slice(1)    ... slice(n)
%                                     .id: 'EdgeCaudal'
%                                     .segzone:  array
%                                                  |
%                                                segzone(1)    ...     segzone(2)
%                                                      .id: 'Ventral'
%                                                      .parx: array
%                                                                  |
%                                                                 parx(1)   ...  parx(n)
%                                                                      .id:  'MWF'
%                                                                      .data: numeric vector
%                                                                      .coords: array of coordinates
%                                                                      .thumbnail_path:  <path to thumbnail image>
%                                                                      .tfm_parx2srcim
%
%
% The input data are .mat files (in <root>/<id>/srcbasedir), which individually
% contain an object array of SKP_CollatedDataset objects (each SKP_CollatedDataset
% contains the full dataset corresponding to one slice of one animal in
% the SKP-SC study).  These objects store the segmentation masks and
% parameter maps separately.  The job of the storage frame is to store the
% data within those masks with a coordinate vector, across the entire
% experimental dataset.  This storage frame will be used to construct
% "graph frames" that will be used to efficiently display the data in graph
% format.

% we will assume that the naming scheme of the .mat files are
% SKP_CollatedData_<id>.  Within the .mat files, we will expect the
% "SliceDatasets" cell array, which contain the SKP_CollatedDataset
% objects.

% The code should be able to handle missing data!!

% We assume that the three groups in the SKP study are:
% 'media', 'SKP', '8wpi'

groupname = {'Media','Cells','8wk'};
n_group = length(groupname);
storageframe = cell(n_group,1);

n_allID = length(IDtag);

for i_group=1:n_group
    
%     go through IDtag cell array and pick out the animals belonging to the
%     current group
    
    include = zeros(1,n_allID);
    for i=1:n_allID
        if strcmp(IDtag{i}.Group,groupname{i_group})
            include(i) = 1;
        else
            include(i) = 0;
        end
    end
    subset_IDtag = IDtag(logical(include));
    n_subject = length(subset_IDtag);
    
    storageframe{i_group}.id = groupname{i_group};
    storageframe{i_group}.subject = cell(n_subject,1);
    
    for i_subject=1:n_subject
        id = subset_IDtag{i_subject}.id
        % load SKP_CollatedData_<id> .mat file
        srcpath = [rootpath id '\' SKP_srcbasedir 'SKP_CollatedData_' id '.mat'];
        if exist(srcpath) ~= 2
            disp([srcpath ' not found']);
            continue;
        end
        load(srcpath); % should load SliceDatasets variable
        if exist('SliceDatasets','var') ~= 1
            disp(['SliceDatasets not loaded from ' srcpath]);
            continue;
        end
        
        % populate .id of subject array's element
        storageframe{i_group}.subject{i_subject}.id = id;
        
        % now populate the slice array
        n_slices = length(SliceDatasets);
        storageframe{i_group}.subject{i_subject}.slice = cell(n_slices,1);
        for i_slice=1:n_slices
            if ~isa(SliceDatasets{i_slice},'SkpCollatedDataset')
                disp(['no SkpCollatedDataset for slice ' num2str(i_slice)]);
                continue;
            end
            
            curr_dataset = SliceDatasets{i_slice};
            % populate .id for current slice
            storageframe{i_group}.subject{i_subject}.slice{i_slice}.id = curr_dataset.slice_id;
            
            % populate segzone array for current slice.  Make sure that the
            % requested DataScheme and Segmentation exists
            if ~curr_dataset.exist('DataScheme',req_datascheme)  %MUST IMPLEMENT
                disp(['no ' req_datascheme ' DataScheme found']);
                continue;
            end
            
            if ~curr_dataset.exist('Segmentation',req_segtype,req_datascheme)
                disp(['no ' req_segtype ' Segmentation in ' req_datascheme ' DataScheme found']);
                continue;
            end
            
            curr_segmentation = curr_dataset.data_schemes.(req_datascheme).segs.(req_segtype);
            segzone_names = fieldnames(curr_segmentation.seg_zones);
            n_segzone = length(segzone_names);
            storageframe{i_group}.subject{i_subject}.slice{i_slice}.segzone = cell(n_segzone,1);
            parxname_list = curr_dataset.data_schemes.(req_datascheme).getParxList();
            n_parx = length(parxname_list);
            for i_seg=1:n_segzone
                storageframe{i_group}.subject{i_subject}.slice{i_slice}.segzone{i_seg}.id = segzone_names{i_seg};
                disp([storageframe{i_group}.id ' ' storageframe{i_group}.subject{i_subject}.id ' ' storageframe{i_group}.subject{i_subject}.slice{i_slice}.id ' ' storageframe{i_group}.subject{i_subject}.slice{i_slice}.segzone{i_seg}.id]);  
                storageframe{i_group}.subject{i_subject}.slice{i_slice}.segzone{i_seg}.parx = cell(n_parx,1);
                for i_parx=1:n_parx
                    parxname = parxname_list{i_parx};
                    currparx.id = parxname;
                    currparx.tfm_parx2srcim = [];
                    [currparx.data,currparx.thumbnail_path] = curr_dataset.getSegmentedData(parxname,req_datascheme,req_segtype, curr_segmentation.seg_zones.(segzone_names{i_seg}).id,'points');
                    currparx.coord = curr_segmentation.seg_zones.(segzone_names{i_seg}).getCoords();
                    currparx.upstreamDataStruct = curr_dataset.data_schemes.(req_datascheme).parx_datasets.(parxname).upstreamDataStruct;
                    storageframe{i_group}.subject{i_subject}.slice{i_slice}.segzone{i_seg}.parx{i_parx} = currparx;
                end
            end
        end
    end
end
