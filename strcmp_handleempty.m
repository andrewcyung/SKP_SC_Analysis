function flag = strcmp_handleempty(s1,s2)
    if isempty(s1) || isempty(s2)
        flag = false;
    else
        flag = strcmp(s1.id,s2);
    end
end