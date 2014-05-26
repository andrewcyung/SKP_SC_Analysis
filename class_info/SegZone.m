classdef SegZone
   properties
      id = ''
      mask; % logical vector/matrix
      included = 0;
      timestamp = 0;
   end
    methods
        % SegZone class constructor
        function obj = SegZone(id,mask)
            if nargin==1
                obj.id = id;
                obj.mask = [];
            elseif nargin==2
                obj.id = id;
                obj.mask = mask;
            end
        end
        
        % set value for included flag
        function obj = setInclude(obj,flag)
            obj.included = flag;
        end


        % update mask array
        function obj = updateMask(obj,mask)
           obj.mask = mask;
           obj.timestamp = now();
           obj.included = 1;
        end
        
        function coords = getCoords(obj)
           [row,col] = find(obj.mask);
           n_points = length(row);
           if n_points == 0
               coords = [];
           else
               for i=1:n_points
                   coords{i}.row = row(i);
                   coords{i}.col = col(i);
               end
           end
        end
        
        % print info on current SegZone object
        function obj = print(obj)
           disp([char(9) char(9) char(9) 'SegZone ' obj.id ':  ' ...
                 'n_mask = ' num2str(numel(obj.mask)) ' '...
                 '.included = ' num2str(obj.included) ' '...
                 '.timestamp = ' datestr(obj.timestamp)]);
        end
    end
end

