function output = check_image(img)

im = ROI(img);
matrix = digit_separate(im);
output = matrix;


X1=show_digit(matrix,1);
X2=show_digit(matrix,2);
X3=show_digit(matrix,3);
try
X4=show_digit(matrix,4);
catch
end
subplot(1,4,1), imshow(X1)
subplot(1,4,2), imshow(X2)
subplot(1,4,3), imshow(X3)
try
subplot(1,4,4), imshow(X4)
catch
end
end
