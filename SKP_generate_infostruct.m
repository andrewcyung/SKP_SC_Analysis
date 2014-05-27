origdir = pwd;

cd('F:\SKP-SC analysis\');

clear slice_name

slice_name{1} = '1EdgeCaudal';
slice_name{2} = '2MidCaudal';
slice_name{3} = '3Epicentre';
slice_name{4} = '4MidCranial';
slice_name{5} = '5EdgeCranial';

save SKP_slice_name slice_name

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear histo_stain

histo_stain{1}.name = 'GFAP';
histo_stain{1}.setdir = '01_Set 1 - P0_GFAP_GFP_10x';
histo_stain{1}.setindex = 1;
histo_stain{1}.dirname = '01-GFAP_blue\';
histo_stain{1}.segmapdir = '';
histo_stain{1}.main_ROI_staindir = '01-GFAP_blue\';
histo_stain{1}.seg_ovnum = 1;
histo_stain{1}.runParMaps = 0;
histo_stain{1}.runROIgridImport = 0;
histo_stain{1}.interset_tfm_name = 'P0';

histo_stain{2}.name = 'GFP_Set1';
histo_stain{2}.setdir = '01_Set 1 - P0_GFAP_GFP_10x';
histo_stain{2}.setindex = 1;
histo_stain{2}.dirname = '02-GFP_green\';
histo_stain{2}.segmapdir = '12-GFP thresholded';
histo_stain{2}.main_ROI_staindir = '01-GFAP_blue\';
histo_stain{2}.seg_ovnum = 1;
histo_stain{2}.runParMaps = 0;
histo_stain{2}.runROIgridImport = 0;
histo_stain{2}.interset_tfm_name = 'P0';

histo_stain{3}.name = 'P0';
histo_stain{3}.setdir = '01_Set 1 - P0_GFAP_GFP_10x';
histo_stain{3}.setindex = 1;
histo_stain{3}.dirname = '03-P0_red\';
histo_stain{3}.segmapdir = '11-P0 thresholded';
histo_stain{3}.main_ROI_staindir = '01-GFAP_blue\';
histo_stain{3}.seg_ovnum = 1;
histo_stain{3}.runParMaps = 0;
histo_stain{3}.runROIgridImport = 1;
histo_stain{3}.interset_tfm_name = 'P0';

histo_stain{4}.name = 'MBP';
histo_stain{4}.setdir = '02_Set 2 - MBP_Axons_10x';
histo_stain{4}.setindex = 2;
histo_stain{4}.dirname = '01-MBP_red\';
histo_stain{4}.segmapdir = '15-MBP thresholded Otsu';
histo_stain{4}.main_ROI_staindir = '02-Axons_blue\';
histo_stain{4}.seg_ovnum = 5;
histo_stain{4}.runParMaps = 1;
histo_stain{4}.runROIgridImport = 1;
histo_stain{4}.interset_tfm_name = '';
histo_stain{4}.upstreamData{1} = struct('name','MBP w/ROIgrid section ',...
                                       'srcfile','',...
                                       'filetype','.tif',...
                                       'dirpath','',...
                                       'options',containers.Map({'ROIGrid_path',''},...
                                                                {'seg_mask_pathname',''}),...
                                       'dispFcnName','DisplayZoomedHisto_PixelGridROI');
                                   

histo_stain{5}.name = 'Axon';
histo_stain{5}.setdir = '02_Set 2 - MBP_Axons_10x';
histo_stain{5}.setindex = 2;
histo_stain{5}.dirname = '02-Axons_blue\';
histo_stain{5}.segmapdir = '16-Axons thresholded Otsu';
histo_stain{5}.main_ROI_staindir = '02-Axons_blue\';
histo_stain{5}.seg_ovnum = 6;
histo_stain{5}.runParMaps = 1;
histo_stain{5}.runROIgridImport = 1;
histo_stain{5}.interset_tfm_name = '';

histo_stain{6}.name = 'GFP_Set2';
histo_stain{6}.setdir = '02_Set 2 - MBP_Axons_10x';
histo_stain{6}.setindex = 2;
histo_stain{6}.dirname = '03-GFP_green\';
histo_stain{6}.segmapdir = 'none';
histo_stain{6}.main_ROI_staindir = '02-Axons_blue\';
histo_stain{6}.seg_ovnum = 1;
histo_stain{6}.runParMaps = 0;
histo_stain{6}.runROIgridImport = 0;
histo_stain{6}.interset_tfm_name = 0'';

histo_stain{7}.name = 'EC';
histo_stain{7}.setdir = '03_Set 3 - Eriochrome_10x';
histo_stain{7}.setindex = 3;
histo_stain{7}.dirname = '';
histo_stain{7}.segmapdir = '15-EC thresholded Otsu';
histo_stain{7}.main_ROI_staindir = '';
histo_stain{7}.seg_ovnum = 6;
histo_stain{7}.runParMaps = 1;
histo_stain{7}.runROIgridImport = 1;
histo_stain{7}.interset_tfm_name = 'EC';

save SKP_histo_stain histo_stain

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TE=6.738/1000;
n_echoes = 32;
te_temp = (TE*1000):(TE*1000):(TE*1000*n_echoes);
T2Times=te_temp(1)+exp(((0:100)+1)/101*log(1500)); % 7T way

clear MRImap_id

MRImap_id{1}.filename = 'FA';
MRImap_id{1}.varname = 'imFA';
MRImap_id{1}.datasetobj_name = 'FA';
MRImap_id{1}.isDisplayed = 1;
MRImap_id{1}.upstreamData{1} = struct('name','',...
                                       'srcfile','',...
                                       'filetype','',...
                                       'dirpath','',...
                                       'im2src_tfm',NaN,...
                                       'options',containers.Map,...
                                       'disp_fcn','');
                                   
MRImap_id{2}.filename = 'ADC';
MRImap_id{2}.varname = 'imADC';
MRImap_id{2}.datasetobj_name = 'ADC';
MRImap_id{2}.isDisplayed = 1;
MRImap_id{2}.upstreamData{1} = struct('name','',...
                                       'srcfile','',...
                                       'filetype','',...
                                       'dirpath','',...
                                       'im2src_tfm',NaN,...
                                       'options',containers.Map,...
                                       'disp_fcn','');

MRImap_id{3}.filename = 'Dlong';
MRImap_id{3}.varname = 'imDlong';
MRImap_id{3}.datasetobj_name = 'Dlong';
MRImap_id{3}.isDisplayed = 1;
MRImap_id{3}.upstreamData{1} = struct('name','',...
                                       'srcfile','',...
                                       'filetype','',...
                                       'dirpath','',...
                                       'im2src_tfm',NaN,...
                                       'options',containers.Map,...
                                       'disp_fcn','');
                                   
MRImap_id{4}.filename = 'Dtrans';
MRImap_id{4}.varname = 'imDtrans';
MRImap_id{4}.datasetobj_name = 'Dtrans';
MRImap_id{4}.isDisplayed = 1;
MRImap_id{4}.upstreamData{1} = struct('name','',...
                                       'srcfile','',...
                                       'filetype','',...
                                       'dirpath','',...
                                       'im2src_tfm',NaN,...
                                       'options',containers.Map,...
                                       'disp_fcn','');
                                   
MRImap_id{5}.filename = 'TrW';
MRImap_id{5}.varname = 'imTrW';
MRImap_id{5}.datasetobj_name = 'TrW';
MRImap_id{5}.isDisplayed = 1;
MRImap_id{5}.upstreamData{1} = struct('name','',...
                                       'srcfile','',...
                                       'filetype','',...
                                       'dirpath','',...
                                       'im2src_tfm',NaN,...
                                       'options',containers.Map,...
                                       'disp_fcn','');
                                   
MRImap_id{6}.filename = 'CPMG_dn';
MRImap_id{6}.varname = 'imDn';
MRImap_id{6}.datasetobj_name = 'CPMG_So';
MRImap_id{6}.isDisplayed = 1;
MRImap_id{6}.upstreamData{1} = struct('name','',...
                                       'srcfile','',...
                                       'filetype','',...
                                       'dirpath','',...
                                       'im2src_tfm',NaN,...
                                       'options',containers.Map,...
                                       'disp_fcn','');
                                   
MRImap_id{7}.filename = 'CPMG_echo10';
MRImap_id{7}.varname = 'CPMG_echo10';
MRImap_id{7}.datasetobj_name = 'CPMG_echo10';
MRImap_id{7}.isDisplayed = 1;
MRImap_id{7}.upstreamData{1} = struct('name','',...
                                       'srcfile','',...
                                       'filetype','',...
                                       'dirpath','',...
                                       'im2src_tfm',NaN,...
                                       'options',containers.Map,...
                                       'disp_fcn','');
                                   
MRImap_id{8}.filename = 'CPMG_flipangle';
MRImap_id{8}.varname = 'imAlpha';
MRImap_id{8}.datasetobj_name = 'CPMG_flipangle';
MRImap_id{8}.isDisplayed = 1;
MRImap_id{8}.upstreamData{1} = struct('name','',...
                                       'srcfile','',...
                                       'filetype','',...
                                       'dirpath','',...
                                       'im2src_tfm',NaN,...
                                       'options',containers.Map,...
                                       'disp_fcn','');
                                   
MRImap_id{9}.filename = 'CPMG_misfit';
MRImap_id{9}.varname = 'imMisfit';
MRImap_id{9}.datasetobj_name = 'CPMG_misfit';
MRImap_id{9}.isDisplayed = 1;
MRImap_id{9}.upstreamData{1} = struct('name','',...
                                       'srcfile','',...
                                       'filetype','',...
                                       'dirpath','',...
                                       'im2src_tfm',NaN,...
                                       'options',containers.Map,...
                                       'disp_fcn','');
                                   
MRImap_id{10}.filename = 'CPMG_MWF';
MRImap_id{10}.varname = 'imMWF';
MRImap_id{10}.datasetobj_name = 'MWF';
MRImap_id{10}.isDisplayed = 1;
MRImap_id{10}.upstreamData{1} = struct('name','T2 distribution',...
                                       'srcfile','CPMG_T2dist',...
                                       'filetype','.mat',...
                                       'dirpath','',...
                                       'im2src_tfm',NaN,...
                                       'options',containers.Map({'varname','T2Times'},...
                                                                {'imT2dist',T2Times}),...
                                       'dispFcnName','plot_T2dist');
                                   
MRImap_id{11}.filename = 'CPMG_SNR';
MRImap_id{11}.varname = 'imSNR';
MRImap_id{11}.datasetobj_name = 'CPMG_SNR';
MRImap_id{11}.isDisplayed = 1;
MRImap_id{11}.upstreamData{1} = struct('name','',...
                                       'srcfile','',...
                                       'filetype','',...
                                       'dirpath','',...
                                       'im2src_tfm',NaN,...
                                       'options',containers.Map,...
                                       'disp_fcn','');
                                   

save SKP-MRImap_id MRImap_id

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear IDtag

IDtag{1}.id='11';
IDtag{1}.MWFexp_cran2caud =[11 9 7 8 10];
IDtag{1}.studypath = 'PK048wk11.551';
IDtag{1}.DTIexp = 12;
IDtag{1}.DTIdir = 'caudal2cranial';
IDtag{1}.ABCid = 'A';
IDtag{1}.Nameid = 'Tim';
IDtag{1}.Group = '8wk';

IDtag{2}.id='16';
IDtag{2}.MWFexp_cran2caud = [10 8 7 9 11];
IDtag{2}.studypath = 'PK048wk16.511';
IDtag{2}.DTIexp = 6;
IDtag{2}.DTIdir = 'cranial2cranial';
IDtag{2}.ABCid = 'F';
IDtag{2}.Nameid = 'Matt';
IDtag{2}.Group = '8wk';
 
IDtag{3}.id='18';
IDtag{3}.MWFexp_cran2caud = [13 11 10 12 14];
IDtag{3}.studypath = 'PK048wk18.531';
IDtag{3}.DTIexp = 15;
IDtag{3}.DTIdir = 'cranial2cranial';
IDtag{3}.ABCid = 'L';
IDtag{3}.Nameid = 'Shane';
IDtag{3}.Group = '8wk';

IDtag{4}.id='20';
IDtag{4}.MWFexp_cran2caud = [12 10 9 15 16];
IDtag{4}.studypath = 'PK048wk20.521';
IDtag{4}.DTIexp = 14;
IDtag{4}.DTIdir = 'cranial2cranial';
IDtag{4}.ABCid = 'I';
IDtag{4}.Nameid = 'Luke';
IDtag{4}.Group = '8wk';

IDtag{5}.id='36';
IDtag{5}.MWFexp_cran2caud = [11 9 8 10 12];
IDtag{5}.studypath = 'PK04_36.3K1';
IDtag{5}.DTIexp = 7;
IDtag{5}.DTIdir = 'cranial2cranial';
IDtag{5}.ABCid = 'B';
IDtag{5}.Nameid = 'George';
IDtag{5}.Group = 'Cells';

IDtag{6}.id='39';
IDtag{6}.MWFexp_cran2caud = [19 17 15 16 18];
IDtag{6}.studypath = 'PK04_39.3F1';
IDtag{6}.DTIexp = 14;
IDtag{6}.DTIdir = 'caudal2cranial';
IDtag{6}.ABCid = 'H';
IDtag{6}.Nameid = 'Bob';
IDtag{6}.Group = 'Media';

IDtag{7}.id='41';
IDtag{7}.MWFexp_cran2caud = [18 10 8 17 19];
IDtag{7}.studypath = 'PK04_41.3F1';
IDtag{7}.DTIexp = 7;
IDtag{7}.DTIdir = 'cranial2caudal';
IDtag{7}.ABCid = 'M';
IDtag{7}.Nameid = 'Josh';
IDtag{7}.Group = 'Media';

IDtag{8}.id='51';
IDtag{8}.MWFexp_cran2caud = [14 12 11 13 15];
IDtag{8}.studypath = 'PK04_51.3K1';
IDtag{8}.DTIexp = 10;
IDtag{8}.DTIdir = 'cranial2cranial';
IDtag{8}.ABCid = 'N';
IDtag{8}.Nameid = 'Jacob';
IDtag{8}.Group = 'Cells';

IDtag{9}.id='54';
IDtag{9}.MWFexp_cran2caud = [11 9 8 10 12];
IDtag{9}.studypath = 'PK04_54.3G1';
IDtag{9}.DTIexp = 7;
IDtag{9}.DTIdir = 'cranial2cranial';
IDtag{9}.ABCid = 'J';
IDtag{9}.Nameid = 'Darren';
IDtag{9}.Group = 'Cells';

IDtag{10}.id='55';
IDtag{10}.MWFexp_cran2caud = [22 20 19 21 23];
IDtag{10}.studypath = 'PK04_55.3G1';
IDtag{10}.DTIexp = 18;
IDtag{10}.DTIdir = 'cranial2cranial';
IDtag{10}.ABCid = 'G';
IDtag{10}.Nameid = 'Andy';
IDtag{10}.Group = 'Cells';

IDtag{11}.id='56';
IDtag{11}.MWFexp_cran2caud = [11 9 8 10 12];
IDtag{11}.studypath = 'PK04_56.3H1';
IDtag{11}.DTIexp = 7;
IDtag{11}.DTIdir = 'cranial2cranial';
IDtag{11}.ABCid = 'E';
IDtag{11}.Nameid = 'Patrick';
IDtag{11}.Group = 'Cells';

IDtag{12}.id='58';
IDtag{12}.MWFexp_cran2caud = [12 10 8 9 11];
IDtag{12}.studypath = 'PK04_58.3G1';
IDtag{12}.DTIexp = 7;
IDtag{12}.DTIdir = 'caudal2cranial';
IDtag{12}.ABCid = 'D';
IDtag{12}.Nameid = 'Brent';
IDtag{12}.Group = 'Media';

IDtag{13}.id='61';
IDtag{13}.MWFexp_cran2caud = [11 9 8 10 11];
IDtag{13}.studypath = 'PK04_61.3H1';
IDtag{13}.DTIexp = 7;
IDtag{13}.DTIdir = 'cranial2cranial';
IDtag{13}.ABCid = 'K';
IDtag{13}.Nameid = 'Doug';
IDtag{13}.Group = 'Media';

IDtag{14}.id='62';
IDtag{14}.MWFexp_cran2caud = [12 10 8 11 13];
IDtag{14}.studypath = 'PK04_62.3H1';
IDtag{14}.DTIexp = 9;
IDtag{14}.DTIdir = 'cranial2cranial';
IDtag{14}.ABCid = 'C';
IDtag{14}.Nameid = 'Greg';
IDtag{14}.Group = 'Media';

save SKP-IDtag IDtag

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear status

status{1}.id = '11';
status{1}.isReg.AxonSection2Sum = [1 2 3 4 5]; % slice # (caud->cran)
status{1}.isReg.AxonSum2MRI = [1 2 3 4 5]; % slice # (caud->cran)
status{1}.isTREcalc = 1;
status{1}.isReg.Interset = [10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31] % section #
status{1}.isROIimport.MRIgrid.toSet1 = []; % slice # (caud->cran)
status{1}.isROIimport.MRIgrid.toSet2 = []; % slice # (caud->cran)
status{1}.isROIimport.MRIgrid.toSet3 = []; % slice # (caud->cran)
status{1}.isROIimport.ECventralIntactDamaged.toSet1 = []; % slice # (caud->cran)
status{1}.isROIimport.ECVentralIntactDamaged.toSet2 = []; % slice # (caud->cran)
status{1}.isROIimport.ECVentralIntactDamaged.toMRI = []; % slice # (caud->cran)
status{1}.isROIimport.Axon63xSquare.toSet1 = []; % slice # (caud->cran)
status{1}.isROIimport.Axon63xSquare.toSet3 = []; % slice # (caud->cran)
status{1}.isROIimport.Axon63xSquare.toMRI = []; % slice # (caud->cran)
status{1}.isROIimport.MRIsector.toSet1 = []; % slice # (caud->cran)
status{1}.isROIimport.MRIsector.toSet2 = []; % slice # (caud->cran)
status{1}.isROIimport.MRIsector.toSet3 = []; % slice # (caud->cran)
status{1}.ParmapExists.MRI.MWFa = [1 2 3 4 5]; % slice # (caud->cran)
status{1}.ParmapExists.MRI.gmT2 = [1 2 3 4 5]; % slice # (caud->cran)
status{1}.ParmapExists.MRI.CPMG_echo10 = [1 2 3 4 5]; % slice # (caud->cran)
status{1}.ParmapExists.MRI.CPMG_SNR = [1 2 3 4 5]; % slice # (caud->cran)
status{1}.ParmapExists.MRI.FA = [1 2 3 4 5]; % slice # (caud->cran)
status{1}.ParmapExists.MRI.ADC = [1 2 3 4 5]; % slice # (caud->cran)
status{1}.ParmapExists.MRI.Dlong = [1 2 3 4 5]; % slice # (caud->cran)
status{1}.ParmapExists.MRI.Dtrans = [1 2 3 4 5]; % slice # (caud->cran)
status{1}.ParmapExists.GFAP.AvgOD_thresh = []; % slice # (caud->cran)
status{1}.ParmapExists.GFAP.AvgOD_whole = []; % slice # (caud->cran)
status{1}.ParmapExists.GFAP.AreaFraction = []; % slice # (caud->cran)
status{1}.ParmapExists.P0.AvgOD_thresh = []; % slice # (caud->cran)
status{1}.ParmapExists.P0.AvgOD_whole = []; % slice # (caud->cran)
status{1}.ParmapExists.P0.AreaFraction = []; % slice # (caud->cran)
status{1}.ParmapExists.GFP_Set1.AvgOD_thresh = []; % slice # (caud->cran)
status{1}.ParmapExists.GFP_Set1.AvgOD_whole = []; % slice # (caud->cran)
status{1}.ParmapExists.GFP_Set1.AreaFraction = []; % slice # (caud->cran)
status{1}.ParmapExists.MBP.AvgOD_thresh = []; % slice # (caud->cran)
status{1}.ParmapExists.MBP.AvgOD_whole = []; % slice # (caud->cran)
status{1}.ParmapExists.MBP.AreaFraction = []; % slice # (caud->cran)
status{1}.ParmapExists.Axon.AvgOD_thresh = []; % slice # (caud->cran)
status{1}.ParmapExists.Axon.AvgOD_whole = []; % slice # (caud->cran)
status{1}.ParmapExists.Axon.AreaFraction = []; % slice # (caud->cran)
status{1}.ParmapExists.GFP_Set2.AvgOD_thresh = []; % slice # (caud->cran)
status{1}.ParmapExists.GFP_Set2.AvgOD_whole = []; % slice # (caud->cran)
status{1}.ParmapExists.GFP_Set2.AreaFraction = []; % slice # (caud->cran)
status{1}.ParmapExists.EC.AvgOD_thresh = []; % slice # (caud->cran)
status{1}.ParmapExists.EC.AvgOD_whole = []; % slice # (caud->cran)
status{1}.ParmapExists.EC.AreaFraction = []; % slice # (caud->cran)

status{2}.id = '16';
status{2}.isReg.AxonSection2Sum = [1 2 3 4 5]; % slice # (caud->cran)
status{2}.isReg.AxonSum2MRI = [1 2 3 4 5]; % slice # (caud->cran)
status{2}.isTREcalc = 1;
status{2}.isReg.Interset = [11 12 13 14 15 17 18 19 20 21 24 25 26 27 28 31 32 33 34 37 38] % section #
status{2}.isROIimport.MRIgrid.toSet1 = []; % slice # (caud->cran)
status{2}.isROIimport.MRIgrid.toSet2 = []; % slice # (caud->cran)
status{2}.isROIimport.MRIgrid.toSet3 = []; % slice # (caud->cran)
status{2}.isROIimport.ECventralIntactDamaged.toSet1 = []; % slice # (caud->cran)
status{2}.isROIimport.ECVentralIntactDamaged.toSet2 = []; % slice # (caud->cran)
status{2}.isROIimport.ECVentralIntactDamaged.toMRI = []; % slice # (caud->cran)
status{2}.isROIimport.Axon63xSquare.toSet1 = []; % slice # (caud->cran)
status{2}.isROIimport.Axon63xSquare.toSet3 = []; % slice # (caud->cran)
status{2}.isROIimport.Axon63xSquare.toMRI = []; % slice # (caud->cran)
status{2}.isROIimport.MRIsector.toSet1 = []; % slice # (caud->cran)
status{2}.isROIimport.MRIsector.toSet2 = []; % slice # (caud->cran)
status{2}.isROIimport.MRIsector.toSet3 = []; % slice # (caud->cran)
status{2}.ParmapExists.MRI.MWFa = [1 2 3 4 5]; % slice # (caud->cran)
status{2}.ParmapExists.MRI.gmT2 = [1 2 3 4 5]; % slice # (caud->cran)
status{2}.ParmapExists.MRI.CPMG_echo10 = [1 2 3 4 5]; % slice # (caud->cran)
status{2}.ParmapExists.MRI.CPMG_SNR = [1 2 3 4 5]; % slice # (caud->cran)
status{2}.ParmapExists.MRI.FA = [1 2 3 4 5]; % slice # (caud->cran)
status{2}.ParmapExists.MRI.ADC = [1 2 3 4 5]; % slice # (caud->cran)
status{2}.ParmapExists.MRI.Dlong = [1 2 3 4 5]; % slice # (caud->cran)
status{2}.ParmapExists.MRI.Dtrans = [1 2 3 4 5]; % slice # (caud->cran)
status{2}.ParmapExists.GFAP.AvgOD_thresh = []; % slice # (caud->cran)
status{2}.ParmapExists.GFAP.AvgOD_whole = []; % slice # (caud->cran)
status{2}.ParmapExists.GFAP.AreaFraction = []; % slice # (caud->cran)
status{2}.ParmapExists.P0.AvgOD_thresh = []; % slice # (caud->cran)
status{2}.ParmapExists.P0.AvgOD_whole = []; % slice # (caud->cran)
status{2}.ParmapExists.P0.AreaFraction = []; % slice # (caud->cran)
status{2}.ParmapExists.GFP_Set1.AvgOD_thresh = []; % slice # (caud->cran)
status{2}.ParmapExists.GFP_Set1.AvgOD_whole = []; % slice # (caud->cran)
status{2}.ParmapExists.GFP_Set1.AreaFraction = []; % slice # (caud->cran)
status{2}.ParmapExists.MBP.AvgOD_thresh = []; % slice # (caud->cran)
status{2}.ParmapExists.MBP.AvgOD_whole = []; % slice # (caud->cran)
status{2}.ParmapExists.MBP.AreaFraction = []; % slice # (caud->cran)
status{2}.ParmapExists.Axon.AvgOD_thresh = []; % slice # (caud->cran)
status{2}.ParmapExists.Axon.AvgOD_whole = []; % slice # (caud->cran)
status{2}.ParmapExists.Axon.AreaFraction = []; % slice # (caud->cran)
status{2}.ParmapExists.GFP_Set2.AvgOD_thresh = []; % slice # (caud->cran)
status{2}.ParmapExists.GFP_Set2.AvgOD_whole = []; % slice # (caud->cran)
status{2}.ParmapExists.GFP_Set2.AreaFraction = []; % slice # (caud->cran)
status{2}.ParmapExists.EC.AvgOD_thresh = []; % slice # (caud->cran)
status{2}.ParmapExists.EC.AvgOD_whole = []; % slice # (caud->cran)
status{2}.ParmapExists.EC.AreaFraction = []; % slice # (caud->cran)

status{3}.id = '18';
status{3}.isReg.AxonSection2Sum = [1 2 3 4 5]; % slice # (caud->cran)
status{3}.isReg.AxonSum2MRI = [1 2 3 4 5]; % slice # (caud->cran)
status{3}.isTREcalc = 1;
status{3}.isReg.Interset = [16 17 20 21 22 23 24 25 26 27 28 29 30 31 33 34 35 36 37 38 39 40 41] % section #
status{3}.isROIimport.MRIgrid.toSet1 = []; % slice # (caud->cran)
status{3}.isROIimport.MRIgrid.toSet2 = []; % slice # (caud->cran)
status{3}.isROIimport.MRIgrid.toSet3 = []; % slice # (caud->cran)
status{3}.isROIimport.ECventralIntactDamaged.toSet1 = []; % slice # (caud->cran)
status{3}.isROIimport.ECVentralIntactDamaged.toSet2 = []; % slice # (caud->cran)
status{3}.isROIimport.ECVentralIntactDamaged.toMRI = []; % slice # (caud->cran)
status{3}.isROIimport.Axon63xSquare.toSet1 = []; % slice # (caud->cran)
status{3}.isROIimport.Axon63xSquare.toSet3 = []; % slice # (caud->cran)
status{3}.isROIimport.Axon63xSquare.toMRI = []; % slice # (caud->cran)
status{3}.isROIimport.MRIsector.toSet1 = []; % slice # (caud->cran)
status{3}.isROIimport.MRIsector.toSet2 = []; % slice # (caud->cran)
status{3}.isROIimport.MRIsector.toSet3 = []; % slice # (caud->cran)
status{3}.ParmapExists.MRI.MWFa = [1 2 3 4 5]; % slice # (caud->cran)
status{3}.ParmapExists.MRI.gmT2 = [1 2 3 4 5]; % slice # (caud->cran)
status{3}.ParmapExists.MRI.CPMG_echo10 = [1 2 3 4 5]; % slice # (caud->cran)
status{3}.ParmapExists.MRI.CPMG_SNR = [1 2 3 4 5]; % slice # (caud->cran)
status{3}.ParmapExists.MRI.FA = [1 2 3 4 5]; % slice # (caud->cran)
status{3}.ParmapExists.MRI.ADC = [1 2 3 4 5]; % slice # (caud->cran)
status{3}.ParmapExists.MRI.Dlong = [1 2 3 4 5]; % slice # (caud->cran)
status{3}.ParmapExists.MRI.Dtrans = [1 2 3 4 5]; % slice # (caud->cran)
status{3}.ParmapExists.GFAP.AvgOD_thresh = []; % slice # (caud->cran)
status{3}.ParmapExists.GFAP.AvgOD_whole = []; % slice # (caud->cran)
status{3}.ParmapExists.GFAP.AreaFraction = []; % slice # (caud->cran)
status{3}.ParmapExists.P0.AvgOD_thresh = []; % slice # (caud->cran)
status{3}.ParmapExists.P0.AvgOD_whole = []; % slice # (caud->cran)
status{3}.ParmapExists.P0.AreaFraction = []; % slice # (caud->cran)
status{3}.ParmapExists.GFP_Set1.AvgOD_thresh = []; % slice # (caud->cran)
status{3}.ParmapExists.GFP_Set1.AvgOD_whole = []; % slice # (caud->cran)
status{3}.ParmapExists.GFP_Set1.AreaFraction = []; % slice # (caud->cran)
status{3}.ParmapExists.MBP.AvgOD_thresh = []; % slice # (caud->cran)
status{3}.ParmapExists.MBP.AvgOD_whole = []; % slice # (caud->cran)
status{3}.ParmapExists.MBP.AreaFraction = []; % slice # (caud->cran)
status{3}.ParmapExists.Axon.AvgOD_thresh = []; % slice # (caud->cran)
status{3}.ParmapExists.Axon.AvgOD_whole = []; % slice # (caud->cran)
status{3}.ParmapExists.Axon.AreaFraction = []; % slice # (caud->cran)
status{3}.ParmapExists.GFP_Set2.AvgOD_thresh = []; % slice # (caud->cran)
status{3}.ParmapExists.GFP_Set2.AvgOD_whole = []; % slice # (caud->cran)
status{3}.ParmapExists.GFP_Set2.AreaFraction = []; % slice # (caud->cran)
status{3}.ParmapExists.EC.AvgOD_thresh = []; % slice # (caud->cran)
status{3}.ParmapExists.EC.AvgOD_whole = []; % slice # (caud->cran)
status{3}.ParmapExists.EC.AreaFraction = []; % slice # (caud->cran)

status{4}.id = '20';
status{4}.isReg.AxonSection2Sum = [1 2 3 4 5]; % slice # (caud->cran)
status{4}.isReg.AxonSum2MRI = [1 2 3 4 5]; % slice # (caud->cran)
status{4}.isTREcalc = 1;
status{4}.isReg.Interset = [16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40] % section #
status{4}.isROIimport.MRIgrid.toSet1 = []; % slice # (caud->cran)
status{4}.isROIimport.MRIgrid.toSet2 = []; % slice # (caud->cran)
status{4}.isROIimport.MRIgrid.toSet3 = []; % slice # (caud->cran)
status{4}.isROIimport.ECventralIntactDamaged.toSet1 = []; % slice # (caud->cran)
status{4}.isROIimport.ECVentralIntactDamaged.toSet2 = []; % slice # (caud->cran)
status{4}.isROIimport.ECVentralIntactDamaged.toMRI = []; % slice # (caud->cran)
status{4}.isROIimport.Axon63xSquare.toSet1 = []; % slice # (caud->cran)
status{4}.isROIimport.Axon63xSquare.toSet3 = []; % slice # (caud->cran)
status{4}.isROIimport.Axon63xSquare.toMRI = []; % slice # (caud->cran)
status{4}.isROIimport.MRIsector.toSet1 = []; % slice # (caud->cran)
status{4}.isROIimport.MRIsector.toSet2 = []; % slice # (caud->cran)
status{4}.isROIimport.MRIsector.toSet3 = []; % slice # (caud->cran)
status{4}.ParmapExists.MRI.MWFa = [1 2 3 4 5]; % slice # (caud->cran)
status{4}.ParmapExists.MRI.gmT2 = [1 2 3 4 5]; % slice # (caud->cran)
status{4}.ParmapExists.MRI.CPMG_echo10 = [1 2 3 4 5]; % slice # (caud->cran)
status{4}.ParmapExists.MRI.CPMG_SNR = [1 2 3 4 5]; % slice # (caud->cran)
status{4}.ParmapExists.MRI.FA = [1 2 3 4 5]; % slice # (caud->cran)
status{4}.ParmapExists.MRI.ADC = [1 2 3 4 5]; % slice # (caud->cran)
status{4}.ParmapExists.MRI.Dlong = [1 2 3 4 5]; % slice # (caud->cran)
status{4}.ParmapExists.MRI.Dtrans = [1 2 3 4 5]; % slice # (caud->cran)
status{4}.ParmapExists.GFAP.AvgOD_thresh = []; % slice # (caud->cran)
status{4}.ParmapExists.GFAP.AvgOD_whole = []; % slice # (caud->cran)
status{4}.ParmapExists.GFAP.AreaFraction = []; % slice # (caud->cran)
status{4}.ParmapExists.P0.AvgOD_thresh = []; % slice # (caud->cran)
status{4}.ParmapExists.P0.AvgOD_whole = []; % slice # (caud->cran)
status{4}.ParmapExists.P0.AreaFraction = []; % slice # (caud->cran)
status{4}.ParmapExists.GFP_Set1.AvgOD_thresh = []; % slice # (caud->cran)
status{4}.ParmapExists.GFP_Set1.AvgOD_whole = []; % slice # (caud->cran)
status{4}.ParmapExists.GFP_Set1.AreaFraction = []; % slice # (caud->cran)
status{4}.ParmapExists.MBP.AvgOD_thresh = []; % slice # (caud->cran)
status{4}.ParmapExists.MBP.AvgOD_whole = []; % slice # (caud->cran)
status{4}.ParmapExists.MBP.AreaFraction = []; % slice # (caud->cran)
status{4}.ParmapExists.Axon.AvgOD_thresh = []; % slice # (caud->cran)
status{4}.ParmapExists.Axon.AvgOD_whole = []; % slice # (caud->cran)
status{4}.ParmapExists.Axon.AreaFraction = []; % slice # (caud->cran)
status{4}.ParmapExists.GFP_Set2.AvgOD_thresh = []; % slice # (caud->cran)
status{4}.ParmapExists.GFP_Set2.AvgOD_whole = []; % slice # (caud->cran)
status{4}.ParmapExists.GFP_Set2.AreaFraction = []; % slice # (caud->cran)
status{4}.ParmapExists.EC.AvgOD_thresh = []; % slice # (caud->cran)
status{4}.ParmapExists.EC.AvgOD_whole = []; % slice # (caud->cran)
status{4}.ParmapExists.EC.AreaFraction = []; % slice # (caud->cran)

status{5}.id = '36';
status{5}.isReg.AxonSection2Sum = [1 2 3 4 5]; % slice # (caud->cran)
status{5}.isReg.AxonSum2MRI = [1 2 3 4 5]; % slice # (caud->cran)
status{5}.isReg.Interset = [11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38] % section #
status{5}.isTREcalc = 1;
status{5}.isROIimport.MRIgrid.toSet1 = []; % slice # (caud->cran)
status{5}.isROIimport.MRIgrid.toSet2 = []; % slice # (caud->cran)
status{5}.isROIimport.MRIgrid.toSet3 = []; % slice # (caud->cran)
status{5}.isROIimport.ECventralIntactDamaged.toSet1 = []; % slice # (caud->cran)
status{5}.isROIimport.ECVentralIntactDamaged.toSet2 = []; % slice # (caud->cran)
status{5}.isROIimport.ECVentralIntactDamaged.toMRI = []; % slice # (caud->cran)
status{5}.isROIimport.Axon63xSquare.toSet1 = []; % slice # (caud->cran)
status{5}.isROIimport.Axon63xSquare.toSet3 = []; % slice # (caud->cran)
status{5}.isROIimport.Axon63xSquare.toMRI = []; % slice # (caud->cran)
status{5}.isROIimport.MRIsector.toSet1 = []; % slice # (caud->cran)
status{5}.isROIimport.MRIsector.toSet2 = []; % slice # (caud->cran)
status{5}.isROIimport.MRIsector.toSet3 = []; % slice # (caud->cran)
status{5}.ParmapExists.MRI.MWFa = [1 2 3 4 5]; % slice # (caud->cran)
status{5}.ParmapExists.MRI.gmT2 = [1 2 3 4 5]; % slice # (caud->cran)
status{5}.ParmapExists.MRI.CPMG_echo10 = [1 2 3 4 5]; % slice # (caud->cran)
status{5}.ParmapExists.MRI.CPMG_SNR = [1 2 3 4 5]; % slice # (caud->cran)
status{5}.ParmapExists.MRI.FA = [1 2 3 4 5]; % slice # (caud->cran)
status{5}.ParmapExists.MRI.ADC = [1 2 3 4 5]; % slice # (caud->cran)
status{5}.ParmapExists.MRI.Dlong = [1 2 3 4 5]; % slice # (caud->cran)
status{5}.ParmapExists.MRI.Dtrans = [1 2 3 4 5]; % slice # (caud->cran)
status{5}.ParmapExists.GFAP.AvgOD_thresh = []; % slice # (caud->cran)
status{5}.ParmapExists.GFAP.AvgOD_whole = []; % slice # (caud->cran)
status{5}.ParmapExists.GFAP.AreaFraction = []; % slice # (caud->cran)
status{5}.ParmapExists.P0.AvgOD_thresh = []; % slice # (caud->cran)
status{5}.ParmapExists.P0.AvgOD_whole = []; % slice # (caud->cran)
status{5}.ParmapExists.P0.AreaFraction = []; % slice # (caud->cran)
status{5}.ParmapExists.GFP_Set1.AvgOD_thresh = []; % slice # (caud->cran)
status{5}.ParmapExists.GFP_Set1.AvgOD_whole = []; % slice # (caud->cran)
status{5}.ParmapExists.GFP_Set1.AreaFraction = []; % slice # (caud->cran)
status{5}.ParmapExists.MBP.AvgOD_thresh = []; % slice # (caud->cran)
status{5}.ParmapExists.MBP.AvgOD_whole = []; % slice # (caud->cran)
status{5}.ParmapExists.MBP.AreaFraction = []; % slice # (caud->cran)
status{5}.ParmapExists.Axon.AvgOD_thresh = []; % slice # (caud->cran)
status{5}.ParmapExists.Axon.AvgOD_whole = []; % slice # (caud->cran)
status{5}.ParmapExists.Axon.AreaFraction = []; % slice # (caud->cran)
status{5}.ParmapExists.GFP_Set2.AvgOD_thresh = []; % slice # (caud->cran)
status{5}.ParmapExists.GFP_Set2.AvgOD_whole = []; % slice # (caud->cran)
status{5}.ParmapExists.GFP_Set2.AreaFraction = []; % slice # (caud->cran)
status{5}.ParmapExists.EC.AvgOD_thresh = []; % slice # (caud->cran)
status{5}.ParmapExists.EC.AvgOD_whole = []; % slice # (caud->cran)
status{5}.ParmapExists.EC.AreaFraction = []; % slice # (caud->cran)

status{6}.id = '39'; 
status{6}.isReg.AxonSection2Sum = [1 2 3 4 5]; % slice # (caud->cran)
status{6}.isReg.AxonSum2MRI = [2 3 4 5]; % slice # (caud->cran)
status{6}.isTREcalc = 0;
status{6}.isReg.Interset = [4 5 6 7 8 9 12 13 14 15 16 17 20 21 22 23 24 25 28 29 30 31 32 33 36 37 38 39 40 41] % section #
status{6}.isROIimport.MRIgrid.toSet1 = []; % slice # (caud->cran)
status{6}.isROIimport.MRIgrid.toSet2 = []; % slice # (caud->cran)
status{6}.isROIimport.MRIgrid.toSet3 = []; % slice # (caud->cran)
status{6}.isROIimport.ECventralIntactDamaged.toSet1 = []; % slice # (caud->cran)
status{6}.isROIimport.ECVentralIntactDamaged.toSet2 = []; % slice # (caud->cran)
status{6}.isROIimport.ECVentralIntactDamaged.toMRI = []; % slice # (caud->cran)
status{6}.isROIimport.Axon63xSquare.toSet1 = []; % slice # (caud->cran)
status{6}.isROIimport.Axon63xSquare.toSet3 = []; % slice # (caud->cran)
status{6}.isROIimport.Axon63xSquare.toMRI = []; % slice # (caud->cran)
status{6}.isROIimport.MRIsector.toSet1 = []; % slice # (caud->cran)
status{6}.isROIimport.MRIsector.toSet2 = []; % slice # (caud->cran)
status{6}.isROIimport.MRIsector.toSet3 = []; % slice # (caud->cran)
status{6}.ParmapExists.MRI.MWFa = [1 2 3 4 5]; % slice # (caud->cran)
status{6}.ParmapExists.MRI.gmT2 = [1 2 3 4 5]; % slice # (caud->cran)
status{6}.ParmapExists.MRI.CPMG_echo10 = [1 2 3 4 5]; % slice # (caud->cran)
status{6}.ParmapExists.MRI.CPMG_SNR = [1 2 3 4 5]; % slice # (caud->cran)
status{6}.ParmapExists.MRI.FA = [1 2 3 4 5]; % slice # (caud->cran)
status{6}.ParmapExists.MRI.ADC = [1 2 3 4 5]; % slice # (caud->cran)
status{6}.ParmapExists.MRI.Dlong = [1 2 3 4 5]; % slice # (caud->cran)
status{6}.ParmapExists.MRI.Dtrans = [1 2 3 4 5]; % slice # (caud->cran)
status{6}.ParmapExists.GFAP.AvgOD_thresh = []; % slice # (caud->cran)
status{6}.ParmapExists.GFAP.AvgOD_whole = []; % slice # (caud->cran)
status{6}.ParmapExists.GFAP.AreaFraction = []; % slice # (caud->cran)
status{6}.ParmapExists.P0.AvgOD_thresh = []; % slice # (caud->cran)
status{6}.ParmapExists.P0.AvgOD_whole = []; % slice # (caud->cran)
status{6}.ParmapExists.P0.AreaFraction = []; % slice # (caud->cran)
status{6}.ParmapExists.GFP_Set1.AvgOD_thresh = []; % slice # (caud->cran)
status{6}.ParmapExists.GFP_Set1.AvgOD_whole = []; % slice # (caud->cran)
status{6}.ParmapExists.GFP_Set1.AreaFraction = []; % slice # (caud->cran)
status{6}.ParmapExists.MBP.AvgOD_thresh = []; % slice # (caud->cran)
status{6}.ParmapExists.MBP.AvgOD_whole = []; % slice # (caud->cran)
status{6}.ParmapExists.MBP.AreaFraction = []; % slice # (caud->cran)
status{6}.ParmapExists.Axon.AvgOD_thresh = []; % slice # (caud->cran)
status{6}.ParmapExists.Axon.AvgOD_whole = []; % slice # (caud->cran)
status{6}.ParmapExists.Axon.AreaFraction = []; % slice # (caud->cran)
status{6}.ParmapExists.GFP_Set2.AvgOD_thresh = []; % slice # (caud->cran)
status{6}.ParmapExists.GFP_Set2.AvgOD_whole = []; % slice # (caud->cran)
status{6}.ParmapExists.GFP_Set2.AreaFraction = []; % slice # (caud->cran)
status{6}.ParmapExists.EC.AvgOD_thresh = []; % slice # (caud->cran)
status{6}.ParmapExists.EC.AvgOD_whole = []; % slice # (caud->cran)
status{6}.ParmapExists.EC.AreaFraction = []; % slice # (caud->cran)

status{7}.id = '41'; %DTI was fuzzy
status{7}.isReg.AxonSection2Sum = [1 2 3 4 5]; % slice # (caud->cran)
status{7}.isReg.AxonSum2MRI = [1 2 3 4 5]; % slice # (caud->cran)
status{7}.isTREcalc = 0;
status{7}.isReg.Interset = [14 15 16 17 18 21 22 23 24 25 26 27 28 29 30 32 33 34 35 36 37 38 39 40 41 42 43] % section #
status{7}.isROIimport.MRIgrid.toSet1 = []; % slice # (caud->cran)
status{7}.isROIimport.MRIgrid.toSet2 = []; % slice # (caud->cran)
status{7}.isROIimport.MRIgrid.toSet3 = []; % slice # (caud->cran)
status{7}.isROIimport.ECventralIntactDamaged.toSet1 = []; % slice # (caud->cran)
status{7}.isROIimport.ECVentralIntactDamaged.toSet2 = []; % slice # (caud->cran)
status{7}.isROIimport.ECVentralIntactDamaged.toMRI = []; % slice # (caud->cran)
status{7}.isROIimport.Axon63xSquare.toSet1 = []; % slice # (caud->cran)
status{7}.isROIimport.Axon63xSquare.toSet3 = []; % slice # (caud->cran)
status{7}.isROIimport.Axon63xSquare.toMRI = []; % slice # (caud->cran)
status{7}.isROIimport.MRIsector.toSet1 = []; % slice # (caud->cran)
status{7}.isROIimport.MRIsector.toSet2 = []; % slice # (caud->cran)
status{7}.isROIimport.MRIsector.toSet3 = []; % slice # (caud->cran)
status{7}.ParmapExists.MRI.MWFa = [1 2 3 4 5]; % slice # (caud->cran)
status{7}.ParmapExists.MRI.gmT2 = [1 2 3 4 5]; % slice # (caud->cran)
status{7}.ParmapExists.MRI.CPMG_echo10 = [1 2 3 4 5]; % slice # (caud->cran)
status{7}.ParmapExists.MRI.CPMG_SNR = [1 2 3 4 5]; % slice # (caud->cran)
status{7}.ParmapExists.MRI.FA = [1 2 3 4 5]; % slice # (caud->cran) FUZZY
status{7}.ParmapExists.MRI.ADC = [1 2 3 4 5]; % slice # (caud->cran) FUZZY
status{7}.ParmapExists.MRI.Dlong = [1 2 3 4 5]; % slice # (caud->cran) FUZZY
status{7}.ParmapExists.MRI.Dtrans = [1 2 3 4 5]; % slice # (caud->cran) FUZZY
status{7}.ParmapExists.GFAP.AvgOD_thresh = []; % slice # (caud->cran)
status{7}.ParmapExists.GFAP.AvgOD_whole = []; % slice # (caud->cran)
status{7}.ParmapExists.GFAP.AreaFraction = []; % slice # (caud->cran)
status{7}.ParmapExists.P0.AvgOD_thresh = []; % slice # (caud->cran)
status{7}.ParmapExists.P0.AvgOD_whole = []; % slice # (caud->cran)
status{7}.ParmapExists.P0.AreaFraction = []; % slice # (caud->cran)
status{7}.ParmapExists.GFP_Set1.AvgOD_thresh = []; % slice # (caud->cran)
status{7}.ParmapExists.GFP_Set1.AvgOD_whole = []; % slice # (caud->cran)
status{7}.ParmapExists.GFP_Set1.AreaFraction = []; % slice # (caud->cran)
status{7}.ParmapExists.MBP.AvgOD_thresh = []; % slice # (caud->cran)
status{7}.ParmapExists.MBP.AvgOD_whole = []; % slice # (caud->cran)
status{7}.ParmapExists.MBP.AreaFraction = []; % slice # (caud->cran)
status{7}.ParmapExists.Axon.AvgOD_thresh = []; % slice # (caud->cran)
status{7}.ParmapExists.Axon.AvgOD_whole = []; % slice # (caud->cran)
status{7}.ParmapExists.Axon.AreaFraction = []; % slice # (caud->cran)
status{7}.ParmapExists.GFP_Set2.AvgOD_thresh = []; % slice # (caud->cran)
status{7}.ParmapExists.GFP_Set2.AvgOD_whole = []; % slice # (caud->cran)
status{7}.ParmapExists.GFP_Set2.AreaFraction = []; % slice # (caud->cran)
status{7}.ParmapExists.EC.AvgOD_thresh = []; % slice # (caud->cran)
status{7}.ParmapExists.EC.AvgOD_whole = []; % slice # (caud->cran)
status{7}.ParmapExists.EC.AreaFraction = []; % slice # (caud->cran)

status{8}.id = '51';
status{8}.isReg.AxonSection2Sum = [1 2 3 4 5]; % slice # (caud->cran)
status{8}.isReg.AxonSum2MRI = [1 2 3 4 5]; % slice # (caud->cran)
status{8}.isTREcalc = 1;
status{8}.isReg.Interset = [13 14 15 16 17 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42] % section #
status{8}.isROIimport.MRIgrid.toSet1 = []; % slice # (caud->cran)
status{8}.isROIimport.MRIgrid.toSet2 = [1]; % slice # (caud->cran)
status{8}.isROIimport.MRIgrid.toSet3 = []; % slice # (caud->cran)
status{8}.isROIimport.ECventralIntactDamaged.toSet1 = []; % slice # (caud->cran)
status{8}.isROIimport.ECVentralIntactDamaged.toSet2 = []; % slice # (caud->cran)
status{8}.isROIimport.ECVentralIntactDamaged.toMRI = []; % slice # (caud->cran)
status{8}.isROIimport.Axon63xSquare.toSet1 = []; % slice # (caud->cran)
status{8}.isROIimport.Axon63xSquare.toSet3 = []; % slice # (caud->cran)
status{8}.isROIimport.Axon63xSquare.toMRI = []; % slice # (caud->cran)
status{8}.isROIimport.MRIsector.toSet1 = []; % slice # (caud->cran)
status{8}.isROIimport.MRIsector.toSet2 = []; % slice # (caud->cran)
status{8}.isROIimport.MRIsector.toSet3 = []; % slice # (caud->cran)
status{8}.ParmapExists.MRI.MWFa = [1 2 3 4 5]; % slice # (caud->cran)
status{8}.ParmapExists.MRI.gmT2 = [1 2 3 4 5]; % slice # (caud->cran)
status{8}.ParmapExists.MRI.CPMG_echo10 = [1 2 3 4 5]; % slice # (caud->cran)
status{8}.ParmapExists.MRI.CPMG_SNR = [1 2 3 4 5]; % slice # (caud->cran)
status{8}.ParmapExists.MRI.FA = [1 2 3 4 5]; % slice # (caud->cran)
status{8}.ParmapExists.MRI.ADC = [1 2 3 4 5]; % slice # (caud->cran)
status{8}.ParmapExists.MRI.Dlong = [1 2 3 4 5]; % slice # (caud->cran)
status{8}.ParmapExists.MRI.Dtrans = [1 2 3 4 5]; % slice # (caud->cran)
status{8}.ParmapExists.GFAP.AvgOD_thresh = []; % slice # (caud->cran)
status{8}.ParmapExists.GFAP.AvgOD_whole = []; % slice # (caud->cran)
status{8}.ParmapExists.GFAP.AreaFraction = []; % slice # (caud->cran)
status{8}.ParmapExists.P0.AvgOD_thresh = []; % slice # (caud->cran)
status{8}.ParmapExists.P0.AvgOD_whole = []; % slice # (caud->cran)
status{8}.ParmapExists.P0.AreaFraction = []; % slice # (caud->cran)
status{8}.ParmapExists.GFP_Set1.AvgOD_thresh = []; % slice # (caud->cran)
status{8}.ParmapExists.GFP_Set1.AvgOD_whole = []; % slice # (caud->cran)
status{8}.ParmapExists.GFP_Set1.AreaFraction = []; % slice # (caud->cran)
status{8}.ParmapExists.MBP.AvgOD_thresh = [1]; % slice # (caud->cran)
status{8}.ParmapExists.MBP.AvgOD_whole = [1]; % slice # (caud->cran)
status{8}.ParmapExists.MBP.AreaFraction = [1]; % slice # (caud->cran)
status{8}.ParmapExists.Axon.AvgOD_thresh = [1]; % slice # (caud->cran)
status{8}.ParmapExists.Axon.AvgOD_whole = [1]; % slice # (caud->cran)
status{8}.ParmapExists.Axon.AreaFraction = [1]; % slice # (caud->cran)
status{8}.ParmapExists.GFP_Set2.AvgOD_thresh = []; % slice # (caud->cran)
status{8}.ParmapExists.GFP_Set2.AvgOD_whole = []; % slice # (caud->cran)
status{8}.ParmapExists.GFP_Set2.AreaFraction = []; % slice # (caud->cran)
status{8}.ParmapExists.EC.AvgOD_thresh = []; % slice # (caud->cran)
status{8}.ParmapExists.EC.AvgOD_whole = []; % slice # (caud->cran)
status{8}.ParmapExists.EC.AreaFraction = []; % slice # (caud->cran)

status{9}.id = '54';
status{9}.isReg.AxonSection2Sum = [1 2 3 4 5]; % slice # (caud->cran)
status{9}.isReg.AxonSum2MRI = [1 2 3 4 5]; % slice # (caud->cran)
status{9}.isTREcalc = 1;
status{9}.isReg.Interset = [10 11 12 13 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40] % section #
status{9}.isROIimport.MRIgrid.toSet1 = []; % slice # (caud->cran)
status{9}.isROIimport.MRIgrid.toSet2 = []; % slice # (caud->cran)
status{9}.isROIimport.MRIgrid.toSet3 = []; % slice # (caud->cran)
status{9}.isROIimport.ECventralIntactDamaged.toSet1 = []; % slice # (caud->cran)
status{9}.isROIimport.ECVentralIntactDamaged.toSet2 = []; % slice # (caud->cran)
status{9}.isROIimport.ECVentralIntactDamaged.toMRI = []; % slice # (caud->cran)
status{9}.isROIimport.Axon63xSquare.toSet1 = []; % slice # (caud->cran)
status{9}.isROIimport.Axon63xSquare.toSet3 = []; % slice # (caud->cran)
status{9}.isROIimport.Axon63xSquare.toMRI = []; % slice # (caud->cran)
status{9}.isROIimport.MRIsector.toSet1 = []; % slice # (caud->cran)
status{9}.isROIimport.MRIsector.toSet2 = []; % slice # (caud->cran)
status{9}.isROIimport.MRIsector.toSet3 = []; % slice # (caud->cran)
status{9}.ParmapExists.MRI.MWFa = [1 2 3 4 5]; % slice # (caud->cran)
status{9}.ParmapExists.MRI.gmT2 = [1 2 3 4 5]; % slice # (caud->cran)
status{9}.ParmapExists.MRI.CPMG_echo10 = [1 2 3 4 5]; % slice # (caud->cran)
status{9}.ParmapExists.MRI.CPMG_SNR = [1 2 3 4 5]; % slice # (caud->cran)
status{9}.ParmapExists.MRI.FA = [1 2 3 4 5]; % slice # (caud->cran)
status{9}.ParmapExists.MRI.ADC = [1 2 3 4 5]; % slice # (caud->cran)
status{9}.ParmapExists.MRI.Dlong = [1 2 3 4 5]; % slice # (caud->cran)
status{9}.ParmapExists.MRI.Dtrans = [1 2 3 4 5]; % slice # (caud->cran)
status{9}.ParmapExists.GFAP.AvgOD_thresh = []; % slice # (caud->cran)
status{9}.ParmapExists.GFAP.AvgOD_whole = []; % slice # (caud->cran)
status{9}.ParmapExists.GFAP.AreaFraction = []; % slice # (caud->cran)
status{9}.ParmapExists.P0.AvgOD_thresh = []; % slice # (caud->cran)
status{9}.ParmapExists.P0.AvgOD_whole = []; % slice # (caud->cran)
status{9}.ParmapExists.P0.AreaFraction = []; % slice # (caud->cran)
status{9}.ParmapExists.GFP_Set1.AvgOD_thresh = []; % slice # (caud->cran)
status{9}.ParmapExists.GFP_Set1.AvgOD_whole = []; % slice # (caud->cran)
status{9}.ParmapExists.GFP_Set1.AreaFraction = []; % slice # (caud->cran)
status{9}.ParmapExists.MBP.AvgOD_thresh = []; % slice # (caud->cran)
status{9}.ParmapExists.MBP.AvgOD_whole = []; % slice # (caud->cran)
status{9}.ParmapExists.MBP.AreaFraction = []; % slice # (caud->cran)
status{9}.ParmapExists.Axon.AvgOD_thresh = []; % slice # (caud->cran)
status{9}.ParmapExists.Axon.AvgOD_whole = []; % slice # (caud->cran)
status{9}.ParmapExists.Axon.AreaFraction = []; % slice # (caud->cran)
status{9}.ParmapExists.GFP_Set2.AvgOD_thresh = []; % slice # (caud->cran)
status{9}.ParmapExists.GFP_Set2.AvgOD_whole = []; % slice # (caud->cran)
status{9}.ParmapExists.GFP_Set2.AreaFraction = []; % slice # (caud->cran)
status{9}.ParmapExists.EC.AvgOD_thresh = []; % slice # (caud->cran)
status{9}.ParmapExists.EC.AvgOD_whole = []; % slice # (caud->cran)
status{9}.ParmapExists.EC.AreaFraction = []; % slice # (caud->cran)

status{10}.id = '55';
status{10}.isReg.AxonSection2Sum = [2 3 4 5]; % slice # (caud->cran)  !! section 1 is screwed up
status{10}.isReg.AxonSum2MRI = [2 3 4 5]; % slice # (caud->cran)
status{10}.isTREcalc = 1;
status{10}.isReg.Interset = [13 14 17 18 21 22 23 24 25 26 28 29 30 31 32 33 36 37 38 39 40 41 43 44 45 46 47 48] % section #
status{10}.isROIimport.MRIgrid.toSet1 = []; % slice # (caud->cran)
status{10}.isROIimport.MRIgrid.toSet2 = []; % slice # (caud->cran)
status{10}.isROIimport.MRIgrid.toSet3 = []; % slice # (caud->cran)
status{10}.isROIimport.ECventralIntactDamaged.toSet1 = []; % slice # (caud->cran)
status{10}.isROIimport.ECVentralIntactDamaged.toSet2 = []; % slice # (caud->cran)
status{10}.isROIimport.ECVentralIntactDamaged.toMRI = []; % slice # (caud->cran)
status{10}.isROIimport.Axon63xSquare.toSet1 = []; % slice # (caud->cran)
status{10}.isROIimport.Axon63xSquare.toSet3 = []; % slice # (caud->cran)
status{10}.isROIimport.Axon63xSquare.toMRI = []; % slice # (caud->cran)
status{10}.isROIimport.MRIsector.toSet1 = []; % slice # (caud->cran)
status{10}.isROIimport.MRIsector.toSet2 = []; % slice # (caud->cran)
status{10}.isROIimport.MRIsector.toSet3 = []; % slice # (caud->cran)
status{10}.ParmapExists.MRI.MWFa = [1 2 3 4 5]; % slice # (caud->cran)
status{10}.ParmapExists.MRI.gmT2 = [1 2 3 4 5]; % slice # (caud->cran)
status{10}.ParmapExists.MRI.CPMG_echo10 = [1 2 3 4 5]; % slice # (caud->cran)
status{10}.ParmapExists.MRI.CPMG_SNR = [1 2 3 4 5]; % slice # (caud->cran)
status{10}.ParmapExists.MRI.FA = [1 2 3 4 5]; % slice # (caud->cran)
status{10}.ParmapExists.MRI.ADC = [1 2 3 4 5]; % slice # (caud->cran)
status{10}.ParmapExists.MRI.Dlong = [1 2 3 4 5]; % slice # (caud->cran)
status{10}.ParmapExists.MRI.Dtrans = [1 2 3 4 5]; % slice # (caud->cran)
status{10}.ParmapExists.GFAP.AvgOD_thresh = []; % slice # (caud->cran)
status{10}.ParmapExists.GFAP.AvgOD_whole = []; % slice # (caud->cran)
status{10}.ParmapExists.GFAP.AreaFraction = []; % slice # (caud->cran)
status{10}.ParmapExists.P0.AvgOD_thresh = []; % slice # (caud->cran)
status{10}.ParmapExists.P0.AvgOD_whole = []; % slice # (caud->cran)
status{10}.ParmapExists.P0.AreaFraction = []; % slice # (caud->cran)
status{10}.ParmapExists.GFP_Set1.AvgOD_thresh = []; % slice # (caud->cran)
status{10}.ParmapExists.GFP_Set1.AvgOD_whole = []; % slice # (caud->cran)
status{10}.ParmapExists.GFP_Set1.AreaFraction = []; % slice # (caud->cran)
status{10}.ParmapExists.MBP.AvgOD_thresh = []; % slice # (caud->cran)
status{10}.ParmapExists.MBP.AvgOD_whole = []; % slice # (caud->cran)
status{10}.ParmapExists.MBP.AreaFraction = []; % slice # (caud->cran)
status{10}.ParmapExists.Axon.AvgOD_thresh = []; % slice # (caud->cran)
status{10}.ParmapExists.Axon.AvgOD_whole = []; % slice # (caud->cran)
status{10}.ParmapExists.Axon.AreaFraction = []; % slice # (caud->cran)
status{10}.ParmapExists.GFP_Set2.AvgOD_thresh = []; % slice # (caud->cran)
status{10}.ParmapExists.GFP_Set2.AvgOD_whole = []; % slice # (caud->cran)
status{10}.ParmapExists.GFP_Set2.AreaFraction = []; % slice # (caud->cran)
status{10}.ParmapExists.EC.AvgOD_thresh = []; % slice # (caud->cran)
status{10}.ParmapExists.EC.AvgOD_whole = []; % slice # (caud->cran)
status{10}.ParmapExists.EC.AreaFraction = []; % slice # (caud->cran)

status{11}.id = '56';
status{11}.isReg.AxonSection2Sum = [1 2 3 4 5]; % slice # (caud->cran)
status{11}.isReg.AxonSum2MRI = [1 2 3 4 5]; % slice # (caud->cran)
status{11}.isTREcalc = 1;
status{11}.isReg.Interset = [13 14 15 16 17 18 21 22 23 24 25 26 28 29 30 31 32 33 36 37 38 39 40 41 43 44 45 46 47 48] % section #
status{11}.isROIimport.MRIgrid.toSet1 = []; % slice # (caud->cran)
status{11}.isROIimport.MRIgrid.toSet2 = []; % slice # (caud->cran)
status{11}.isROIimport.MRIgrid.toSet3 = []; % slice # (caud->cran)
status{11}.isROIimport.ECventralIntactDamaged.toSet1 = []; % slice # (caud->cran)
status{11}.isROIimport.ECVentralIntactDamaged.toSet2 = []; % slice # (caud->cran)
status{11}.isROIimport.ECVentralIntactDamaged.toMRI = []; % slice # (caud->cran)
status{11}.isROIimport.Axon63xSquare.toSet1 = []; % slice # (caud->cran)
status{11}.isROIimport.Axon63xSquare.toSet3 = []; % slice # (caud->cran)
status{11}.isROIimport.Axon63xSquare.toMRI = []; % slice # (caud->cran)
status{11}.isROIimport.MRIsector.toSet1 = []; % slice # (caud->cran)
status{11}.isROIimport.MRIsector.toSet2 = []; % slice # (caud->cran)
status{11}.isROIimport.MRIsector.toSet3 = []; % slice # (caud->cran)
status{11}.ParmapExists.MRI.MWFa = [1 2 3 4 5]; % slice # (caud->cran)
status{11}.ParmapExists.MRI.gmT2 = [1 2 3 4 5]; % slice # (caud->cran)
status{11}.ParmapExists.MRI.CPMG_echo10 = [1 2 3 4 5]; % slice # (caud->cran)
status{11}.ParmapExists.MRI.CPMG_SNR = [1 2 3 4 5]; % slice # (caud->cran)
status{11}.ParmapExists.MRI.FA = [1 2 3 4 5]; % slice # (caud->cran)
status{11}.ParmapExists.MRI.ADC = [1 2 3 4 5]; % slice # (caud->cran)
status{11}.ParmapExists.MRI.Dlong = [1 2 3 4 5]; % slice # (caud->cran)
status{11}.ParmapExists.MRI.Dtrans = [1 2 3 4 5]; % slice # (caud->cran)
status{11}.ParmapExists.GFAP.AvgOD_thresh = []; % slice # (caud->cran)
status{11}.ParmapExists.GFAP.AvgOD_whole = []; % slice # (caud->cran)
status{11}.ParmapExists.GFAP.AreaFraction = []; % slice # (caud->cran)
status{11}.ParmapExists.P0.AvgOD_thresh = []; % slice # (caud->cran)
status{11}.ParmapExists.P0.AvgOD_whole = []; % slice # (caud->cran)
status{11}.ParmapExists.P0.AreaFraction = []; % slice # (caud->cran)
status{11}.ParmapExists.GFP_Set1.AvgOD_thresh = []; % slice # (caud->cran)
status{11}.ParmapExists.GFP_Set1.AvgOD_whole = []; % slice # (caud->cran)
status{11}.ParmapExists.GFP_Set1.AreaFraction = []; % slice # (caud->cran)
status{11}.ParmapExists.MBP.AvgOD_thresh = []; % slice # (caud->cran)
status{11}.ParmapExists.MBP.AvgOD_whole = []; % slice # (caud->cran)
status{11}.ParmapExists.MBP.AreaFraction = []; % slice # (caud->cran)
status{11}.ParmapExists.Axon.AvgOD_thresh = []; % slice # (caud->cran)
status{11}.ParmapExists.Axon.AvgOD_whole = []; % slice # (caud->cran)
status{11}.ParmapExists.Axon.AreaFraction = []; % slice # (caud->cran)
status{11}.ParmapExists.GFP_Set2.AvgOD_thresh = []; % slice # (caud->cran)
status{11}.ParmapExists.GFP_Set2.AvgOD_whole = []; % slice # (caud->cran)
status{11}.ParmapExists.GFP_Set2.AreaFraction = []; % slice # (caud->cran)
status{11}.ParmapExists.EC.AvgOD_thresh = []; % slice # (caud->cran)
status{11}.ParmapExists.EC.AvgOD_whole = []; % slice # (caud->cran)
status{11}.ParmapExists.EC.AreaFraction = []; % slice # (caud->cran)

status{12}.id = '58';
status{12}.isReg.AxonSection2Sum = [1 2 3 4 5]; % slice # (caud->cran)
status{12}.isReg.AxonSum2MRI = [1 2 3 4 5]; % slice # (caud->cran)
status{12}.isTREcalc = 0;
status{12}.isReg.Interset = [12 13 14 15 17 19 20 21 22 23 24 27 28 29 30 31 34 35 36 37 38 41 42 43 44 45] % section #
status{12}.isROIimport.MRIgrid.toSet1 = []; % slice # (caud->cran)
status{12}.isROIimport.MRIgrid.toSet2 = []; % slice # (caud->cran)
status{12}.isROIimport.MRIgrid.toSet3 = []; % slice # (caud->cran)
status{12}.isROIimport.ECventralIntactDamaged.toSet1 = []; % slice # (caud->cran)
status{12}.isROIimport.ECVentralIntactDamaged.toSet2 = []; % slice # (caud->cran)
status{12}.isROIimport.ECVentralIntactDamaged.toMRI = []; % slice # (caud->cran)
status{12}.isROIimport.Axon63xSquare.toSet1 = []; % slice # (caud->cran)
status{12}.isROIimport.Axon63xSquare.toSet3 = []; % slice # (caud->cran)
status{12}.isROIimport.Axon63xSquare.toMRI = []; % slice # (caud->cran)
status{12}.isROIimport.MRIsector.toSet1 = []; % slice # (caud->cran)
status{12}.isROIimport.MRIsector.toSet2 = []; % slice # (caud->cran)
status{12}.isROIimport.MRIsector.toSet3 = []; % slice # (caud->cran)
status{12}.ParmapExists.MRI.MWFa = [1 2 3 4 5]; % slice # (caud->cran)
status{12}.ParmapExists.MRI.gmT2 = [1 2 3 4 5]; % slice # (caud->cran)
status{12}.ParmapExists.MRI.CPMG_echo10 = [1 2 3 4 5]; % slice # (caud->cran)
status{12}.ParmapExists.MRI.CPMG_SNR = [1 2 3 4 5]; % slice # (caud->cran)
status{12}.ParmapExists.MRI.FA = [1 2 3 4 5]; % slice # (caud->cran)
status{12}.ParmapExists.MRI.ADC = [1 2 3 4 5]; % slice # (caud->cran)
status{12}.ParmapExists.MRI.Dlong = [1 2 3 4 5]; % slice # (caud->cran)
status{12}.ParmapExists.MRI.Dtrans = [1 2 3 4 5]; % slice # (caud->cran)
status{12}.ParmapExists.GFAP.AvgOD_thresh = []; % slice # (caud->cran)
status{12}.ParmapExists.GFAP.AvgOD_whole = []; % slice # (caud->cran)
status{12}.ParmapExists.GFAP.AreaFraction = []; % slice # (caud->cran)
status{12}.ParmapExists.P0.AvgOD_thresh = []; % slice # (caud->cran)
status{12}.ParmapExists.P0.AvgOD_whole = []; % slice # (caud->cran)
status{12}.ParmapExists.P0.AreaFraction = []; % slice # (caud->cran)
status{12}.ParmapExists.GFP_Set1.AvgOD_thresh = []; % slice # (caud->cran)
status{12}.ParmapExists.GFP_Set1.AvgOD_whole = []; % slice # (caud->cran)
status{12}.ParmapExists.GFP_Set1.AreaFraction = []; % slice # (caud->cran)
status{12}.ParmapExists.MBP.AvgOD_thresh = []; % slice # (caud->cran)
status{12}.ParmapExists.MBP.AvgOD_whole = []; % slice # (caud->cran)
status{12}.ParmapExists.MBP.AreaFraction = []; % slice # (caud->cran)
status{12}.ParmapExists.Axon.AvgOD_thresh = []; % slice # (caud->cran)
status{12}.ParmapExists.Axon.AvgOD_whole = []; % slice # (caud->cran)
status{12}.ParmapExists.Axon.AreaFraction = []; % slice # (caud->cran)
status{12}.ParmapExists.GFP_Set2.AvgOD_thresh = []; % slice # (caud->cran)
status{12}.ParmapExists.GFP_Set2.AvgOD_whole = []; % slice # (caud->cran)
status{12}.ParmapExists.GFP_Set2.AreaFraction = []; % slice # (caud->cran)
status{12}.ParmapExists.EC.AvgOD_thresh = []; % slice # (caud->cran)
status{12}.ParmapExists.EC.AvgOD_whole = []; % slice # (caud->cran)
status{12}.ParmapExists.EC.AreaFraction = []; % slice # (caud->cran)

status{13}.id = '61';
status{13}.isReg.AxonSection2Sum = [1 2 3 4 5]; % slice # (caud->cran)
status{13}.isReg.AxonSum2MRI = [1 2 3 4 5]; % slice # (caud->cran)
status{13}.isTREcalc = 0;
status{13}.isReg.Interset = [17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42] % section #
status{13}.isROIimport.MRIgrid.toSet1 = []; % slice # (caud->cran)
status{13}.isROIimport.MRIgrid.toSet2 = []; % slice # (caud->cran)
status{13}.isROIimport.MRIgrid.toSet3 = []; % slice # (caud->cran)
status{13}.isROIimport.ECventralIntactDamaged.toSet1 = []; % slice # (caud->cran)
status{13}.isROIimport.ECVentralIntactDamaged.toSet2 = []; % slice # (caud->cran)
status{13}.isROIimport.ECVentralIntactDamaged.toMRI = []; % slice # (caud->cran)
status{13}.isROIimport.Axon63xSquare.toSet1 = []; % slice # (caud->cran)
status{13}.isROIimport.Axon63xSquare.toSet3 = []; % slice # (caud->cran)
status{13}.isROIimport.Axon63xSquare.toMRI = []; % slice # (caud->cran)
status{13}.isROIimport.MRIsector.toSet1 = []; % slice # (caud->cran)
status{13}.isROIimport.MRIsector.toSet2 = []; % slice # (caud->cran)
status{13}.isROIimport.MRIsector.toSet3 = []; % slice # (caud->cran)
status{13}.ParmapExists.MRI.MWFa = [1 2 3 4]; % slice # (caud->cran)
status{13}.ParmapExists.MRI.gmT2 = [1 2 3 4]; % slice # (caud->cran)
status{13}.ParmapExists.MRI.CPMG_echo10 = [1 2 3 4]; % slice # (caud->cran)
status{13}.ParmapExists.MRI.CPMG_SNR = [1 2 3 4]; % slice # (caud->cran)
status{13}.ParmapExists.MRI.FA = [1 2 3 4 5]; % slice # (caud->cran)
status{13}.ParmapExists.MRI.ADC = [1 2 3 4 5]; % slice # (caud->cran)
status{13}.ParmapExists.MRI.Dlong = [1 2 3 4 5]; % slice # (caud->cran)
status{13}.ParmapExists.MRI.Dtrans = [1 2 3 4 5]; % slice # (caud->cran)
status{13}.ParmapExists.GFAP.AvgOD_thresh = []; % slice # (caud->cran)
status{13}.ParmapExists.GFAP.AvgOD_whole = []; % slice # (caud->cran)
status{13}.ParmapExists.GFAP.AreaFraction = []; % slice # (caud->cran)
status{13}.ParmapExists.P0.AvgOD_thresh = []; % slice # (caud->cran)
status{13}.ParmapExists.P0.AvgOD_whole = []; % slice # (caud->cran)
status{13}.ParmapExists.P0.AreaFraction = []; % slice # (caud->cran)
status{13}.ParmapExists.GFP_Set1.AvgOD_thresh = []; % slice # (caud->cran)
status{13}.ParmapExists.GFP_Set1.AvgOD_whole = []; % slice # (caud->cran)
status{13}.ParmapExists.GFP_Set1.AreaFraction = []; % slice # (caud->cran)
status{13}.ParmapExists.MBP.AvgOD_thresh = []; % slice # (caud->cran)
status{13}.ParmapExists.MBP.AvgOD_whole = []; % slice # (caud->cran)
status{13}.ParmapExists.MBP.AreaFraction = []; % slice # (caud->cran)
status{13}.ParmapExists.Axon.AvgOD_thresh = []; % slice # (caud->cran)
status{13}.ParmapExists.Axon.AvgOD_whole = []; % slice # (caud->cran)
status{13}.ParmapExists.Axon.AreaFraction = []; % slice # (caud->cran)
status{13}.ParmapExists.GFP_Set2.AvgOD_thresh = []; % slice # (caud->cran)
status{13}.ParmapExists.GFP_Set2.AvgOD_whole = []; % slice # (caud->cran)
status{13}.ParmapExists.GFP_Set2.AreaFraction = []; % slice # (caud->cran)
status{13}.ParmapExists.EC.AvgOD_thresh = []; % slice # (caud->cran)
status{13}.ParmapExists.EC.AvgOD_whole = []; % slice # (caud->cran)
status{13}.ParmapExists.EC.AreaFraction = []; % slice # (caud->cran)

status{14}.id = '62';
status{14}.isReg.AxonSection2Sum = [1 2 3 4 5]; % slice # (caud->cran)
status{14}.isReg.AxonSum2MRI = [1 2 3 4 5]; % slice # (caud->cran) 
status{14}.isTREcalc = 0;
status{14}.isReg.Interset = [-1 0 1 2 3 4 6 7 8 9 10 11 12 15 16 17 18 19 22 23 24 25 26 27 30 31 32 33 34] % section #
status{14}.isROIimport.MRIgrid.toSet1 = []; % slice # (caud->cran)
status{14}.isROIimport.MRIgrid.toSet2 = []; % slice # (caud->cran)
status{14}.isROIimport.MRIgrid.toSet3 = []; % slice # (caud->cran)
status{14}.isROIimport.ECventralIntactDamaged.toSet1 = []; % slice # (caud->cran)
status{14}.isROIimport.ECVentralIntactDamaged.toSet2 = []; % slice # (caud->cran)
status{14}.isROIimport.ECVentralIntactDamaged.toMRI = []; % slice # (caud->cran)
status{14}.isROIimport.Axon63xSquare.toSet1 = []; % slice # (caud->cran)
status{14}.isROIimport.Axon63xSquare.toSet3 = []; % slice # (caud->cran)
status{14}.isROIimport.Axon63xSquare.toMRI = []; % slice # (caud->cran)
status{14}.isROIimport.MRIsector.toSet1 = []; % slice # (caud->cran)
status{14}.isROIimport.MRIsector.toSet2 = []; % slice # (caud->cran)
status{14}.isROIimport.MRIsector.toSet3 = []; % slice # (caud->cran)
status{14}.ParmapExists.MRI.MWFa = []; % slice # (caud->cran)
status{14}.ParmapExists.MRI.gmT2 = []; % slice # (caud->cran)
status{14}.ParmapExists.MRI.CPMG_echo10 = []; % slice # (caud->cran)
status{14}.ParmapExists.MRI.CPMG_SNR = []; % slice # (caud->cran)
status{14}.ParmapExists.MRI.FA = [1 2 3 4 5]; % slice # (caud->cran)
status{14}.ParmapExists.MRI.ADC = [1 2 3 4 5]; % slice # (caud->cran)
status{14}.ParmapExists.MRI.Dlong = [1 2 3 4 5]; % slice # (caud->cran)
status{14}.ParmapExists.MRI.Dtrans = [1 2 3 4 5]; % slice # (caud->cran)
status{14}.ParmapExists.GFAP.AvgOD_thresh = []; % slice # (caud->cran)
status{14}.ParmapExists.GFAP.AvgOD_whole = []; % slice # (caud->cran)
status{14}.ParmapExists.GFAP.AreaFraction = []; % slice # (caud->cran)
status{14}.ParmapExists.P0.AvgOD_thresh = []; % slice # (caud->cran)
status{14}.ParmapExists.P0.AvgOD_whole = []; % slice # (caud->cran)
status{14}.ParmapExists.P0.AreaFraction = []; % slice # (caud->cran)
status{14}.ParmapExists.GFP_Set1.AvgOD_thresh = []; % slice # (caud->cran)
status{14}.ParmapExists.GFP_Set1.AvgOD_whole = []; % slice # (caud->cran)
status{14}.ParmapExists.GFP_Set1.AreaFraction = []; % slice # (caud->cran)
status{14}.ParmapExists.MBP.AvgOD_thresh = []; % slice # (caud->cran)
status{14}.ParmapExists.MBP.AvgOD_whole = []; % slice # (caud->cran)
status{14}.ParmapExists.MBP.AreaFraction = []; % slice # (caud->cran)
status{14}.ParmapExists.Axon.AvgOD_thresh = []; % slice # (caud->cran)
status{14}.ParmapExists.Axon.AvgOD_whole = []; % slice # (caud->cran)
status{14}.ParmapExists.Axon.AreaFraction = []; % slice # (caud->cran)
status{14}.ParmapExists.GFP_Set2.AvgOD_thresh = []; % slice # (caud->cran)
status{14}.ParmapExists.GFP_Set2.AvgOD_whole = []; % slice # (caud->cran)
status{14}.ParmapExists.GFP_Set2.AreaFraction = []; % slice # (caud->cran)
status{14}.ParmapExists.EC.AvgOD_thresh = []; % slice # (caud->cran)
status{14}.ParmapExists.EC.AvgOD_whole = []; % slice # (caud->cran)
status{14}.ParmapExists.EC.AreaFraction = []; % slice # (caud->cran)

save SKP_status status

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear histomap_id

histomap_id{1}.setdir = '01_Set 1 - P0_GFAP_GFP_10x';
histomap_id{1}.n_stain = 3;
histomap_id{1}.stain_dir{1}  = '01-GFAP_blue';
histomap_id{1}.stain_dir{2} = '02-GFP_green';
histomap_id{1}.stain_dir{3} = '03-P0_red';
histomap_id{1}.runAnalysis{1}  = 0;
histomap_id{1}.runAnalysis{2} = 0;
histomap_id{1}.runAnalysis{3} = 0;
histomap_id{1}.stain_segmapdir{1} = '';
histomap_id{1}.stain_segmapdir{2} = '09-GFP thresholded';
histomap_id{1}.stain_segmapdir{3} = '08-P0 thresholded';
histomap_id{1}.stain_shortname{1}  = 'GFAP';
histomap_id{1}.stain_shortname{2} = 'GFP_Set1';
histomap_id{1}.stain_shortname{3} = 'P0';


histomap_id{2}.setdir = '02_Set 2 - MBP_Axons_10x';
histomap_id{2}.n_stain = 3;
histomap_id{2}.stain_dir{1}  = '01-MBP_red';
histomap_id{2}.stain_dir{2} = '02-Axons_blue';
histomap_id{2}.stain_dir{3} = '03-GFP_green';
histomap_id{2}.runAnalysis{1}  = 1;
histomap_id{2}.runAnalysis{2} = 0;
histomap_id{2}.runAnalysis{3} = 0;
histomap_id{2}.stain_segmapdir{1} = '07-MBP thresholded';
histomap_id{2}.stain_segmapdir{2} = '08-Axons thresholded';
histomap_id{2}.stain_segmapdir{3} = '';
histomap_id{2}.stain_shortname{1}  = 'MBP';
histomap_id{2}.stain_shortname{2} = 'Axon';
histomap_id{2}.stain_shortname{3} = 'GFP_Set2';

histomap_id{3}.setdir = '03_Set 3 - Eriochrome_10x';
histomap_id{3}.n_stain = 1;
histomap_id{3}.runAnalysis{1}  = 0;
histomap_id{3}.stain_dir{1}  = '';
histomap_id{3}.stain_segmapdir{1} = '07-EC thresholded';
histomap_id{3}.stain_shortname{1}  = 'EC';

save SKP-histomap_id histomap_id

clear MRI_orientation

% flipLR flipUD transpose
MRI_orientation{1} = [1 0 0];
MRI_orientation{2} = [1 0 0];
MRI_orientation{3} = [1 0 0];
MRI_orientation{4} = [0 0 0];
MRI_orientation{5} = [0 0 1];
MRI_orientation{6} = [0 1 1];
MRI_orientation{7} = [1 0 0];
MRI_orientation{8} = [1 0 0];
MRI_orientation{9} = [0 1 0];
MRI_orientation{10} = [1 1 1];
MRI_orientation{11} = [0 0 1];
MRI_orientation{12} = [0 0 0];
MRI_orientation{13} = [0 1 0];
MRI_orientation{14} = [0 0 1];

save SKP_MRI_orientation MRI_orientation

cd(origdir);