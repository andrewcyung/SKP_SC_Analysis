origdir = pwd;
cd('F:\SKP-SC analysis\');

%caudal to cranial
matchkey{1}.id = '11';
matchkey{1}.histoextent = [5 10; 10 15; 15 20; 21 26; 26 31];

matchkey{2}.id = '16';
matchkey{2}.histoextent = [9 14; 15 20; 21 26; 27 32; 33 38];

matchkey{3}.id = '18';
matchkey{3}.histoextent = [15 20; 21 26; 27 32; 32 37; 38 43];

matchkey{4}.id = '20';
matchkey{4}.histoextent = [16 21; 21 26; 26 31; 30 35; 35 40];

matchkey{5}.id = '36';
matchkey{5}.histoextent = [9 14; 15 20; 21 26; 27 32; 33 38];

matchkey{6}.id = '39';
matchkey{6}.histoextent = [13 18; 19 24; 25 30; 31 36; 37 42];

matchkey{7}.id = '41';
matchkey{7}.histoextent = [14 19; 20 25; 26 31; 32 37; 38 43];

matchkey{8}.id = '51';
matchkey{8}.histoextent = [5 10; 13 18; 21 26; 29 34; 37 42];

matchkey{9}.id = '54';
matchkey{9}.histoextent = [11 16; 17 22; 23 28; 29 34; 35 40];

matchkey{10}.id = '55';
matchkey{10}.histoextent = [13 18; 21 26; 28 33; 36 41; 43 48];

matchkey{11}.id = '56';
matchkey{11}.histoextent = [13 18; 21 26; 29 34; 37 42; 45 50];

matchkey{12}.id = '58';
matchkey{12}.histoextent = [12 17; 19 24; 27 32; 34 39; 41 46];

matchkey{13}.id = '61';
matchkey{13}.histoextent = [14 19; 21 26; 27 32; 34 39; 40 45];

matchkey{14}.id = '62';
matchkey{14}.histoextent = [-1 4; 7 12; 15 20; 22 27; 30 35];

save SKP_matchkey_leo_original matchkey
cd(origdir);