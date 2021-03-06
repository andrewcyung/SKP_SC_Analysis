function pts = read_fcsv_file(filename)

    text = fileread(filename);
    pattern = 'columns .*associatedNodeID\r\n(.*)';
    textlist = regexp(text,pattern,'tokens');
    line = regexp(textlist{1}{1},'\n','split');
    n_line = length(line)-1;
    pts = cell(n_line,1);
    for i=1:n_line
       tokens = regexp(line{i},',','split');
       pts{i} = [str2num(tokens{2}) str2num(tokens{3}) str2num(tokens{4})];
    end
    