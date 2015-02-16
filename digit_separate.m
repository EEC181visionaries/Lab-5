function digit_matrix = digit_separate(roi)
% takes the region of interest matrix and splits the numbers in them

[row,col] = size(roi);

i = row/2;  %start in the center row
j = 1;  %start at the leftmost column
hit = 0;
last_hit = 0;
mid = 1;
bad = 0;
last_mid = 1;
digit_matrix = [];
start = 0;

for j = 1:4:col
   if ( (roi(i,j) == 1) || (j+4 > col) ) % if hit white, or hit end
       i
       j
       roi(i,j)
       50
       hit = j;
       mid = (hit - last_hit)/2 + last_hit; % put middle in between
       mid = int64(mid)
       
       for (mid_row = 1:row) % check if white space was found in column
           if (roi(mid_row,mid) == 1)
               bad = 1;
               100
               break;
           end
       end
       
       if (bad ~= 1) % If there is no white, add digit to matrix
           digit = roi(1:row,last_mid:mid);
           digit = imresize(digit,[28,28]);
           digit_vector = reshape(digit,784,1);
           if (start == 0) % ignore the first digit (it is blank)
               start = 1;
           else
               digit_matrix = [digit_matrix, digit_vector];
           end
           
           last_mid = mid;
       end
       bad = 0;
       last_hit = hit;
   end
end
