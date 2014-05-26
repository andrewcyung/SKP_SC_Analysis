function datapack = collate_parmapdata(parmap_name,collation_scheme,hierarchy_info,exclusion_list,loadsrc)
% Packages paramater map data into a multidimensional cell array, according
% to organization specified in collation_scheme.  Members of each data
% dimension (e.g. slice, group, sector) are specified in hierarchy_info.  A
% list of excluded members can be specified through the exclusion_list cell
% array.  We assume that the data is already loaded into the variable
% workspace. If loadsrc is 'varspace', the data will be loaded from the
% variables already loaded into the workspace.  Otherwise loadsrc is
% expected to contain the directory path.  If the number of dimensions
% requested by the collation_scheme is less than the total number of
% dimensions in hierarchy_info, the function will collapse all other
% dimensions into the last output datapack dimension.
%

% check consistency
parmap_found = sum(strcmp(parmap_name,hierarchy_info.parmap_name));
if ~parmap_found
    disp('parmap name not found in hierarchy_info');
    return;
end
    
n_dim = length(collation_scheme);
for i=1:n_dim
    dim_found = sum(strcmp(collation_scheme{i},hierarachy_info.dimname));
    if ~dim_found
        disp([collation_scheme{i} ' not found in hierarchy_info']);
        return;
    end
end

if length(exclusion_list) ~= n_dim
    disp('exclusion_list does not have same number of dimensions as collation_scheme');
    return;
end

for i=1:n_dim
    if length(exclusion_list{i}) > hierarchy_info.(collation_scheme{i}).n
        disp(['too many elements in exclusion list for ' collation_scheme{i}]);
        return;
    end
end


%%%%%%%%%%%%%%%%% compile a list of data variables to query:  variable_list
n_alldim = length(hierarchy_info.dimname);

% generate list of included members in each dimension
included_members = cell(n_alldim,1);
for i=1:n_alldim
    dimname = hierarchy_info{i}.name;
    memberlist = hierarchy_info{i}.members;
    n_members = length(memberlist);
    include_flag = ones(n_members);
    % figure out which members of this dimension to exclude
    for j=1:n_dim
        if strcmp(collation_scheme{j},dimname)
            n_excludes = length(exclusion_list{j});
            if n_excludes > 1
                for k=1:n_excludes
                    exclude_test = strcmp(exclusion_list{j}{k},memberlist);
                    include_flag = include_flag & ~exclude_test;
                end
            end
        end
    end
    included_members{i} = memberlist(include_flag);
end            

i_var = 1;
for i=1:n_alldim
    varname = parmap_name;
    for j=1:length(included_members{i})
        varname = [varname '_' included_members{i}{j}];
end