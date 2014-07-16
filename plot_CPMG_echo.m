function plot_CPMG_echo(h_targetfig,selectedRow,selectedCol,posnTfm,CPMG_echo,options,rootpath)
TE = options('TE');
if isnan(posnTfm)
    curr_echotrain = squeeze(CPMG_echo(selectedRow,selectedCol,:));
    n_echo = length(curr_echotrain);
    TEtimes = TE*(1:n_echo);
    figure(h_targetfig);
    hold off
    plot(TEtimes,curr_echotrain,'+');
end