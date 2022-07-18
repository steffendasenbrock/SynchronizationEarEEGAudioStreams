function sorted_stream = sort_stream_entries(stream)
% This function sorts the entries of a recorded LSL stream, 
% as ac2xdf tends to store them in a different order sometimes
% 
% Correspondence: steffen.dasenbrock@uol.de
%
% Developed in 9.11.0.1837725 (R2021b) Update 2
%-------------------------------------------------------------------------

    for i=1:3
       % Store time stamps to seconds position
       if(contains(stream{1, i}.info.name,'_ts'))
           sorted_stream{2} = stream{1, i};
       % Store clock correction offset values to third position
       elseif (contains(stream{1, i}.info.name,'_tc'))
           sorted_stream{3} = stream{1, i};
       else
       % Store time series to first position
           sorted_stream{1} = stream{1, i};
       end
     
    end

end