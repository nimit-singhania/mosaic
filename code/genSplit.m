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

function [idp, idn] = genSplit(Xout, Xin, pset, p)
% Given a set of points Xout(pset, :) and another point, Xin(p, :), the
% goal is to find a split of points given by indices pset into idp and idn
% such that Xout(idp, :) and Xout(idn, :) is linearly separable from Xin(p,
% :).

% IMPLEMENTS spliting of groups in genGuard in EMSOFT 2014 paper.

idp = [];
idn = [];
points = [Xout(pset, :) ones(size(pset, 1), 1)];
point = [ Xin(p, :), 1];

if(length(pset) <= 1)
    error('Exception in genSplit');
end

c = pca(points);
c = c(:, 1);
h = [c(1:end -1); c(end)-point*c];
idp = find(points*h > 0);
idn = find(points*h < 0);

counter = 0;
while ((isempty(idp) || isempty(idn)) && (length(idp) + length(idn) ~= size(points, 1)) && counter < 10000)
    c = rand(length(point), 1);
    %c = pca(points);
    c = c(:, 1);
    h = [c(1:end -1); c(end)-point*c];
    idp = find(points*h > 0);
    idn = find(points*h < 0);
    counter = counter + 1;
end

if(counter >= 10000)
    error('Exception in genSplit');
end

end