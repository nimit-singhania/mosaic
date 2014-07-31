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

function [H]= genHyperplanes(X, y, err_bound)
% generates a set of affine functions that pass through given points X and y
% X is padded to take care of constant coefficients.

% H : It is a (k x (D+1)) matrix, where k is the number of affine functions
%   found by the tool and D is the dimension of input. ith row in the
%   matrix represents an affine function.
%   i.e. if the ith row is (c_1, c_2, c_3, .. c_D, c_(D+1)), then the
%   corresponding affine function is 
%       c_1.x_1 + c_2.x_2 + .. + c_D.x_D + c_(D+1)


% IMPLEMENTS the first part of genPiecewiseAffineModel in EMSOFT 2014 paper

H = [];
X = [X ones(size(X, 1), 1)];
ind = ones(size(X, 1), 1);

disp('Generating affine functions');
disp('---------------------------');
while (any(ind))
    h = genApproxHyperplane(X(find(ind), :), y(find(ind)), err_bound); % generate hyperplane
    I = X*h - y; % compute points that pass through these hyperplanes.
    I = abs(I) > err_bound;
    
    % remove points lying on h
    ind = ind & I;
    
    H = [H;h'];
end
%H = H(2:size(H,1), :);

disp(['# of affine functions generated: ', int2str(size(H, 1))]);
disp(' ');