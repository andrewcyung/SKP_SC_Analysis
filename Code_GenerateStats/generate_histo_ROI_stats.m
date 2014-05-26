function results = generate_histo_ROI_stats(im_path,ROI_path,seg_path)

im = imread(im_path);
imsize = size(im);
if length(imsize) > 2
    disp('generate_ROI_stats: input image has more than one channel');
    return;
end

ROI = imread(ROI_path);
seg = imread(seg_path);
stained_pixels = im(ROI(seg));

results.n_ROI_points = length(im(ROI));
results.n_seg_points = length(im(seg));
results.data = stained_pixels(:);
results.segavg = mean(results.data);
results.segstdev = std(results.data);
results.median = median(results.data);
results.n_stainfraction = results.n_seg_points/results.n_ROI_points;
