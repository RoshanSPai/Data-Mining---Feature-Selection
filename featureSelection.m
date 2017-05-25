function [] = featureSelection()
%select the input file
clear all;
[fileName1,pathName1] = uigetfile('*.txt','Select the training data file');
trainData = csvread(strcat(pathName1,fileName1),0,0);
classData = csvread(strcat(pathName1,fileName1),0,0,[0, 0, 0, size(trainData,2)-1]);

[trot class_index]=sort(classData);
trainData=trainData(:,class_index);
[Ng, bin] = histc(trainData(1,:),unique(trainData(1,:)));
trainData = trainData(2:end,:);
Cmean=[];
CmeanRep=[];
classData=trot;
features=size(trainData,1);
n=size(trainData,2);
class_name=unique(classData);
noOfClasses=size(class_name,2);

fStat=zeros(features,1);


for i=1:features
    %calculate Xig here
    Xig=zeros(1,noOfClasses);
    Xi=mean(trainData(i,:));
    j=1;
    k=0;
    for g=1:noOfClasses
        k=k+Ng(g);
        Xig(g)=mean(trainData(i,j:k));
        j=k+1;
    end
    k=0;
    Wii=0;
    Tii=0;
    for g=1:noOfClasses
        for t=(k+1):(k+Ng(g))
            Xigt= trainData(i,t);
            Wii=Wii+((Xigt-Xig(g))^2);
            Tii=Tii+((Xigt-Xi)^2);
        end
        k=k+Ng(g);
    end
    Vi=Wii/Tii;
    fStat(i)=((n-features-noOfClasses+1)/noOfClasses-1)*(Vi-1);
end

[B,I]=sort(fStat,'descend');


top=[10 20 30 50 100 200];
ts=size(top,2);
output = [];
for i=1:6
    in=top(i);
    impFeatures=I(1:in);
    fSelect_train=zeros(in,n);
    for j=1:in
        fSelect_train(j,:)=trainData(I(j),:);
    end
    knn=10;
    [accKnn,accLin,accCen,accSvm]=kfoldCV(fSelect_train,classData,knn);
    output=vertcat(output,[accKnn,accLin,accCen,accSvm]);
end
output
for i=1:4
    figure(1);
    xaxis=top;
    yaxis=output(1:ts,i);
    plot(xaxis,yaxis,'--s')
    title('Feature Selection');
    xlabel('Top k features');
    ylabel('Acurracy');
    legend('KNN','Linear Regression','Centroid Clustering', 'Svm');
    hold on
end
end

