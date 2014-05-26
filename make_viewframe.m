function viewframe =  make_viewframe(parxname,view_categories,storageframe,storage_layout,requested_members)
% This function outputs a nested set of cell vectors (the viewframe, up to
% 3 levels deep) for a particular parameter (the parxname). 
% The viewframe serves as input to correlation scatterplots (compare 
% viewframes from two parameters) or comparison of a parameter's value
% across different dimensions of the experiment (eg. experimental group).
%
% The viewframe assumes that there will be up to three levels in the data
% hierarchy, mainly to accommodate a correlation scatterplot where the
% group dimensions will be encoded by the a) hue, b) shading, and c) marker
% type.  The basic element of the viewframe is an array of parx structs 
% which have the following fields:
%   .id             the name of the parameter
%   .data           the parameter values (usually within a ROI in an image)
%   .coord          the position or coordinate of the corresponding members of .data
%   .srcimpath      the filepath to the original source image
%   .tfm_parx2srcim transform matrix which converts coordinates from the parameter map to the src image
% 
% The .coord, .srcimpath and .tfm_parx2srcim fields allow us to
% reference back to the source data from which the data point was derived
% (e.g. coordinates for fractional anisotropy data point refers to position
% within the original FA map; coordinates for EC optical density refers to
% position within the original high-resolution EC stain image).
%
% The viewframe is constructed as 3D-vector of "hue" vectors, which
% themselves contain a 1D vector of "shade" vectors, which each encapsulate
% a 1D vector of "marker" vectors.  If the datasets that correspond to that
% hue-shade-marker combination is missing, the parx vector will be an
% empty set.
% 
% Once the viewframe is constructed, the graphing function can display all
% the data or a selected subset.  The idea is to generate a viewframe once
% for a typical data exploration task which results in a more "focused" dataset,
% which will hopefully reduce overhead while hiding/showing different elements
% of the viewed dimensions.
%
% The input data to the viewframe is stored in the "storageframe" structure
% array (eg. make_SKP_storageframe for study-specific implementation), whose
% structure is described in "storage_layout".  The storage frame should include
% all the data from an entire study (all subjects, all parameters) for a specific
% "datascheme" (e.g. MRIPixelGrid) and "seg type" (e.g. Sectors). The selected
% dimensions of the viewframe are given by string cell array "view_categories",
% which is assumed to name a subset of the members contained in
% storage_layout.  Because the number of category dimensions in the storage
% frame is more than the number of view categories (3 or less), the data
% will be combined across those other dimensions (e.g. if "slice" is not
% named as a view category, data from all slices will be collapsed into one
% dataset instead of treated individually).
%
% To accomodate situations where we want some data to be intentionally
% omitted (e.g. in mid-study, the data for all subjects has not yet been
%  acquired, "requested_members" is a structure array with field names 
% given by storage_layout, which lists the elements that we want to
% include in the view_frame.

% for the SKP project, some of the input variables will take the following
% form (let us assume we are working with datascheme = MRIPixelGrid and
% segtype = Sectors).

% storage_layout = {'group','subject','slice','segzone','parx'};
%
% requested_members.('group') = {'media','SKP'};
% requested_members.('subject') = {'11' '36','51'};
% requested_members.('slice') = {'epicentre'};
% requested_members.('segzone') = {'lateral'};
%
% view_categories = {'group','slice','subject'};

% STEP 1: check that requested view categories are part of the storage layout
n_viewcat = length(view_categories);
for i_cat=1:n_viewcat
   if ~ismember(view_categories{i_cat},storage_layout)
       disp(['view category ' view_categories{i_cat} ' not found in storage frame.']);
       return;
   end
end

% STEP 2:  construct viewframe iteratively
% The first three for loops (across hue, shade and marker dimensions of the
% viewframe) determine the specific group, subject, slice and segzone to
% extract out of the storageframe and store in the current element of the
% viewframe.  The variables that contain these choices are groupid,
% subjectid, sliceid, and segid.  If the storageframe dimension was not 
% named as a view category, this means that the data in this dimension
% should be collapsed and treated as one dataset (the corresponding id
% variable will be marked as 'collapsed').
n_hue = length(requested_members.(view_categories{1}));
n_shade = length(requested_members.(view_categories{2}));
n_marker = length(requested_members.(view_categories{3}));
viewframe = cell(n_hue,n_shade,n_marker);

for i_hue=1:n_hue
    switch view_categories{1}
        case 'group'
            groupid = requested_members.('group'){i_hue};
        case 'subject'
            subjectid = requested_members.('subject'){i_hue};
        case 'slice'
            sliceid = requested_members.('slice'){i_hue};
        case 'segzone'
            segid = requested_members.('segzone'){i_hue};
    end
    
    for i_shade=1:n_shade
        switch view_categories{2}
            case 'group'
                groupid = requested_members.('group'){i_shade};
            case 'subject'
                subjectid = requested_members.('subject'){i_shade};
            case 'slice'
                sliceid = requested_members.('slice'){i_shade};
            case 'segzone'
                segid = requested_members.('segzone'){i_shade};
        end
        for i_marker=1:n_marker
            switch view_categories{3}
                case 'group'
                    groupid = requested_members.('group'){i_marker};
                case 'subject'
                    subjectid = requested_members.('subject'){i_marker};
                case 'slice'
                    sliceid = requested_members.('slice'){i_marker};
                case 'segzone'
                    segid = requested_members.('segzone'){i_marker};
            end
            
            collapsed_dim = setdiff(storage_layout,view_categories);
            n_collapse = length(collapsed_dim);
            for i_collapse=1:n_collapse
                switch collapsed_dim{i_collapse}
                    case 'group'
                        groupid = 'collapsed';
                    case 'subject'
                        subjectid = 'collapsed';
                    case 'slice'
                        sliceid = 'collapsed';
                    case 'segzone'
                        segid = 'collapsed';
                end
            end
            
            %             disp([num2str(i_hue) ' ' num2str(i_shade) ' ' num2str(i_marker)]);
            %             disp([groupid ' ' subjectid ' ' sliceid ' ' segid]);
            %
            %           The next three for loops (remember we are inside the
            %           hue-shade-marker loops) iterate through the storageframe.
            %           The code explores every branch of storageframe and constructs
            %           for-loop iterators which either reference a specific member
            %           of the current storageframe level (xxxx_iterator = K), all of
            %           the members (xxxx_iterator = 1:<n_members> if the id was
            %           'collapsed'), or skip the for-loop if the requested member
            %           was not found in the current storageframe branch (e.g. when a
            %           specific subject is not found in the current group).
            %           accum_parvec will accumulate all individual parx structs
            %           (fieldnames include .id, .data, .coords, .srcimpath, .tfmparx2srcim).
            
            
            group_iterator = []; subject_iterator = []; slice_iterator = []; seg_iterator = [];
            accum_parvec = [];
            n_group = length(storageframe);
            found_flag = zeros(1,n_group);
            
            if ~strcmp(groupid,'collapsed')
                for i=1:n_group
                    found_flag(i) = strcmp_handleempty(storageframe{i},groupid);
                end
            else
                for i=1:n_group
                    n_subject = length(storageframe{i}.subject);
                    for j=1:n_subject
                        if strcmp_handleempty(storageframe{i}.subject{j},subjectid)
                            found_flag(i) = 1;
                            continue;
                        end
                    end
                end
            end
            group_iterator = find(found_flag);

            if ~isempty(group_iterator)
                for i_group=group_iterator
                    subject_frame = storageframe{i_group}.subject;
                    n_subject = length(subject_frame);
                    found_flag = zeros(1,n_subject);
                    if ~strcmp(subjectid,'collapsed')
                        for i=1:n_subject
                            found_flag(i) = strcmp_handleempty(subject_frame{i},subjectid);
                        end
                    else
                        requested_subjects = requested_members.('subject');
                        n_requested_subjects = length(requested_subjects);
                        for i=1:n_subject
                            if isempty(subject_frame{i})
                                found_flag(i) = false;
                            elseif ismember(subject_frame{i}.id,requested_subjects)
                                found_flag(i) = true;
                            else
                                found_flag(i) = false;
                            end
                        end
                    end
                    subject_iterator = find(found_flag);
  
                end
            end
            
            if ~isempty(subject_iterator)
                for i_subject=subject_iterator
                    slice_frame = subject_frame{i_subject}.slice;
                    n_slice = length(slice_frame);
                    found_flag = zeros(1,n_slice);
                    
                    if ~strcmp(sliceid,'collapsed')
                        for i=1:n_slice
                            found_flag(i) = strcmp_handleempty(slice_frame{i},sliceid);
                        end
                    else
                        requested_slices = requested_members.('slice');
                        for i=1:n_slice
                            if isempty(slice_frame{i})
                                found_flag(i) = false;
                            elseif ismember(slice_frame{i}.id,requested_slices)
                                found_flag(i) = true;
                            else
                                found_flag(i) = false;
                            end
                        end
                    end
                    slice_iterator = find(found_flag);
                end
            end
            
            if ~isempty(slice_iterator)
                for i_slice=slice_iterator
                    seg_frame = slice_frame{i_slice}.segzone;
                    n_seg = length(seg_frame);
                    found_flag = zeros(1,n_seg);
                    
                    if ~strcmp(segid,'collapsed')
                        for i=1:n_seg
                            found_flag(i) = strcmp_handleempty(seg_frame{i},segid);
                        end
                    else
                        requested_segs = requested_members.('segzone');
                        for i=1:n_seg
                            if isempty(seg_frame{i})
                                found_flag(i) = false;
                            elseif ismember(seg_frame{i}.id,requested_segs)
                                found_flag(i) = true;
                            else
                                found_flag(i) = false;
                            end
                        end                        
                        
                        for i=1:n_seg
                            found_flag(i) = ~isempty(seg_frame{i});
                        end
                    end
                    seg_iterator = find(found_flag);
                end
            end
            
            if ~isempty(seg_iterator)
                for i_seg=seg_iterator
                    parx_frame = seg_frame{i_seg}.parx;
                    n_parx = length(parx_frame);
                    found_flag = zeros(n_parx,1);
                    for i=1:n_parx
                        found_flag(i) = strcmp_handleempty(parx_frame{i},parxname);
                    end
                    parvec = parx_frame(find(found_flag));
                    accum_parvec = [accum_parvec parvec];
                end
            end
            disp([groupid ' ' subjectid ' ' sliceid ' ' segid]);
%             At the very end of the for loop, the viewframe element ends
%             up being an array of parx structs.
            viewframe{i_hue}{i_shade}{i_marker} = accum_parvec;
        end
    end
end