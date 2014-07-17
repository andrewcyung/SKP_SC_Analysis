function plot_T2dist(h_targetfig,selectedRow,selectedCol,posnTfm,data,options,rootpath)
integlim = [20];
T2dist_varname = options('varname');
eval(['T2dist = data.' T2dist_varname ';']);
% T2dist = data.imT2dist;
T2Times = options('T2Times');
if isnan(posnTfm)
    currT2Dist = squeeze(T2dist(selectedRow,selectedCol,:));
    figure(h_targetfig);
    hold off
    semilogx(T2Times,currT2Dist);
    dis = currT2Dist;
%     MWF = sum(dis(find(T2Times<=integlim(1))))/sum(dis);
%     disp(['MWF for ' T2dist_varname ' = ' num2str(MWF)]);
%                     
%     xlim([0 300]);
    hold on
    maxAmp = max(currT2Dist);
    for i=1:length(integlim)
        line([integlim(i) integlim(i)],[0 maxAmp],'Color','r');
    end
    hold off
end