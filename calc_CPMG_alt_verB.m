function [short_peakT2,long_peakT2,T2_cutoff,varMWF] = calc_CPMG_alt_verB(T2dist,T2times)

n_distpoints = length(T2dist);


T2dist = preprocess_hack(T2dist);
T2dist = T2dist/max(T2dist);

figure(19);semilogx(T2times,T2dist);


inflection_found = false;
shortT2peak_missing = false;
% first look for myelin water peak
T2dist_subrange1 = T2dist(T2times>=0 & T2times<30);
% T2dist_sub = T2dist;
if T2dist_subrange1(1) > 0.01 && (T2dist_subrange1(1) > T2dist_subrange1(2))
    pk1 = T2dist_subrange1(1);
    pkindex1 = 1; 
    short_peakT2 = T2times(1);
else
    [pk1,pkindex1] = findpeaks(T2dist_subrange1,'npeaks',1);
    short_peakT2 = T2times(pkindex1);
end

if isempty(pk1)
%     if no peaks were found, it may be that the myelin water peak is a shoulder
%     to the larger IC/EC peak.  Take the first derivative of the curve and
%     choose the point that is closest to zero (the inflection point)
    curve_slope = diff(T2dist_subrange1);
    if min(curve_slope) < 0
        disp(['negative slope detected: findpeaks should have found this']);
        cutoff_index = 2;
        short_peakT2 = T2times(1);
        pkindex1 = 1;
    else
%     if there really is an inflection point, there should be a local
%     minimun to the curve_slope.  If not, probably it's just a flat line

        [minval,minindex] = findpeaks(-curve_slope(2:end),'npeaks',1);
        if ~isempty(minval)
            cutoff_index = minindex+1;
            inflection_found = true;
            pkindex1 = cutoff_index-1+1;
            short_peakT2 = T2times(pkindex1);
            inflection_found = true;
        else %no inflection found
            pkindex1 = 1;
            cutoff_index = pkindex1+1; 
            short_peakT2 = T2times(pkindex1);
            shortT2peak_missing = true;
        end
    end
end

% Now look for 2nd peak, which we will assume is the IC/EC peak
T2dist_subrange2 = T2dist(pkindex1:end);
[pk2,pkindex2] = findpeaks(T2dist_subrange2,'npeaks',1);
pkindex2 = pkindex2+pkindex1-1;
if isempty(pk2)
    long_peakT2 = T2times(end);
    pkindex2 = numel(T2times);
    if ~inflection_found
        if shortT2peak_missing
            cutoff_index = 2;
        else
            cutoff_index = pk1+1;
        end
    end
else
    long_peakT2 = T2times(pkindex2);
    if shortT2peak_missing
        cutoff_index = pkindex1+1;
    else
        if ~inflection_found
            T2dist_invert_subrange2 = -T2dist(pkindex1:pkindex2);
            [minval,minindex] = findpeaks(T2dist_invert_subrange2,'npeaks',1);
            cutoff_index = minindex+pkindex1-1;
        end
    end
end

T2_cutoff = T2times(cutoff_index);
varMWF = sum(T2dist(T2times>=0 & T2times<=T2_cutoff))/sum(T2dist);

line([T2times(pkindex1) T2times(pkindex1)],[0,max(T2dist)],'Color','r');
line([T2times(pkindex2) T2times(pkindex2)],[0,max(T2dist)],'Color','r');
line([T2times(cutoff_index) T2times(cutoff_index)],[0,max(T2dist)],'Color','g');

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
        