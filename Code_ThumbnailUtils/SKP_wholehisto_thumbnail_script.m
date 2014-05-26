load([rootpath 'SKP-IDtag'])

% src_histo_subpath = '01_Set 1 - P0_GFAP_GFP_10x\08-P0 thresholded\';
src_histo_subpath = '01_Set 1 - P0_GFAP_GFP_10x\09-GFP thresholded\';
% src_histo_subpath = '02_Set 2 - MBP_Axons_10x\07-MBP thresholded\';
% src_histo_subpath = '02_Set 2 - MBP_Axons_10x\08-Axons thresholded\';
% src_histo_subpath = '03_Set 3 - Eriochrome_10x\07-EC thresholded\';
histoname = 'GFP';

for j=1:14


    id = IDtag{j}.id
    src_histo_path = ['F:\SKP-SC analysis\' id '\03-Segmentation\02_Histology\' src_histo_subpath];
    
    
    dest_basepath = ['F:\SKP-SC analysis\Group Results\02-WholeCordHisto\'];
    mkdir(dest_basepath);

    filelist = rdir([src_histo_path '*.jpg']);
    n_im = length(filelist);
    order = zeros(1,n_im);
    im = cell(n_im);
    for i=1:n_im
        [pathstr,name,ext,versn] = fileparts(filelist(i).name);
        try
            order(i) = str2num(name);
        catch exception
            disp('name');
        end
    end
    order = sort(order);
    ncols = 8;
    nrows = ceil(n_im/ncols);
    
    origdir = pwd;
    cd(src_histo_path);
    h=figure(1);
    set(h,'Position',[0 0 2000 800])

    for i=1:n_im
        if order(i) < 10 && order(i) > 0
            filename = ['0' num2str(order(i)) '.jpg'];
        else
            filename = [num2str(order(i)) '.jpg'];
        end
        figure(1); subplot_tight(nrows,ncols,i); imshow(imread(filename)); title(filename(1:(end-4)));
    end
    tightfig;
    
    cd(origdir);
    
    
    dest_filename = ['WholeCordHisto_' id histoname '.tif'];
    saveas(h,[dest_basepath dest_filename], 'tif');
    close(h);
end


