ROI_dirname = '02-Whole section\';
rootpath = 'F:\SKP-SC analysis\'
dest_path = '07-Analysis Jobs\';
results_basename = 'histo_WholeSection_';

load([rootpath 'SKP-IDtag'])
load([rootpath 'SKP-MRImap_id'])
load([rootpath 'SKP-histomap_id'])

for j=14:14
    id = IDtag{j}.id;
    
    % generate histology ROI stats
    for m=1:length(histomap_id)
        for n=1:histomap_id{m}.n_stain
            if ~strcmp(histomap_id{m}.stain_segmapname{n},'')
                src_seg_path = [rootpath id '\03-Segmentation\02_Histology\' histomap_id{m}.setname '\' histomap_id{m}.stain_segmapname{n} '\']
                src_im_path = [rootpath id '\03-Segmentation\02_Histology\' histomap_id{m}.setname '\' histomap_id{m}.stain_segmapname{n} '\']
                src_ROI_path = [rootpath id '\03-Segmentation\02_Histology\' histomap_id{m}.setname '\' ROI_dirname]
                im_filelist = rdir([src_im_path '*.tif']);
                n_im = length(im_filelist);
                for i=1:n_im
                    [pathstr sectname extname versn] = fileparts(im_filelist(i).name);
                    im_filename = im_filelist(i).name
                    ov_seg_filelist = rdir([src_seg_path sectname '.ov*']);

                    if length(ov_seg_filelist)>0
                        segmap_filename = ov_seg_filelist(1).name;
                    end
                    ov_ROI_filelist = rdir([src_ROI_path sectname '.ov*']);

                    if length(ov_ROI_filelist)>0
                        ROI_filename = ov_ROI_filelist(1).name;
                    end
                    
                    if length(ov_seg_filelist)>0 && length(ov_ROI_filelist)>0
                        results = SKP_generate_histo_ROI_stats(im_filename,ROI_filename,segmap_filename);
                        if ~strcmp(results,'')
                            results_varname = [results_basename 'rat' id '_section' sectname '_' histomap_id{m}.stain_shortname{n}];
                            eval([results_varname '= results;']);
                        end
                    end
                end
            end
        end
    end

    save([rootpath id '\' dest_path results_basename 'rat' id],'-regexp',['^' results_basename 'rat' id]);
     
    
end