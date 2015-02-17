function digit_matrix = digit_separate(roi)
% takes the region of interest matrix and splits the numbers in them

[row,col] = size(roi);

i = round(row/2);  %start in the center row
j = 1;  %start at the leftmost column
hit = 0;
last_hit = 0;
right_edge = 0;
mid = 1;
bad = 0;
last = 0;
last_mid = 1;
digit_matrix = [];
start = 0;
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
                digit = imresize(digit,[28,28]);
                
                
                
                %center image vertically
                digit_left = 1;
                digit_right = 28;
                for k = 1:28
                    if (any(digit(:,k)))
                        digit_left = k;
                        break;
                    end
                end
                for k = 28:-1:1
                   if (any(digit(:,k)))
                       digit_right = k;
                       break;
                   end
                end
                digit_width = digit_right - digit_left;
                left_add = idivide((27-digit_width),int8(2),'ceil');
                right_add = idivide((27-digit_width),int8(2),'floor');
                left_add = zeros(28,left_add);
                right_add = zeros(28,right_add);
                digit = [left_add digit(:,digit_left:digit_right) right_add];
                %
                
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
