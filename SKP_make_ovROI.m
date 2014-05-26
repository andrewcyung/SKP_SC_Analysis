id = '11';
file_basename = '11';

mask_colour = [1 1 0]; %yellow


im_path = ['F:\SKP-SC analysis\' id '\03-Segmentation\02_Histology\01_Set 1 - P0_GFAP_GFP_10x\07-Inclusion Areas for Analysis\01-GFAP_blue\'];
dest_path{1} = im_path;

im = imread([im_path file_basename '.tif']);
figure(1); imshow(im);
ROI = roipoly;
uiwait;
ov_filename = [file_basename '.ov1'];
imwrite(ROI,[dest_path{1} ov_filename],'bmp');
dest_file{1} = [dest_path{1} ov_filename];
SKP_make_ROI_thumbnail(dest_file,[im_path file_basename '.tif'],'outline',mask_colour,0.5,0.5)

