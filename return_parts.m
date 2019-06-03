function [wind]=return_parts(signal, num_of_windows)
len=length(signal);
wind={}; %array with changable length and datatypes
wind_len=floor(len/num_of_windows);
for i=0:num_of_windows-1
 wind{i+1}= signal(i*wind_len+1:(i+1)*wind_len);
 wind{i+1}=fft(wind{i+1}-mean(wind{i+1}));  %fft okna
end

end