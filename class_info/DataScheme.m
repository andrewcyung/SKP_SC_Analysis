classdef DataScheme
   properties
      id = '';
      parx_datasets = struct([]); % a struct/dict of ParxData objects
      segs = struct([]); % a struct/dict of Segmentation objects
      included = 0;
      timestamp = 0;
   end
    methods
        % DataScheme class constructor
        function obj = DataScheme(id)
            if nargin == 1
                obj.id = id;
            end
        end
        
        % set value for included flag
        function obj = setInclude(obj,flag)
            obj.included = flag;
        end
        
        % add or update existing entry in parx_datasets (ParxDataset struct array)
        function obj = updateParxDataset(obj,parx_name,parx_dataset)
            if nargin == 2 %if no ParxDataset object given, initialize to empty object
                % do it only if there is already a ParxDataset with the same name
                if ~isfield(obj.parx_datasets,parx_name)
                    if numel(obj.parx_datasets) == 0 %special case when struct is empty (dot notation does not work)
                        obj.parx_datasets = struct(parx_name,ParxDataset(parx_name));
                    else
                        obj.parx_datasets.(parx_name) = ParxDataset(parx_name);
                    end
                end
            elseif nargin == 3
                if isa(parx_dataset,'ParxDataset')
                    if ~isfield(obj.parx_datasets,parx_name)
                        disp(['ParxDataset ' parx_name ' in ' obj.id ' is new']);
                    end
                    %add/update parx_dataset
                    obj.parx_datasets.(parx_name) = parx_dataset;
                    obj.timestamp = now();
                else
                    disp(['parx_datasets update of ' obj.id ' failed: ' parx_name ' is not a ParxDataset object.']);
                end
            end
        end
        
        % remove existing entry in parx_datasets (ParxDataset struct array)
        function obj = cutParxDataset(obj,parx_name)
           if isfield(obj.parx_datasets,parx_name)
               obj.parx_datasets = rmfield(obj.parx_datasets,parx_name);
               msg = ['ParxDataset ' parx_name ' removed from ' obj.id];
               obj.timestamp = now();
           else
               msg = ['ParxDataset ' parx_name ' is not a member of ' obj.id];
           end
           disp(msg);
        end
        
        % add or update existing entry in segs (Segmentation struct array)
        function obj = updateSeg(obj,seg_name,seg)
            if nargin == 2 %if no Segmentation object given, initialize to empty object
                % do it only if there is already a Segmentation with the same name
                if ~isfield(obj.segs,seg_name)
                    if numel(obj.segs) == 0 %special case when struct is empty (dot notation does not work)
                        obj.segs = struct(seg_name,Segmentation(seg_name));
                    else
                        obj.segs.(seg_name) = Segmentation(seg_name);
                    end
                end
            elseif nargin == 3
                if isa(seg,'Segmentation')
                    if ~isfield(obj.segs,seg_name)
                        disp(['Segmentation ' seg_name ' in ' obj.id ' is new']);
                    end
                    %add/update seg_zones
                    obj.segs.(seg_name) = seg;
                    obj.timestamp = now();
                else
                    disp(['segs update of ' obj.id ' failed: ' seg_name ' is not a Segmentation object.']);
                end
            end
        end
        
        % remove existing entry in parx_datasets (ParxDataset struct array)
        function obj = cutSeg(obj,seg_name)
           if isfield(obj.segs,seg_name)
               obj.segs = rmfield(obj.segs,seg_name);
               msg = ['Segmentation ' seg_name ' removed from ' obj.id];
               obj.timestamp = now();
           else
               msg = ['Segmentation ' seg_name ' is not a member of ' obj.id];
           end
           disp(msg);
        end
        
        function parxnames = getParxList(obj)
           parxnames = fieldnames(obj.parx_datasets);
        end
        
        % print info about this DataScheme object and its contents
        function print(obj)
            disp([char(9) 'DataScheme ' obj.id ': ' ...
                '.included = ' num2str(obj.included) ' ' ...
                '.timestamp = ' datestr(obj.timestamp)]);
            parx_names = fieldnames(obj.parx_datasets);
            seg_names = fieldnames(obj.segs);
            for i=1:length(parx_names)
                obj.parx_datasets.(parx_names{i}).print();
            end
            for i=1:length(seg_names)
                obj.segs.(seg_names{i}).print();
            end
        end
        
    end
end

