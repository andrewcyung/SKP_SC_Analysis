function msg = setOverlay(toggle,h_overlay,transparency)

if toggle == 1
    set(h_overlay,'AlphaData',transparency);
else
    set(h_overlay,'AlphaData',0);
end
msg = 0;