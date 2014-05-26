
classdef CollatedDataset
    properties
        uid = 'undefined';
        data_schemes = struct([]); % a struct/dict of DataScheme objects
        included = 0;
        timestamp = 0;
    end
    methods
        % CollatedDataset class constructor
        function obj = CollatedDataset(uid)
            if nargin == 1
                obj.uid = uid;
            end
        end
        
        % set value for included flag
        function obj = setInclude(obj,flag)
            obj.included = flag;
        end

        function obj = updateSegZone(obj,scheme_name,seg_name,segzone_name,data)
            if nargin == 4 %if a segzone_name is given but there is no data, initialize to empty data array
                % do it only if there is already a SegZone with the same name
                if ~isfield(obj.data_schemes.(scheme_name).segs.(seg_name).seg_zones,segzone_name)
                    if numel(obj.data_schemes.(scheme_name).segs.(seg_name).seg_zones) == 0 %special case when struct is empty (dot notation does not work)
                        obj.data_schemes.(scheme_name).segs.(seg_name).seg_zones = struct(seg_zone,SegZone(segzone_name)); 
                    else
                        obj.data_schemes.(scheme_name).segs.(seg_name).seg_zones = SegZone(segzone_name);
                    end
                end
            elseif nargin == 5
                if ismatrix(data)
                    if ~isfield(obj.data_schemes.(scheme_name).segs.(seg_name).seg_zones,segzone_name)
                        disp(['SegZone ' segzone_name ' is new in ' obj.uid ', scheme ' scheme_name ', segzone ' segzone_name]);
                        obj.data_schemes.(scheme_name).segs.(seg_name).seg_zones.(segzone_name) = {};
                    end
                    
                    obj.data_schemes.(scheme_name).segs.(seg_name).seg_zones.(segzone_name) = obj.data_schemes.(scheme_name).segs.(seg_name).seg_zones.(segzone_name).updateMask(data);
                    stamp = now();
                    obj.data_schemes.(scheme_name).timestamp = stamp;
                    obj.timestamp = stamp;
                    obj.included = 1;
                else
                    disp(['parx_data update of ' obj.id ' scheme ' scheme_name ' failed: ' parx_name ' is not a matrix.']);
                end
            end            
        end        
        
        function flag = exist(obj,level_name,search_string,scheme_name,seg_name)
            if strcmp(level_name,'DataScheme')
                if nargin ~= 3
                    disp('number of arguments should be 2')
                    flag = 0;
                else
                    flag = isfield(obj.data_schemes,search_string);
                end
            elseif strcmp(level_name,'Segmentation')
                if nargin ~= 4
                    disp('number of arguments should be 3')
                else
                    if isfield(obj.data_schemes,scheme_name)
                        flag = isfield(obj.data_schemes.(scheme_name).segs,search_string);
                    else
                        disp(['DataScheme ' scheme_name ' not found']);
                        flag = 0;
                    end
                end
            elseif strcmp(level_name,'SegZone')
                if nargin ~= 5
                    disp('number of arguments should be 4')
                else
                    if isfield(obj.data_schemes,scheme_name)
                        if isfield(obj.data_schemes.(scheme_name).segs,seg_name)
                            flag = isfield(obj.data_schemes.(scheme_name).segs.(seg_name).seg_zones,search_string);
                        else
                            disp(['Segmentation ' seg_name ' not found in DataScheme ' scheme_name]);
                            flag = 0;
                        end
                    else
                        disp(['DataScheme ' scheme_name ' not found']);
                        flag = 0;
                    end
                end
            end
        end
        
        function obj = updateParxDataset(obj,scheme_name,parx_name,data,thumbnail_path)
            if nargin == 3 %if a parx_name is given but there is no data, initialize to empty data array
                % do it only if there is already a ParxDataset with the same name
                if ~isfield(obj.data_schemes.(scheme_name).parx_datasets,parx_name)
                    if numel(obj.data_schemes.(scheme_name).parx_datasets) == 0 %special case when struct is empty (dot notation does not work)
                        obj.data_schemes.(scheme_name).parx_datasets = struct(parx_name,ParxDataset(parx_name)); 
                    else
                        obj.data_schemes.(scheme_name).parx_datasets.(parx_name) = ParxDataset(parx_name);
                    end
                end
            elseif nargin == 5
                if ismatrix(data)
                    if ~isfield(obj.data_schemes.(scheme_name).parx_datasets,parx_name)
                        disp(['ParxDataset ' parx_name ' in ' obj.uid ', scheme ' scheme_name ' is new']);
                        obj.data_schemes.(scheme_name).parx_datasets.(parx_name) = {};
                    end
                    
                    obj.data_schemes.(scheme_name).parx_datasets.(parx_name) = obj.data_schemes.(scheme_name).parx_datasets.(parx_name).updateData(data,thumbnail_path);
                    stamp = now();
                    obj.data_schemes.(scheme_name).timestamp = stamp;
                    obj.timestamp = stamp;
                    obj.included = 1;
                else
                    disp(['parx_data update of ' obj.id ' scheme ' scheme_name ' failed: ' parx_name ' is not a matrix.']);
                end
            end            
        end        
        
        function obj = addUpstreamDataStruct(obj,scheme_name,parx_name,upstreamDataStruct)
           obj.data_schemes.(scheme_name).parx_datasets.(parx_name) = obj.data_schemes.(scheme_name).parx_datasets.(parx_name).addUpstreamDataStruct(upstreamDataStruct); 
        end
        
        % add or update existing entry in data_schemes (DataSchemes struct array)
        function obj = updateDataScheme(obj,scheme_name,data_scheme)
            if nargin == 2 %if no DataScheme object given, initialize to empty object
                % do it only if there is already a DataScheme with the same name
                if ~isfield(obj.data_schemes,scheme_name)
                    if numel(obj.data_schemes) == 0 %special case when struct is empty (dot notation does not work)
                        obj.data_schemes = struct(scheme_name,DataScheme(scheme_name)); 
                    else
                        obj.data_schemes.(scheme_name) = DataScheme(scheme_name);
                    end
                end
            elseif nargin == 3
                if isa(data_scheme,'DataScheme')
                    if ~isfield(obj.data_schemes,scheme_name)
                        disp(['DataScheme ' scheme_name ' in ' obj.uid ' is new']);
                    end
                    %add/update DataScheme
                    stamp = now();
                    obj.data_schemes.(scheme_name) = data_scheme;
                    obj.timestamp = now();
                else
                    disp(['data_schemes update of ' obj.id ' failed: ' scheme_name ' is not a DataScheme object.']);
                end
            end
        end
        % remove existing entry in parx_datasets (ParxDataset struct array)
        function obj = cutDataScheme(obj,scheme_name)
            if isfield(obj.data_schemes,scheme_name)
                obj.data_schemes = rmfield(obj.data_schemes,scheme_name);
                msg = ['DataScheme ' scheme_name ' removed from ' obj.id];
                obj.timestamp = now();
            else
                msg = ['DataScheme ' parx_name ' is not a member of ' obj.id];
            end
            disp(msg);
        end
        
        % print info about this CollatedDataset object and its contents
        function print(obj)
            disp(['CollatedDataset ' obj.uid ': ' ...
                '.included = ' num2str(obj.included) ' ' ...
                '.timestamp = ' datestr(obj.timestamp)]);
            scheme_names = fieldnames(obj.data_schemes);
            for i=1:length(scheme_names)
                obj.data_schemes.(scheme_names{i}).print();
            end
        end
        
