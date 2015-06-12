% Change the filenames if you've saved the files under different names
% On some platforms, the files might be saved as 
% train-images.idx3-ubyte / train-labels.idx1-ubyte
clearvars, clc
datadir='../../../Data/Raw/MNIST/';
images = loadMNISTImages([datadir, 'train-images.idx3-ubyte']);
labels = loadMNISTLabels([datadir, 'train-labels.idx1-ubyte']);
 %%

images3 = images(:,labels==3);
images8 = images(:,labels==8);
images38=[images3 images8];

[u,d,v]=svd(images38);

%% plot results

figure(1), clf, plot(diag(d),'.-')


i=0; figure(2), clf
i=i+1; imagesc(reshape(u(:,i),[28 28])), colormap('gray')