function [] = show_tpms()
cmap = inferno;
TPM = nd2cell(readnicenii(imgname('mni:tpm','',0)),4);
sliceshow(TPM{1},zfun,cmap,[0,1]);
print(thesisname('fig',['tpm-gm.png']),'-dpng');
close(gcf);
sliceshow(TPM{2},zfun,cmap,[0,1]);
print(thesisname('fig',['tpm-wm.png']),'-dpng');
close(gcf);
sliceshow(TPM{3},zfun,cmap,[0,1]);
print(thesisname('fig',['tpm-csf.png']),'-dpng');
close(gcf);
vcolorbar([0:0.2:1],cmap);
print(thesisname('fig',['cmap-tpm.eps']),'-depsc');
close(gcf);

