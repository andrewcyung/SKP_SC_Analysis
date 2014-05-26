rootpath = 'F:\SKP-SC analysis\';

section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

load([rootpath 'SKP-IDtag']) %loads IDtag
load([rootpath 'SKP_matchkey_ay_original']) %loads matchkey
load([rootpath 'SKP-MRImap_id']) %loads MRImap_id
load([rootpath 'SKP-histomap_id']) %loads histomap_id
load([rootpath 'SKP_slice_name']) %loads slice_name




% for j=1:14
for j=[8 12]
    src_basepath = [rootpath id '\' '06-Transformation\01-HistologyParMaps\01-Source data\'];
    dest_basepath = [rootpath id '\' '06-Transformation\01-HistologyParMaps\02-Results\'];
    seg_basepath = [rootpath id '\' '03-Segmentation\02_Histology\'];
    

    
    
    for i=1:5
        startindex = matchkey{j}.histoextent(i,1);
        endindex = matchkey{j}.histoextent(i,2);
        n_histo = endindex-startindex+1;
        
        src_path = [src_basepath section_path{i}];
        dest_path = [dest_basepath section_path{i}];
        
        n_histoSet = length(histomap_id);
        for k=1:n_histoSet
            for q=1:histomap{k}.n_stain
                ROIgrid_matfilename = [id '_' slice_name{i} '_' histomap_id{k}.stain_shortname{k} '_ROIgrid_info.mat'];
                

                load([src_path ROIgrid_matfilename]); %will load ROIgrid, ROIgrid_i, ROIgrid_j
                                
                eval(['ROIgrid = ' ROIgrid_varname]);
                eval(['grid_i = ' grid_posn_i_varname]);
                eval(['grid_j = ' grid_posn_j_varname]);
                threshold_seg_pathname = [seg_basepath histomap_id{k}.setname '\' histomap_id{k}.stain_segmapname{q} '\'];
                
                %read in individual section images into im_histo
                i_foundhisto = 1;
                for r=1:n_histo
                    section_basename = num2str(startindex-1+r);
                    im_filelist = rdir([src_path section_basename '.tif']);
                    if length(im_filelist)==1
                        im_histo{i_foundhisto} = imread(im_filelist.name);
                        i_foundhisto = i_foundhisto + 1;
                    else
                        disp([section_basename '.tif not found']);
                    end
                    segmap{i_foundhisto} = imread([threshold_seg_pathname section_basename '.ov1']);
                end
                n_foundhisto = i_foundhisto-1;
                [AreaFraction, AvgOD_whole, AvgOD_AboveThresh] = makeHistoParmaps(im_histo,segmap,ROIgrid,grid_i,grid_j);
                histo_parmap_matfilename = [id '_' slice_name{i} '_' histomap_id{k}.stain_shortname{k} '_HistoParmaps.mat'];
                save([dest_path histo_parmap_matfilename],'AreaFraction','AvgOD_whole','AvgOD_AboveThresh')
            end
        end
    end
end