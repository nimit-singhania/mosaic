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

function [] = testFerrari(tcase, bounds, clusterSize, numPlanes)
% Executes tests on real data and collects statistics

iter = 15;
tsizeVal = zeros(length(bounds), 2);
tsizeDev = zeros(length(bounds), 2);
testRmseVal = zeros(length(bounds), 2);
for i = 1:length(bounds)
    [synergyData, impreciseData] = runFerrari(tcase, bounds(i), iter);
    tsizeVal(i, :) = [mean(synergyData(:, 1)), mean(impreciseData(:, 1))];
    tsizeDev(i, :) = [std(synergyData(:, 1)), std(impreciseData(:, 1))];
    testRmseVal(i, :) = [mean(synergyData(:, 2)), mean(impreciseData(:, 2))];
    testRmseLVal(i, :) = [min(synergyData(:, 2)), min(impreciseData(:, 2))];
    testRmseUVal(i, :) = [max(synergyData(:, 2)), max(impreciseData(:, 2))];
    trainRmseVal(i, :) = [mean(synergyData(:, 3)), mean(impreciseData(:, 3))];
    trainRmseLVal(i, :) = [min(synergyData(:, 3)), min(impreciseData(:, 3))];
    trainRmseUVal(i, :) = [max(synergyData(:, 3)), max(impreciseData(:, 3))];
end

clusterData = [];
for j = 1:length(clusterSize)
    for k = 1:length(numPlanes)
        [d] = runClusterFerrari(tcase, clusterSize(j), numPlanes(k), 3);
        if(size(d, 1) > 0) 
            clusterData = [clusterData; clusterSize(j), numPlanes(k), mean(d, 1)];
        end
    end
end

save(['../stats/ferrari_' int2str(tcase) '_stats.mat'], 'bounds', 'tsizeVal', 'tsizeDev', 'testRmseVal', 'testRmseLVal', 'testRmseUVal', 'trainRmseVal', 'trainRmseLVal', 'trainRmseUVal', 'clusterData');

