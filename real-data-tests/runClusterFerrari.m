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

function [clusterData] = runClusterFerrari(tcase, clusterSize, numPlanes, iter)
% Runs test on Ferrari-Trecate data set No. <tcase> assuming given bound
% and repeats it <iter> number of times

load(['../real-data/ferrari/new' num2str(tcase) '.mat']);

a = 2;
b = 2;
N = 2250;

ind = round(linspace(1, length(trace_x), N + max(a, b)));

% generate train data
train_ind = ind(1:(N*2/3 + max(a, b)));
test_ind = ind(N*2/3 + 1:end); 

U = trace_y(3,train_ind)';
Y = trace_y(2,train_ind)';

trainI = zeros(N*2/3, a + b);
for k = 1:a
    trainI(:, k) = Y((max(a, b) + 1 - k):(end - k) );
end

for k = 1:b
    trainI(:, k + a) = U((max(a, b) + 2 - k):(end - k + 1));
end
trainZ = Y(max(a, b) + 1:end);

% generate test data
U = trace_y(3,test_ind)';
Y = trace_y(2,test_ind)';
testI = zeros(N*1/3 , a + b);
for k = 1:a
    testI(:, k) = Y((max(a, b) + 1 - k):(end - k) );
end

for k = 1:b
    testI(:, k + a) = U((max(a, b) + 2 - k):(end - k + 1));
end
testZ = Y(max(a, b) + 1:end);


% run tests
clusterData = [];
for j = 1:iter
    
    %%%%%%%%% Compare with 3rd technique %%%%%%%%%%%%%%%
    try
        [H, C] = genSimpleHyperplanes( trainI, trainZ, clusterSize, numPlanes); 
    catch
        continue;
    end

    % Compare with other technique
    guards = getSimpleConditionals3(trainI, C);

    trainZ1 = getSimpleLearntFVal(guards, H, trainI);
    testZ1 = getSimpleLearntFVal(guards, H, testI);

    train_rmse = sqrt(mean((trainZ-trainZ1).^2));
    test_rmse = sqrt(mean((testZ-testZ1).^2));

    tsize = size(guards, 1);
    for m = 1:size(guards, 1)
        if(isempty(guards{m}))
            continue;
        end
        x = guards{m};
        tsize = tsize + length(x) + 1;
    end
    
    clusterData = [clusterData; tsize, test_rmse, train_rmse];
end

