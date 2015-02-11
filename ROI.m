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
if (average < 100)
    level = .5;
elseif (average < 150)
    level = .7;
end


% Finding large ROI
bw_70 = im2bw(gray1,level);    % Converts gray to bw

[row,col] = size(bw_70);    % Finds dimensions of image

prev_val = 0;
val = 0;
i = row/2;
for j = 1:50:col
    if(bw_70(i,j) == 1)
        x = j;
        prev_val = val;
        val = val + 1;
    end
    if (prev_val == val && val)
        val = 0;
    end
    if (val == 3)
        disp(x);
        val = 0;
        prev_val = 0;
        break
    end
end
for j = col:-50:1
    if(bw_70(i,j) == 1)
        y = j;
        prev_val = val;
        val = val + 1;
    end
    if (prev_val == val && val)
        val = 0;
    end
    if (val == 3)
        disp(y);
        val = 0;
        prev_val = 0;
        break
    end
end

j = col/2;
for i = 1:50:row
    if(bw_70(i,j) == 1)
        v = i;
        prev_val = val;
        val = val + 1;
    end
    if (prev_val == val && val)
        val = 0;
    end
    if (val == 3)
        disp(v);
        val = 0;
        prev_val = 0;
        break
    end
end
for i = row:-50:1
    if (bw_70(i,j) == 1)
        w = i;
        prev_val = val;
        val = val + 1;
    end
    if (prev_val == val && val)
        val = 0;
    end
    if (val == 3)
        disp(w);
        val = 0;
        prev_val = 0;
        break
    end
end

% Large ROI
lroi = bw_70(v:w,x:y);
%imshow(lroi);

[row,col] = size(lroi);

i = row/2;
for j = 1:10:col
    if(lroi(i,j) == 0)
        x = j;
        prev_val = val;
        val = val + 1;
    end
    if (prev_val == val && val)
        val = 0;
    end
    if (val == 2)
        disp(x);
        val = 0;
        prev_val = 0;
        break
    end
end
for j = col:-10:1
    if(lroi(i,j) == 0)
        y = j;
        prev_val = val;
        val = val + 1;
    end
    if (prev_val == val && val)
        val = 0;
    end
    if (val == 2)
        disp(y);
        val = 0;
        prev_val = 0;
        break
    end
end

j = col/2;
for i = 1:10:row
    if(lroi(i,j) == 0)
        v = i;
        prev_val = val;
        val = val + 1;
    end
    if (prev_val == val && val)
        val = 0;
    end
    if (val == 2)
        disp(v);
        val = 0;
        prev_val = 0;
        break
    end
end
for i = row:-10:1
    if (lroi(i,j) == 0)
        w = i;
        prev_val = val;
        val = val + 1;
    end
    if (prev_val == val && val)
        val = 0;
    end
    if (val == 2)
        disp(w);
        val = 0;
        prev_val = 0;
        break
    end
end

roi = lroi(v:w,x:y);
imshow(roi);
