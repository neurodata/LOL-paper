function out = isinZ(a)
% 
% out = isinZ(a);
% 
% This function verifies that a is an integer-valued array;
% --------------------------------------------------------

if isreal(a),
    eps = 2^(-22);
    N = length(a);
    count = 0;
    for k=1:N,
        aux = abs(rem(a(k),2));
        if (aux<eps) || (abs(aux-1)<eps),
            count = count + 1;
        end
    end
    if count == N,
        out = true;
    else
        out = false;
    end
else
    error('Invalid argument for isinZ function');
end

     