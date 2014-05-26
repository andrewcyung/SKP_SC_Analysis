id = '36'

src_basepath = ['F:\SKP-SC analysis\' id '\05-Registration\01-DTIvsMWF ManualRegistration\01-Source data\'];
dest_basepath = ['F:\SKP-SC analysis\' id '\05-Registration\01-DTIvsMWF ManualRegistration\02-Results\'];

section_path{1} = '01-edge_caudal';
section_path{2} = '02-mid_caudal';
section_path{3} = '03-epicentre';
section_path{4} = '04-mid_cranial';
section_path{5} = '05-edge_cranial';

load(['F:\SKP-SC analysis\SKP-CPMGDTImatch']);

DTIref = matchref{5}.DTI
MWFref = matchref{5}.MWF

for i=2:2
    dest_path = [dest_basepath section_path{i}];
    src_path = [src_basepath section_path{i}];  
    cd(src_path);
    load TrW
    load CPMG_echo10
    load CPMG_gmT2
    figure(1);imagesc(CPMG_echo10);axis image;colormap gray

%     DTIref_flip = [DTIref{i}(1) DTIref{i}(2)]
    DTIref_flip = [129-DTIref{i}(1) DTIref{i}(2)]

    padx = MWFref{i}(1)-DTIref_flip(1);
    pady = MWFref{i}(2)-DTIref_flip(2);

    TrWflip = (imTrW);
    figure(2);imagesc(TrWflip);axis image;colormap gray
   
    DTInew = zeros(256);
    DTInew((pady+1):(pady+128),(padx+1):(padx+128)) = TrWflip;
%     DTInew((padx+1):(padx+128),(pady+1):(pady+128)) = imTrW;
    DTInew = DTInew(1:256,1:256);

    figure(3);imagesc(DTInew);axis image;colormap gray

end



