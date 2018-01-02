% This function is equivalent to ksdensity, except that repetitive overhead is
% removed (which otherwise accounts for ~0.5 the runtime).
% Some hard-coded parameters: [0,1] input data range and support

function [px] = ksd(X,xi,kfcn,wid)
% minimal function calls...

N = numel(X(:));
kcut = 3;
px = compute_pdf_cdf(xi, 1, 100, -Inf, +Inf, ones(1,N)./N, ...
                    kfcn, kcut, 0, wid, X(:), Inf);
% p = compute_pdf_cdf([0,1], 1, 100, -Inf, Inf, ones(1,N)./N, ...
%                     kfcn, kcut, 0, wid, X(:), Inf);

% everything else is stolen from "statkscompute"

% -----------------------------
function [fout,xout,u]=compute_pdf_cdf(xi,xispecified,m,L,U,weight,...
                          kernel,cutoff,iscdf,u,ty,foldpoint)

foldwidth = min(cutoff,3);
issubdist = isfinite(foldpoint);
if ~xispecified
    xi = compute_default_xi(ty,foldwidth,issubdist,m,u,U,L);
elseif ~isvector(xi)
    error('stats:ksdensity:VectorRequired','XI must be a vector');
end

% Compute transformed values of evaluation points that are in bounds
xisize = size(xi);
fout = zeros(xisize);
if iscdf && isfinite(U)
    fout(xi>=U) = sum(weight);
end
xout = xi;
xi = xi(:);
if L==-Inf && U==Inf   % unbounded support
    inbounds = true(size(xi));
    txi = xi;
elseif L==0 && U==Inf  % positive support
    inbounds = (xi>0);
    xi = xi(inbounds);
    txi = log(xi);
    foldpoint = log(foldpoint);
else % finite support [L, U]
    inbounds = (xi>L) & (xi<U);
    xi = xi(inbounds);
    txi = log(xi-L) - log(U-xi);
    foldpoint = log(foldpoint-L) - log(U-foldpoint);
end

% If the density is censored at the end, add new points so that we can fold
% them back across the censoring point as a crude adjustment for bias.
if issubdist
    needfold = (txi >= foldpoint - foldwidth*u);
    txifold = (2*foldpoint) - txi(needfold);
    nfold = sum(needfold);
else
    nfold = 0;
end

% Compute kernel estimate at the requested points
f = dokernel(iscdf,txi,ty,u,weight,kernel,cutoff);

% If we need extra points for folding, do that now
if nfold>0
    % Compute the kernel estimate at these extra points
    ffold = dokernel(iscdf,txifold,ty,u,weight,kernel,cutoff);
    if iscdf
        % Need to use upper tail for cdf at folded points
        ffold = sum(weight) - ffold;
    end

    % Fold back over the censoring point
    f(needfold) = f(needfold) + ffold;
    
    if iscdf
        % For cdf, extend last value horizontally
        maxf = max(f(txi<=foldpoint));
        f(txi>foldpoint) = maxf;
    else
        % For density, define a crisp upper limit with vertical line
        f(txi>foldpoint) = 0;
        if ~xispecified
            xi(end+1) = xi(end);
            f(end+1) = 0;
            inbounds(end+1) = true;
        end
    end
end


if iscdf
    % Guard against roundoff.  Lower boundary of 0 should be no problem.
    f = min(1,f);
else
    % Apply reverse transformation and create return value of proper size
    f = f(:) ./ u;
    if L==0 && U==Inf   % positive support
        f = f ./ xi;
    elseif U<Inf        % bounded support
        f = f * (U-L) ./ ((xi-L) .* (U-xi));
    end
end
fout(inbounds) = f;
xout(inbounds) = xi;

% -----------------------------
function xi = compute_default_xi(ty,foldwidth,issubdist,m,u,U,L)
% Get XI values at which to evaluate the density

% Compute untransformed values of lower and upper evaluation points
ximin = min(ty) - foldwidth*u;
if issubdist
    ximax = max(ty);
else
    ximax = max(ty) + foldwidth*u;
end

if L==0 && U==Inf    % positive support
    ximin = exp(ximin);
    ximax = exp(ximax);
elseif U<Inf         % bounded support
    ximin = (U*exp(ximin)+L) / (exp(ximin)+1);
    ximax = (U*exp(ximax)+L) / (exp(ximax)+1);
end

xi = linspace(ximin, ximax, m);

% -----------------------------
function f = dokernel(iscdf,txi,ty,u,weight,kernel,cutoff)
% Now compute density estimate at selected points
blocksize = 3e4;
m = length(txi);
n = length(ty);

if n*m<=blocksize && ~iscdf
    % For small problems, compute kernel density estimate in one operation
    z = (repmat(txi',n,1)-repmat(ty,1,m))/u;
    f = weight * feval(kernel, z);
else
    % For large problems, try more selective looping

    % First sort y and carry along weights
    [ty,idx] = sort(ty);
    weight = weight(idx);

    % Loop over evaluation points
    f = zeros(1,m);

    if isinf(cutoff)
        for k=1:m
            % Sum contributions from all
            z = (txi(k)-ty)/u;
            f(k) = weight * feval(kernel,z);
        end
    else
        % Sort evaluation points and remember their indices
        [stxi,idx] = sort(txi);

        jstart = 1;       % lowest nearby point
        jend = 1;         % highest nearby point
        halfwidth = cutoff*u;
        for k=1:m
            % Find nearby data points for current evaluation point
            lo = stxi(k) - halfwidth;
            while(ty(jstart)<lo && jstart<n)
                jstart = jstart+1;
            end
            hi = stxi(k) + halfwidth;
            jend = max(jend,jstart);
            while(ty(jend)<=hi && jend<n)
                jend = jend+1;
            end
            nearby = jstart:jend;

            % Sum contributions from these points
            z = (stxi(k)-ty(nearby))/u;
            fk = weight(nearby) * feval(kernel,z);
            if iscdf
                fk = fk + sum(weight(1:jstart-1));
            end
            f(k) = fk;
        end

        % Restore original x order
        f(idx) = f;
    end
end

              