function y = filterFun(a, b, option);
% DESCRIPTION
%   The function 'filterFun' performs filtering on 'a' by using 'b'
%   based on option.
% PARAMETERS
%   a:
%       input matrix to be filterd.
%   b:
%       input matrix to used as filter.
%   option:
%       filtering option. The value can be one of 3 types:
%       'full' - returns full 2D filtering.
%       'same' - returns central part that is same size as a.
%       'valid' - returns only those parts of the filtering that are
%                 computed without the zero-padded edges.
% RETURN
%   y:
%       filtered matrix.

% check arguements
if (nargin ~= 3)
    error( 'filterFun requires 2 or 3 arguements' );
end

% get array sizes
[ma, na] = size(a);
[mb, nb] = size(b);

y = zeros(ma+mb-1, na+nb-1);
for i = 1:mb
    for j = 1:nb
        r1 = i;
        r2 = r1 + ma - 1;
        c1 = j;
        c2 = c1 + na - 1;
        y(r1:r2,c1:c2) = y(r1:r2,c1:c2) + b(i,j) * a;
    end
end

% Option1 - do full filtering
if(strcmp(option, 'full'))
% Option2 - do same filtering
elseif(strcmp(option, 'same'))
    % extract region of size(a) from y
    r1 = floor(mb/2) + 1;
    r2 = r1 + ma - 1;
    c1 = floor(nb/2) + 1;
    c2 = c1 + na - 1;
    y = y(r1:r2, c1:c2);

% Option3 - do valid filtering
elseif(strcmp(option, 'valid'))
    % extract valid region from y
    y = y(mb:ma, nb:na);
else
    error('The third arguement must be ''full'', ''same'', or ''valid'' ');
end
