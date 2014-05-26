src_basepath = 'E:\mriuser\nmr\';
dest_basepath = 'F:\SKP-SC analysis\';
dest_basepath2 = '01-Original Images\01-MRI\';

% id='11';
% expno='12';
% studypath = 'PK048wk11.551';
% orientation = 'caudal2cranial';
% 

id='16';
expno='6';
studypath = 'PK048wk16.511';
orientation = 'cranial2caudal';

% id='18';
% expno='15';
% studypath = 'PK048wk18.531';
% orientation = 'cranial2caudal';

% id='20';
% expno='14';
% studypath = 'PK048wk20.521';
% orientation = 'cranial2caudal';
% 
% id='36';
% expno='7';
% studypath = 'PK04_36.3K1';
% orientation = 'cranial2caudal';
% 
% id='39';
% expno='14';
% studypath = 'PK04_39.3F1';
% orientation = 'caudal2cranial';
% 
% id='41';
% expno='7';
% studypath = 'PK04_41.3F1';
% orientation = 'cranial2caudal';
% 
% id='51';
% expno='10';
% studypath = 'PK04_51.3K1';
% orientation = 'cranial2caudal';
% 
% id='54';
% expno='7';
% studypath = 'PK04_54.3G1';
% orientation = 'cranial2caudal';
% 
% id='55';
% expno='18';
% studypath = 'PK04_55.3G1';
% orientation = 'cranial2caudal';
% 
% id='56';
% expno='7';
% studypath = 'PK04_56.3H1';
% orientation = 'cranial2caudal';
% 
% id='58';
% expno='7';
% studypath = 'PK04_58.3G1';
% orientation = 'caudal2cranial';
% 
% id='61';
% expno='7';
% studypath = 'PK04_61.3H1';
% orientation = 'cranial2caudal';
% 
% id='62';
% expno='9';
% studypath = 'PK04_62.3H1';
% orientation = 'cranial2caudal';

srcpath = [src_basepath studypath '\' expno];
if strcmp(orientation,'cranial2caudal')
    destpath{1} = [dest_basepath id '\' dest_basepath2 '05-edge_cranial\'];
    destpath{2} = [dest_basepath id '\' dest_basepath2 '04-mid_cranial\'];
    destpath{3} = [dest_basepath id '\' dest_basepath2 '03-epicentre\'];
    destpath{4} = [dest_basepath id '\' dest_basepath2 '02-mid_caudal\'];
    destpath{5} = [dest_basepath id '\' dest_basepath2 '01-edge_caudal\'];
else
    destpath{5} = [dest_basepath id '\' dest_basepath2 '05-edge_cranial\'];
    destpath{4} = [dest_basepath id '\' dest_basepath2 '04-mid_cranial\'];
    destpath{3} = [dest_basepath id '\' dest_basepath2 '03-epicentre\'];
    destpath{2} = [dest_basepath id '\' dest_basepath2 '02-mid_caudal\'];
    destpath{1} = [dest_basepath id '\' dest_basepath2 '01-edge_caudal\'];
end

DTIset = get2dseq(srcpath,2);

for i_slice=1:5
    imFA = squeeze(DTIset.data(:,:,1,i_slice)); save([destpath{i_slice} 'FA'], 'imFA');
    imADC = squeeze(DTIset.data(:,:,2,i_slice)); save([destpath{i_slice} 'ADC'], 'imADC');
    imTrW = squeeze(DTIset.data(:,:,4,i_slice)); save([destpath{i_slice} 'TrW'], 'imTrW');
    imDlong = squeeze(DTIset.data(:,:,11,i_slice)); save([destpath{i_slice} 'Dlong'], 'imDlong');
    imDtrans = squeeze(0.5*(DTIset.data(:,:,12,i_slice) + DTIset.data(:,:,13,i_slice))); save([destpath{i_slice} 'Dtrans'], 'imDtrans');
    
    h1 = figure(1); axis image; imagesc(imFA); title('FA'); colorbar; caxis([0 0.5]); colormap('jet'); saveas(h1, [destpath{i_slice} 'FA'],'png');
    h2 = figure(2); axis image; imagesc(imADC); title('ADC'); colorbar; caxis([0 1.4e-3]); colormap('jet'); saveas(h2, [destpath{i_slice} 'ADC'],'png');
    h3 = figure(3); axis image; imagesc(imTrW); title('TrW'); colorbar; colormap('gray'); saveas(h3, [destpath{i_slice} 'TrW'],'png');
    h4 = figure(4); axis image; imagesc(imDtrans); title('Dtrans'); colorbar; caxis([0 1.4e-3]); colormap('jet'); saveas(h4, [destpath{i_slice} 'Dtrans'],'png');
    h5 = figure(5); axis image; imagesc(imDlong); title('Dlong'); colorbar; caxis([0 1.4e-3]); colormap('jet'); saveas(h5, [destpath{i_slice} 'Dlong'],'png');
    
    imwrite(imFA,[destpath{i_slice} 'FA.tif'],'tiff');
end


