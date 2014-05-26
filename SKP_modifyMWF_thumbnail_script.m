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

for j=1:14
    id = IDtag{j}.id;
    disp(['id =' id]);
    
    MRIsrc_basepath = [rootpath id '\' '04-Preprocessing\07-MRI initial flip alignment\02-Results\'];
    
    for i=status{j}.isReg.AxonSum2MRI

        disp(['MRI slice = ' slice_name{i}]);

        MRIsrc_path = [MRIsrc_basepath section_path{i}];
        load([MRIsrc_path 'CPMG_MWF.mat']); %loads imMWF
        load([MRIsrc_path 'Dlong.mat']); %loads imDlong
        load([MRIsrc_path 'Dtrans.mat']); %loads imDtrans
        load([MRIsrc_path 'FA.mat']); %loads imFA
        
        figure(2); hfig = imagesc(imMWF); caxis([0 1]); axis image; axis off;
        tightfig;
        saveas(hfig,[MRIsrc_path 'imMWF2.png'],'png');
        
        figure(2); hfig = imagesc(imDlong); caxis([0 1.5e-3]); axis image; axis off;
        tightfig;
        saveas(hfig,[MRIsrc_path 'imDlong2.png'],'png');

        figure(2); hfig = imagesc(imDtrans); caxis([0 1.5e-3]); axis image; axis off;
        tightfig;
        saveas(hfig,[MRIsrc_path 'imDtrans2.png'],'png');

        figure(2); hfig = imagesc(imFA); caxis([0 1]); axis image; axis off;
        tightfig;
        saveas(hfig,[MRIsrc_path 'imFA2.png'],'png');

    end
end