% MAKEDIFFEOS
% Calling the functions mni2ptx_old and ptx2mni_old re-computes a transformation
% matrix which is expensive to compute and can easily be saved as a mat file.
% The purpose of this function is to pre-compute those transforms (T) for use by
% the new mni2ptx and ptx2mni to transform between mni and ptx quickly. You must
% run makealldiffeos first.

function [] = makediffeos(N,nvec)
for n = nvec
  for t = 1:2
    switch t
      case 1
        xform     = imglutname('xform',  N,n,1);
        templatei = imgname('mni:FLAIR',   n,1);
        templateo = imglutname('FLAIR',  N,n,1);
        savename  = imglutname('mni2ptx',N,n,0);
      case 2
        xform     = imglutname('ixform', N,n,1);
        templatei = imglutname('FLAIR',  N,n,1);
        templateo = imgname('mni:FLAIR',   n,1);
        savename  = imglutname('ptx2mni',N,n,0);
    end
    ni = nifti(templatei);
    no = nifti(templateo);
    nx = nifti(xform);
    si = size(ni.dat);
    so = size(no.dat);
    M  = nx.mat\ni.mat;
    X  = spm_affine(squeeze(single(nx.dat(:,:,:,1,:))),inv(no.mat));
    T  = zeros([si,3],'single');
    for d = 1:3
      for z = 1:si(3)
        Mz  = M*spm_matrix([0,0,z]);
        Tzd = spm_slice_vol(X(:,:,:,d),Mz,si(1:2),[1,nan]);
        T(:,:,z,d) = single(Tzd);
      end
    end
    save(savename,'T','so');
  end
end