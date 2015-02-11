% Getting 20 Images every 3 seconds
for i = 1:100
    a = int2str(i+1000);
    a = strcat('pics/',a);
try
   ROI(a);
catch
    display('Error with image ');
    disp(a);
end

end

