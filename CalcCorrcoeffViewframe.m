

function [R,R_upperCI,R_lowerCI,pval] = CalcCorrcoeffViewframe(viewframe_x,viewframe_y,corrmode)

vf_dim = size(viewframe_x);
n_dim = length(vf_dim);
R = cell(vf_dim);
R_CI = cell(vf_dim);
pval = cell(vf_dim);

if n_dim == 2
    vf_dim = [vf_dim 1];
elseif n_dim == 1
    vf_dim = [vf_dim 1 1];
end

if ~strcmp(corrmode,'Pearson') && ~strcmp(corrmode,'Spearman')
   disp('correlation mode must be Pearson or Spearman');
   return;
end

for i=1:vf_dim(1)
    for j=1:vf_dim(2)
        for k=1:vf_dim(3)
            if n_dim == 3
                xcontents = viewframe_x{i}{j}{k};
                ycontents = viewframe_y{i}{j}{k};
            elseif n_dim == 2
                xcontents = viewframe_x{i}{j};
                ycontents = viewframe_y{i}{j};
            elseif n_dim == 1
                xcontents = viewframe_x{i};
                ycontents = viewframe_y{i};
            end
            
            if iscell(xcontents) && length(xcontents)==1
                xcontents = xcontents{1};
                ycontents = ycontents{1};
            end
            
            xcontents_all = [];
            ycontents_all = [];
            if isstruct(xcontents)
                xcontents_all = [xcontents_all; xcontents.data];
                ycontents_all = [ycontents_all; ycontents.data];
            else
                n_vec = length(xcontents);
                for i_vec=1:n_vec
                    xcontents_all = [xcontents_all; xcontents{i_vec}.data];
                    ycontents_all = [ycontents_all; ycontents{i_vec}.data];
                end
            end
%             strip entries that have NaN in either data vector
            NaN_indices = isnan(xcontents_all) | isnan(ycontents_all);
            xcontents_all = xcontents_all(~NaN_indices);
            ycontents_all = ycontents_all(~NaN_indices);
            
            if strcmp(corrmode,'Pearson')
                [r,p,r_lo,r_hi] = corrcoef(xcontents_all,ycontents_all);
            elseif strcmp(corrmode,'Spearman')
                [x_sorted, index_x] = sort(xcontents_all);
                [y_sorted, index_y] = sort(ycontents_all);
                [r,p,r_lo,r_hi] = corrcoef(index_x, index_y);
            end
            R{i,j,k} = r(1,2);
            pval{i,j,k} = p(1,2);
            R_upperCI{i,j,k} = r_hi(1,2);
            R_lowerCI{i,j,k} = r_lo(1,2);
        end
    end
end
end