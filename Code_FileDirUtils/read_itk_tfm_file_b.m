function tfm_matrix = read_itk_tfm_file_b(filename)

    text = fileread(filename);
    pattern = 'Parameters: (.*)\nFixed';
    line = regexp(text,pattern,'tokens');
    numbers = regexp(line{1},'\s','split');
    numbers = numbers{1};
    
    
    tfm_matrix = zeros(4,4);
    tfm_matrix(1,:) = [str2num(numbers{1}) str2num(numbers{2}) str2num(numbers{3}) str2num(numbers{10})];
    tfm_matrix(2,:) = [str2num(numbers{4}) str2num(numbers{5}) str2num(numbers{6}) str2num(numbers{11})];
    tfm_matrix(3,:) = [str2num(numbers{7}) str2num(numbers{8}) str2num(numbers{9}) str2num(numbers{12})];
    tfm_matrix(4,:) = [0 0 0 1];
    
    
