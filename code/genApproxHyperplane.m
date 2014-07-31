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

 function [H]= genApproxHyperplane(X, y, err_bound)
% X : N x (d + 1) - N points in d dimensional real hyperspace padded with
% ones to take care of constants.
% Y : N x 1 - Mapping of points in X
% H : 1 x (d + 1) One hyperplane that passes through some points in X

% Get a random point in X.
p = randi(size(X,1));

% sort points by distances from p.
diff = bsxfun(@minus, X, X(p, :));
dist = sqrt(sum(diff.*diff, 2));
[~, ind] = sort(dist);

sortX = X(ind, :);
sortY = y(ind, :);

k = min(size(X, 2) - 1 , size(X, 1));

while(true)    
    A = sortX(1:k, :);
    b = sortY(1:k);
    
    H = regress(b, A); 
    
    v = sortX*H - sortY;
    I = find(abs(v) >= err_bound);

    if(isempty(I) || I(1) <= k)
        if(~isempty(I))
            k = k - 1;
        end
        break;
    end
    k = k + 1;
end


A = sortX(1:k,:);
b = sortY(1:k);
[H] = regress(b, A);
tempH = H;

while(true)
    % find the set of points lying outside the err_bound
    I = find(abs(sortX*tempH - sortY) < err_bound);
    % if no new points found then exit.
    if(size(I, 1) == 0 || length(I) <= length(b))
        break;
    end

    H = tempH;
    A = sortX(I, :);
    b = sortY(I);
    [tempH] = regress(b, A);

end
