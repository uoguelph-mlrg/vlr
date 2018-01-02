% TIMSHOW is a flexible function for displaying multiple images tightly on the
%         same figure. Padding between images, grid dimensions, contrast scale, 
%         and colourmaps can be specified. Attributes apply to all images. Best
%         results with same sized images. Grayscale or colour images.
% 
% Input: (any order, all optional except at least one image)
%    image(s)  - any number of 2D grayscale or colour images. Rendered in the
%                order they are presented, top to bottom, left to right. 
%                * The x-dimension of any image should not have a size of 3,
%                  else it will be confused for a colourmap.
% 
%    minmax    - minmax specification for contrast scaling, as in imshow(I,[]).
%                array of size: 1 by 2, or a empty array: []. Applies to all
%                images equally.
%                Default: [] (image-adaptive)
% 
%    colourmap - colourmap used for displaying images:
%                array of size: M by 3 or a colourmap function
%                Default: curent default figure colormap
% 
%    padval    - decimal value on the interval (0, 0.5) dictating the padded
%                spacing between images (relative to figure size).
%                Default: 0.005 (0.5%)
% 
%    gridstr   - string like "5x2", specifying the number of images to tile
%                horizontally (5) and vertically (2)
%                Default: square as possible based on num. images, wider bias
% 
%    maxwid    - string like "w800", specifying the maximum width of the figure
%                (overrides maxht).
%                Default: 0.9*screenwidth
% 
%    maxht     - string like "h300", specifying the maximum height of the figure
%                (overrides maxwid).
%                Default: 0.9*screenheight
% 
%              * if 2+ non-image arguments are given, only the last one is used.
% 
% Output arguments: 
%    axes      - handles to all subplot axes.
%                * only returned on nargout == 1
% 
% Examples:
% 
%    timshow(randn(10,10));
%                Show a random 10x10 image of data with the default figure
%                colourmap, automatic contrast scaling, with 0.5% of total
%                figure size padded around.
% 
%    timshow(I1, I2, I3, I4, hot, 0, [0,1], '4x1');
%                Show images I1, I2, I3, I4 using the hot colourmap, with no
%                space between, contrast from 0 to 1, and in a horizontal line.
% 
% Jesse Knight 2016

function [varargout] = timshow(varargin)
[data] = parseargs(varargin);
[data] = initaxes(data);
[data] = showims(data);
if nargout == 1
  varargout{1} = data.ax;
end
  
function [data] = parseargs(vargs)
screensize = get(0,'screensize');
% default values
data.img       = [];
data.minmax    = [];
data.colourmap = get(0,'defaultfigurecolormap');
data.pad       = 0.005;
data.maxwid    = 0.9*screensize(3);
data.maxht     = 0.9*screensize(4);

% handle input arguments based on dimensions / attributes
for v = 1:numel(vargs)
    sizev = size(vargs{v});
    % padval
    if (numel(sizev) == 2) && (all(sizev == [1,1])) && (vargs{v} < 0.5)
        data.pad = vargs{v};
    % gridstr
    elseif ischar(vargs{v}) && numel(sscanf(vargs{v},'%dx%d')) == 2
        xy = sscanf(vargs{v},'%dx%d');
        data.nSubx = xy(1);
        data.nSuby = xy(2);
    % maxwid
    elseif ischar(vargs{v}) && numel(sscanf(vargs{v},'w%d')) == 1
        data.maxwid = sscanf(vargs{v},'w%d');
        data.maxht  = inf;
    % maxht
    elseif ischar(vargs{v}) && numel(sscanf(vargs{v},'h%d')) == 1
        data.maxht  = sscanf(vargs{v},'h%d');
        data.maxwid = inf;
    % colourmap
    elseif sizev(2) == 3
        data.colourmap = vargs{v};
    % minmax (numerical)
    elseif (numel(sizev) == 2) && (all(sizev == [1,2]))
        data.minmax = vargs{v};
    % minmax ([])
    elseif sizev(1) == 0
        data.minmax = [];
    % image
    elseif (numel(sizev) == 2) || (numel(sizev) == 3 && sizev(3) == 3)
        data.img(end+1).data  = vargs{v};
        data.img(end).size    = size(data.img(end).data);
    % argument not recognized: ignoring
    else
        warning(['Ignoring argument number ',num2str(v),'.']);
    end
end
assert(size(data.img,1) ~= 0,'Must give at least one image.');

function [data] = initaxes(data)
% optimize display grid square-ish if not user specified
data.N = numel(data.img);
if ~all(isfield(data,{'nSubx','nSuby'}))
  if data.N ~= 3
    data.nSubx = ceil(sqrt(data.N));
    data.nSuby = ceil(data.N/data.nSubx);
  else % special case for 3: horizontal line - less awkward
    data.nSubx = 3;
    data.nSuby = 1;
  end
end
% subplot handles initialization
for a = 1:data.N
    data.ax(a) = subplot(data.nSuby,data.nSubx,a);
end
% optimize figure display size for the current monitor and first image size
% centres the figure in onscreen too.
screensize = get(0,'screensize');
aspect     = (size(data.img(1).data,1) / size(data.img(1).data,2));
imgSize    = min( data.maxwid / data.nSubx, data.maxht / data.nSuby / aspect);
figSize    = ...
   [(screensize(3) - (       imgSize*data.nSubx))/2,... % Lower-left corner X
    (screensize(4) - (aspect*imgSize*data.nSuby))/2,... % Lower-left corner Y
    (imgSize*data.nSubx),...                            % Width in X
    (imgSize*data.nSuby*aspect)];                       % Width in Y
set(gcf,'color','k','position',figSize);
 
function [data] = showims(data)
% show the images in default subplot locations
for i = 1:data.N
    imshow(data.img(i).data,data.minmax,...
      'parent',data.ax(i),'initialmagnification','fit');
end
% subplot spacing (separate loop since otherwise axes die if they overlap)
for i = 1:data.N
    y = ceil(i / data.nSubx);
    x = mod(i, data.nSubx);
    x(~x) = data.nSubx;
    set(data.ax(i),'position',[(x - 1) / data.nSubx + 0.5*data.pad,  ...
                                1 - (y / data.nSuby - 0.5*data.pad), ...
                                     1 / data.nSubx - data.pad,      ...
                                     1 / data.nSuby - data.pad]);
    colormap(data.ax(i),data.colourmap); % R2017+
end
colormap(data.colourmap); % R0:R2016
