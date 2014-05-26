% output a cell array of parameter map points or data aggregate,
% maximum dimension 3 according to the choice of requested_hierarchy.  
% Within each dimension, include all the indata_members except for the
% excluded_members.
function datapack = getShuffledData(parx_name,requested_hierarchy,excluded_members, ...
                        indata_hierarchy, all_members, indata)
    n_dim = numel(requested_hierarchy);
    % consistency checks
    if n_dim > 3
        disp('too many dimensions in requested hierarchy');
        return;
    end
    if numel(excluded_members) ~= n_dim
        disp('excluded_members dimension does not match requested hierarchy');
        return;
    end
    
    % construct cell arrays of included members at each level (all-excluded)
    for i=1:n_dim
        dim_name = requested_hierarchy{i};
        included_members{i} = setdiff(excluded_members{i},all_members.(dim_name));
    end        
    
    if n_dim == 1
       dim_name = requested_hierarchy{1};
       dim_index = find(ismember(dim_name,indata_hierarchy));
       datapack =  
    end
  
end                    