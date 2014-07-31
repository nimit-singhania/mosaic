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

function [ H, guards ] = genPiecewiseAffineModel( I, Z, bound )
% H : set of affine functions learnt from the data
% guards : set of guards for the affine functions
% I : input values of data points (N x D)
% Z : output values of data points (N x 1) 
% bound : the error allowed on the learnt model

% I: It represents the input data. It is a matrix of size (N x D), where N  
%   is the number of points and D is the input dimension. ith row in the
%   matrix correponds to input values of ith point in the data. 

% Z: It represents the output data. ith value in the vector represents
%   output value of the ith point in the data

% H : It is a (k x (D+1)) matrix, where k is the number of affine functions
%   found by the tool and D is the dimension of input. ith row in the
%   matrix represents an affine function.
%   i.e. if the ith row is (c_1, c_2, c_3, .. c_D, c_(D+1)), then the
%   corresponding affine function is 
%       c_1.x_1 + c_2.x_2 + .. + c_D.x_D + c_(D+1)

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

[H] = genHyperplanes(I, Z, bound);
[H, C] = getClusterAssignment(I, H, Z, bound);
guards = genConditionals(I, C);
Z1 = getValue(guards, H, I);
v = abs(Z - Z1) > bound;
if(any(v))
    disp('FAILED: Uncovered points found');
else
    disp('SUCCES: All points covered by the learnt model');
end

