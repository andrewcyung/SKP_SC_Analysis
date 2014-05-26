function [x y z] = read_acsv_file(filename)

    text = fileread(filename);
    pattern = 'pointColumns .*\n(.*)\n';
    line = regexp(text,pattern,'tokens');
    line = line{1}{1};
    numbers = regexp(line,'\|','split');
    x = str2num(numbers{2});
    y = str2num(numbers{3});
    z = str2num(numbers{4});

    