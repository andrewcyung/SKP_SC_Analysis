function displayUpstreamData(upstreamData,row,col,h_fig_upstream,parname)

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
            dispFcn = [] ;
            eval(['dispFcn = @' upstreamData.dispFcnName ';']);
            dispFcn(h_fig_upstream,row,col,upstreamData.im2src_tfm,dispQuantity,upstreamData.options);
        end
    end
end

end