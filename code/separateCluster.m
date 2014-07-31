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

function guard = separateCluster(Xpos, Xneg)
% Given a set of positive points, Xpos and negetive points, Xneg, returns an
% implicit representation of a predicate "guard" such that
% "guard" is true on Xpos and false on Xneg.

% IMPLEMENTS genGuard function in the EMSOFT 2014 paper. 

% not used 
relaxCoeff = 0.94;

% Algorithm

% Initialize Sa and Sb.
p = randi(size(Xpos, 1));
n = randi(size(Xneg, 1));

Sa = {[p]};
Sb = {[n]};
guard = genInterpolant(Xpos, Xneg, Sa, Sb);

% set up timeout
start = clock;
TimeOut = 15000; %secs

% debugging counters
countNegetiveSplits = 0;
countPositiveMerges = 0;
countPositiveRemerges = 0;
countPositiveNew = 0;
countPositiveSplits = 0;
countNegetiveMerges = 0;
countNegetiveRemerges = 0;
countNegetiveNew = 0;

str = sprintf('Generating guard \n-------------------');
disp(str);
        

% repeat till a feasible interpolant is found.
while(true)
    % check if it is a valid interpolant.
    resA = checkITPA(guard, Xpos);
    resB = checkITPB(guard, Xneg);
    %if(mean(resA) > relaxCoeff && mean(resB) > relaxCoeff)
    if(all(resA) && all(resB))
        str = sprintf(' # of +ve group splits: %d, merges: %d, new: %d, remerges: %d', countPositiveSplits, countPositiveMerges, countPositiveNew + 1, countPositiveRemerges);
        disp(str);
        str = sprintf(' # of -ve group splits: %d, merges: %d, new: %d, remerges: %d', countNegetiveSplits, countNegetiveMerges, countNegetiveNew + 1, countNegetiveRemerges);
        disp(str);
        fprintf(' # inequalities in guard: %d x %d \n\n', size(guard, 2), size(guard{1, 1}, 1));
        return;
    end
    
    % use randomization to choose between -ve and +ve counterexample.
    coin = rand(1, 1);
    weight = 1 - (sum(~resB)/(sum(~resA) + sum(~resB)));
    if(all(resB))
        coin = 1;
        weight = 0;
    elseif(all(resA))
        coin = 0;
        weight = 1;
    end
    

    % find a counterexample
    if(coin >= weight)
        % positive counterexample
        CEs = find(resA == 0);
        ce = CEs(randi(length(CEs)));
        merged = 0;
        
        % remove elements from Sb, if they are in direct conflict with ce.
        Sb_new = [];
        changed = false;
                
        for i = 1:length(Sb)
            [~, flag]= genInterpolant(Xpos, Xneg, {ce}, Sb(i));
            if(flag ~= 1)
                %split Sb(i) into 2 parts so that an interpolant can be
                %found.
                changed = true;
                
                [idp, idn] = genSplit(Xneg, Xpos, Sb{i}, ce);
                Sb_new = [Sb_new {Sb{i}(idp)}];
                Sb_new = [Sb_new {Sb{i}(idn)}];
                
                countNegetiveSplits = countNegetiveSplits + 1;
            else
                Sb_new = [Sb_new Sb(i)];
            end
        end
        Sb = Sb_new;
        
        if(changed)
            % trying to merge the samplesets in Sa.
            Sa_new = [];
            for i = 1:length(Sa)
                changed = 0;
                for j = (i + 1):length(Sa)
                    S = [Sa{i};Sa{j}];
                    [~, flag]= genInterpolant(Xpos, Xneg, {S}, Sb);
                    if(flag == 1)
                        Sa{j} = S;
                        countPositiveRemerges = countPositiveRemerges + 1;
                        changed = 1;
                        break;
                    end
                end
                if (changed == 0)
                    Sa_new = [Sa_new Sa(i)];
                end
            end
            Sa = Sa_new;
            
            [t_inter, flag] = genInterpolant(Xpos, Xneg, Sa, Sb);
            if(flag ~= 1)
                error('Exception');
                return;
            end
            guard = t_inter;
        end
        
        
        % try merging the counterexample with one of the exisiting regions.
        % Order Sa by the distance from ce
        dist = findDistance(Xpos, Sa, ce);
        [~, distI] = sort(dist);
        for i = distI
            [t_inter, flag]= genInterpolant(Xpos, Xneg, {[Sa{i};ce]}, Sb);
            if(flag == 1)
                countPositiveMerges = countPositiveMerges + 1;
                % raise error if ce already in Sa{i}
                if(any(Sa{i} == ce))
                    error('Exception')
                    return;
                end
                Sa{i} = [Sa{i};ce];
                [t_inter, flag]= genIncrInterpolant(Xpos, Xneg, Sa, Sb, guard, i, 1:length(Sb));
                if(flag ~= 1)
                    error('Exception');
                    return;
                end
                guard = t_inter;
                merged = 1;
                break;
            end
        end
        % if not merged, then create a separate region out of this
        % counterexample if possible.
        if(~merged)
            countPositiveNew = countPositiveNew + 1;
            Sa{end + 1} = [ce];
            [t_inter, flag] = genIncrInterpolant(Xpos, Xneg, Sa, Sb, guard, length(Sa), 1:length(Sb));
            if(flag == 1)
                guard = t_inter;
                merged = 1;
            else 
                error('Exception');
                return;
            end
        end
    else
        % negetive counterexample
        CEs = find(resB == 0);
        %ce = CEs(1);
        ce = CEs(randi(length(CEs)));
        merged = 0;
        
        % remove elements from Sa, if they are in direct conflict with it.
        Sa_new = [];
        changed = false;
        
        for i = 1:length(Sa)
            [~, flag]= genInterpolant(Xpos, Xneg, Sa(i), {ce});
            if(flag ~= 1)
                countPositiveSplits = countPositiveSplits + 1;
                %split Sa(i) into 2 parts so that an interpolant can be
                %found.
                changed = true;
                [idp, idn] = genSplit(Xpos, Xneg, Sa{i}, ce);
                Sa_new = [Sa_new {Sa{i}(idp)}];
                Sa_new = [Sa_new {Sa{i}(idn)}];
            else
                Sa_new = [Sa_new Sa(i)];
            end
        end
        Sa = Sa_new;
        
        if(changed)
            % trying to merge the samplesets in Sb.
            Sb_new = [];
            for i = 1:length(Sb)
                changed = 0;
                for j = (i + 1):length(Sb)
                    S = [Sb{i};Sb{j}];
                    [~, flag]= genInterpolant(Xpos, Xneg, Sa, {S});
                    if(flag == 1)
                        Sb{j} = S;
                        countNegetiveRemerges = countNegetiveRemerges + 1;
                        changed = 1;
                        break;
                    end
                end
                if (changed == 0)
                    Sb_new = [Sb_new Sb(i)];
                end
            end
            Sb = Sb_new;

            [t_inter, flag] = genInterpolant(Xpos, Xneg, Sa, Sb);
            if(flag ~= 1)
                error('Exception');
                return;
            end
            guard = t_inter;
        end
        
        % try merging the counterexample with one of the exisiting regions.
        dist = findDistance(Xneg, Sb, ce);
        [~, distI] = sort(dist);
        for i = distI
            [t_inter, flag]= genInterpolant(Xpos, Xneg, Sa, {[Sb{i};ce]});
            if(flag == 1)
                countNegetiveMerges = countNegetiveMerges + 1;
                if(any(Sb{i} == ce))
                    error('Exception')
                    return;
                end
                Sb{i} = [Sb{i};ce];
                [t_inter, flag]= genIncrInterpolant(Xpos, Xneg, Sa, Sb, guard, 1:length(Sa), i);
                if(flag ~= 1)
                    error('Exception');
                    return;
                end
                guard = t_inter;
                merged = 1;
                break;
            end
        end
        % if not merged, then create a separate region out of this
        % counterexample if possible.
        if(~merged)
            countNegetiveNew = countNegetiveNew + 1;
            Sb{end + 1} = [ce];
            [t_inter, flag] = genIncrInterpolant(Xpos, Xneg, Sa, Sb, guard, 1:length(Sa), length(Sb));
            if(flag == 1)
                guard = t_inter;            
            else 
                error('Exception');
                return;
            end
        end
        
    end
    
    if(etime(clock,start) > TimeOut)
        error('Time out happened before function could complete');
        return;
    end
end
