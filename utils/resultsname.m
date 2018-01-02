function [name] = resultsname(type,varargin)
switch type
  case 'tab'
    name = ['performance.tex'];
  case 'scat'
    metric = varargin{1};
    name = ['scat-',metric,'.eps'];
  case 'box'
    metric = varargin{1};
    name = ['box-',metric,'.eps'];
  case 'ba'
    num = varargin{1};
    assert(any(num==[1,2]),...
      'Blant-Altman name is indexed 1:2.');
    name = ['ba-',num2str(num),'.eps'];
  case 'img'
    iname = varargin{1};
    assert(any(strcmp(iname,{'T','S','Y','TP','FP','FN'})),...
      'Unrecognized image name: %s',iname);
    name  = [iname,'.png'];
  case 'cmap'
    key = varargin{1};
    name = ['cmap-',key,'.eps'];
end