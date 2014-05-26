classdef Segmentation
    properties
        id = '';
        seg_zones = struct([]); % a struct/dict of SegZone objects
        included = 0;
        timestamp = 0;
    end
    methods
        % Segmentation class constructor
        function obj = Segmentation(id)
            if nargin == 1
                obj.id = id;
            else
                disp('wrong number of constructor arguments; properties set to default vals');
            end
        end
        
        % set value for included flag
        function obj = setInclude(obj,flag)
            obj.included = flag;
        end
        
        % add or update existing entry in seg_zones (SegZone struct array)
        function obj = updateSegZones(obj,zone_name,seg_zone)
            if nargin == 2 %if no SegZones object given, initialize to empty object
                % do it only if there is already a SegZone with the same name
                if ~isfield(obj.seg_zones,zone_name)
                    if numel(obj.seg_zones) == 0 %special case when struct is empty (dot notation does not work)
                        obj.seg_zones = struct(zone_name,SegZone(zone_name));
                    else
                        obj.seg_zones.(zone_name) = SegZone(zone_name);
                    end
                end
            elseif nargin == 3
                if isa(seg_zone,'SegZone')
                    if ~isfield(obj.seg_zones,zone_name)
                        disp(['SegZone ' zone_name ' in ' obj.id ' is new']);
                    end
                    %add/update seg_zones
                    obj.seg_zones.(zone_name) = seg_zone;
                    obj.timestamp = now();
                else
                    msg = ['seg_zones update of ' obj.id ' failed: ' zone_name ' is not a SegZone object.'];
                    disp(msg);
                end
            end
        end
        
        % remove existing entry in seg_zones (struct array of SegZone)
        function obj = cutSegZones(obj,zone_name)
           if isfield(obj.seg_zones,zone_name)
               obj.seg_zones = rmfield(obj.seg_zones,zone_name);
               msg = ['SegZone ' zone_name ' removed from ' obj.id];
               obj.timestamp = now();
           else
               msg = ['SegZone ' zone_name ' is not a member of ' obj.id];
           end
           disp(msg);
        end
        
        % retrieve mask array.  If the zone name is set to 'all' then the
        % union of all seg_zones masks is returned
        function mask = getSegMask(obj,zone_name)
            if isfield(obj.seg_zones,zone_name)
                mask = obj.seg_zones.(zone_name).mask;
            elseif strcmp(zone_name,'all')
                zone_names = fieldnames(obj.seg_zones);
                mask = obj.seg_zones.(zone_names{1}).mask;
                if numel(zone_names) > 1
                    for i=2:numel(zone_names)
                        mask = mask | obj.seg_zones.(zone_names{i}).mask;
                    end
                end
            else
                disp(['requested mask with name ' zone_name ' not found.']);
                return;
            end
                
        end
        
        % print info about this Segmentation object and its contents
        function print(obj)
           disp([char(9) char(9) 'Segmentation ' obj.id ': ' ...
                 '.included = ' num2str(obj.included) ' ' ... 
                 '.timestamp = ' datestr(obj.timestamp)]);
           zone_names = fieldnames(obj.seg_zones);
           n_seg_zone = numel(zone_names);
           for i=1:n_seg_zone
                obj.seg_zones.(zone_names{i}).print();
           end
        end
    end
end

