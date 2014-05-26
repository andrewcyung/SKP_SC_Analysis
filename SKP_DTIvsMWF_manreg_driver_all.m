section_path{1} = '01-edge_caudal';
section_path{2} = '02-mid_caudal';
section_path{3} = '03-epicentre';
section_path{4} = '04-mid_cranial';
section_path{5} = '05-edge_cranial';


load(['F:\SKP-SC analysis\' 'SKP_matchkey_leo_original'])


for j=14:14

    id = matchref{j}.id
    src_basepath = ['F:\SKP-SC analysis\' id '\05-Registration\01-DTIvsMWF ManualRegistration\01-Source data\'];
    dest_basepath = ['F:\SKP-SC analysis\' id '\05-Registration\01-DTIvsMWF ManualRegistration\02-Results\'];

    for i=4:4
        disp(num2str(i));
        dest_path = [dest_basepath section_path{i} '\'];
        src_path = [src_basepath section_path{i} '\'];  
        cd(src_path);
        load CPMG_echo10
        load CPMG_MWF
        figure(1);imagesc(CPMG_echo10);axis image;colormap gray

         
        MWFref = matchref{j}.CPMG(i,:);
        DTIref = matchref{j}.DTI(i,:);
        DTI_dr = MWFref - DTIref;
 
        load TrW
        TrWshifted = SKP_im_pad_flip_move(imTrW,matchref{j}.flipdir,DTI_dr);
        checkim=checkvis(mat2gray(CPMG_echo10),mat2gray(TrWshifted),16,8,8);
        h1=figure(3);imagesc(checkim);axis image;colormap gray
        imTrW = TrWshifted;
        saveas(h1, [dest_path 'TrWvsCPMG'],'png');
        save([dest_path 'TrW'], 'imTrW');

        load ADC
        ADCshifted = SKP_im_pad_flip_move(imADC,matchref{j}.flipdir,DTI_dr);
        imADC = ADCshifted;
        save([dest_path 'ADC'], 'imADC');
        
        load Dlong
        Dlongshifted = SKP_im_pad_flip_move(imDlong,matchref{j}.flipdir,DTI_dr);
        imDlong = Dlongshifted;
        save([dest_path 'Dlong'], 'imDlong');
        
        load Dtrans
        Dtransshifted = SKP_im_pad_flip_move(imDtrans,matchref{j}.flipdir,DTI_dr);
        imDtrans = Dtransshifted;
        save([dest_path 'Dtrans'], 'imDtrans');
     
        load FA
        FAshifted = SKP_im_pad_flip_move(imFA,matchref{j}.flipdir,DTI_dr);
        imFA = FAshifted;
        save([dest_path 'FA'], 'imFA');
        
        symlinker_file('CPMG_MWF.mat',src_path,dest_path);
        symlinker_file('CPMG_dn.mat',src_path,dest_path);
        symlinker_file('CPMG_echo10.mat',src_path,dest_path);
        symlinker_file('CPMG_flipangle.mat',src_path,dest_path);
        symlinker_file('CPMG_misfit.mat',src_path,dest_path);
        symlinker_file('CPMG_SNR.mat',src_path,dest_path);
        symlinker_file('CPMG_MWF.mat',src_path,dest_path);
        symlinker_file('CPMG_T2dist.mat',src_path,dest_path);
    end

end


