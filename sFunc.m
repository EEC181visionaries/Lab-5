function [ output] = sFunc(finalB1L1, finalB1L2, finalW1L1, finalW1L2, finalSoftmaxTheta)

img = imread('http://eec181.ece.ucdavis.edu:8081/photo.jpg');
imget = ROI(img);
data = digit_separate(imget);

[m,n] = size(data);

number = 0;

for i = 1:n
   M = recognizer(finalB1L1, finalB1L2, finalW1L1, finalW1L2, finalSoftmaxTheta, data(:,i));
   number = (number*10) + M;
end

output = number;



end

function [ output] = recognizer(finalB1L1, finalB1L2, finalW1L1, finalW1L2, finalSoftmaxTheta, data)
%FUNC Summary of this function goes here
%   Detailed explanation goes here




    Vdat = data;
    Vb1 = finalW1L1*Vdat;
    Vb1 = Vb1 + finalB1L1;
    Vb1 = sigmf(Vb1,[1 0]);
    Vb1 = finalW1L2*Vb1;
    Vb1 = Vb1 + finalB1L2;



 Vb1 = sigmf(Vb1,[1 0]);
    Vb1 = finalSoftmaxTheta*Vb1;

    M = find(Vb1==max(Vb1));
    if(M == 10)
        M = 0;
    end

    output = M;



end
