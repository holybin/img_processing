% Exercise 1.3: Edge preserving smoothing

clc;clear all;close all;

% load original gray image
grayImg = imread('lena_std_gray.tif');

% Gaussian standard deviation values of noising
sval_noise = [1,2,4,8,16,32];
% Gaussian standard deviation values of denoising
sval_gaussian = [0.5,1,1.5,2,2.5,2.5];
% intensity standard deviation values of denoising
sval_intensity = [0.001,0.05,0.1,0.3,0.5,0.7,0.9,1.1,3,6,12,24];

resB = [];
for i = 1:size(sval_noise,2)
    noisedImg = imread(sprintf('.\\sigma=%d\\lena_std_%d.tif',sval_noise(i),sval_noise(i)));
    denoisedImgG = imread(sprintf('.\\sigma=%d\\lena_std_%d_%.2f.tif',sval_noise(i),sval_noise(i),sval_gaussian(i)));

    for j = 1:size(sval_intensity,2)
        % set bilateral filter parameters
        w = 4*sval_gaussian(i)/2;   % bilateral filter half-width
        sigma = [sval_gaussian(i) sval_intensity(j)];   % bilateral filter standard deviations

        % set range to [0,1], and set type to double
        dNoisedImg = double(noisedImg)/255;
        % apply bilateral filter to each image
        denoisedImgB = bfilter2(dNoisedImg,w,sigma);

        % calculate PSNR and SSIM
        psnr = PSNR(grayImg, denoisedImgB);
        ssim = SSIM(grayImg, denoisedImgB);
        resB = [resB;sval_noise(i) sval_gaussian(i) sval_intensity(j) psnr ssim];
        
        % show denoised image: Gaussian vs. bilateral
        f = figure;
%         subplot 221, imshow(grayImg);
%         title('Original Image')
%         subplot 222, imshow(noisedImg);
%         title(sprintf('Noised Image: sigma=%d',sval_noise(i)))
        subplot 121, imshow(denoisedImgG);
        title(sprintf('Gaussian Denoised: size=%d,sigma=%.2f',...
            4*sval_gaussian(i),sval_gaussian(i)))
        subplot 122, imshow(denoisedImgB);
        title(sprintf('Bilateral Denoised: size=%d,sigma1=%.2f,sigma2=%.3f',...
            4*sval_gaussian(i),sval_gaussian(i),sval_intensity(j)))
        % save denoised image: Gaussian vs. bilateral
        %saveas(f, sprintf('.\\sigma=%d\\lena_std_%d_compare.tif',sval_noise(i)));
        
        % save bilateral denoised image
        imwrite(denoisedImgB, sprintf('.\\sigma=%d\\lena_std_%d_%.2f_%.3f.tif',...
            sval_noise(i),sval_noise(i),sval_gaussian(i),sval_intensity(j)));
    end
    pause;
    close all;
end

save('resB.mat','resB');
