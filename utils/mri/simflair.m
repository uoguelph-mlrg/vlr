function [flair,y,tpm] = simflair(TERI,norm,mri)
if nargin < 1
  error('Must specify the TE/TR/TI in TERI.');
end
if nargin < 2
  norm = 'wm';
end
if nargin < 3
  mri = 'ir';
end
[tpm,M] = gettpm(3);
[y] = getintensities(TERI(1),TERI(2),TERI(3),mri);
flair = zeros(size(M));
for c = 1:size(tpm,4)
  flair = flair + tpm(:,:,:,c).*y(c);
end
switch norm
  case 0
  case 'gm',  flair = flair ./ y(1);   y = y ./ y(1);
  case 'wm',  flair = flair ./ y(2);   y = y ./ y(2);
  case 'csf', flair = flair ./ y(3);   y = y ./ y(3);
  case 'les', flair = flair ./ y(4);   y = y ./ y(4);
  case 'max', flair = flair ./ max(y); y = y ./ max(y);
  otherwise,  error('Normalization type: %s not implemented.',norm);
end
if nargout == 0
  volshow(flair);
end

function [tpm,M] = gettpm(les)
% need to clean this up __JK__
tpmname  = 'D:\DATA\brainweb\GT\msles\phantom_1.0mm_msles*.nii';
%tpmname  = 'D:\DATA\brainweb\TPM.nii';
maskname = 'D:\DATA\WML\mni\brain\MNI_1.0mm_brain_old.nii';
tpm   = imrotate(im2double(readnii(strrep(tpmname,'*',num2str(les)))),180);
M     = ones(size(tpm(:,:,:,1)));
%M     = imrotate(im2double(readnii(maskname)),180);
tpm   = tpm(:,:,:,[1,2,3,end]);
%tpm   = tpm(:,:,:,[1,2,3]);
tpm   = bsxfun(@rdivide,tpm,sum(tpm,4).*M);
%Mi    = padarray(M,[0,0,0,size(tpm,4)-1],'circular','post');
%tpm(~Mi | isnan(tpm)) = 0;

function [Y] = getintensities(TE,TR,TI,mri)
% tiss:  GM,   WM,  CSF,  les
T1 = [  940,  550, 4210, 1300];
T2 = [  100,   90, 2100,  150];
P  = [ 0.75, 0.65, 1.00, 0.80];
switch mri
  case 'ir'
    % Fast Spin Echo
    %Y  = P.*(1 - 2.*exp(-TI./T1) + exp(-(TR-TE)./T1)).*exp(-TE./T2);
    % Conventional Spin Echo
    Y = P.*(1 - 2.*exp(-TI./T1) + exp(-(TR)./T1)).*exp(-TE./T2);
  case 'se'
    Y = P.*(1 - exp(-(TR)./T1)).*exp(-TE./T2);
end
Y  = max(0, Y);


% references:
% Melhem1997 (all 4 tissues)
% % x GM, WM: Stanisz2005
% % x CSF:    Condon1987

