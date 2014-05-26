classdef ParxDataset
    properties
        id = '';
        data; % int/float vector/matrix
        thumbnail_path = '';
        included = 0;
        timestamp = 0;
        upstreamDataStruct = {};
    end
    methods
        % ParxDataset class constructor
        function obj = ParxDataset(id,data)
            if nargin == 1
                obj.id = id;
                obj.data = [];
            elseif nargin == 2
                obj.id = id;
                obj.data = data;
                obj.timestamp = now();
            end
        end
        
        % set value for included flag
        function obj = setInclude(obj,flag)
            obj.included = flag;
        end

        % update data array
        function obj = updateData(obj,data,thumbnail_path)
           obj.data = data;
           obj.timestamp = now();
           obj.included = 1;
           obj.thumbnail_path = thumbnail_path;
        end
        
        function obj = addUpstreamDataStruct(obj,curr_UpstreamDataStruct)
           obj.upstreamDataStruct =  curr_UpstreamDataStruct;
        end
        
        % print info on current ParxDataset object
        function obj = print(obj)
            disp([char(9) char(9) 'ParxDataset ' obj.id ':  ' ...
                'n_data = ' num2str(numel(obj.data)) ' '...
                '.included = ' num2str(obj.included) ' '...
                '.timestamp = ' datestr(obj.timestamp)]);
        end

    end
end

