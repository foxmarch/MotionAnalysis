function [energies]=energiesV1(winds, Fs, a,b) % a,b - band boundaries
freqs={};
for i=1:length(winds)
     freqs{i}=Fs*linspace(0,1,length(winds{i})); 
     FF=freqs{i}; 
end 

for i=1:length(winds)
    cur_wind=winds{i};
    wind_energy=sum(abs(cur_wind).^2);
    [a_closest, a_idx]=min(abs(freqs{i}-a));
    [b_closest, b_idx]=min(abs(freqs{i}-b));
    band_energy=sum(abs(cur_wind(a_idx:b_idx)).^2);
    energies(i)=band_energy*2/wind_energy*100; 
end

end