function status = ov2pngfile(ov_filename)
    [pathstr name ext] = fileparts(ov_filename);
    if strcmp(ext(1:3),'.ov')
        im = imread(ov_filename);
        bmp_filename = [name '.png'];
        imwrite(im,[pathstr '\' bmp_filename],'png');
        status = 1;
    else
        status = 0;
        disp('not a ov file');
    end
        
end