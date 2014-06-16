

function [R,R_CI,pval,R_all,R_CI_all,pval_all] = CalcCorrcoeffViewframe(viewframe_x,viewframe_y,corrmode)

vf_dim = size(viewframe_x);
R = cell(vf_dim);
R_CI = cell(vf_dim);
pval = cell(vf_dim);
R_all = cell(vf_dim);
R_CI_all = cell(vf_dim);
pval_a = cell(vf_dim);
if ~strcmp(corrmode,'Pearson') && ~strcmp(corrmode,'Spearman')
   disp('correlation mode must be Pearson or Spearman');
   return;
end

for i=1:vf_dim(1)
    for j=1:vf_dim(2)
        for k=1:vf_dim(3)
            xcontents = viewframe_x{i}{j}{k};
            ycontents = viewframe_y{i}{j}{k};
            
            
            n_vec = length(xcontents);
            for i_vec=1:n_vec
                if strcmp(corrmode,'Pearson')
                    [r,p,r_lo,r_hi] = corrcoef(xcontents{i_vec},ycontents{i_vec});
                elseif strcmp(corrmode,'Spearman')
                    [x_sorted, index_x] = sort(xcontents{i_vec});
                    [y_sorted, index_y] = sort(ycontents{i_vec});
                    [r,p,r_lo,r_hi] = corrcoef(index_x, index_y);
                end
                R{i,j,k} = r(1,2);
                pval{i,j,k} = p(1,2);
                R_CI{i,j,k} = [r_lo(1,2) r_hi(1,2)];
            end
            
            xcontents_all = cell2mat(xcontents);
            ycontents_all = cell2mat(ycontents);
            
            if strcmp(corrmode,'Pearson')
                [r,p,r_lo,r_hi] = corrcoef(xcontents_all,ycontents_all);
            elseif strcmp(corrmode,'Spearman')
                [x_sorted, index_x] = sort(xcontents_all);
                [y_sorted, index_y] = sort(ycontents_all);
                [r,p,r_lo,r_hi] = corrcoef(index_x, index_y);
            end
            R_all{i,j,k} = r(1,2);
            pval_all{i,j,k} = p(1,2);
            R_CI_all{i,j,k} = [r_lo(1,2) r_hi(1,2)];
        end
    end
end
end