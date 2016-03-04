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

function guards = getDTreeConditionals(X, clusters)
% X represents the input vector for each point. 
% clusters is a matrix where (i, j)th entry is 1, if ith point in X is
%   covered by jth affine function otherwise it is 0.

% guards: It is a (k-1) length cell array. 
%   Each cell corresponds to a guard g.
%   It consists of m cells and g is a disjunction of predicates
%   represented by each cell. 
%   Each cell in g in turn is a matrix of size n x (D+1) and represents a
%   conjunction of n affine inequalities. Each row in the matrix represents
%   the coefficients of an affine inequality, 
%   i.e. if the ith row is (c_1, c_2, c_3, .. c_D, c_(D+1)), then the
%   corresponding inequality is 
%       c_1.x_1 + c_2.x_2 + .. + c_D.x_D + c_(D+1) <= 0.
%   In all, each guard has (m x n) inequalities and is a disjunction of m
%   disjuncts where each disjunct is a conjunction of n conjuncts. 


% IMPLEMENTS the second part of genPiecewiseAffineModel in EMSOFT 2014 paper.

if (size(clusters, 2) <= 1)
    guards = [];
    return;
end

% initialize guards cell array. 
guards = cell(size(clusters, 2) - 1, 1);
Y = zeros(size(X, 1), 1);


for i = 1:size(guards, 1)
    posI = clusters(:, i);
    negI = any(clusters(:, (i+1):end), 2);
    if(~any(posI & ~negI))
        continue;
    end
    
    Y(posI & ~negI) = 1;
    Y(~posI & negI) = 0;
    Y(posI & negI| ~posI & ~negI) = NaN;
    
    % learn ith guard. 
    guards{i} = fitctree(X,Y);
    
    % remove points on which guard(i) is true
    for j = 1:size(X, 1)
        c = guards{i};
        flag = predict(c, X(j, :));
        if(flag)
            clusters(j, :) = zeros(1, size(clusters, 2));
        end
    end
    
end