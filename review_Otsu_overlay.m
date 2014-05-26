% impath = 'F:\SKP-SC analysis\18\03-Segmentation\02_Histology\02_Set 2 - MBP_Axons_10x\15-MBP thresholded Otsu\15.tif';

function review_Otsu_overlay(impath)

[srcdir,srcfile,srcext] = fileparts(impath);
ovfile_list = rdir([srcdir filesep srcfile '.ov*']);
n_ov = length(ovfile_list);
for i=1:n_ov
    ovfilename{i} = ovfile_list(i).name;
end

colors = {[1 0 0],[0 1 0],[0 0 1],[1 1 0],[1 0 1],[0 1 1]};
curr_color = colors{1};

toggle = 1;
im = imread(impath);
dim = size(im);
ov = zeros(dim(1),dim(2),3);
mask = imread([ovfilename{1}]);
ov(:,:,1) = curr_color(1) & mask;
ov(:,:,2) = curr_color(2) & mask;
ov(:,:,3) = curr_color(3) & mask;

xl = xlim; yl = ylim;

hfig=figure
hi1=imshow(im); axis image; ha1=gca;
if xl(1) ~= 0
    xlim(xl); ylim(yl);
end
hold on;
hi2_overlay = imshow(ov);
set(hi2_overlay,'AlphaData',0.5);
hold off;
title(ovfilename{1});
zoom on;

hManager = uigetmodemanager(hfig);
set(hManager.WindowListenerHandles,'Enable','off');

set(hfig,'KeyPressFcn',@change_overlay);

figtitle = ',=overlay--     .=overlay++     /=toggle overlay';
ov_index = 1;
set(hfig,'name',figtitle);

    function change_overlay(src,event)
        switch event.Character
            case {','}
                if (ov_index==1)
                    disp('reached 1st overlay');
                else
                    ov_index=ov_index-1;
                    ov = zeros(dim(1),dim(2),3);
                    mask = imread([ovfilename{ov_index}]);
                    curr_color = colors{ov_index};
                    ov(:,:,1) = curr_color(1) & mask;
                    ov(:,:,2) = curr_color(2) & mask;
                    ov(:,:,3) = curr_color(3) & mask;
                    set(hi2_overlay,'CData',ov);
                    title(ovfilename{ov_index});
                end
            case {'.'}
                if (ov_index==n_ov)
                    disp('reached end overlay');
                else
                    ov_index=ov_index+1;
                    ov = zeros(dim(1),dim(2),3);
                    mask = imread([ovfilename{ov_index}]);
                    curr_color = colors{ov_index};
                    ov(:,:,1) = curr_color(1) & mask;
                    ov(:,:,2) = curr_color(2) & mask;
                    ov(:,:,3) = curr_color(3) & mask;
                    set(hi2_overlay,'CData',ov);
                    title(ovfilename{ov_index});
                end
            case {'/'}
                toggle = -1*toggle; setOverlay(toggle,hi2_overlay,0.5);
        end
    end
end