function z = PSNR(x,y)

% DESCRIPTION
%   To find the PSNR (peak signal-to-noise ratio) between two gray images 
%   x and y, each having values in the interval [0,255].
% RETURN
%   z:
%       The answer is in decibels (dB).

if x == y
   error('Images are identical: PSNR has infinite value')
end

[M N] = size(x);
dx = im2double(x);
dy = im2double(y);

err = dx - dy;
MSE = sum(sum(err.^2)) / (M * N);   %mean square error
z = 10*log10(255^2 / MSE);
