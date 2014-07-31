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

function [H, flag]= genHalfInterpol(A, B)
% This function takes in two sets of points A and B (non-padded)


% Generates a half plane x.i <= 1. Where each point a in A lies in the non-positive region, 
% i.e. a.i <= 1
% and each point b in B lies in the non-negetive region.
% i.e b.i > 1, or -b.i < -1

% H: ix - 1 <= 0
% TODO handle strict inequalities.

k = -1;

X = [A; -1.*B];
X = [X [ones(size(A, 1), 1); -1*ones(size(B, 1), 1)]];
y = [k*ones(size(A, 1), 1); (k*ones(size(B, 1), 1))];
f = zeros(size(X, 2), 1);

options = optimoptions('linprog','MaxIter',100000, 'Algorithm', 'simplex');


% check if H is feasible
% using evalc to supress linprog output. 
evalc('[H, ~, flag] = linprog(f, X, y, [], [], -inf*ones(size(X, 2), 1), inf*ones(size(X, 2), 1), [], options);');

