rootpath = 'F:\SKP-SC analysis\';

load(['F:\SKP-SC analysis\' 'SKP-IDtag']) %loads IDtag
load(['F:\SKP-SC analysis\' 'SKP_matchkey_ay_original']) %loads matchkey

slice_name{1} = '1EdgeCaudal';
slice_name{2} = '2MidCaudal';
slice_name{3} = '3Epicentre';
slice_name{4} = '4MidCranial';
slice_name{5} = '5EdgeCranial';

stains{1} = '_AxonSum';
stains{2} = 'Axon';
stains{3} = 'EC';

n_stain = length(stains);

dest_path = [rootpath 'Group Results\05-ROIgrid overlays\'];

h=figure(1);

for j=1:14
    id = matchkey{j}.id
    src_path = [rootpath id '\06-Transformation\01-HistologyParMaps\02-Results\'];

    segDone = 1;
    for i=1:5
        figure(h); clf; segDone = 1;
        for k=1:n_stain
            src_filename = [src_path 'ROIgrid_' id '_' slice_name{i} '_' stains{k} '.jpg'];
            src_filelist = rdir(src_filename);
            if length(src_filelist) == 1
               figure(h); subplot_tight(1,n_stain,k); imshow(src_filename);
            else
                segDone=0;
            end

        end        

        if segDone
            tightfig;
            dest_filename = ['ROIgrid_' id '_' slice_name{i} '_All.tif'];
            saveas(h,[dest_path dest_filename], 'tif');
        end
    end
end


