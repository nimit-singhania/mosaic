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


asize = [10, 10, 11, 19, 0, 0, 0];
funName = {'f1','f2','f3','g', 'p', 'q', 'r'};
M = [500, 1000, 2000, 5000, 10000];
stdMat = [];
sizeMat = [];

for k = 1:length(funName)
   load( ['../stats/' funName{k} '_stats.mat']);
   sizeMat = [sizeMat valM(:, 1)];
   stdMat = [stdMat devM(:, 1)];
end

figure
hold on;
hb = bar(1:length(funName), sizeMat');
%stdMat = [zeros(1, length(funName)); stdMat];

colors = colormap;

for ib = 1:numel(hb)
      % Find the centers of the bars
      xData = get(get(hb(ib),'Children'),'XData');
      barCenters = mean(unique(xData,'rows'));
      errorbar(barCenters,sizeMat(ib,:),stdMat(ib,:),'k.')
end

pbaspect([3 2 1])

legend(hb, '500 points', '1000 points', '2000 points', '5000 points', '10000 points', 'Location', 'NorthWest');

%xlabel('Functions');
%ylabel('Size of learnt function');
xlhand = get(gca,'xlabel');
set(xlhand,'string','Functions','fontsize',15)
ylhand = get(gca,'ylabel');
set(ylhand,'string','Size of learnt model','fontsize',15)

set(gca,'XTick', 1:length(funName))
set(gca,'XTickLabel',funName)
set(gca,'yscale','log');
print('-dpsc2','../plots/quality_size.eps');
