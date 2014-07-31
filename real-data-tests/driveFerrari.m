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

clear

clusterSize = [70, 40, 25, 10];
numPlanes = [2, 4, 8, 12];

bounds = [0.05, 0.08, 0.10, 0.13, 0.15, 0.17, 0.2];
tcase = 1;
testFerrari(tcase, bounds, clusterSize, numPlanes)
plotFerrariData(tcase);

bounds = [0.1, 0.15, 0.2, 0.25, 0.3, 0.4, 0.5];
tcase = 2;
testFerrari(tcase, bounds, clusterSize, numPlanes)
plotFerrariData(tcase);

bounds = [0.12, 0.20, 0.3, 0.4, 0.5, 0.6, 0.7];
tcase = 4;
testFerrari(tcase, bounds, clusterSize, numPlanes)
plotFerrariData(tcase);

bounds = [0.1, 0.15, 0.2, 0.25, 0.3, 0.4, 0.5];
tcase = 3;
testFerrari(tcase, bounds, clusterSize, numPlanes)
plotFerrariData(tcase);

