section_path{1} = '01-edge_caudal';
section_path{2} = '02-mid_caudal';
section_path{3} = '03-epicentre';
section_path{4} = '04-mid_cranial';
section_path{5} = '05-edge_cranial';

comparison_dir = '03-original images';

load(['F:\SKP-SC analysis\' 'SKP_matchkey_leo_original'])

dummyim = zeros(256);

for j=1:1

    id = matchkey{j}.id
    src_MRI_basepath = ['F:\SKP-SC analysis\' id '\04-Preprocessing\01-rough MRI centroid alignment and cropping\02-Results\'];
    src_histo_basepath = ['F:\SKP-SC analysis\' id '\01-Original Images\02-Optical Histology\'];
    src_histo_subpath{1} = '01_Set 1 - P0_GFAP_GFP_10x\';
    src_histo_subpath{2} = '02_Set 2 - MBP_Axons_10x\';
    src_histo_subpath{3} = '03_Set 3 - Eriochrome_10x\';
    
    
    dest_basepath = ['F:\SKP-SC analysis\' id '\02-Image Correspondences\01-MRI-HistologySet1-3Leo_10x\'];

    for i=1:1
        disp(num2str(i));
        dest_path = [dest_basepath section_path{i}];
        src_MRI_path = [src_MRI_basepath section_path{i}];  
        dest_MRI_path = [dest_basepath section_path{i} '\01-MRI\'];
        mkdir(dest_MRI_path);
        symlinker(src_MRI_path,dest_MRI_path);
        
        startindex = matchkey{j}.histoextent(i,1);
        endindex = matchkey{j}.histoextent(i,2);
        n_histo = endindex-startindex+1;
        
        for k=1:3
            src_histo_path = [src_histo_basepath src_histo_subpath{k}];  
            dirlist = rdir(src_histo_path,'isdir==1');
            dest_basepath2 = [dest_basepath section_path{i} '\02-Histo\'];
            mkdir([dest_basepath2 src_histo_subpath{k}])
            if length(dirlist)==0
               src_histo_full_path = src_histo_path;
               dest_path = [dest_basepath2 src_histo_subpath{k}];
               mkdir(dest_path);
               for p=1:n_histo
                  foundfiles = rdir([src_histo_full_path num2str(startindex+p-1) '.*']);
                  if length(foundfiles)==0
                     imwrite(dummyim,[dest_path '\' num2str(startindex+p-1) '.jpg'],'jpg')
                     imwrite(dummyim,[dest_path '\' num2str(startindex+p-1) '.tif'],'tif')
                  else
                    for q=1:length(foundfiles)
                        [pathstr filename ext] = fileparts(foundfiles(q).name);
                        shortname = [filename ext];
                        symlinker_file(shortname,src_histo_full_path,dest_path); 
                    end
                  end
               end
            else
                for m=1:length(dirlist)
                    [parentdir subdir] = fileparts(dirlist(m).name);
                    dest_path = [dest_basepath2 src_histo_subpath{k} subdir];
                    mkdir(dest_path);
                    src_histo_full_path = [dirlist(m).name '\'];
                   for p=1:n_histo
                      foundfiles = rdir([src_histo_full_path num2str(startindex+p-1) '.*']);
                      if length(foundfiles)==0
                         imwrite(dummyim,[dest_path '\' num2str(startindex+p-1) '.jpg'],'jpg')
                         imwrite(dummyim,[dest_path '\' num2str(startindex+p-1) '.tif'],'tif')
                      else
                        for q=1:length(foundfiles)
                            [pathstr filename ext] = fileparts(foundfiles(q).name);
                            shortname = [filename ext];
                            symlinker_file(shortname,src_histo_full_path,dest_path); 
                        end
                      end
                   end
                end
            end
        end
    end
end


