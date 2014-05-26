origdir = pwd;
cd('F:\SKP-SC analysis\');

%caudal to cranial
matchkey{1}.id = '11';
matchkey{1}.histoextent = [10 15; 15 20; 20 25; 25 30; 30 35];
matchkey{1}.excludelist{1} = [32 33 34 35];
matchkey{1}.excludelist{2} = [32 33 34 35];
matchkey{1}.excludelist{3} = [20 32 33 34 35];

matchkey{2}.id = '16';
matchkey{2}.histoextent = [11 15; 17 21; 24 28; 31 34; 37 41];
matchkey{2}.excludelist{1} = [39 40 41];
matchkey{2}.excludelist{2} = [41];
matchkey{2}.excludelist{3} = [25 39 40 41];

matchkey{3}.id = '18';
matchkey{3}.histoextent = [16 21; 21 26; 26 31; 31 36; 36 41];
matchkey{3}.excludelist{1} = [];
matchkey{3}.excludelist{2} = [];
matchkey{3}.excludelist{3} = [18];

matchkey{4}.id = '20';
matchkey{4}.histoextent = [15 20; 20 25; 25 30; 30 35; 35 40];
matchkey{4}.excludelist{1} = [15 16 22 30 33];
matchkey{4}.excludelist{2} = [15];
matchkey{4}.excludelist{3} = [15 19];

matchkey{5}.id = '36';
matchkey{5}.histoextent = [11 16; 17 23; 24 29; 30 36; 37 42];
matchkey{5}.excludelist{1} = [21 39 40 41 42];
matchkey{5}.excludelist{2} = [39 40 41 42];
matchkey{5}.excludelist{3} = [11 12 13 14 39 40 41 42];

matchkey{6}.id = '39';
matchkey{6}.histoextent = [4 9; 12 17; 20 25; 28 33; 36 41];
matchkey{6}.excludelist{1} = [4 32 41];
matchkey{6}.excludelist{2} = [];
matchkey{6}.excludelist{3} = [];

matchkey{7}.id = '41';
matchkey{7}.histoextent = [14 19; 20 25; 26 31; 32 37; 38 43];
matchkey{7}.excludelist{1} = [19 20 21 28 30 31];
matchkey{7}.excludelist{2} = [20 28];
matchkey{7}.excludelist{3} = [19 20 31];

matchkey{8}.id = '51';
matchkey{8}.histoextent = [13 18; 19 24; 25 30; 31 36; 37 42];
matchkey{8}.excludelist{1} = [];
matchkey{8}.excludelist{2} = [];
matchkey{8}.excludelist{3} = [];

matchkey{9}.id = '54';
matchkey{9}.histoextent = [8 13; 15 21; 22 27; 28 34; 35 40];
matchkey{9}.excludelist{1} = [8 9];
matchkey{9}.excludelist{2} = [8 9];
matchkey{9}.excludelist{3} = [8 9 22];

matchkey{10}.id = '55';
matchkey{10}.histoextent = [13 18; 20 26; 28 33; 35 41; 43 48];
matchkey{10}.excludelist{1} = [20 35 40];
matchkey{10}.excludelist{2} = [20 35];
matchkey{10}.excludelist{3} = [18 20 35];

matchkey{11}.id = '56';
matchkey{11}.histoextent = [13 18; 20 26; 28 33; 35 41; 43 48];
matchkey{11}.excludelist{1} = [20 35];
matchkey{11}.excludelist{2} = [20 35];
matchkey{11}.excludelist{3} = [20 35];

matchkey{12}.id = '58';
matchkey{12}.histoextent = [12 17; 19 24; 26 31; 33 38; 40 45];
matchkey{12}.excludelist{1} = [17 26 33 40];
matchkey{12}.excludelist{2} = [21 26 33 40];
matchkey{12}.excludelist{3} = [14 16 21 26 33 38 40];

matchkey{13}.id = '61';
matchkey{13}.histoextent = [17 22; 22 27; 27 32; 32 37; 37 42];
matchkey{13}.excludelist{1} = [];
matchkey{13}.excludelist{2} = [];
matchkey{13}.excludelist{3} = [38 39 40 41 42];

matchkey{14}.id = '62';
matchkey{14}.histoextent = [-1 4; 6 12; 14 19; 21 27; 29 34];
matchkey{14}.excludelist{1} = [6 14 21 29];
matchkey{14}.excludelist{2} = [6 14 21 29];
matchkey{14}.excludelist{3} = [-1 0 1 2 3 4 6 7 8 9 14 21 24 27 29];


save SKP_matchkey_ay_original matchkey
cd(origdir);