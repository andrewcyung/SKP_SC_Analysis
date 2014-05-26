% sf = make_SKP_storageframe('MRIPixelGrid','Sectors','F:\SKP-SC analysis\','06-Transformation\02-ConsolidatedData\',IDtag);
rootpath = 'F:\SKP-SC analysis\';
origdir = pwd;
cd(rootpath);
% load SKP_sf.mat
cd(origdir);

view_categories = {'slice','subject','group'};

storage_layout = {'group','subject','slice','segzone'};

disp_attributes.hue = [0 6 1 7 2 8 3 9 4 10 5 11]/12;
disp_attributes.shade = [0.5 0.4 0.3 0.6 0.7];
disp_attributes.marker = ['+','o','*','.','x','s','d','p','h','^','v','>','<','+'];

all_members.('group') = {'Media','Cells','8wk'};
all_members.('subject') = {'18','51','58'};
all_members.('slice') = {'1EdgeCaudal','2MidCaudal','3Epicentre','4MidCranial','5EdgeCranial'};
all_members.('segzone') = {'Dorsal','Ventral','Lateral'};
 
requested_members = all_members;
parx_pairs = {{'MWF','EC_AreaFraction'}, ... 
              {'MWF','MBP_AreaFraction'}, ...
              {'Dlong','Axon_AreaFraction'}, ...
              {'Dtrans','EC_AreaFraction'}, ...
              {'Dtrans','MBP_AreaFraction'}};

axisextents = {[0 1 0 1],[0 1 0 1],[0 3e-3 0 1],[0 3e-3 0 1],[0 3e-3 0 1]};           
          
n_subject = length(all_members.('subject'));
n_slice = length(all_members.('slice'));
n_segzone = length(all_members.('segzone'));

rho_matrix = zeros(n_subject,n_segzone+1);
pval_matrix = zeros(n_subject,n_segzone+1);


for i=1:n_subject
    requested_members.('subject') = {all_members.('subject'){i}};
        
        n_pairs = length(parx_pairs);
        corrcoeff_all = cell(1,n_pairs);
        for k=1:n_pairs
            parname_x = parx_pairs{k}{1};
            parname_y = parx_pairs{k}{2};
            vf_x = make_viewframe(parname_x,view_categories,sf,storage_layout,requested_members);
            vf_y = make_viewframe(parname_y,view_categories,sf,storage_layout,requested_members);
            h=figure(1);
            [h_series corrcoeff corrcoeff_all{k}]= create_scatterplot_viewframe(vf_x,vf_y,parname_x,parname_y,disp_attributes,h,requested_members,view_categories,'mean','Pearson','auto',axisextents{k});
            for p=1:n_segzone
                if ~isempty(corrcoeff{p})
                    rho_matrix(i,p) = corrcoeff{p}.rho;
                    pval_matrix(i,p) = corrcoeff{p}.pval;
                else
                    rho_matrix(i,j,p) = 0;
                    pval_matrix(i,j,p) = 1;
                end
            end
            rho_matrix(i,p+1) = corrcoeff_all{k}.rho;
            pval_matrix(i,p+1) = corrcoeff_all{k}.pval;
            h_legend = legend_viewframe(h_series,requested_members,view_categories,'standard','SouthOutside');
            %             disp([parname_x char(9) parname_y char(9) num2str(corrcoeff_all{i}.rho) char(9) num2str(corrcoeff_all{i}.pval)]);
        pause;
        end
     
    
    %     pause;
   
end
% 
% linestyle{1}='r+-';
% linestyle{2}='g+-';
% linestyle{3}='b+-';
% linestyle{4}='k+-';
% 
% 
% for i=1:n_subject
%     clf;
%     for j=1:n_segzone+1
%         hold on;
%         plot(1:5,squeeze(rho_matrix(i,:,j)),linestyle{j}); 
%         axis([1 5 -1 1])
%         hold off;
%     end
%     legend('Dorsal','Ventral','Lateral','WholeSection');
%     xlabel('Position'); ylabel('Pearson''s R'); title(all_members.('subject'){i});
%     
%     pause;
% end
