% IMGLUTNAME
% This function is a wrapper for imgname,
% where the index of an image in a multi-source set can be used
% instead of the image index from its original set
% e.g. 1:96 instead of 1:20, 1:20, 1:20, 1:5, 1:5, 1:5, 1:21
% The specific multi-source set must be indexed in a lut-#.txt file (# = h.Ni)

function [name,setkey,setnum] = imglutname(imgkey,N,n,varargin)
lut = getlut(N);
[setkey,setnum] = strtok(lut{n},':');
setnum = str2double(setnum(2:end));
% usual lookup for any given dataset
if isempty(strfind(imgkey,'mni:'))
  name = imgname([setkey,':',imgkey],setnum,varargin{:});
% special mni lookup
% since need to use both the current lut-index and the master lut-129.txt
else
  lutall = getlut(129);
  n = find(strcmp(lutall,lut{n}));
  name = imgname(imgkey,n,varargin{:});
end

function [lut] = getlut(N)
% n.b. relative path
fid = fopen(['.\utils\mri\imgname\lut\lut-',num2str(N),'.txt']);
lut = textscan(fid,'%s',N);
lut = lut{1};
fclose(fid);