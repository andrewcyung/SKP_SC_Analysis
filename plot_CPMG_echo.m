function plot_CPMG_echo(h_targetfig,selectedRow,selectedCol,posnTfm,data,options,rootpath)
TE = options('TE');

CPMG_echo = data.imEcho_CVvarlim;
decay_pred = data.imdecay_pred_CVvarlim;
if isnan(posnTfm)
    curr_echotrain = squeeze(CPMG_echo(selectedRow,selectedCol,:));
    curr_pred = squeeze(decay_pred(selectedRow,selectedCol,:));
    n_echo = length(curr_echotrain);
    TEtimes = TE*(1:n_echo);
    figure(h_targetfig);
    hold off
    plot(TEtimes,curr_echotrain,'+',TEtimes,curr_pred,'r-');
end