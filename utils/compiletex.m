function [] = compiletex(filename)
[dirname,~] = fileparts(filename);
cmdstr = strrep('!pdflatex.exe -synctex=1 -interaction=nonstopmode $.tex >NUL',...
                '$',filename);
try
  cdir = cd;
  cd(dirname);
  eval(cmdstr);
  eval(cmdstr);
  cd(cdir);
catch ME
  error(ME.getReport);
end
