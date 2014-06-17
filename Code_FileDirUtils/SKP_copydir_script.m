rootpath = 'F:\SKP-SC analysis\';
srcbasepath = '04-Preprocessing\07-MRI initial flip alignment\02-Results';
rootpath_dest = 'H:\SKP_Subset\';
destbasepath = '04-Preprocessing\07-MRI initial flip alignment\02-Results';

% section_path{1} = '01-edge_caudal';
% section_path{2} = '02-mid_caudal';
% section_path{3} = '03-epicentre';
% section_path{4} = '04-mid_cranial';
% section_path{5} = '05-edge_cranial';


load([rootpath 'SKP-IDtag'])
origdir = pwd;

for j=1:14
    id = IDtag{j}.id
    cd([rootpath id '\']);
    destpath = [rootpath_dest id '\'];
    [status,message,messageid] = copyfile(srcbasepath,[destpath destbasepath],'f');
    disp(message);
end

cd(origdir);