function def()
% DISPLAY
format short g;
format compact;
% FONTS
fontname = 'Helvetica';
fontsize = 16;

set(0,'defaultTextFontName',      fontname);
set(0,'defaultAxesFontName',      fontname);
set(0,'defaultUicontrolFontName', fontname);
set(0,'defaultUitableFontName',   fontname);
set(0,'defaultUipanelFontName',   fontname);

set(0,'defaultTextFontSize',      fontsize);
set(0,'defaultAxesFontSize',      fontsize);
set(0,'defaultUicontrolFontSize', fontsize);
set(0,'defaultUitableFontSize',   fontsize);
set(0,'defaultUipanelFontSize',   fontsize);

% PLOT LINE THICKNESS
set(0,'defaultLineLineWidth', 2);
% PLOT COLORS (RAINBOW)
set(0,'defaultAxesColorOrder',rainbow7);
% PDF SAVING SPECS
set(0,'defaultfigurepaperpositionmode','auto');
% IMG COLORS (RAINBOW)
set(0,'defaultFigureColormap',gray);
% FIGURE BACKGROUND COLOR
set(0,'defaultFigureColor',[1,1,1]);
% WARNINGS
warning('off', 'Images:initSize:adjustingMag');
warning('off', 'Images:imshow:magnificationMustBeFitForDockedFigure');
warning('off', 'MATLAB:hg:transform:computeTransform:AxesLimitsTooLarge1');
warning('off', 'stats:kmeans:EmptyCluster');
warning('off', 'MATLAB:dispatcher:UnresolvedFunctionHandle');
close all;

  