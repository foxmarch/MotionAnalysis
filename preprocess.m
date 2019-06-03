    function [T]=preprocess(file_n)
    comma2point_overwrite(file_n);
    opts=detectImportOptions(file_n, 'Delimiter',';'); 
    T = readtable(file_n, opts); 
    
    %obtaining substantial part of signal
    num_of_points=size(T);
    num_of_points=num_of_points(1);
    a = round(num_of_points * 0.2);
    b = round(num_of_points * 0.85);
    T=T{a:b,1:end-1};

    end