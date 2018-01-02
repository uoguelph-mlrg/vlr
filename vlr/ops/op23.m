% [IF] = op23(I,filtfun,W)
% 
% OP23 filters a 3D image I using the 2D image filtering function filtfun in a
%   single operation (using reshaping). This speeds up the application of 
%   nonlinear filters on 3D volumes by not processing slices in serial.
% 
% Inputs:
%   I       - 3D image volume for filtering.
% 
%   filtfun - filter function which only accepts 2D inputs. 
%   
%   wid     - (optional) padding width to avoid mixing data from adjacent
%             slices; only important if I contains information near the edges.
%             Padding style: replicate. Default wid: 0 (no padding).
% 
% Outputs:
%   IF  - filtered image.
%
% Examples:
% 
%   >> op23(randn(10,10,10),@(I)medfilt2(I,[5,5]),2);
%   Show a random 10x10x10 volume of data with the default figure colourmap,
%   automatic contrast scaling, with 0.5% of total figure size padded around.
% 
% Jesse Knight 2016

function [IF] = op23(I,filtfun,wid)
if nargin == 2
  wid = 0; % default: no padding
end
i3size = size(I);
ipsize = i3size + [0,2*wid,0];
i2size = [ipsize(1),ipsize(2)*ipsize(3)];
% pad along x, then reshape (append along x)
I2  = reshape(padarray(I,[0,wid,0],'replicate','both'),i2size);
% median filter (MEX), then reshape (unwrap x -> z)
IF = reshape(filtfun(I2),ipsize);
% unpad
IF = IF(:,wid+1:end-wid,:);



