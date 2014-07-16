function displayUpstreamData(upstreamDataArray,row,col,h_fig_upstream,parname,rootpath)

hManager = uigetmodemanager(h_fig_upstream);
set(hManager.WindowListenerHandles,'Enable','off');
set(h_fig_upstream,'KeyPressFcn',@GotoAnotherUpstreamDataset);

n_upstream = length(upstreamDataArray);
i_upstream = 1;

    function GotoAnotherUpstreamDataset(src,event)
        switch event.Character
            case {','}
                if i_upstream == 1
                    i_upstream = n_upstream;
                else
                    i_upstream = i_upstream-1;
                end
            case {'.'}
                if i_upstream == n_upstream
                    i_upstream = 1;
                else
                    i_upstream = i_upstream+1;
                end
        end
        displaySingleUpstreamDataset(upstreamDataArray{i_upstream},row,col,h_fig_upstream,parname,rootpath)
    end

displaySingleUpstreamDataset(upstreamDataArray{1},row,col,h_fig_upstream,parname,rootpath);

end

function displaySingleUpstreamDataset(upstreamDataset,row,col,h_fig_upstream,parname,rootpath)

set(h_fig_upstream,'Name',[parname ' upstreamData: ' upstreamDataset.name]);
upstreamDataFilename = [rootpath upstreamDataset.dirpath upstreamDataset.srcfile upstreamDataset.filetype];
if exist(upstreamDataFilename,'file')
    if strcmp(upstreamDataset.filetype,'.mat')
        if isKey(upstreamDataset.options,'varname')
           dispQuantity = load(upstreamDataFilename); %may be more than one variable
        end
    elseif strcmp(upstreamDataset.filetype,'.png') || strcmp(upstreamDataset.filetype,'.tif')
        dispQuantity = imread(upstreamDataFilename);
    end
    dispFcn = [];
    if ~isempty(upstreamDataset.dispFcnName)
        eval(['dispFcn = @' upstreamDataset.dispFcnName ';']);
        dispFcn(h_fig_upstream,row,col,upstreamDataset.im2src_tfm,dispQuantity,upstreamDataset.options,rootpath);
    end
end

end