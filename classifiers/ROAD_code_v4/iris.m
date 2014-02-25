load fisheriris
se_indices = strcmp('setosa',species);
se = meas(se_indices,:);
ve_indices = strcmp('versicolor',species);
ve = meas(ve_indices,:);

vi_indices = strcmp('virginica',species);
vi = meas(vi_indices,:);

%%%%Step 1:  separate Iris setosa from the cloud containing Iris versicolor and Iris virginica together
display('Step 1:  separate Iris setosa from the cloud containing Iris versicolor and Iris virginica together');
display('100 Random Splits. Inside each split, 50 training and 50 testing.');
x1 = se;
x2 = [ve;vi];

road_errorlist =zeros(100,1);
road_numlist = zeros(100,1);
lda_errorlist = zeros(100,1);
lda_numlist = zeros(100,1);
for randSeed=1:100
    n1 = size(x1,1);
    n2 = size(x2,1);
    rand('state', randSeed);
    randn('state',randSeed);
    i1 = randperm(n1);
    i2 = randperm(n2);
    
    n1tr = round(n1/2);
    n1te = n1-n1tr;
    n2tr = round(n2/2);
    n2te = n2-n2tr;
    ind1_tr = i1(1:n1tr);
    ind1_te = setdiff(1:n1, ind1_tr);
    ind2_tr = i2(1:n2tr);
    ind2_te = setdiff(1:n2, ind2_tr);
    
    x = [x1(ind1_tr,:);x2(ind2_tr,:)];
    xtest = [x1(ind1_te,:);x2(ind2_te,:)];
    
    y = [zeros(n1tr,1);ones(n2tr,1)];
    ytest = [zeros(n1te,1);ones(n2te,1)];
    
    
    [obj] = roadBatch(x, y, xtest, ytest);
    [ldaobj] = lda(x,y,xtest,ytest);
    road_errorlist(randSeed)=obj.testError;
    road_numlist(randSeed)=obj.num;
    lda_errorlist(randSeed)=ldaobj.testError;
    lda_numlist(randSeed)=ldaobj.num;
    
end
display(['median classification error for road: ', num2str(median(road_errorlist))]);
display(['median nonzero number for road: ', num2str(median(road_numlist))]);
display(['median classification error for lda: ', num2str(median(lda_errorlist))]);
display(['median nonzero number for lda: ', num2str(median(lda_numlist))]);


%%%%Step 2: separate Iris versicolor and Iris virginica
display('Step 2: separate Iris versicolor and Iris virginica');

display('100 Random Splits. Inside each split, 50 training and 50 testing.');
x1 = ve;
x2 = vi;

road_errorlist =zeros(100,1);
road_numlist = zeros(100,1);
lda_errorlist = zeros(100,1);
lda_numlist = zeros(100,1);

for randSeed=1:100
    n1 = size(x1,1);
    n2 = size(x2,1);
    rand('state', randSeed);
    randn('state',randSeed);
    i1 = randperm(n1);
    i2 = randperm(n2);
    
    n1tr = round(n1/2);
    n1te = n1-n1tr;
    n2tr = round(n2/2);
    n2te = n2-n2tr;
    ind1_tr = i1(1:n1tr);
    ind1_te = setdiff(1:n1, ind1_tr);
    ind2_tr = i2(1:n2tr);
    ind2_te = setdiff(1:n2, ind2_tr);
    
    x = [x1(ind1_tr,:);x2(ind2_tr,:)];
    xtest = [x1(ind1_te,:);x2(ind2_te,:)];
    
    y = [zeros(n1tr,1);ones(n2tr,1)];
    ytest = [zeros(n1te,1);ones(n2te,1)];
    
    [obj] = roadBatch(x, y, xtest, ytest);
    [ldaobj] = lda(x,y,xtest,ytest);
    road_errorlist(randSeed)=obj.testError;
    road_numlist(randSeed)=obj.num;
    lda_errorlist(randSeed)=ldaobj.testError;
    lda_numlist(randSeed)=ldaobj.num;
    
end
display(['median classification error for road: ', num2str(median(road_errorlist))]);
display(['median nonzero number for road: ', num2str(median(road_numlist))]);
display(['median classification error for lda: ', num2str(median(lda_errorlist))]);
display(['median nonzero number for lda: ', num2str(median(lda_numlist))]);