%         function obj = updateSegZone(scheme_name,seg_name,segzone_name,mask)
%             obj.data_schemes.(scheme_name).segs.(seg_name).seg_zones.(segzone_name).mask = mask;
%         end
        
        
        % return the points or aggregate measure of a ParameterDataset from
        % a particular DataScheme, masked by a SegZone (or union of SegZones)
        % from a particular Segmentation type
        function [seg_data thumbnail_path] = getSegmentedData(obj,parx_name,scheme_name,seg_name,zone_names,aggregation)
           parx_map = obj.data_schemes.(scheme_name).parx_datasets.(parx_name).data;
           thumbnail_path = obj.data_schemes.(scheme_name).parx_datasets.(parx_name).thumbnail_path;

           if isempty(parx_map)
               seg_data = [];
               thumbnail_path = '';
               return;
           end
           seg_zones = obj.data_schemes.(scheme_name).segs.(seg_name).seg_zones;
           if ~iscell(zone_names) && strcmp(zone_names,'All')
               n_all_zones = numel(seg_zones);
               all_zone_names = fieldnames(seg_zones);
               mask = seg_zones.(all_zone_names{1}).mask;
               for i=2:n_all_zones
                   mask = mask | seg_zones.all_zone_names{i}.mask;
               end
               seg_data{1} = parx_map(mask);
           elseif ~iscell(zone_names)
               mask = seg_zones.(zone_names).mask;
               if strcmp(aggregation,'points')
                   seg_data = parx_map(mask);
               elseif strcmp(aggregation,'avg')
                   seg_data = mean(parx_map(mask));
               elseif strcmp(aggregation,'stdev')
                   seg_data = std(parx_map(mask));
               elseif strcmp(aggregation,'median')
                   seg_data = median(parx_map(mask));
               end
           else
              n_zones = numel(zone_names);
              seg_data = cell(n_zones,1);
              for i=1:n_zones
                  mask = seg_zones.(zone_names{i}).mask;
                  if strcmp(aggregation,'points')
                      seg_data{i} = parx_map(mask);
                  elseif strcmp(aggregation,'avg')
                      seg_data{i} = mean(parx_map(mask));
                  elseif strcmp(aggregation,'stdev')
                      seg_data{i} = std(parx_map(mask));
                  elseif strcmp(aggregation,'median')
                      seg_data{i} = median(parx_map(mask));
                  end
              end             
           end
        end
    end
end

