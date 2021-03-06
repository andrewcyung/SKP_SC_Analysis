% STEP 1:  define the data dimensions you want to include in the viewframes
% view_categories = {'subject','slice','segzone'}; 
view_categories = {'group','subject','slice'}; 

% STEP 3: define the parameter maps you want to compare
    parx_pairs = {{'MWF','MBP_IntegODThresh'},...
                  {'MWF','MBP_AreaFraction'},...
                  {'MWF','EC_IntegODThresh'},...
                  {'MWF','EC_AreaFraction'},...
                  {'Dlong','Axon_IntegODThresh'},...
                  {'Dlong','Axon_AreaFraction'},...
                  {'Dtrans','MBP_IntegODThresh'},...
                  {'Dtrans','MBP_AreaFraction'},...
                  {'Dtrans','EC_IntegODThresh'},...
                  {'Dtrans','EC_AreaFraction'}};

SKP_GenerateInfostruct;
sf = make_SKP_storageframe('MRIPixelGrid','Sectors','F:\SKP-SC analysis\','06-Transformation\02-ConsolidatedData\',IDtag);
storage_layout = {'group','subject','slice','segzone'};
origdir = pwd;
cd(rootpath);
save('SKP-sf-original.mat','sf');
% load SKP-sf.mat
cd(origdir);

% Note the experiment groups:
%  - 8 week injury baseline:  11,16,18,20
%  - 27 wpi, cell injection:  36,51,54,55,56
%  - 27 wpi, media injection: 39,41,58,61,62
n_pairs = length(parx_pairs);

requested_members.('slice') = {'1EdgeCaudal','2MidCaudal','3Epicentre','4MidCranial','5EdgeCranial'};
requested_members.('segzone') = {'Dorsal','Ventral','Lateral'};
subjectlist = {'8-11','8-16','8-18','8-20',...
               'C-36','C-51','C-54','C-55','C-56',...
               'M-39','M-41','M-58','M-61','M-62'};

dest_path = [rootpath 'Correlations/'];
run_name = 'original';
filelist = cell(1,n_pairs);
for i=1:n_pairs

    parname_x = parx_pairs{i}{1};
    parname_y = parx_pairs{i}{2};

    requested_members.('group') = {'8wk'};
    requested_members.('subject') = {'11','16','18','20'};
    vf_x = MakeViewframe(parname_x,view_categories,sf,storage_layout,requested_members);
    vf_y = MakeViewframe(parname_y,view_categories,sf,storage_layout,requested_members);
    [R_8wk,R_upperCI_8wk,R_lowerCI_8wk,pval_8wk] = CalcCorrcoeffViewframe(vf_x,vf_y,'Pearson');

    requested_members.('group') = {'Media'};
    requested_members.('subject') = {'36','51','54','55','56'};
    vf_x = MakeViewframe(parname_x,view_categories,sf,storage_layout,requested_members);
    vf_y = MakeViewframe(parname_y,view_categories,sf,storage_layout,requested_members);
    [R_Media,R_upperCI_Media,R_lowerCI_Media,pval_Media] = CalcCorrcoeffViewframe(vf_x,vf_y,'Pearson');

    requested_members.('group') = {'Cells'};
    requested_members.('subject') = {'39','41','58','61','62'};
    vf_x = MakeViewframe(parname_x,view_categories,sf,storage_layout,requested_members);
    vf_y = MakeViewframe(parname_y,view_categories,sf,storage_layout,requested_members);
    [R_Cells,R_upperCI_Cells,R_lowerCI_Cells,pval_Cells] = CalcCorrcoeffViewframe(vf_x,vf_y,'Pearson');
    
    R_matrix = [squeeze(cell2mat(R_8wk)); squeeze(cell2mat(R_Media)); squeeze(cell2mat(R_Cells))];
    R_upperCI_matrix = [squeeze(cell2mat(R_upperCI_8wk)); squeeze(cell2mat(R_upperCI_Media)); squeeze(cell2mat(R_upperCI_Cells))];
    R_lowerCI_matrix = [squeeze(cell2mat(R_lowerCI_8wk)); squeeze(cell2mat(R_lowerCI_Media)); squeeze(cell2mat(R_lowerCI_Cells))];

    h_corrfig = figure(7);

    upper_size = R_upperCI_matrix - R_matrix;
    lower_size = R_matrix - R_lowerCI_matrix;
    facecolor = cell(size(R_matrix));
    facecolor(:,1) = {'r'};
    facecolor(:,2) = {'g'};
    facecolor(:,3) = {'b'};
    facecolor(:,4) = {'y'};
    facecolor(:,5) = {'m'};
    
    R_matrix(isnan(R_matrix)) = 0;
    upper_size(isnan(upper_size)) = 0;
    lower_size(isnan(lower_size)) = 0;

    h_ax = barError3d(R_matrix,upper_size,lower_size,facecolor);
    zlim([-1 1]);
    set(gca,'XTickLabel',subjectlist);
    set(gca,'YTickLabel',requested_members.('slice'));
    set(gca,'XTick',[1:size(R_matrix,1)]);
    set(gca,'YTick',[1:size(R_matrix,2)]);
    set(gca,'FontSize',12);
    zlabel('R');
    htext = title(['Correlations between ' parname_x ' vs. ' parname_y]);
    set(htext,'Interpreter','none');
    filename = [parname_x '_vs_' parname_y '_corrcoeff_' run_name];
    save([dest_path filename],'R_matrix','R_upperCI_matrix','R_lowerCI_matrix');
    saveas(h_corrfig,[dest_path filename],'tif');
    filelist{i} = [dest_path filename '.tif'];
    clf(h_corrfig);
end
% set(gcf,'units','normalized','outerposition',[0 0 1 1])

h_im=montage(filelist(1:4),'Size',[2 2]);
montage_im = get(h_im,'CData');
imwrite(montage_im,[dest_path 'montage1_' run_name '.tif']);

h_im=montage(filelist(5:10),'Size',[2 3]);
montage_im = get(h_im,'CData');
imwrite(montage_im,[dest_path 'montage2_' run_name '.tif']);
