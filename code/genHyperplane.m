% Copyright (c) 2014, Nimit Singhania, University of Pennsylvania, All
% rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 1. Redistributions of source code must retain the above copyright
% notice, this list of conditions and the following disclaimer.
% 2. Redistributions in binary form must reproduce the above copyright
% notice, this list of conditions and the following disclaimer in the
% documentation and/or other materials provided with the distribution.
% 3. All advertising materials mentioning features or use of this
% software must display the following acknowledgement: This product
% includes software developed by The University of Pennsylvania
% 4. Neither the name of the University of Pennsylvania nor the names of
% its contributors may be used to endorse or promote products derived
% from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ''AS IS'' AND ANY
% EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
% BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
% WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
% OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
% IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function [H, flag]= genHyperplane(X, y)
% X : N x (d + 1) - N points in d dimensional real hyperspace padded with
% ones to take care of constants.
% Y : N x 1 - Mapping of points in X
% H : 1 x (d + 1) One hyperplane that passes through some points in X

precision = 2^(-20);

% Get a random point in X.
p = randi(size(X,1));

% sort points by distances from p.
diff = bsxfun(@minus, X, X(p, :));
dist = sqrt(sum(diff.*diff, 2));
[~, I] = sort(dist);

sortX = X(I, :);
sortY = y(I, :);

% set up linear program to find coefficients of hyperplane.
f = zeros(size(X, 2), 1);
flag = 1;

np = min(size(X, 2) - 1, size(X, 1));
A = sortX(1:np,:);
b = sortY(1:np);
sortX(1:np, :) = [];
sortY(1:np) = [];

H = zeros(size(X, 2), 1);
while(flag == 1)
    [tempH, ~, flag] = linprog(f, [], [], A, b);
    if(flag == 1)
        H = tempH;
        
        % No more elements to satisfy the hyperplane
        if(size(sortX, 1) == 0)
            break;
        end
        
        v = sortX*H - sortY;
        I = find(abs(v) >= precision);
        
        if(isempty(I))
            break;
        end
        
        A = [A; sortX(I(1), :)];
        b = [b; sortY(I(1))];
        sortX(I(1), :) = [];
        sortY(I(1)) = [];
    end
end
