function [Waic,daic,dbic] = aicbicLAD(Yaux,X,morph,parameters)
%
% la funcion se llama también desde ldr:
%
% [Waic,daic,dbic] = ldr(Y,X,'LAD','disc','aicbic')
%
%

%%%% TODO ESTE BLOQUE ES IGUAL QUE EN AIC O BIC %%%%%%
%----checking type of response and slicing if needed.......................
if strcmpi(morph,'disc'),
    Y = mapdata(Yaux);
    parameters.nslices = max(Y);
else % morph = 'cont'
    if parameters.nslices==0,
        warning('MATLAB:slices','for continuous responses, a number of slices should be given. Five slices will be used');
        parameters.nslices = 5;
    end
    Y = slices(Yaux,parameters.nslices);
end


% ---- main process............................................................
h = parameters.nslices;
[n,p] = size(X);
data_parameters = setdatapars(Y,X,h);
sigmag = data_parameters.sigmag; 


%--- get handle to objective function, derivative, dof

%---indica cuál es la funcion a optimizar y los Fparameters, que acá se
%llaman data_parameters para enfatizar que se forman con los datos...
Fhandle = F(@F4lad,data_parameters);
%---igual que recien pero con la derivada de la F...
dFhandle = dF(@dF4lad,data_parameters);
%---grados de libertad del modelo como función de d0
dof = @(do) (p+(h-1)*do+do*(p-do)+(h-1)*do*(do+1)/2 + p*(p+1)/2);
%--- valor de la F para do=0..................
f0 = n*p*(1+log(2*pi))/2 + n*logdet(sigmag)/2;

% NOTA: si en lugar de LAD aplicamos otro modelo, sólo habría que cambiar
% aqui arriba...


%---- llamamos al loop que encuentra el subespacio para cada una de las
%dimensiones desde d0=0 hasta d0=p. Ese loop guarda los valores de la F en
%función de la dimension, que es independiente de que estemos buscando AIC
%o BIC....
ic_choose = icloop(Fhandle,dFhandle,f0,dof,Y,X,data_parameters,parameters);

%%%%%%%%%%%%% HASTA ACA ES TODO IGUAL %%%%%%%%%%%%%%%%%%

% ahora decimos que con las f que guardó en el paso anterior, le aplique el
% criterio AIC para encontrar la mejor d:
daic = ic_choose('aic');

% hacemos lo mismo para encontrar la mejor d según BIC, sin repetir el
% bucle de cómputos:
dbic = ic_choose('bic');

% la idea aca es que la llamada a icloop realiza el loop para encontrar los
% subespacios y guardar las f correspondientes a cada dimension. El
% resultado de esa llamada, no es un número ni una matriz, sino UNA FUNCION
% que llamamos localmente ic_choose en este caso que para evaluarla le
% tenemos que decir un método, si queremos 'aic' o 'bic'. Recién ahí
% obtenemos un d.

%...aplicvamos LAD con la dimension encontrada para AIC
[Waic] = lad(Y,X,daic,morph,parameters);


% ACA NOTAMOS QUE DEVOLVEMOS SOLAMENTE Waic, daic y dbic, es decir que los
% resultados no son los mismo que para el resto de las funciones. esto se
% puede arreglar, pero hecho rápido sería así para que puedas obtener los
% dos "d" que son los que realmente interesan en todo esto.
