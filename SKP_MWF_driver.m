src_basepath = 'E:\mriuser\nmr\';
dest_basepath = 'F:\SKP-SC analysis\';
dest_basepath2 = '01-Original Images\01-MRI\';

load(['F:\SKP-SC analysis\' 'SKP-IDtag'])

% echo_images = cell(14,5);
% for j=6:6
%     id = IDtag{j}.id
%     exp_cran2caud = IDtag{j}.MWFexp_cran2caud;
%     studypath = IDtag{j}.studypath;
% 
%     for i_slice=1:5
%         srcpath = [src_basepath studypath '\' num2str(exp_cran2caud(i_slice))];
%         CPMGset = get2dseq(srcpath,1);
%         [reconData,okornot] = OpenCorrect(CPMGset.data);
%         echo_images{j,i_slice} = reconData;
%     end
%     
% end
% save([dest_basepath 'CPMG_echo_images.mat'],'echo_images');
load([dest_basepath 'CPMG_echo_images.mat']);

for j=3:14
    id = IDtag{j}.id
    exp_cran2caud = IDtag{j}.MWFexp_cran2caud;
    studypath = IDtag{j}.studypath;
    
    dest{1} = [dest_basepath id '\' dest_basepath2 '05-edge_cranial\'];
    dest{2} = [dest_basepath id '\' dest_basepath2 '04-mid_cranial\'];
    dest{3} = [dest_basepath id '\' dest_basepath2 '03-epicentre\'];
    dest{4} = [dest_basepath id '\' dest_basepath2 '02-mid_caudal\'];
    dest{5} = [dest_basepath id '\' dest_basepath2 '01-edge_caudal\'];
    
    ROIpath = [dest_basepath id '\' dest_basepath2];
    load([ROIpath 'MWFgen_ROI_' id],'ROI');
    
    TE=6.738/1000;
    isCVNNLS = 1; fixed_misfit = 1.0001;
    isSEcorr = 0;
%     integlim = [7.5 22 200];
    integlim = [7.5 22 800];
    
     for i_slice=1:5
        disp([id ' slice ' num2str(i_slice)]);
         MWFset{i_slice} = MWF_cmd(echo_images{j,i_slice}, ROI{i_slice}, isCVNNLS, isSEcorr, TE, integlim/1000, fixed_misfit);
        
%         imAlpha = squeeze(MWFset{i_slice}.alphamap); save([dest{i_slice} 'CPMG_flipangle'], 'imAlpha');
%         imDn = squeeze(MWFset{i_slice}.dnmap); save([dest{i_slice} 'CPMG_dn'], 'imDn');
%         imGmT2 = squeeze(MWFset{i_slice}.gmT2map); save([dest{i_slice} 'CPMG_gmT2'], 'imGmT2');
%         imSNR = squeeze(MWFset{i_slice}.SNRmap); save([dest{i_slice} 'CPMG_SNR'], 'imSNR');
%         imMisfit = squeeze(MWFset{i_slice}.misfitmap); save([dest{i_slice} 'CPMG_misfit'], 'imMisfit');

%         imMWF_CVstim = squeeze(MWFset{i_slice}.MWFmap); save([dest{i_slice} 'CPMG_MWF_CVstim'], 'imMWF_CVstim');
%         imT2dist_CVstim = squeeze(MWFset{i_slice}.T2distmap); save([dest{i_slice} 'CPMG_T2dist_CVstim'], 'imT2dist_CVstim');
%         imEcho_CVstim = squeeze(echo_images(j,i_slice)); save([dest{i_slice} 'CPMG_echo_CVstim'], 'imEcho_CVstim');

%         imMWF_fixedmisfit = squeeze(MWFset{i_slice}.MWFmap); save([dest{i_slice} 'CPMG_MWF_fixedmisfit'], 'imMWF_fixedmisfit');
%         imT2dist_fixedmisfit = squeeze(MWFset{i_slice}.T2distmap); save([dest{i_slice} 'CPMG_T2dist_fixedmisfit'], 'imT2dist_fixedmisfit');
%         imdecay_pred_fixedmisfit = squeeze(MWFset{i_slice}.decay_pred);
%         imEcho_fixedmisfit = squeeze(echo_images(j,i_slice)); save([dest{i_slice} 'CPMG_echo_fixedmisfit'], 'imEcho_fixedmisfit','imdecay_pred_fixedmisfit');
%         imGoF_fixedmisfit = squeeze(MWFset{i_slice}.GoFmap); save([dest{i_slice} 'CPMG_GoF_fixedmisfit'], 'imGoF_fixedmisfit');

        imMWF_CVvarlim = squeeze(MWFset{i_slice}.MWFmap); save([dest{i_slice} 'CPMG_MWF_CVvarlim'], 'imMWF_CVvarlim');
        imT2dist_CVvarlim = squeeze(MWFset{i_slice}.T2distmap); save([dest{i_slice} 'CPMG_T2dist_CVvarlim'], 'imT2dist_CVvarlim');
        imdecay_pred_CVvarlim = squeeze(MWFset{i_slice}.decay_pred);
        imEcho_CVvarlim = squeeze(echo_images(j,i_slice)); save([dest{i_slice} 'CPMG_echo_CVvarlim'], 'imEcho_CVvarlim','imdecay_pred_CVvarlim');
        imGoF_CVvarlim = squeeze(MWFset{i_slice}.GoFmap); save([dest{i_slice} 'CPMG_GoF_CVvarlim'], 'imGoF_CVvarlim');
        imIntegLim_CVvarlim = squeeze(MWFset{i_slice}.integlim_map); save([dest{i_slice} 'CPMG_IntegLim_CVvarlim'], 'imIntegLim_CVvarlim');
        
%         h1 = figure(1); axis image; imagesc(imMWF); title('MWF'); colorbar; caxis(MWFset{i_slice}.MWFmapClim); colormap('jet'); saveas(h1, [dest{i_slice} 'CPMG_MWF'],'png');
%         h2 = figure(2); axis image; imagesc(imAlpha); title('flip angle'); colorbar; caxis(MWFset{i_slice}.alphamapClim); colormap('jet'); saveas(h2, [dest{i_slice} 'CPMG_flipangle'],'png');
%         h3 = figure(3); axis image; imagesc(imDn); title('Proton density'); colorbar; caxis(MWFset{i_slice}.dnmapClim); colormap('jet'); saveas(h3, [dest{i_slice} 'CPMG_dn'],'png');
%         h4 = figure(4); axis image; imagesc(imGmT2); title('gmT2'); colorbar; caxis(MWFset{i_slice}.gmT2mapClim); colormap('jet'); saveas(h4, [dest{i_slice} 'CPMG_gmT2'],'png');
%         h5 = figure(5); axis image; imagesc(imSNR); title('SNR'); colorbar; caxis(MWFset{i_slice}.SNRmapClim); colormap('jet'); saveas(h5, [dest{i_slice} 'CPMG_SNR'],'png');
%         h6 = figure(6); axis image; imagesc(imMisfit); title('misfit'); colorbar; caxis(MWFset{i_slice}.misfitmapClim); colormap('jet'); saveas(h6, [dest{i_slice} 'CPMG_misfit'],'png');
        
    end
end