src_IDmode = 'number';
rootpath = 'F:\SKP-SC analysis\';
src_subpath = '03-Segmentation\02_Histology\01_Set 1 - P0_GFAP_GFP_10x\07-Inclusion Areas for Analysis\01-GFAP_blue\';
dest_subpath = '03-Segmentation\02_Histology\01_Set 1 - P0_GFAP_GFP_10x\08-Exclusion Areas - Rips Folds MissingPortions Floppers\01-GFAP_blue\';


load([rootpath 'SKP-IDtag'])

    
for j=1:14
    dest_id = IDtag{j}.id;

    if strcmp(src_IDmode,'name')
        src_id = IDtag{j}.Nameid;
    elseif strcmp(src_IDmode,'ABC')
        src_id = IDtag{j}.ABCid;
    elseif strcmp(src_IDmode,'number')
        src_id = IDtag{j}.id;
    end
    
    dest_path = [rootpath dest_id '\' dest_subpath]
%     src_path = [src_rootpath  src_id '\' '*.ov*']
    src_path = [rootpath  src_id '\' src_subpath '*.*']

    [success, message, messageid] = copyfile(src_path,dest_path);
    disp(message);
end