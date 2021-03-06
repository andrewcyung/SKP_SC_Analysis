function [AreaFraction, AvgOD_Whole, AvgOD_AboveThresh, IntegOD_AboveThresh, InclMask] = makeHistoParmaps(histo_im,threshold_mask,excl_mask,whole_mask,ROIGrid,pixel_pos_i,pixel_pos_j,imsize)

% applies ROI grid to the histology sections corresponding to one MRI slice
% to create a map of histology parameters (Area fraction, average optical
% density over entire warped MRI pixel, average optical density over thresholded
% areas in the entire warped MRI pixel.

AreaFraction = zeros(imsize);
AvgOD_Whole = zeros(imsize);
AvgOD_AboveThresh = zeros(imsize);
IntegOD_AboveThresh = zeros(imsize);
InclMask = zeros(imsize);


n_ROI = length(pixel_pos_i);
n_sections = length(histo_im);


for i=1:n_sections
    all_im{i} = histo_im{i} .* uint8(~excl_mask{i});
    thresh_im{i} = histo_im{i} .* uint8(threshold_mask{i} & ~excl_mask{i});
end

for q=1:n_ROI
    all_data = [];
    thresh_data = [];
    incl_data = [];
    n_pts_all = 0;
    n_pts_thresh = 0;
    n_pts_incl = [];
    for i=1:n_sections
        gridmask = find(ROIGrid{i} == q);
        thresh_subdata = thresh_im{i}(gridmask);
        incl_subdata = whole_mask{i}(gridmask);
        all_subdata = all_im{i}(gridmask);
        thresh_data = [thresh_data nonzeros(thresh_subdata)'];
        incl_data = [incl_data nonzeros(incl_subdata)'];
            
        all_data = [all_data nonzeros(all_subdata)'];
    end
    n_pts_thresh = length(thresh_data);
    n_pts_all = length(all_data);
    n_pts_incl = length(incl_data);
    
    if n_pts_incl == 0
        InclMask(pixel_pos_i(q),pixel_pos_j(q)) = 0;
    else
        InclMask(pixel_pos_i(q),pixel_pos_j(q)) = 1;
    end
    
    AreaFraction(pixel_pos_i(q),pixel_pos_j(q)) = n_pts_thresh/n_pts_all;
    AvgOD_Whole(pixel_pos_i(q),pixel_pos_j(q)) = mean(all_data);
    AvgOD_AboveThresh(pixel_pos_i(q),pixel_pos_j(q)) = mean(thresh_data);
    IntegOD_AboveThresh(pixel_pos_i(q),pixel_pos_j(q)) = sum(thresh_data);
end

