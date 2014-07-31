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

clear;

% generate input points for the example
X = -30:10:30;
Y = -30:10:30;
Y = Y';
n = size(X);
X = repmat(X, [n, 1]);
Y = repmat(Y, [n, 1])';
Y = Y(:);
I = [X', Y];

% assign output values. 
Z = zeros(size(I, 1), 1);
for j=1:size(I, 1)
    Z(j) = example(I(j, 1), I(j, 2));
end
bound = 0.00001;

%learn piecewise affine model
[H, guards] = genPiecewiseAffineModel(I, Z, bound);

% get output from the model
Z1 = getValue(guards, H, I);

% check if any points are outside the given bound. 
v = abs(Z - Z1) > bound;
fprintf('# of uncovered points : %d \n', sum(v));

% plot Input-Output Data
plotValues;

% plot Model and guard assignments to points.
plotModel(I, guards);
