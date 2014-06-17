% STEP 1:  define the data dimension that you want to denote as the hue,
% shade and marker type.  In terms of scatterplot: 
% view_categories = {<hue class>,<shade class>,<marker type class>}
view_categories = {'slice','subject','segzone'}; 

% STEP 2:  define the specific colours, shades and marker types you want to
% use for displaying of the different data dimensions (disp_attributes).
% Remember to have enough hues/shades/marker types for all the elements in
% the chosen data dimensions.

    % Option 1:  6 hues, 5 shades, 14 marker types
    disp_attributes.hue = [0 1 2 3 4 5]/6;
    disp_attributes.shade = [0.5 0.4 0.3 0.6 0.7]; 
    disp_attributes.marker = ['+','o','*','.','x','s','d','p','h','^','v','>','<','+'];

    % % Option 2:  12 hues, 5 shades, 14 marker types
    % disp_attributes.hue = [0 6 1 7 2 8 3 9 4 10 5 11]/12; 
    % disp_attributes.shade = [0.5 0.4 0.3 0.6 0.7]; 
    % disp_attributes.marker = ['+','o','*','.','x','s','d','p','h','^','v','>','<','+'];

% STEP 3:  define which elements in each data dimension to include.  In
% other words, choose which subjects, slices, sectors, groups you want to
% see (requested_members)

% Note the experiment groups:
%  - 8 week injury baseline:  11,16,18,20
%  - 27 wpi, cell injection:  36,51,54,55,56
%  - 27 wpi, media injection: 39,41,58,61,62

    % % Option 1:  focus on one slice of one subject
    requested_members.('group') = {'8wk','Media','Cells'};
    requested_members.('segzone') = {'Dorsal','Ventral','Lateral'};
    requested_members.('subject') = {'41'};
    % requested_members.('slice') = {'1EdgeCaudal'};
    % requested_members.('slice') = {'2MidCaudal'};
    % requested_members.('slice') = {'3Epicentre'};
    % requested_members.('slice') = {'4MidCranial'};
    requested_members.('slice') = {'5EdgeCranial'};

    % % Option 2:  include the whole study
    % requested_members.('group') = {'Media','Cells','8wk'};
    % requested_members.('subject') = {'11','16','18','20','36','39','41','51','54','55','56','58','61','62'};
    % requested_members.('slice') = {'1EdgeCaudal','2MidCaudal','3Epicentre','4MidCranial','5EdgeCranial'};
    % requested_members.('segzone') = {'Dorsal','Ventral','Lateral'};

% STEP 4: define the parameter maps you want to compare
    parx_pairs = {{'MWF','EC_AreaFraction'}};
    
    % parx_pairs = {{'MWF','MBP_IntegODThresh'}};
    % parx_pairs = {{'MWF','MBP_AreaFraction'}};
    % parx_pairs = {{'MWF','EC_IntegODThresh'}};
    % parx_pairs = {{'MWF','EC_AreaFraction'}};
    % parx_pairs = {{'Dlong','MBP_IntegODThresh'}};
    % parx_pairs = {{'Dlong','MBP_AreaFraction'}};
    % parx_pairs = {{'Dlong','EC_IntegODThresh'}};
    % parx_pairs = {{'Dlong','EC_AreaFraction'}};
    % parx_pairs = {{'Dlong','Axon_IntegODThresh'}};
    % parx_pairs = {{'Dlong','Axon_AreaFraction'}};
    % parx_pairs = {{'Dtrans','MBP_IntegODThresh'}};
    % parx_pairs = {{'Dtrans','MBP_AreaFraction'}};
    % parx_pairs = {{'Dtrans','EC_IntegODThresh'}};
    % parx_pairs = {{'Dtrans','EC_AreaFraction'}};
    % parx_pairs = {{'Dtrans','Axon_IntegODThresh'}};
    % parx_pairs = {{'Dtrans','Axon_AreaFraction'}};
    % parx_pairs = {{'FA','MBP_IntegODThresh'}};
    % parx_pairs = {{'FA','MBP_AreaFraction'}};
    % parx_pairs = {{'FA','EC_IntegODThresh'}};
    % parx_pairs = {{'FA','EC_AreaFraction'}};
    % parx_pairs = {{'FA','Axon_IntegODThresh'}};
    % parx_pairs = {{'FA','Axon_AreaFraction'}};

SKP_GenerateInfostruct;
sf = make_SKP_storageframe('MRIPixelGrid','Sectors','F:\SKP-SC analysis\','06-Transformation\02-ConsolidatedData\',IDtag);
storage_layout = {'group','subject','slice','segzone'};
rootpath = 'F:\SKP-SC analysis\';
origdir = pwd;
cd(rootpath);
save('SKP-sf.mat','sf');
% load SKP_sf.mat
cd(origdir);

n_pairs = length(parx_pairs);

for i=1:n_pairs
    parname_x = parx_pairs{i}{1};
    parname_y = parx_pairs{i}{2};
    vf_x = MakeViewframe(parname_x,view_categories,sf,storage_layout,requested_members);
    vf_y = MakeViewframe(parname_y,view_categories,sf,storage_layout,requested_members);
    h_scatter=figure(1);
    h_thumbx=figure(2);
    h_thumby=figure(3);
    h_upstream_x=figure(5);
    h_upstream_y=figure(6);
   
    axisextents = [];
    h_series = CreateViewframeScatterplot(vf_x,vf_y,parname_x,parname_y,disp_attributes,view_categories,h_scatter,h_thumbx,h_thumby,h_upstream_x,h_upstream_y,requested_members,view_categories,'points','Spearman','auto',[]);
    h_legend = CreateViewframeLegend(h_series,requested_members,view_categories,'separateFigure','EastOutside',8);
    figure(h_scatter);
    ti = get(gca,'TightInset');
    set(gca,'Position',[ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);
end