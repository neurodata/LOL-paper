% MNIST figure
clearvars, clc,
fpath = mfilename('fullpath');
findex=strfind(fpath,'/');
rootDir=fpath(1:findex(end-1));
p = genpath(rootDir);
gits=strfind(p,'.git');
colons=strfind(p,':');
for i=0:length(gits)-1
    endGit=find(colons>gits(end-i),1);
    p(colons(endGit-1):colons(endGit)-1)=[];
end
addpath(p);

newsim=0;
if newsim==1
    [task,T,S,P,Pro,Z]= run_MNIST(rootDir);
else
    load([rootDir, '../Data/Results/mnist'])
end


%% make figure

h(6)=figure(6); clf, clear bottom
gray=0.75*[1 1 1];
colormap('bone')
Ncols=4;

width=0.22;
height=width;
leftside=0.1;
space=0.01;
hspace=0.05;
bottom(3)=0.01;
bottom(2)=bottom(3)+height+hspace;
bottom(1)=bottom(3)+2*(height+hspace); %1-(height+space);
right=leftside+3*(width+space)+7*space;
left2=leftside+width+space+0.08;         % left for 2nd column
left3=leftside+2*(width+space)+0.20;% left for 3rd column

lenName=length(task.name);
label_keepers=[];
for j=7:lenName-1
    label_keepers=[label_keepers, str2num(task.name(j))];
end
plot3d=false;

%% plot exemplars

group=Z.Ytrain;
training=Z.Xtrain;
un=unique(group);

clear aind im v vj
nex=7;
imj=nan(29*nex,29*3);
siz=size(imj);
for j=1:3
    aind{j}=find(group==un(j));
    for k=1:nex
        imj((k-1)*29+1:k*29,(j-1)*29+1:j*29)=[reshape(training(:,aind{j}(k)),[28 28]), ones(28,1);ones(1,29)];
    end
end
imj=-imj+1;
imj(:,end)=[];
imj=repmat(imj,1,1,3);

imj(:,1:28,1)=0;
imj(:,1:28,2)=0;

imj(:,30:57,2)=0;
imj(:,30:57,3)=0;

imj(:,59:end,1)=0;
imj(:,59:end,3)=0;

imagesc(imj)
colormap('bone')
subplot('Position',[leftside, bottom(3), width, width*3+hspace*2]), %[left,bottom,width,height]

imagesc(imj), 
set(gca,'XTickLabel',[],'YTickLabel',[]); 
tfs=14;
title('Examples','FontSize',tfs)


%% plot projections
clear aind im v vj
im1=zeros(28*4,28*4);
for j=1:3
    aind{j}=find(group==un(j));
    for k=1:4
        v{j}{k}=reshape(Pro{j}.V(k,:),[28 28]);
    end
    m=max(v{j}{1}(:));
    if j==3, m=1; end
    vj{j}=[v{j}{1}, m*ones(28,1) v{j}{2}; m*ones(1,28*2+1); v{j}{3}, m*ones(28,1), v{j}{4}];
end

for j=1:3
    subplot('Position',[left2, bottom(j), width, height]),
       if j==1
        imagesc(abs(vj{3})<1e-4),
        title('Projections','FontSize',tfs)
       elseif j==2
        imagesc(vj{1}),
       elseif j==3
        imagesc(vj{2}),
    end
    set(gca,'XTickLabel',[],'YTickLabel',[]);
 end


%% plot embeddings


for i=1:3;
    iproj=i;
    Xtest=Pro{iproj}.V*Z.Xtest;
    Xtrain=Pro{iproj}.V*Z.Xtrain;
    
    for jjj=1:length(label_keepers)
        if jjj==1
            color='b';
            marker='x';
        elseif jjj==2
            color='r';
            marker='o';
        else
            color='g';
            marker='d';
        end
        
        if i==1,
            si=3; ylab='LOL        ';
        elseif i==3,
            si=1; ylab='Lasso        ';
        else
            si=i; ylab='PCA        ';
        end
        subplot('Position',[left3 bottom(si), width, height]); hold all %[left,bottom,width,height]
        if plot3d==1
            plot3(Xtest(1,Z.Ytest==label_keepers(jjj)),Xtest(2,Z.Ytest==label_keepers(jjj)),Xtest(3,Z.Ytest==label_keepers(jjj)),'.',...
                'marker',marker,'markersize',4,'color',color)
            view([0.5,0.5,1])
        else
            plot(Xtest(1,Z.Ytest==label_keepers(jjj)),Xtest(2,Z.Ytest==label_keepers(jjj)),'.',...
                'marker',marker,'markersize',4,'color',color)
        end
    end
    if i==1,
        tit='';
        set(gca,'xtick',-20:4:20,'ytick',-20:4:20,'ztick',-20:4:20)
    elseif i==2,
        tit='';
        if plot3d
            set(get(gca,'xlabel'),'rotation',45);
            set(get(gca,'ylabel'),'rotation',-45);
        end
        set(gca,'xtick',-20:4:20,'ytick',-20:4:20,'ztick',-20:4:20)
    else
        set(gca,'xtick',-20:0.5:20,'ytick',-20:0.5:20,'ztick',-20:0.5:20)
        tit='Embeddings';
    end
    ylabel(ylab,'Rotation',360,'FontWeight','bold','FontName','FixedWidth')
    title(tit,'FontSize',tfs), grid off, axis('tight'), %axis('square')
    set(gca,'XtickLabel',[],'YTickLabel',[],'ZTickLabel',[]);
    
end


%% save plot

if task.savestuff==1
    clear F
    F.PaperSize=[6.5 6];ff=findex;
    F.fname=[rootDir, '../Figs/mnist'];
    F.PaperPosition=[-0.5 0 F.PaperSize];
    print_fig(h(6),F)
end


