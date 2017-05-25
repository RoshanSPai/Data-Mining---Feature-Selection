function Ind = CentroidClustering( trainData,testData,classData )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

N = size(trainData,1);
M = size(testData,1);
col = size(trainData,2);

class_name=unique(classData);
noOfClasses=size(class_name,2);
for x = 1:noOfClasses
    rep(x)=histc(classData, class_name(x));
end
rep;
i=1;

for x = 1:size(rep,2)
    sumOf=0;
    for y = 1:rep(x)
        if i <= col
            sumOf = sumOf+trainData(:,i);
            i  = i+1;
        else
            break;
        end
    end
    centroidTrain(:,x) = sumOf ./ rep(x);
end    
    
final= pdist2(centroidTrain',testData');
[Fin,Ind] = min(final,[],1);

