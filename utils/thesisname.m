function [name] = thesisname(opt,varargin)
base.base   = fullfile('C:\Users\Jesse\Documents\Research\');
base.thesis = fullfile(base.base,'working-docs\thesis');
switch opt
  case 'paper'
    name = fullfile(base.base,'working-docs','paper','figs');
    if nargin > 1
      name = fullfile(name,varargin{:});
    end
  case 'fig'
    name = fullfile(base.thesis,'figs');
    if nargin > 1
      name = fullfile(name,varargin{:});
    end
  case 'poster'
    name = fullfile(base.base,'conferences\MICCAI 2017\poster\figs');
    % <hacks>
    legend(gca,'boxoff');
    set(gcf,'PaperPositionMode','manual','InvertHardcopy','off');
    % </hacks>
    if nargin > 1
      name = fullfile(name,varargin{:});
    end
  case 'dir'
    name = fullfile(base.thesis);
    if nargin > 1
      name = fullfile(name,varargin{:});
    end
  case 'pdf'
    name = fullfile(base.thesis,'main.pdf');
end