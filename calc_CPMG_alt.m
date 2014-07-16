function [short_peakT2,long_peakT2,T2_cutoff,varMWF] = calc_CPMG_alt(T2dist,T2times)

n_distpoints = length(T2dist);


T2dist = preprocess_hack(T2dist);
T2dist = T2dist/max(T2dist);
% T2dist_sub = T2dist(T2times>=0 & T2times<500);
T2dist_sub = T2dist;
[pks,pkindex] = findpeaks(T2dist_sub,'npeaks',3,'minpeakdistance',4);
figure(1);semilogx(T2times,T2dist);
if T2dist_sub(1) > 0.2
    pks = [T2times(1); pks];
    pkindex = [1; pkindex];
end

if isempty(pks)
%     if no peaks were found, there may still be a chance that the myelin
%     water peak is right at the edge of the dataset
    if T2dist(1) > 0
        short_peakT2 = T2times(1);
    else
        short_peakT2 = NaN;
    end
    long_peakT2 = NaN;
    varMWF = NaN;
    T2_cutoff = T2times(end);
    cutoff_index = numel(T2times);
else
    if length(pks)==1
        long_peakT2 = T2times(pkindex);
        short_peakT2 = NaN;
        varMWF = 0;
        T2_cutoff = T2times(1);
        cutoff_index = 1;
    elseif length(pks)>1       
        short_peakT2 = T2times(pkindex(1));
        long_peakT2 = T2times(pkindex(2));
        T2dist_invert_sub = -T2dist(pkindex(1):end);
        
%         T2dist_invert_sub = -T2dist(pkindex(1):pkindex(2));
        [minval,minindex] = findpeaks(T2dist_invert_sub,'npeaks',1);
          cutoff_index = minindex+pkindex(1)-1;
        T2_cutoff = T2times(cutoff_index);
        varMWF = sum(T2dist(T2times>=0 & T2times<=T2_cutoff))/sum(T2dist);
    end


    hold on
    if length(pks)>0
        line([T2times(pkindex(1)) T2times(pkindex(1))],[0,max(T2dist)],'Color','r');
    end
    if length(pks)>1
        line([T2times(pkindex(2)) T2times(pkindex(2))],[0,max(T2dist)],'Color','r');
    end
    line([T2times(cutoff_index) T2times(cutoff_index)],[0,max(T2dist)],'Color','g');
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
        