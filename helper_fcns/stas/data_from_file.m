function [data] = data_from_file(file_name);
%% Data extraction from file
fid = fopen(file_name);
title = fscanf(fid, '%s', 194);
data = fscanf(fid, '%f');
data = reshape(data, 194, []);
data = data';
end



