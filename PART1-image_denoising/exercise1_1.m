% Exercise 1.1: Adding Noise to an Image

clc;clear all;close all;

% load and show image
img = imread('lena_std.tif');
figure,imshow(img);
pause;

% convert the image to grayscale
grayImg = rgb2gray(img);
figure,imshow(grayImg);
% save gray image
imwrite(grayImg, 'lena_std_gray.tif');
pause;

% get image size
[height, width] = size(grayImg);
% different s values
sval=[1,2,4,8,16,32];
% add noise to image and show image
for i = 1:size(sval,2)
    noiseGrayImg = double(grayImg) + sval(i)*randn(height,width);%type double
    noiseGrayImg_uint8 = uint8(noiseGrayImg);
    figure,imshow(noiseGrayImg_uint8);%typecast back to uint8 using 'uint8(img)'
    % figure,imshow(noiseGrayImg/255);%or using 'img/255'
    
    % save noised images
    imwrite(noiseGrayImg_uint8, sprintf('.\\sigma=%d\\lena_std_%d.tif',sval(i),sval(i)));
end
pause;close all;
