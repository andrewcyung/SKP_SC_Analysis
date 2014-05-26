function [short_peakT2 long_peakT2 varMWF] = calc_CPMG_alt(T2dist,T2times)

n_distpoints = length(T2dist);


T2dist = preprocess_hack(T2dist);
T2dist = T2dist/max(T2dist);
T2dist_sub = T2dist(find(T2times>=0 & T2times<500));
[pks,pkindex] = findpeaks(T2dist_sub,'npeaks',3);
figure(1);semilogx(T2times,T2dist);


if length(pks)==0
    short_peakT2 = NaN;
    long_peakT2 = NaN;
    varMWF = NaN;
else
    if length(pks)==1
        long_peakT2 = T2times(pkindex);
        short_peakT2 = NaN;
        varMWF = 0;
    elseif length(pks)>1       
        short_peakT2 = T2times(pkindex(1));
        long_peakT2 = T2times(pkindex(2));
        T2dist_invert_sub = -T2dist(pkindex(1):pkindex(2));
        [minval,minindex] = findpeaks(T2dist_invert_sub,'npeaks',1);
        cutoff_index = minindex+pkindex(1)-1;
        T2_cutoff = T2times(cutoff_index);
        varMWF = sum(T2dist(find(T2times>=0 & T2times<=T2_cutoff)))/sum(T2dist);
    end

    if varMWF>0.8
        disp('highMWF');
    end
    hold on
    if length(pks)>0
        line([T2times(pkindex(1)) T2times(pkindex(1))],[0,max(T2dist)]);
    end
    if length(pks)>1
        line([T2times(pkindex(2)) T2times(pkindex(2))],[0,max(T2dist)]);
        line([T2times(cutoff_index) T2times(cutoff_index)],[0,max(T2dist)]);
    end
    hold off
end
end

function results = preprocess_hack(src)
    size = length(src);
    results = src;
    for i=2:size
        if src(i) == src(i-1)
%             results(i-1) = src(i-1)
            results(i) = src(i)+1e-4;
        end
    end
end
        