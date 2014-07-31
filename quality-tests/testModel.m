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

function [statVal, statDev] = testModel(fun, range, N, D, bound, noise, testN, iter)
% Given a function handle fun, 
%      - it randomly generates some test data 
%      - repeatedly learns a model using some randomaly generated data
%      - computes the performance of learnt model on test data

% fun: handle to the function from which data is generated
% range : Range of values of each input dimension
% N : Number of data points
% D : Input dimension of the function
% bound : Bound on the error of the learnt model
% noise : Amount of noise to be added to the generated data
% testN : No. of test data points
% iter : No. of times to repeat.

% statVal and statDev store the mean values and standard deviation of 
%       size of model, 
%       percentage of tests points with error > bound,
%       time taken to learn the model
%       test root mean square error
%       test absolute error


rmseVal = 0;
abseVal = 0;
nVal = 0;
timeVal = 0;
sizeVal = 0;

rmseStd = 0;
abseStd = 0;
nStd = 0;
timeStd = 0;
sizeStd = 0;

% generate random test data
trange = range;
testI = rand(testN, D)*trange - trange/2;
testZ = zeros(size(testI, 1), 1);
    
for j=1:size(testI, 1)
    testZ(j) = fun(testI(j, :));
end

for k = 1:iter
    % Learn model and evaluate it on test data
    [H, guards, time] = learnModel(fun, D, range, N, bound, noise);
    testZ1 = getValue(guards, H, testI);
                
    rmseVal = rmseVal + sqrt(mean((testZ - testZ1).^2));
    abseVal = abseVal + mean(abs(testZ - testZ1));
    nVal = nVal + length(find(abs(testZ - testZ1) > bound));
    timeVal = timeVal + time;

    rmseStd = rmseStd + (sqrt(mean((testZ - testZ1).^2)))^2;
    abseStd = abseStd + (mean(abs(testZ - testZ1)))^2;
    nStd = nStd + (length(find(abs(testZ - testZ1) > bound)))^2;
    timeStd = timeStd + (time)^2;
                
    tsize = sizeModel(guards);
    
    sizeVal = sizeVal + tsize;
    sizeStd = sizeStd + (tsize)^2;
end
rmseVal = rmseVal/iter;
abseVal = abseVal/iter;
nVal = nVal*100/(iter*testN);
timeVal = timeVal/iter;
sizeVal = sizeVal/iter;

rmseStd = sqrt(rmseStd/iter - (rmseVal)^2);
abseStd = sqrt(abseStd/iter - (abseVal)^2);
nStd = sqrt(nStd*(100/testN)^2/(iter) - nVal^2);
timeStd = sqrt(timeStd/iter - timeVal^2);
sizeStd = sqrt(sizeStd/iter - sizeVal^2);
           
statVal= [sizeVal nVal timeVal rmseVal abseVal];
statDev = [sizeStd nStd timeStd rmseStd abseStd];
end
