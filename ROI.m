function ROI(img_num)
% ROI - Finds the region of interest
%


s = strcat(img_num,'.jpg');
% Initializations
rgb = imread(s);    % Reads in '61.jpg'
gray = rgb2gray(rgb);     % Converts img to grayscale
x = 0;                      % Initialize large ROI
y = 0;
v = 0;
w = 0;


% Finds the average val between 0 and 255
% 0 = black; 255 = white
col = zeros(1,2448);        % Initializes an array to find the avg
for i = 1:2448
    col(1,i) = gray(i,3000);
end
average = mean(col);
if (average < 100)
    level = .5;
elseif (average < 150)
    level = .7;
end


% Finding large ROI
bw = im2bw(gray,level);    % Converts gray to bw

[row,col] = size(bw);    % Finds dimensions of image

prev_val = 0;
val = 0;
i = row/2;
for j = 1:50:col
    prev_val = val;
    if(bw(i,j) == 1)
        x = j;
        val = val + 1;
    end
    if (prev_val == val && val)
        val = 0;
    end
    if (val == 3)
        %disp(x);
        val = 0;
        prev_val = 0;
        break
    end
end
for j = col:-50:1
    prev_val = val;
    if(bw(i,j) == 1)
        y = j;
        val = val + 1;
    end
    if (prev_val == val && val)
        val = 0;
    end
    if (val == 3)
        %disp(y);
        val = 0;
        prev_val = 0;
        break
    end
end

j = col/2;
for i = 1:50:row
    prev_val = val;
    if(bw(i,j) == 1)
        v = i;
        val = val + 1;
    end
    if (prev_val == val && val)
        val = 0;
    end
    if (val == 3)
        %disp(v);
        val = 0;
        prev_val = 0;
        break
    end
end
for i = row:-50:1
    prev_val = val;
    if (bw(i,j) == 1)
        w = i;
        val = val + 1;
    end
    if (prev_val == val && val)
        val = 0;
    end
    if (val == 3)
        %disp(w);
        val = 0;
        prev_val = 0;
        break
    end
end

% Large ROI
lroi = bw(v:w,x:y);
%imshow(lroi);

[row,col] = size(lroi);

i = row/2;
i = round(i);
for j = 1:5:col
    prev_val = val;
    if(lroi(i,j) == 0)
        if (val == 0)
            x = j;
        end
        val = val + 1;
    end
    if (prev_val == val && val)
        val = 0;
    end
    if (val == 2)
        %disp(x);
        val = 0;
        prev_val = 0;
        break
    end
end
for j = col:-5:1
    prev_val = val;
    if(lroi(i,j) == 0)
        if (val == 0)
            y = j;
        end
        val = val + 1;
    end
    if (prev_val == val && val)
        val = 0;
    end
    if (val == 2)
        %disp(y);
        val = 0;
        prev_val = 0;
        break
    end
end

j = 2*col/5;
j = round(j);
for i = 1:2:row
    if(lroi(i,j) == 0)
        if (val == 0)
            v = i;
        end
        prev_val = val;
        val = val + 1;
    end
    if (prev_val == val && val)
        val = 0;
    end
    if (val == 2)
        %disp(v);
        val = 0;
        prev_val = 0;
        break
    end
end
for i = row:-2:1
    if (lroi(i,j) == 0)
        if (val == 0)
            w = i;
        end
        prev_val = val;
        val = val + 1;
    end
    if (prev_val == val && val)
        val = 0;
    end
    if (val == 2)
        %disp(w);
        val = 0;
        prev_val = 0;
        break
    end
end

roi = lroi(v:w,(x+3):(y-3));

% Refining Region of Interest
% If the first column top is black, check the bottom
[row,col] = size(roi);    % Finds dimensions of image
LeftTop = 0;
LeftBottom = 0;
RightTop = 0;
RightBottom = 0;

% If the element is black, store that address
for i = 1:row
    % Top Left
    if (LeftTop == 0)
        if (roi(i,1)==0)
            LeftTop = i;
        end
    end
    % Bottom Left
    if (LeftBottom == 0)
        if (roi((row-i),1)==0)
            LeftBottom = (row-i);
        end
    end
    % Top Right
    if (RightTop == 0)
        if (roi(i,col)==0)
            RightTop = i;
        end
    end
    % Bottom Right
    if (RightBottom == 0)
        if (roi((row-i),col)==0)
            RightBottom = (row-i);
        end
    end
    if (LeftTop && LeftBottom && RightTop && RightBottom)
        break
    end
end

if (LeftTop >= RightTop)
    v = LeftTop;
else
    v = RightTop;
end

if (LeftBottom <= RightBottom)
    w = LeftBottom;
else
    w = RightBottom;
end

roi = roi(v:w,1:col);
imshow(roi);
