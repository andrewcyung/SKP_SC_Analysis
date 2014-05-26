function [status message] = SKP_make_ROI_thumbnail(ROIpathlist,src_impath,ROIdispmode,mask_colour,dimming_factor,transparency,n_ROIrequested,dest_path)

if n_ROIrequested == 0
    n_ROI = length(ROIpathlist);
else
    n_ROI = n_ROIrequested;
end

if n_ROI == 0
    return;
end

for i=1:n_ROI
   ROI{i} = imread(ROIpathlist(i).name); 
end

if strcmp(dest_path,'')
    src_im = imread(src_impath);
else
    src_im = imread(dest_path);
end

imsize = size(src_im);

if size(ROI{1}) ~= imsize(1:2)
    status = -1;
    message = 'incompatible sizes';
    return;
end

dest_im = src_im;
n_ROI = length(ROI);
composite_ROI = zeros([size(ROI{1}) 3]);
r_ROI = zeros(size(ROI{1}));
g_ROI = zeros(size(ROI{1}));
b_ROI = zeros(size(ROI{1}));

if strcmp(ROIdispmode,'outline')
    h=figure(1); imshow(src_im); hold on; axis image
    for k=1:n_ROI
        outline = bwboundaries(ROI{k});
        n_boundaries = length(outline);
        for i=1:n_boundaries
            plot(outline{i}(:,2), outline{i}(:,1), 'Color', mask_colour{k}, 'LineWidth', 2)
            axis off
        end
    end
    hold off
    status = 1; message ='';
elseif strcmp(ROIdispmode,'overlay')
    for k=1:n_ROI
        colour = mask_colour{k};
        r_ROI(ROI{k}) = colour(1);
        g_ROI(ROI{k}) = colour(2);
        b_ROI(ROI{k}) = colour(3);
    end
    composite_ROI(:,:,1) = r_ROI;
    composite_ROI(:,:,2) = g_ROI;
    composite_ROI(:,:,3) = b_ROI;
    
%     gray_ROI = rgb2gray(composite_ROI);
%     
%     r = squeeze(src_im(:,:,1));
%     g = squeeze(src_im(:,:,2));
%     b = squeeze(src_im(:,:,3));
%     r(gray_ROI==0) = dimming_factor*r(gray_ROI==0);
%     g(gray_ROI==0) = dimming_factor*g(gray_ROI==0);
%     b(gray_ROI==0) = dimming_factor*b(gray_ROI==0);
%     src_im(:,:,1) = r;
%     src_im(:,:,2) = g;
%     src_im(:,:,3) = b;


    
    h=figure(1); imshow(src_im); hold on; axis image
    himg = imshow(composite_ROI); set(himg,'AlphaData',transparency);
    hold off
    axis off
    status = 1; message ='';
else
    message = 'invalid option for ROI thumbnail generation';
    status = -1;
end

if strcmp(dest_path,'')
    [pathstr base ext vrsn] = fileparts(src_impath);
else
    [pathstr base ext vrsn] = fileparts(dest_path);
end

delete([pathstr '\' base '.jpg'])
saveas(h,[pathstr '\' base '.jpg'],'jpg');
