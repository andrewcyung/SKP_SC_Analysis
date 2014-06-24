% STEP 1:  define the data dimensions you want to include in the viewframes
view_categories = {'subject','slice','segzone'}; 

% STEP 3: define the parameter maps you want to compare
    parx_pairs = {{'MWF','EC_AreaFraction'},...
        {'MWF','MBP_IntegODThresh'},...
        {'MWF','MBP_AreaFraction'},...
        {'MWF','EC_IntegODThresh'},...
        {'MWF','EC_AreaFraction'},...
        {'Dlong','MBP_IntegODThresh'},...
        {'Dlong','MBP_AreaFraction'},...
        {'Dlong','EC_IntegODThresh'},...
        {'Dlong','EC_AreaFraction'},...
        {'Dlong','Axon_IntegODThresh'},...
        {'Dlong','Axon_AreaFraction'},...
        {'Dtrans','MBP_IntegODThresh'},...
        {'Dtrans','MBP_AreaFraction'},...
        {'Dtrans','EC_IntegODThresh'},...
        {'Dtrans','EC_AreaFraction'},...
        {'Dtrans','Axon_IntegODThresh'},...
        {'Dtrans','Axon_AreaFraction'},...
        {'FA','MBP_IntegODThresh'},...
        {'FA','MBP_AreaFraction'},...
        {'FA','EC_IntegODThresh'},...
        {'FA','EC_AreaFraction'},...
        {'FA','Axon_IntegODThresh'},...
        {'FA','Axon_AreaFraction'}};
    
SKP_GenerateInfostruct;
% sf = make_SKP_storageframe('MRIPixelGrid','Sectors','F:\SKP-SC analysis\','06-Transformation\02-ConsolidatedData\',IDtag);
storage_layout = {'group','subject','slice','segzone'};
origdir = pwd;
cd(rootpath);
% save('SKP-sf.mat','sf');
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

for i=1:n_pairs

    parname_x = parx_pairs{i}{1};
    parname_y = parx_pairs{i}{2};

    requested_members.('group') = {'8wk'};
    requested_members.('subject') = {'11','16','18','20'};
    vf_x = MakeViewframe(parname_x,view_categories,sf,storage_layout,requested_members);
    vf_y = MakeViewframe(parname_y,view_categories,sf,storage_layout,requested_members);
    [R_8wk,R_CI_8wk,pval_8wk,R_all_8wk,R_CI_all_8wk,pval_all_8wk] = CalcCorrcoeffViewframe(vf_x,vf_y,'Pearson');

    requested_members.('group') = {'Cells'};
    requested_members.('subject') = {'36','51','54','55','56'};
    vf_x = MakeViewframe(parname_x,view_categories,sf,storage_layout,requested_members);
    vf_y = MakeViewframe(parname_y,view_categories,sf,storage_layout,requested_members);
    [R_Media,R_CI_Media,pval_Media,R_all_Media,R_CI_all_Media,pval_all_Media] = CalcCorrcoeffViewframe(vf_x,vf_y,'Pearson');

    requested_members.('group') = {'Media'};
    requested_members.('subject') = {'39','41','58','61','62'};
    vf_x = MakeViewframe(parname_x,view_categories,sf,storage_layout,requested_members);
    vf_y = MakeViewframe(parname_y,view_categories,sf,storage_layout,requested_members);
    [R_Cells,R_CI_Cells,pval_Cells,R_all_Cells,R_CI_all_Cells,pval_all_Cells] = CalcCorrcoeffViewframe(vf_x,vf_y,'Pearson');
    
    Rmatrix = [squeeze(cell2mat(R_8wk)); squeeze(cell2mat(R_Media)); squeeze(cell2mat(R_Cells))];
    
    h_corrbars = figure(7);
    h_ax = bar3(Rmatrix);
    zlim([0 1]);
    set(gca,'YTickLabel',subjectlist);
    set(gca,'XTickLabel',requested_members.('slice'));
    set(gca,'FontSize',6);
    zlabel('R');
    title(['Correlations between ' parname_x ' vs. ' parname_y]);
    
    
end