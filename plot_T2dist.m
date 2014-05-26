function plot_T2dist(h_targetfig,selectedRow,selectedCol,posnTfm,T2dist,options)

T2Times = options('T2Times');
if isnan(posnTfm)
   currT2Dist = squeeze(T2dist(selectedCol,selectedRow,:));
   figure(h_targetfig);
   semilogx(T2Times,currT2Dist);
end