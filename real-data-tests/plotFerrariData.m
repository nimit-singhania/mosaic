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

function [] = plotFerrariData(tcase)
load(['../stats/ferrari_' int2str(tcase) '_stats.mat']);

figure
hold on;

[~, ind] = sort(bounds);
s1 = errorbar(bounds(ind), testRmseVal(ind, 1), testRmseVal(ind, 1) - testRmseLVal(ind, 1), testRmseUVal(ind, 1) - testRmseVal(ind, 1), 'Marker', 'x','markersize', 10, 'LineWidth',1.5);
s2 = errorbar(bounds(ind), testRmseVal(ind, 2), testRmseVal(ind, 2) - testRmseLVal(ind, 2), testRmseUVal(ind, 2) - testRmseVal(ind, 2), 'r', 'Marker', '+','markersize', 10, 'LineWidth',1.5);

range = linspace(min(bounds), max(bounds), length(clusterData(:, 4)));
range = range + 0.005;
scatter(range, clusterData(:, 4), 'k', 'Marker', 'o', 'LineWidth',1.5);

% r1 = plot(bounds(ind), trainRmseVal(ind, 1), '--','Marker', 'x', 'LineWidth',1.1);
% r2 = plot(bounds(ind), trainRmseVal(ind, 2), 'r--', 'Marker', '+', 'LineWidth',1.1);

r1 = errorbar(bounds(ind), trainRmseVal(ind, 1), trainRmseVal(ind, 1) - trainRmseLVal(ind, 1), trainRmseUVal(ind, 1) - trainRmseVal(ind, 1), '--','Marker', 'x', 'LineWidth',1.1);
r2 = errorbar(bounds(ind), trainRmseVal(ind, 2), trainRmseVal(ind, 2) - trainRmseLVal(ind, 2), trainRmseUVal(ind, 2) - trainRmseVal(ind, 2), '--r', 'Marker', '+', 'LineWidth',1.1);
scatter(range, clusterData(:, 5), 20, 'k', 'Marker', 'd', 'LineWidth',0.8);

pbaspect([3 2 1])
legend('mosaic test', 'linear test', 'cluster test', 'mosaic train', 'linear train', 'cluster train');

%xlabel('Error bounds \delta');
%ylabel('Test Root Mean Square Error');
xlhand = get(gca,'xlabel');
set(xlhand,'string','Error bound \delta','fontsize',15, 'FontWeight', 'bold')
ylhand = get(gca,'ylabel');
set(ylhand,'string',['RMSE for Data-set ' int2str(tcase)],'fontsize',15, 'FontWeight', 'bold')

set(gca,'yscale','log');
print('-dpsc2',['../plots/ferrari_' int2str(tcase) '_rmse.eps']);
hold off;

figure
hold on;
sizeMat = [tsizeVal(ind, 1), tsizeVal(ind, 2)]';
hb = bar(1:length(bounds), sizeMat');
stdMat = [tsizeDev(ind, 1), tsizeDev(ind, 2)]';

for ib = 1:numel(hb)
      % Find the centers of the bars
      xData = get(get(hb(ib),'Children'),'XData');
      barCenters = mean(unique(xData,'rows'));
      errorbar(barCenters,sizeMat(ib,:),stdMat(ib,:),'k.')
end

pbaspect([3 2 1])
legend(hb, 'mosaic', 'linear', 'Location', 'NorthEast');

xlhand = get(gca,'xlabel');
set(xlhand,'string','Error bound \delta','fontsize',15, 'FontWeight', 'bold')
ylhand = get(gca,'ylabel');
set(ylhand,'string',['Size for Data-set ' int2str(tcase)],'fontsize',15, 'FontWeight', 'bold')

set(gca,'XTick',1:length(bounds))
set(gca,'XTickLabel',bounds)
hold off;
print('-dpsc2',['../plots/ferrari_' int2str(tcase) '_size.eps']);

