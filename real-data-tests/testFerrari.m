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
tsizeVal = zeros(length(bounds), 3);
tsizeDev = zeros(length(bounds), 3);
testRmseVal = zeros(length(bounds), 3);
for i = 1:length(bounds)
    [MosaicData, SVMData, DTreeData] = runFerrari(tcase, bounds(i), iter);
    tsizeVal(i, :) = [mean(MosaicData(:, 1)), mean(SVMData(:, 1)), mean(DTreeData(:, 1))];
    tsizeDev(i, :) = [std(MosaicData(:, 1)), std(SVMData(:, 1)), std(DTreeData(:, 1))];
    testRmseVal(i, :) = [mean(MosaicData(:, 2)), mean(SVMData(:, 2)), mean(DTreeData(:, 2))];
    testRmseLVal(i, :) = [min(MosaicData(:, 2)), min(SVMData(:, 2)), min(DTreeData(:, 2))];
    testRmseUVal(i, :) = [max(MosaicData(:, 2)), max(SVMData(:, 2)), max(DTreeData(:, 2))];
    trainRmseVal(i, :) = [mean(MosaicData(:, 3)), mean(SVMData(:, 3)), mean(DTreeData(:, 3))];
    trainRmseLVal(i, :) = [min(MosaicData(:, 3)), min(SVMData(:, 3)), min(DTreeData(:, 3))];
    trainRmseUVal(i, :) = [max(MosaicData(:, 3)), max(SVMData(:, 3)), max(DTreeData(:, 3))];
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

