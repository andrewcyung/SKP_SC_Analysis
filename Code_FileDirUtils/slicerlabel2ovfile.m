function status = slicerlabel2ovfile(nrrd_filename,ovnum)
    [pathstr name ext] = fileparts(nrrd_filename);
    if strcmp(ext,'.nrrd')
        im = nrrdread(nrrd_filename);
        roi = logical(im); 
        ov_filename = [name(1:(end-6)) '.ov' num2str(ovnum)];
%         ov_filename = [name '.ov' num2str(ovnum)];
%         ov_filename = [name(1:(end-2)) '.ov' num2str(ovnum)];
        imwrite(roi,[pathstr '\' ov_filename],'bmp');
        status = 1;
    else
        status = 0;
        disp('not a nrrd file');
    end
        
end