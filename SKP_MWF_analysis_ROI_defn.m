src_basepath = 'E:\mriuser\nmr\';
dest_basepath = 'F:\SKP-SC analysis\';
dest_basepath2 = '01-Original Images\01-MRI\';

% id='11';
% exp_cran2caud =[11 9 7 8 10];
% studypath = 'PK048wk11.551';
% 

% id='16';
% exp_cran2caud = [10 8 7 9 11];
% studypath = 'PK048wk16.511';
 
% id='18';
% exp_cran2caud = [13 11 10 12 14];
% studypath = 'PK048wk18.531';

% id='20';
% exp_cran2caud = [12 10 9 15 16];
% studypath = 'PK048wk20.521';
% 
% id='36';
% exp_cran2caud = [11 9 8 10 12];
% studypath = 'PK04_36.3K1';
% 
% id='39';
% exp_cran2caud = [19 17 15 16 18];
% studypath = 'PK04_39.3F1';
% 
id='41';
exp_cran2caud = [18 10 8 17 19];
studypath = 'PK04_41.3F1';
% 
% id='51';
% exp_cran2caud = [14 12 11 13 15];
% studypath = 'PK04_51.3K1';
% 
% id='54';
% exp_cran2caud = [11 9 8 10 12];
% studypath = 'PK04_54.3G1';
% 
% id='55';
% exp_cran2caud = [22 20 19 21 23];
% studypath = 'PK04_55.3G1';
% 
% id='56';
% exp_cran2caud = [11 9 8 10 12];
% studypath = 'PK04_56.3H1';
% 
% id='58';
% exp_cran2caud = [12 10 8 9 11];
% studypath = 'PK04_58.3G1';
% 
% id='61';
% exp_cran2caud = [11 9 8 10 11];
% studypath = 'PK04_61.3H1';

% id='62';
% exp_cran2caud = [12 10 8 11 13];
% studypath = 'PK04_62.3H1';


for i_slice=1:5
    srcpath = [src_basepath studypath '\' num2str(exp_cran2caud(i_slice))];
    CPMGset = get2dseq(srcpath,1);
    figure(1); imagesc(CPMGset.data(:,:,11)); axis image; colormap gray;
    ROI{i_slice} = roipoly;
    figure(5); imagesc(ROI{i_slice}); axis image; colormap gray;
    uiwait;
end

destpath = [dest_basepath id '\' dest_basepath2];

save([destpath 'MWFgen_ROI_' id],'ROI');