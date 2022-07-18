function [rising_edges,maximum_height] = find_epoch_half_maximum(epoch_time_series,time_vector,dy)
% This function find the rising edge, defined as the point, where the 
% signal exceeds half of the maximum value with reference to the average
% epoch value
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------

% calculate epoch means
epoch_means = mean(epoch_time_series,1);
% substracte means from every epoch
zero_mean_epoch = epoch_time_series-epoch_means;
% calculate half maximum of epochs
epoch_half_maxima = max(zero_mean_epoch,[],1)/2;
    
    for i=1:1:size(epoch_time_series,2)
    
        if epoch_means(i) ~= 0
        % find index where value of epoch exceeds half maximum
        idx = find(zero_mean_epoch(:,i)>epoch_half_maxima(i));
        rising_edges(i) = time_vector(idx(1));
        maximum_height(i) = zero_mean_epoch(idx(1));
    
        end
    end

end