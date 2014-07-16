% Script to look through MRI and histology correlations for all MRI slices
% and save thumbnails of all the results
clear parMapView_name_list
clear h_parMapView_list
SKP_GenerateInfostruct;

% sf = make_SKP_storageframe('MRIPixelGrid','Sectors',rootpath,'06-Transformation\02-ConsolidatedData\',IDtag);
storage_layout = {'group','subject','slice','segzone'};
origdir = pwd;
cd(rootpath);
% save('SKP-sf.mat','sf');
if ~exist('sf','var')
    load SKP-sf-original.mat
end
cd(origdir);

% Phase 1:  Examine all individual MRI slices (one thumbnail mosaic per
% subject; one slice per row and one scatterplot/parmap per column

disp_attributes.hue = [0 1 2 3 4 5]/6;
disp_attributes.shade = [0.5 0.4 0.3 0.6 0.7];
disp_attributes.marker = ['+','o','*','.','x','s','d','p','h','^','v','>','<','+'];

slice_names = {'1EdgeCaudal','2MidCaudal','3Epicentre','4MidCranial','5EdgeCranial'}; n_slice = length(slice_names);
subject_names = {'11','16','18','20','36','39','41','51','54','55','56','58','61','62'}; n_subject = length(subject_names);
sector_names = {'Dorsal','Ventral','Lateral'};
parx_pairs = {{'MWF','MBP_IntegODThresh'},{'MWF','MBP_AreaFraction'},{'MWF','EC_IntegODThresh'},{'MWF','EC_AreaFraction'},...
    {'Dlong','Axon_IntegODThresh'},{'Dlong','Axon_AreaFraction'},...
    {'Dtrans','MBP_IntegODThresh'},{'Dtrans','MBP_AreaFraction'},{'Dtrans','EC_IntegODThresh'},{'Dtrans','EC_AreaFraction'}};
n_pair = length(parx_pairs);

dest_path = [rootpath 'Group Results\'];



for i_subject = 14

    disp(subject_names{i_subject})
%     for i_pair = 1:n_pair
    for i_pair = 4
        
        % one slice at a time
        requested_members.('subject') = {subject_names{i_subject}};
        requested_members.('group') = {'8wk','Media','Cells'};
        requested_members.('segzone') = {'Dorsal','Ventral','Lateral'};
        view_categories = {'slice','subject',''};
        
        h_scatter_list{1} = figure(1);
        scatter_parxname_list{1} = parx_pairs{i_pair};
        h_parMapView_list{1} = figure(2);
        h_parMapView_list{2} = figure(3);
        parMapView_name_list{1} = parx_pairs{i_pair}{1};
        parMapView_name_list{2} = parx_pairs{i_pair}{2};
        h_upstreamView_list = [];
        h_scatterlegend_list = [];

        for i_slice = 1:5
%             status{i_subject}.isReg.AxonSum2MRI
            requested_members.('slice') = {slice_names{i_slice}};
            StartPointViewCoordinator(sf,storage_layout,view_categories,requested_members,disp_attributes,h_scatter_list,h_scatterlegend_list,scatter_parxname_list,h_parMapView_list,parMapView_name_list,h_upstreamView_list,rootpath)
            saveas(h_scatter_list{1},'slice_scatterplot.tif');
            saveas(h_parMapView_list{1},'slice_parMap1.tif');
            saveas(h_parMapView_list{2},'slice_parMap2.tif');
            file_list = {'slice_scatterplot.tif','slice_parMap1.tif','slice_parMap2.tif'};
            figure(10); montage(file_list,'Size',[1 3]); tightfig;
            filename = ['slice_montage' num2str(i_slice) '.tif'];
            print('-dtiff','-r600',filename) 
            slice_filename{i_slice} = filename;
        end
        figure(10); montage(slice_filename,'Size',[5 1]);
        tightfig;
        slice_column_filename{i_pair} = [dest_path 'CorrSummary_PerSlice' subject_names{i_subject} parx_pairs{i_pair}{1} 'vs' parx_pairs{i_pair}{2} '.tif'];
        print('-dtiff','-r1200',slice_column_filename{i_pair});
        
        % all slices grouped together, individual sector
        view_categories = {'segzone','subject',''};
        h_scatter_list{1} = figure(1);
        h_parMapView_list = [];
        parMapView_name_list =[];
        h_upstreamView_list = [];
            
        StartPointViewCoordinator(sf,storage_layout,view_categories,requested_members,disp_attributes,h_scatter_list,h_scatterlegend_list,scatter_parxname_list,h_parMapView_list,parMapView_name_list,h_upstreamView_list,rootpath)
        all_scatterplot_filename{i_pair} =  [dest_path 'CorrSummary_AllSlice' subject_names{i_subject} parx_pairs{i_pair}{1} 'vs' parx_pairs{i_pair}{2} '.tif'];
        print('-dtiff','-r600',all_scatterplot_filename{i_pair});
        
    end
    
  
end
    
    
    
