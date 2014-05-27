function displayUpstreamData(upstreamDataArray,row,col,h_fig_upstream,parname)

upstreamData = upstreamDataArray{1};
set(h_fig_upstream,'Name',[parname ' upstreamData: ' upstreamData.name]);
upstreamDataFilename = [upstreamData.dirpath upstreamData.srcfile upstreamData.filetype];
if exist(upstreamDataFilename,'file')
    if strcmp(upstreamData.filetype,'.mat')
        if isKey(upstreamData.options,'varname')
            varname = upstreamData.options('varname');
            try
                loadedVar = load(upstreamDataFilename,varname);
            end
            dispQuantity = loadedVar.(varname);
        end
    elseif strcmp(upstreamData.filetype,'.png') || strcmp(upstreamData.filetype,'.tif')
        dispQuantity = imread(upstreamDataFilename);
    end
    dispFcn = [];
    eval(['dispFcn = @' upstreamData.dispFcnName ';']);
    dispFcn(h_fig_upstream,row,col,upstreamData.im2src_tfm,dispQuantity,upstreamData.options);
end
end