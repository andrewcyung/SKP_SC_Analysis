function dest_im = im_pad_flip_move(src_im,flipdir,dr)

    if strcmp(flipdir,'lr')
        imflip = fliplr(src_im);
    else
        imflip = flipud(src_im);
    end
    impadflip = zeros(256);
    impadflip(65:192,65:192) = imflip;
    dest_im = circshift(impadflip,[dr(2) dr(1)]);
