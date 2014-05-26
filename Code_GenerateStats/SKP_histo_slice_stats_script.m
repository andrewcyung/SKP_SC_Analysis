rootpath = 'F:\SKP-SC analysis\'
load([rootpath 'SKP-IDtag'])
load([rootpath 'SKP-MRImap_id'])
load([rootpath 'SKP-histomap_id'])
load([rootpath 'SKP_matchkey_ay_original'])
load([rootpath 'SKP-slice_name'])

results_basename = 'histo_WholeSection_';
stain_shortname = 'P0';

slice_name{1} = 'EdgeCaudal';
slice_name{2} = 'MidCaudal';
slice_name{3} = 'Epicentre';
slice_name{4} = 'MidCranial';
slice_name{5} = 'EdgeCranial';

for j=1:14
    id = IDtag{j}.id;
    
    base_path = [rootpath id '\' '07-Analysis Jobs\'];
    src_file = [base_path results_basename 'rat' id '.mat'];
    
    load(src_file);
    
    stained_area = zeros(1,5);
    stained_intensity = zeros(1,5);
    
    for i=1:5
        destfile_name = [results_basename 'rat' id '_' 'Slice' '_' stain_shortname];
        destvar_name = [results_basename 'rat' id '_' stain_shortname];
        sectionextent = matchkey{j}.histoextent(i,:);
        startindex = sectionextent(1);
        n_sections = sectionextent(2)-sectionextent(1)+1;
        i_section = 1;
        for k=1:n_sections
           srcvar_name = [results_basename 'rat' id '_section' num2str(startindex+k-1) '_' stain_shortname];
           try
               eval(['results =' srcvar_name ';']);
               stained_area(i_section) = results.n_seg_points / results.n_ROI_points;
               stained_intensity(i_section) = results.avg;
               i_section = i_section + 1;
           catch exception
               disp(['section not found ' slice_name{i} ' ' srcvar_name]);
               
           end
        end
        n_foundsections = i_section-1;
        stained_area_avg = mean(stained_area(1:n_foundsections));
        stained_area_std = std(stained_area(1:n_foundsections));
        stained_intensity_avg = mean(stained_intensity(1:n_foundsections));
        stained_intensity_std = std(stained_intensity(1:n_foundsections));
        eval([destvar_name '.' slice_name{i} '.stained_area_avg = stained_area_avg;']);
        eval([destvar_name '.' slice_name{i} '.stained_area_std = stained_area_std;']);
        eval([destvar_name '.' slice_name{i} '.stained_intensity_avg = stained_intensity_avg;']);
        eval([destvar_name '.' slice_name{i} '.stained_intensity_std = stained_intensity_std;']);
        save([base_path destfile_name '.mat'],destvar_name);
    end

%     save([rootpath id '\' dest_path results_basename 'rat' id],'-regexp',['^' results_basename 'rat' id]);
     
    
end