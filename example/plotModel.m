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

function plotModel( X, guards )
% plots the model assuming input is in 2 dimensions
% plots points with color based on which affine function was assigned to
% them. 
% plots the affine inequalities in guards, with different color for
% inequalities of each guard

figure;
mode = getMode( guards, X );
cmap = hsv(max(mode) + size(guards, 1));
hold on

% plot points 
for i = 1:max(mode)
    ind = find(mode == i);
    plot(X(ind, 1), X(ind, 2), '+', 'Color',cmap(i + size(guards, 1),:), 'markersize', 7, 'LineWidth',2);
end

% plot affine inequalities in the guards. 
% each guard is assigned a unique color. 
Xs = [min(X(:, 1));max(X(:, 1))];
Ys = [min(X(:, 2));max(X(:, 2))];

for j = 1:size(guards, 1)
    hps = guards{j};
    for l = 1:size(hps, 2)
        h = hps{1, l};
        for k = 1:size(h, 1)
            Yr = -(h(k, 1)*Xs + (h(k, 3)))/h(k, 2);
            ind = find(Yr >= Ys(1) & Yr <= Ys(2));
            p = [Xs(ind) Yr(ind)];

            Xr = -(h(k, 2)*Ys + (h(k, 3)))/h(k, 1);
            ind = find(Xr >= Xs(1) & Xr <= Xs(2));
            p = [p; [Xr(ind) Ys(ind)]];

            plot(p(:, 1), p(:, 2), '-', 'Color',cmap(j,:))

        end
    end
end

set(gca,'FontSize', 15);
axis([min(X(:, 1)) max(X(:, 1)) min(X(:, 2)) max(X(:, 2))])
box on;

xlabel('x_1');
ylabel('x_2');

pbaspect([1 1 1])

hold off