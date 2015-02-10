% ROI - Finds the region of interest
%

% Initializations
rgb1 = imread('61.jpg');    % Reads in '61.jpg'
gray1 = rgb2gray(rgb1);     % Converts img to grayscale
x = 0;                      % Initialize large ROI
y = 0;
v = 0;
w = 0;


% Finds the average val between 0 and 255
% 0 = black; 255 = white
col = zeros(1,2448);        % Initializes an array to find the avg
for i = 1:2448
    col(1,i) = gray1(i,3000);
end
average = mean(col);


% Finding large ROI
bw_70 = im2bw(gray1,.7);    % Converts gray to bw

[row,col] = size(bw_70);    % Finds dimensions of image

i = row/2;
for j = 1:50:col
    if(bw_70(i,j) == 1)
        x = j;
        disp(x);
        break;
    end
end
for j = col:-50:1
    if(bw_70(i,j) == 1)
        y = j;
        disp(y);
        break;
    end
end

j = col/2;
for i = 1:50:row
    if(bw_70(i,j) == 1)
        v = i;
        disp(v);
        break
    end
end
for i = row:-50:1
    if(bw_70(i,j) == 1)
        w = i;
        disp(w);
        break
    end
end

% Large ROI
LROI = bw_70(v:w,x:y);
imshow(LROI);
