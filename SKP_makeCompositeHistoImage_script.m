src_path = 'F:\SKP-SC analysis\11\05-Registration\03-Axon_BtwnSectionSmooth_Rigid\02-Results\03-epicentre\';
tfm_path = 'F:\SKP-SC analysis\11\05-Registration\03-Axon_BtwnSectionSmooth_Rigid\02-Results\03-epicentre\';
exclusion_ROI_path = 'F:\SKP-SC analysis\11\03-Segmentation\02_Histology\02_Set 2 - MBP_Axons_10x\12-Exclusion Areas for Summation Image\02-Results\';
dest_path = tfm_path;

fixed_im_filename = '22.tif';
moving_im_filename = { '20.tif'; ...
                        '21.tif'; ...
                        '23.tif'; ...
                        '24.tif'; ...
                        '25.tif'};

moving_transform_filename = {'20_transform0.tfm'; ...
                        '21_transform0.tfm'; ...
                        '23_transform0.tfm'; ...
                        '24_transform1.tfm'; ...
                        '25_transform0.tfm'};
                    
% manual_shift = [0 -200];                    
manual_shift = [0 0];                    
tfm_pixsize = 0.35278;
                   
n_moving = length(moving_im_filename);
fixed_im = imread([src_path fixed_im_filename]);
fixed_im = circshift(fixed_im,manual_shift);
sum_im = double(fixed_im);
imsize = size(sum_im);
% sum_im = zeros(imsize);
nx = imsize(2);
ny = imsize(1);
n_included = zeros(imsize);

figure(1);imagesc(sum_im);colormap gray;axis image;

for i=1:n_moving
    im_filename = moving_im_filename{i};
    tfm_filename = moving_transform_filename{i};
    src_im = imread([src_path im_filename]);
    src_im = circshift(src_im,manual_shift);
    
    tfm_matrix = read_itk_tfm_file([tfm_path tfm_filename]);
    tfm_matrix(3,:) = tfm_matrix(3,:)/tfm_pixsize;
    tfm = maketform('affine',tfm_matrix);

    [moving_im,x,y] = imtransform(src_im,tfm,...
        'XData', [1 size(src_im, 2)] + tfm_matrix(3,1),...
        'YData', [1 size(src_im, 1)] + tfm_matrix(3,2),...
        'FillValues', 0);

    m_size = size(moving_im);
    m_nx = m_size(2);
    m_ny = m_size(1);

    x = floor(x);
    y = floor(y);

    disp(['x1=' num2str(x(1)) ' y1=' num2str(y(1))])
    
    aligned_im = circshift(moving_im,[-y(1) -x(1)]);
    
    aligned_size = size(aligned_im);
    a_ny = aligned_size(1);
    a_nx = aligned_size(2);
    
    if a_ny > ny
        aligned_im = aligned_im(1:ny,:);
    else
        aligned_im = [aligned_im; zeros(ny-a_ny,a_nx)];
    end
    
    if a_nx > nx
        aligned_im = aligned_im(:,1:nx);
    else
        aligned_size = size(aligned_im);
        a_ny = aligned_size(1);
        aligned_im = [aligned_im zeros(a_ny,nx-a_nx)];
    end
    
    sum_im = sum_im + double(aligned_im);

    exclude_ROI_filename = [moving_im_filename{i}(1:(end-3)) 'ov1'];
    ROI_list = rdir([exclusion_ROI_path exclude_ROI_filename]);
    if length(ROI_list) == 1
        exclude_ROI = imread(ROI_list(1).name);
        exclude_ROI = circshift(exclude_ROI,[-y(1) -x(1)]);
        
        ROI_size = size(exclude_ROI);
        r_ny = ROI_size(1);
        r_nx = ROI_size(2);
        
        if r_ny >= ny
            exclude_ROI = exclude_ROI(1:ny,:);
        else
            exclude_ROI = [exclude_ROI; zeros(ny-r_ny,r_nx)];
        end
        
        if r_nx >= nx
            exclude_ROI = exclude_ROI(:,1:nx);
        else
            roi_size = size(exclude_ROI);
            r_ny = roi_size(1);
            exclude_ROI = [exclude_ROI zeros(r_ny,nx-r_nx)];
        end
        n_included(~exclude_ROI) = n_included(~exclude_ROI) + 1;

    else
        n_included = n_included + 1;
    end
    
    figure(1);imagesc(sum_im);colormap gray;axis image;
    
end

avg_im = sum_im ./ n_included;
figure(2);imagesc(avg_im);colormap gray;axis image;
imwrite(mat2gray(avg_im),[dest_path 'sum_image.tif'],'tif');

