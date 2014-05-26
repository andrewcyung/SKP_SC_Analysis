rootpath = 'F:\SKP-SC analysis\'
load([rootpath 'SKP-IDtag'])
load([rootpath 'SKP-MRImap_id'])
load([rootpath 'SKP-histomap_id'])
load([rootpath 'SKP_matchkey_ay_original'])


ROI_dirname = '05-Whole tissue\';
results_basename = 'histo_WholeSection_';
dest_path = [rootpath 'Group Results\03-WholeSection-GroupStats\'];
stain_shortname = 'EC';

slice_name{1} = 'EdgeCaudal';
slice_name{2} = 'MidCaudal';
slice_name{3} = 'Epicentre';
slice_name{4} = 'MidCranial';
slice_name{5} = 'EdgeCranial';

i_8wk = 1;
i_media = 1;
i_cells = 1;

for j=1:14
    id = IDtag{j}.id;
    
    src_file = [rootpath id '\' '07-Analysis Jobs\' results_basename 'rat' id '_Slice_' stain_shortname '.mat'];
    load(src_file);
    
    src_varname = [results_basename 'rat' id '_' stain_shortname];
    
    for i=1:5
        destfile_name = [results_basename 'rat' id '_' slice_name{i} '_' stain_shortname];
        sectionextent = matchkey{j}.histoextent(i,:);
        startindex = sectionextent(1);
        n_sections = sectionextent(2)-sectionextent(1)+1;
        i_section = 1;
        for k=1:n_sections
           srcvar_name = [results_basename 'rat' id '_section' num2str(startindex+k+1) '_' stain_shortname];
           try
               eval(['results =' srcvar_name ';']);
               stained_area(i_section) = results.n_seg_points / results.n_ROI_points;
               stained_intensity(i_section) = results.avg;
               i_section = i_section + 1;
           catch exception
               disp('section not found');
           end
        end
        n_foundsections = i_section-1;
        if n_foundsections > 0
            stained_area_avg = mean(stained_area(1:n_sections));
            stained_area_std = std(stained_area(1:n_sections));
            save([dest_path destfile_name '.mat'],'stained_area_avg','stained_area_std');
        else
            disp('no sections available to calculate slice-wise stats');
        end
    end

%     save([rootpath id '\' dest_path results_basename 'rat' id],'-regexp',['^' results_basename 'rat' id]);
     
end
