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
%-------------------------------------------------------------------------

% run tests on different synthetic functions. 

% Calls testModel on different functions for different values of N (number
% of train points)

% saves results in ../stats/<fun_name>.mat. 
% Result includes a value matrix valM and standard deviation matrix stdM.
% Each matrix has columns : size n time rmse abse
% Each matrix has rows corresponding to different values of N.
% Can be used by plotN.m and plotSize.m to generate plots. 

range = 2000;
D = [5, 5, 5, 10];
N = [500, 1000, 2000, 5000, 10000];
testN = 20000;
fun = {@f1, @f2, @f3, @g};
funName = {'f1', 'f2', 'f3', 'g'};
bound = 0.1;
noise = 0.001;
iter = 5;

for i = 1:length(D)
    valM = [];
    devM = [];
    for j = 1:length(N)
        [statVal, statDev] = testModel(fun{i}, range, N(j), D(i), bound, noise, testN, iter);
        valM = [valM; statVal];
        devM = [devM; statDev];
    end
    save(['../stats/' funName{i} '_stats.mat'], 'valM', 'devM', 'N');
end

%%
range = 2000;
D = [3, 4, 3];
N = [500, 1000, 2000, 5000, 10000];
testN = 20000;
fun = {@p, @q, @r};
funName = {'p', 'q', 'r'};
bound = 0.1;
noise = 0.001;
iter = 5;

for i = 1:length(D)
    valM = [];
    devM = [];
    for j = 1:length(N)
        [statVal, statDev] = testModel(fun{i}, range, N(j), D(i), bound, noise, testN, iter);
        valM = [valM; statVal];
        devM = [devM; statDev];
    end
    save(['../stats/' funName{i} '_stats.mat'], 'valM', 'devM', 'N');
end
