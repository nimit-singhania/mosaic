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

function [ guards, r ] = getSimpleConditionals2(X, clusters)
% Learns a single affine inequality that best separates a cluster from all
% other points and repeats it on other clusters
% It is a modification of getSimpleConditionals in that a greedy heuristic
% is used first, where the cluster that is best separated from other
% clusters is used for separation first. 

if (size(clusters, 2) <= 1)
    guards = [];
    return;
end

guards = cell(size(clusters, 2) - 1, 1);

l = 1:(size(guards, 1)+1);
r = zeros((size(guards, 1) + 1), 1);

for i = 1:size(guards, 1)
    
    % choose the best possible set
    t = cell(length(l), 1);
    err = zeros(length(l), 1);
    for j = 1:length(l)
        posI = clusters(:, l(j));
        negI = any(clusters(:, [l(1:j-1) l(j+1:end)]), 2);
        if(~any(posI & ~negI))
            continue;
        end
        pos = find(posI & ~negI);
        neg = find(~posI & negI);
        t{j} = svmtrain([X(pos, :); X(neg, :)], [ones(size(pos, 1), 1); zeros(size(neg, 1), 1)], 'boxconstraint' , 5);
        err(j) = sum(svmclassify(t{j}, X(pos, :)) == 0) + sum(svmclassify(t{j}, X(neg, :)) == 1);
    end
    [~, p] = min(err);
    r(i) = l(p);
    guards(i) = t(p);
    l(p) = [];
end
r(i+1) = l(1);