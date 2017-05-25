function final = KNNClassifier(trainData,testData,classData,k)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

if isempty(k)
    prompt = 'enter value of k  ';
    k=input(prompt);
end
    
N = size(trainData,1);
M = size(testData,1);

eucli = zeros(M,N);

for row = 1:M
    for col = 1:N
        eucli(row,col)= sqrt(sum((trainData(col,:) -  testData(row,:)).^2));
        
    end
end
      
[B,I] = sort(eucli,2);

kI=I(:,1:k);

final = zeros(1,M);
for x = 1:M
    votes  = containers.Map('KeyType','int32','ValueType','int32');
    for y = 1:k
        response = classData(kI(x,y));
        tf = isKey(votes,response);
        if tf == 1
            votes(response)= votes(response)+1;
        else
            votes(response) = 1;
          
        end
        
    end
    key = cell2mat(keys(votes));
    val = cell2mat(values(votes));
    [arr,in]= sort(val,2,'descend');
    final(1,x)= key(in(1));
end

