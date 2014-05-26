src_basepath = 'E:\mriuser\nmr\';
dest_basepath = 'F:\SKP-SC analysis\';
dest_basepath2 = '01-Original Images\01-MRI\';

load SKP-IDtag

for i=1:length(IDtag)
    dest{1} = [dest_basepath IDtag{i}.id '\' dest_basepath2 '05-edge_cranial\'];
    dest{2} = [dest_basepath IDtag{i}.id '\' dest_basepath2 '04-mid_cranial\'];
    dest{3} = [dest_basepath IDtag{i}.id '\' dest_basepath2 '03-epicentre\'];
    dest{4} = [dest_basepath IDtag{i}.id '\' dest_basepath2 '02-mid_caudal\'];
    dest{5} = [dest_basepath IDtag{i}.id '\' dest_basepath2 '01-edge_caudal\'];

    for i_slice=1:5
        srcpath = [src_basepath IDtag{i}.studypath '\' num2str(IDtag{i}.MWFexp_cran2caud(i_slice))];
        CPMGset = get2dseq(srcpath,1);
        CPMG_echo10 = squeeze(CPMGset.data(:,:,11));
        h1 = figure(1); axis image; imagesc(CPMG_echo10); title('MWF'); colormap('gray');
        saveas(h1, [dest{i_slice} 'CPMG_echo10'],'png');
        save([dest{i_slice} 'CPMG_echo10'], 'CPMG_echo10');
    end
end