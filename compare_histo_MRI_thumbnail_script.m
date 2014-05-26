rootpath = 'F:\SKP-SC analysis\';

section_path{1} = '01-edge_caudal\';
section_path{2} = '02-mid_caudal\';
section_path{3} = '03-epicentre\';
section_path{4} = '04-mid_cranial\';
section_path{5} = '05-edge_cranial\';

slice_name{1} = '1EdgeCaudal';
slice_name{2} = '2MidCaudal';
slice_name{3} = '3Epicentre';
slice_name{4} = '4MidCranial';
slice_name{5} = '5EdgeCranial';


load(['F:\SKP-SC analysis\' 'SKP-IDtag']) %loads IDtag
load(['F:\SKP-SC analysis\' 'SKP_matchkey_ay_original']) %loads matchkey
load(['F:\SKP-SC analysis\' 'SKP_status']) %loads status
load(['F:\SKP-SC analysis\' 'SKP_histo_stain']) %loads histo_stain

for j=[1:14]
    id = IDtag{j}.id;
    disp(['id =' id]);
    
    src_basepath = [rootpath id '\' '06-Transformation\01-HistologyParMaps\02-Results\'];
    MRIsrc_basepath = [rootpath id '\' '04-Preprocessing\07-MRI initial flip alignment\02-Results\'];
    
    for i=status{j}.isReg.AxonSum2MRI

        disp(['MRI slice = ' slice_name{i}]);

        MRIsrc_path = [MRIsrc_basepath section_path{i}];
        load([MRIsrc_path 'CPMG_MWF.mat']); %loads imMWF
        load([MRIsrc_path 'Dlong.mat']); %loads imDlong
        load([MRIsrc_path 'Dtrans.mat']); %loads imDtrans
        load([MRIsrc_path 'FA.mat']); %loads imFA
        
        HistoParmap_matfilename = ['HistoParMap_' id '_' slice_name{i} '_' 'EC' '.mat'];
        load([src_basepath  HistoParmap_matfilename]); %loads AreaFraction, AvgOD_Whole, AvgOD_AboveThreshold
        EC_AF = AreaFraction;
        
        HistoParmap_matfilename = ['HistoParMap_' id '_' slice_name{i} '_' 'MBP' '.mat'];
        load([src_basepath  HistoParmap_matfilename]); %loads AreaFraction, AvgOD_Whole, AvgOD_AboveThreshold
        MBP_AF = AreaFraction;
        
        HistoParmap_matfilename = ['HistoParMap_' id '_' slice_name{i} '_' 'Axon' '.mat'];
        load([src_basepath  HistoParmap_matfilename]); %loads AreaFraction, AvgOD_Whole, AvgOD_AboveThreshold
        Axon_AF = AreaFraction;
        
        hfig = figure(2);
        subplot_tight(2,3,1); imagesc(imMWF); caxis([0 1]); axis image; axis off;
        subplot_tight(2,3,2); imagesc(imDlong); caxis([0 1.5e-3]); axis image; axis off;
        subplot_tight(2,3,3); imagesc(imDtrans); caxis([0 1.5e-3]); axis image; axis off;
        subplot_tight(2,3,4); imagesc(EC_AF); caxis([0 1]); axis image; axis off;
        subplot_tight(2,3,5); imagesc(MBP_AF); caxis([0 1]); axis image; axis off;
        subplot_tight(2,3,6); imagesc(Axon_AF); caxis([0 1]); axis image; axis off;
        
        tightfig;
        saveas(hfig,[src_basepath id '_' slice_name{i} '_MRIvshisto.png'],'png');
        
    end
end