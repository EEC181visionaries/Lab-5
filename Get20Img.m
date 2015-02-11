% Getting 20 Images every 3 seconds
for i = 1:20
    img = imread('http://eec181.ece.ucdavis.edu:8081/photo.jpg');
    a = int2str(i);
    str = strcat(a,'.jpg');
    %str = sprintf('%d.jpg',i);
    imwrite(img, str, 'jpg');
    pause(3);
end

