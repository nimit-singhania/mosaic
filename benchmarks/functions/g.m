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

function  [z] = g( x )
%g : a function with 8 conditionals and 10 dimensions

if (4*x(1) > 5*x(5) ) 
    z = x(2) + x(3) + x(8);
elseif (x(2) - 10*x(3) + 11*x(1) < 10)
    z = x(3) + x(5) + 5  + x(9);
elseif (x(3) + 2*x(4) + 3*x(5) < x(1) + x(2))
    z = x(2)*6 + x(1)*5 + 1 ;
elseif (x(10)*22 + x(9)*18 - x(8)*3 + x(2)*10 > 53)
    z = x(1)*100 - x(7)*52 + x(9)*3 - x(4)*10 + x(5)*13;
elseif (x(3)*13 + x(6)*19 - x(2)*261 > 363)
    z = x(5)*100 + x(6)*10 - x(1)*1000 + x(10);
elseif (x(2) + x(6) + x(3) > 35)
    z = x(2)*6 + x(1)*5 + 1 ;
elseif (x(5) - x(10) + 55*x(3) < x(2)*100)
    z = x(3) + x(5) + 5  + x(9);
else
    z = 1000;
end
