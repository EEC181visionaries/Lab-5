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

function digit_matrix = digit_separate(roi)
% takes the region of interest matrix and splits the numbers in them
% then centers the numbers horizontally and vertically

[row,col] = size(roi);

i = round(row/2);  %start in the center row
j = 1;  %start at the leftmost column
hit = 0;
right_edge = 0;
bad = 0;
last = 0;
last_mid = 1;
digit_matrix = [];
first = 1;

for j= 1:4:col
    if ( (roi(i,j) == 1) || (j+4 > col) ) % if hit white, or hit end
        if (first == 1)
            first = 0;
            hit = 1;
        else
        if (hit == 0)

            hit = 1;
            mid = (j - right_edge)/2 + right_edge; % put middle in between
            mid = int64(mid);
            if (roi(i,j) == 1) % ignore if the end is reached
            for mid_row = 1:row % check if white space was found in column
                if (roi(mid_row,mid) == 1)
                    bad = 1;
                    break;
                end
            end
            end
            if ( bad ~= 1)
                digit = roi(1:row,last_mid:mid);
                

                % center image vertically
                digit_left = 1;
                digit_right = mid-last_mid;
                for k = 1:(mid-last_mid)
                    if (any(digit(:,k)))
                        digit_left = k;
                        break;
                    end
                end
                for k = (mid-last_mid):-1:1
                   if (any(digit(:,k)))
                       digit_right = k;
                       break;
                   end
                end
                digit_width = digit_right - digit_left;
                left_add = idivide(int16(row-digit_width),int16(2),'ceil');
                right_add = idivide(int16(row-digit_width),int16(2),'floor');
                left_add = zeros(row,left_add);
                right_add = zeros(row,right_add);
                digit = [left_add digit(:,digit_left:digit_right) right_add];
                %
                
                
                
                digit = imresize(digit,[28,28]);
                
                
                
                % center image horizontally
                digit_top = 1;
                digit_bottom = 28;
                for k = 1:28
                    if (any(digit(k,:)))
                        digit_top = k;
                        break;
                    end
                end
                for k = 28:-1:1
                   if (any(digit(k,:)))
                       digit_bottom = k;
                       break;
                   end
                end
                digit_height = digit_bottom - digit_top;
                top_add = idivide((27-digit_height),int8(2),'ceil');
                bottom_add = idivide((27-digit_height),int8(2),'floor');
                top_add = zeros(top_add,28);
                bottom_add = zeros(bottom_add,28);
                digit = [top_add;digit(digit_top:digit_bottom,:);bottom_add];
                %
                

                digit_vector = reshape(digit,784,1);
                digit_matrix = [digit_matrix, digit_vector];
                last_mid = mid;
            end
            
        end
        end
        last = 1;
    elseif (last == 1)
        right_edge = j;
        last = 0;
        hit = 0;
    else
        last = 0;
        hit = 0;
    end
    bad = 0;

end
end





% ===================================================================

function output = ROI(rgb)
% ROI - Finds the region of interest
%


%s = strcat(img_num,'.jpg');
% Initializations
%rgb = imread(img_num);    % Reads in '61.jpg'
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
output = roi;
%imshow(roi);
end
