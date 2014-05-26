rootpath = 'F:\SKP-SC analysis\';
pathname = '05-Registration\06-MRI_Axon_MI_Affine\01-Source data\01-edge_caudal\';
src_path = [rootpath '11' '\' pathname];
im_filename = '11.tif';
tfm_filename = '11_transform1.tfm';
fixed_im = imread([src_path im_filename]);
tfm_matrix = read_itk_tfm_file([src_path tfm_filename]);
tfm_pixsize = 0.35278;
tfm_matrix(3,:) = tfm_matrix(3,:)/tfm_pixsize;

tfm = maketform('affine',tfm_matrix);
[moving_im,x,y] = imtransform(fixed_im,tfm,...
                        'XData', [1 size(fixed_im, 2)] + tfm_matrix(3,1),...
                        'YData', [1 size(fixed_im, 1)] + tfm_matrix(3,2),...
                        'FillValues', 0);
figure(1);imagesc(fixed_im);colormap gray;axis image;
figure(2);imagesc(x,y,moving_im);colormap gray;axis image;