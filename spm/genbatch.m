% GENBATCH
% This function writes SPM batch files using the templates in `templates` dir
% and the meta-data specified here.
% Previously run batches can be found in `ran` dir.
% This is a working file - edit as necessary to create your batch file

% edit here --------------------------------------------------------------------
srcdir = 'C:/Users/Jesse/Documents/m/Research/wmlseg/workspace/';
tname   = [srcdir,'spm/templates/template_normalizewrite.m'];
bname   = [srcdir,'spm/batch_normalizewrite_h17_mans.m'];
% main    =  @(k)imgname('i15:FLAIR',k,1);  % $ - main
% towrite = {};
main    =  @(k)imgname('h17:xform',k,1);  % $ - main
towrite = {@(k)imgname('h17:mans',k,1);};
% towrite = {@(k)imgname('i15:FLAIR',k,1);
%            @(k)imgname('i15:FLAIRm',k,1);
%            @(k)imgname('i15:mans1',k,1);
%            @(k)imgname('i15:mans2',k,1);
%            @(k)imgname('i15:mansand',k,1);
%            @(k)imgname('i15:mansor',k,1);
%            @(k)imgname('i15:c1',k,1);
%            @(k)imgname('i15:c2',k,1);
%            @(k)imgname('i15:c3',k,1);}; % @ - paired
% towrite = {imgname('h17:FLAIR','#');
%            imgname('h17:FLAIRm','#')
%            imgname('h17:mans','#');
%            imgname('h17:c1','#');
%            imgname('h17:c2','#');
%            imgname('h17:c3','#')};     % @ - paired
nimgs   = 1:60;
% ------------------------------------------------------------------------------

% file i/o
template = fileread(tname);
batfile  = fopen(bname,'w+');
% iterating through images
nums = nimgs; % #
for k = 1:numel(nums);
  % create @ file list
  fnames = '''';
  for w = 1:numel(towrite)
    fnames = [fnames,towrite{w}(k),''';',10,''''];
  end
  fnames = fnames(1:end-2);
  % initialize the template
  batnum = sprintf('%02.f',k);      
  imgnum = sprintf('%02.f',nums(k));
  output = template;
  % substitutions
  output = strrep(output,'#',batnum); % batch number
  output = strrep(output,'$',['''',main(k),'''']); % main
  output = strrep(output,'@',fnames); % paired
  fwrite(batfile,output);
end
fclose('all');
