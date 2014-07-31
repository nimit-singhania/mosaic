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

function [ guards, r ] = getSimpleConditionals3(X, clusters)
% This learns an affine inequality for every pair of clusters and returns a
% combination of these. Better than both getSimpleConditionals and
% getSimpleConditionals2. 

% IMPLEMENTS guard generation for Ferrari-Trecate comparison in EMSOFT 2014
% paper.

if (size(clusters, 2) <= 1)
    guards = [];
    return;
end

guards = cell(size(clusters, 2) - 1, 1);
r = 1:size(clusters, 2);

for i = 1:size(guards, 1)
    posI = clusters(:, i);
    sp = [];
    for j = (i+1):size(clusters, 2)
        negI = clusters(:, j);
        if(~any(posI & ~negI))
            continue;
        end
        pos = find(posI & ~negI);
        neg = find(~posI & negI);
        options = statset();
        options.MaxIter = 300000;
        sp = [sp; svmtrain([X(pos, :); X(neg, :)], [ones(size(pos, 1), 1); zeros(size(neg, 1), 1)],  'boxconstraint' , 5, 'options', options)];
    end
    guards{i} = sp;
end