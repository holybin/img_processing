% Exercise 1.2: Denoising a Noisy Image

clc;clear all;close all;

% load original gray image
grayImg = imread('lena_std_gray.tif');

% different standard deviation values
sval_noise = [1,2,4,8,16,32];
sval_denoise = [0.5,1,1.5,2,2.5,3,3.5,4,4.5,5];
% sval_denoise = [6,6.5,7,7.5,8,8.5,9,9.5,10];

resG = [];
for i = 1:size(sval_noise,2)
    noisedImg = imread(sprintf('.\\sigma=%d\\lena_std_%d.tif',sval_noise(i),sval_noise(i)));
    for j = 1:size(sval_denoise,2)
        sigma = sval_denoise(j);
        
        % Gaussian filter
        gaussFilter = fspecial('gaussian', 4*sigma, sigma);
        % denoise image by using the filter
        denoisedImg = imfilter(noisedImg, gaussFilter, 'symmetric');
        
        % show denoised image
        f = figure;
        subplot 131, imshow(grayImg);
        title('Original Image')
        subplot 132, imshow(noisedImg);
        title(sprintf('Noised Image: sigma=%d',sval_noise(i)))
        subplot 133, imshow(denoisedImg);
        title(sprintf('Denoised Image: size=%d,sigma=%.2f',4*sigma, sigma))
        % save denoised image
        % saveas(f, sprintf('.\\sigma=%d\\lena_std_%d_%.2f.tif',sval_noise(i),sval_noise(i),sigma));
        imwrite(denoisedImg, sprintf('.\\sigma=%d\\lena_std_%d_%.2f.tif',sval_noise(i),sval_noise(i),sigma));
        
        % calculate PSNR and SSIM
        psnr = PSNR(grayImg, denoisedImg);
        ssim = SSIM(grayImg, denoisedImg);
        resG = [resG;sval_noise(i) sval_denoise(j) psnr ssim];
    end
    pause;
    close all;
end

save('resG.mat','resG');

