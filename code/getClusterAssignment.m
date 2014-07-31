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

function [ H, clusterMap ] = getClusterAssignment( X, H, y, err_bound)
% Computes cluster mappings for each data point. Also rearranges clusters
% so that smaller clusters appear first and then the bigger ones. The
% smaller ones are most likely to be removed. 
%
% clusterMap is a matrix where (i, j)th entry is 1, if ith point in X is
% covered by jth affine function otherwise it is 0.

% COMPUTES P in the algorithm genPiecewiseAffineModel in EMSOFT 2014 paper.

X = [X ones(size(X, 1), 1)];

clusterMap = zeros(size(X, 1), size(H, 1));

for i = 1:size(H, 1)
    diff = X*H(i, :)' - y;
    clusterMap(:, i) = ~(abs(diff) > err_bound);
end

clsize = sum(clusterMap);
[~, clorder] = sort(clsize);
clusterMap = clusterMap(:, clorder);
H = H(clorder, :);

ind = [];
for i = 1:size(H, 1)
    posI = clusterMap(:, i);
    negI = any(clusterMap(:, (i+1):end), 2);
    if(~any(posI & ~negI))
        continue;
    end
    ind = [ind i];
end

H = H(ind, :);
clusterMap = clusterMap(:, ind);
