% Exercise 2.1: Filtering

clc;clear all;close all;

% input matrices
I1 = [125 130 120 110 50;
      140 130 130 60 35;
      125 110 50 35 20;
      80 40 40 20 10;
      35 30 20 5 5];

I2 = [125 130 120 110 125;
      140 130 130 100 120;
      65 60 55 50 40;
      35 30 40 20 10;
      15 10 20 5 5];

% used filters
filter1 = 1/3*ones(1,3);
filter2 = 1/3*ones(3,1);
filter3 = 1/9*ones(3,3);

%% filter matrix 1
% use filter 1
I1_filter1_full = filterFun(I1,filter1,'full');
save('I1_filter1_full.mat', 'I1_filter1_full');
I1_filter1_same = filterFun(I1,filter1,'same');
save('I1_filter1_same.mat', 'I1_filter1_same');
I1_filter1_valid = filterFun(I1,filter1,'valid');
save('I1_filter1_valid.mat', 'I1_filter1_valid');

% use filter 2
I1_filter2_full = filterFun(I1,filter2,'full');
save('I1_filter2_full.mat', 'I1_filter2_full');
I1_filter2_same = filterFun(I1,filter2,'same');
save('I1_filter2_same.mat', 'I1_filter2_same');
I1_filter2_valid = filterFun(I1,filter2,'valid');
save('I1_filter2_valid.mat', 'I1_filter2_valid');

% use filter 3
I1_filter3_full = filterFun(I1,filter3,'full');
save('I1_filter3_full.mat', 'I1_filter3_full');
I1_filter3_same = filterFun(I1,filter3,'same');
save('I1_filter3_same.mat', 'I1_filter3_same');
I1_filter3_valid = filterFun(I1,filter3,'valid');
save('I1_filter3_valid.mat', 'I1_filter3_valid');

%% filter matrix 2
% use filter 1
I2_filter1_full = filterFun(I2,filter1,'full');
save('I2_filter1_full.mat', 'I2_filter1_full');
I2_filter1_same = filterFun(I2,filter1,'same');
save('I2_filter1_same.mat', 'I2_filter1_same');
I2_filter1_valid = filterFun(I2,filter1,'valid');
save('I2_filter1_valid.mat', 'I2_filter1_valid');

% use filter 2
I2_filter2_full = filterFun(I2,filter2,'full');
save('I2_filter2_full.mat', 'I2_filter2_full');
I2_filter2_same = filterFun(I2,filter2,'same');
save('I2_filter2_same.mat', 'I2_filter2_same');
I2_filter2_valid = filterFun(I2,filter2,'valid');
save('I2_filter2_valid.mat', 'I2_filter2_valid');

% use filter 3
I2_filter3_full = filterFun(I2,filter3,'full');
save('I2_filter3_full.mat', 'I2_filter3_full');
I2_filter3_same = filterFun(I2,filter3,'same');
save('I2_filter3_same.mat', 'I2_filter3_same');
I2_filter3_valid = filterFun(I2,filter3,'valid');
save('I2_filter3_valid.mat', 'I2_filter3_valid');
    