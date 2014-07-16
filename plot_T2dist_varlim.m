function plot_T2dist_varlim(h_targetfig,selectedRow,selectedCol,posnTfm,data,options,rootpath)

T2dist = data.imT2dist;
integlim = data.imIntegLim_CVvarlim;
T2Times = options('T2Times');
if isnan(posnTfm)
    currT2Dist = squeeze(T2dist(selectedRow,selectedCol,:));
    curr_integlim = integlim(selectedRow,selectedCol);
    figure(h_targetfig);
    hold off
    semilogx(T2Times,currT2Dist);
    dis = currT2Dist;
%     MWF = sum(dis(find(T2Times>=integlim(1) & T2Times<=integlim(2))))/sum(dis);
%     disp(['MWF = ' num2str(MWF)]);
%                     
    xlim([0 300]);
    hold on
    maxAmp = max(currT2Dist);
    for i=1:length(curr_integlim)
        line([curr_integlim(i) curr_integlim(i)],[0 maxAmp],'Color','r');
    end
    hold off
end