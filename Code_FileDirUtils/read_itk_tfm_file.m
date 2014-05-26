function tfm_matrix = read_itk_tfm_file(filename)

    text = fileread(filename);
    pattern = 'Parameters: (.*)\nFixed';
    line = regexp(text,pattern,'tokens');
    numbers = regexp(line{1},'\s','split');
    numbers = numbers{1};
    tfm_matrix = zeros(3,2);
    tfm_matrix(1,:) = [str2num(numbers{1}) str2num(numbers{2})];
    tfm_matrix(2,:) = [str2num(numbers{4}) str2num(numbers{5})];
    tfm_matrix(3,:) = [str2num(numbers{10}) str2num(numbers{11})];
    
