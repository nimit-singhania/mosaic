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

function [ Hyp, clusters ] = genSimpleHyperplanes( X, y, n, k )
% Implements the strategy from Ferrari-Trecate et. al. to learn the
% Hyperplane
% A simpler version as numerical errors occur in their version.

% IMPLEMENTS affine function generation for Ferrari-Trecate comparsion in
% EMSOFT 2014 paper.

w = zeros(size(X, 1),1);
e = zeros(size(X, 1), 2*size(X, 2) + 1);
for p = 1:size(X, 1)
% Get a random point in X.

% sort points by distances from p.
diff = bsxfun(@minus, X, X(p, :));
dist = sqrt(sum(diff.*diff, 2));
[~, I] = sort(dist);

sortX = X(I(1:n), :);
sortY = y(I(1:n), :);

phiX = [sortX ones(size(sortX, 1), 1)];

H = (phiX'*phiX + eye(size(phiX, 2)))\(phiX'*sortY);
% SSR = sortY'*(eye(size(phiX, 1)) - phiX*inv(phiX'*phiX + eye(size(phiX, 2)))*phiX')*sortY;
% V = (SSR*inv(phiX'*phiX + eye(size(phiX, 2))))/(n - size(X, 1) + 1);

m = mean(sortX, 1);
% % define Q
% x = bsxfun(@minus, sortX, m);
% Q = 0;
% for i = 1:size(x, 1)
%     Q = Q + (x(i, :))'*x(i, :);
% end
% 
% R = zeros(size(V, 1) + size(Q,1));
% R(1:size(V, 1), 1:size(V, 1)) = V;
% R((size(V, 1) + 1):end, (size(V, 1) + 1):end) = Q;
% 
e(p, :) = [H; m'];
% 
% w(p, :) = 1/sqrt(abs((2*pi)^(2*(size(X, 2)) + 1)*det(R)));
end

[IDX, C] = kmeans(e, k);

for i = 1:k
    clusters(:, i) = (IDX == i);
    ids = find(IDX == i);
    sortX = X(ids, :);
    sortY = y(ids, :);
    phiX = [sortX ones(size(sortX, 1), 1)];
    Hyp(i, :) = ((phiX'*phiX + eye(size(phiX, 2)))\(phiX'*sortY))';
end

