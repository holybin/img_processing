% Exercise 2.2: Canny Edge Detection

clc;close all;clear all;

% load image
I = imread('lena_std.tif');
figure, imshow(I), title('Original Image'); 
% type to double
dI = im2double(I);
[M N] = size(I);
               
% deal with margin
for i = 1:M+4
    for j = 1:N+4
        if(i<=2 || j<=2 || i>=M+3 || j>=N+3)
            mI(i,j) = 0;
        else 
            mI(i,j) = dI(i-2,j-2);
        end;
    end
end

%% Step 1: Gaussian filter
gfilter = [2 4 5 4 2;4 9 12 9 4;5 12 15 12 5;4 9 12 9 4;2 4 5 4 2];

for i = 1:5
    for j = 1:5
        gfilter(i,j) = gfilter(i,j)/159;
    end
end
gfI = imfilter(mI, gfilter, 'symmetric');
figure,imshow(gfI),title('Gaussian Filtered Image');

% deal with margin
for i = 1:M+2
    for j = 1:N+2
        if(i<=1 || j<=1 || i>=M || j>=N)
            mgfI(i,j) = 0;
        else 
            mgfI(i,j) = gfI(i-1,j-1);
        end;
    end
end

%% Step 2: Finding the intensity gradient using Sobel operator
sx = [-1 0 1; -2 0 2; -1 0 1]; % Sobel mask in x-Direction
sy = [-1 -2 -1; 0 0 0; 1 2 1]; % Sobel mask in y-Direction
% Soble x-direction
for u = 2:M
    for v = 2:N
        sum = 0;
        for i = -1:1
            for j = -1:1
                sum = sum + mgfI(u + i, v + j)* sx(i + 2,j + 2);
            end
        end
        sxI(u,v) = sum;
    end
end
% Soble y-direction
for u = 2:M
    for v = 2:N
        sum = 0; 
        for i = -1:1
            for j = -1:1
                sum = sum + mgfI(u + i, v + j)* sy(i + 2,j + 2);
            end
        end
        syI(u,v) = sum;
    end
end

% compute the gradient magnitude
for u = 1:M
   for v = 1:N
        mag(u,v) = sqrt(sxI(u,v)^2 + syI(u,v)^2);
   end
end
figure,imshow(uint8(mag.*255)),title('Gradient Image');

% deal with margin
tmpMag = mag;
for i= 1:M+2
    for j = 1:N+2
        if(i<=1 || j<=1 || i>=M || j>=N)
            mag(i,j) = 0;
        else 
            mag(i,j) = tmpMag(i-1,j-1);
        end;
    end
end

%% Step 3: Non-maximum suppression
theta(u,v) = 0; % original gradient angle
roundtheta(u,v) = 0; % rounded gradient angle
nmsupimg(u,v) = 0;  % non-maximum suppressed image

for u = 2 : M
    for v = 2 : N
        % gradient angle
        theta(u,v) = atand(syI(u,v)/sxI(u,v)); 
        % [?22.5бу,22.5бу] or [157.5бу,202.5бу] round to 0бу
        if ((theta(u,v) > 0 ) && (theta(u,v) < 22.5) || (theta(u,v) > 157.5) && (theta(u,v) < -157.5))
            roundtheta(u,v) = 0;
        end
        % [22.5бу,67.5бу] or [202.5бу,247.5бу] round to 45бу
        if ((theta(u,v) > 22.5) && (theta(u,v) < 67.5) || (theta(u,v) < -112.5) && (theta(u,v) > -157.5))
            roundtheta(u,v) = 45;
        end
        % [67.5бу,112.5бу] or [247.5бу,292.5бу] round to 90бу
        if ((theta(u,v) > 67.5 && theta(u,v) < 112.5) || (theta(u,v) < -67.5 && theta(u,v) > 112.5))
            roundtheta(u,v) = 90;
        end
        % [112.5бу,157.5бу] or [292.5бу,337.5бу] round to 135бу
        if ((theta(u,v) > 112.5 && theta(u,v) <= 157.5) || (theta(u,v) < -22.5 && theta(u,v) > -67.5))
            roundtheta(u,v) = 135;
        end
        
        % process of non-maximum suppression: 3*3 neighbors
        if (roundtheta(u,v) == 0)
            if (mag(u, v) > mag(u, v-1) && mag(u, v) > mag(u, v+1))
                nmsupimg(u,v) = mag(u,v);
            else
                nmsupimg(u,v) = 0;
            end
        end
        
        if (roundtheta(u,v) == 45)
            if (mag(u, v) > mag(u+1, v-1) && mag(u, v) > mag(u-1, v+1))
                nmsupimg(u,v) = mag(u,v);
            else
                nmsupimg(u,v) = 0;
            end
        end
           
        if (roundtheta(u,v) == 90)
            if (mag(u, v) > mag(u-1, v) && mag(u, v) > mag(u+1, v))
                nmsupimg(u,v) = mag(u,v);
            else
                nmsupimg(u,v) = 0;
            end
        end
        
        if (roundtheta(u,v) == 135)
            if (mag(u, v) > mag(u-1, v-1) && mag(u, v) > mag(u+1, v+1))
                nmsupimg(u,v) = mag(u,v);
            else
                nmsupimg(u,v) = 0;
            end 
        end    
    end
end
figure,imshow(nmsupimg),title('Non-maximum Suppression Image');

%% Step 4: Hysteresis Thresholding
highthresh = 0.2;   % high threshold
lowthresh = 0.1;    % low threshold
resimg(u,v) = 0; % result image including edges
 
for u = 2:M-1
    for v = 2:N-1
        % case 1: > T(high)
        if(nmsupimg(u,v) > highthresh)
            resimg(u,v) = 1;
        else
            % case 2: > T(low) && <T(high)
            if(nmsupimg(u,v) >= lowthresh && nmsupimg(u,v) <= highthresh )
                resimg(u,v) = 1;
            else
                % case 3: < T(low)
                if (nmsupimg(u,v) < lowthresh)
                    resimg(u,v) = 0;
                end
            end
        end
        % case 2: complicated situations
        if (nmsupimg(u-1,v-1) > highthresh || nmsupimg(u,v-1) > highthresh... 
            || nmsupimg(u+1,v-1) > highthresh || nmsupimg(u+1,v) > highthresh...
            || nmsupimg(u+1,v+1) > highthresh || nmsupimg(u,v+1) > highthresh...
            || nmsupimg(u-1,v+1) > highthresh || nmsupimg(u-1,v) > highthresh)
            resimg(u,v) = 1;
        else
            resimg(u,v) = 0;
        end
    end
end

figure,imshow(resimg),title('Hysteresis Thresholding Image');
