% DEFHYPSET(HYPSET)
% This function defines various sets of hyperparameter combinations for
% comparison.

function [h,names,params] = defhypset(hypset)
switch hypset
  case 'ovb' % add regularizations 'one at a time' vs baseline
    params = {'e[P--L--A--F--]','\texttt{base}';
              'e[P1-L--A--F--]','$V = 1$';
              'e[P--L3-A--F--]','$\lambda = {10}^{-3}$';
              'e[P--L--Af-F--]','$\mathrm{a}_{R} = 1$';
              'e[P--L--As-F--]','$\mathrm{a}_{S} = \mathbf{N}_6$';};
    ho = hypdef_baseline;
    for i = 1:size(params,1)
      h{i}     = key2hyp(ho,params{i,1});
      names{i} = params{i,2};
    end
  case 'cv' % compare different cross validation methods (expensive)
    cvs = {'loso', '\texttt{loso}' ;
           'kfcv', '\texttt{kfcv}' ;
           'loo',  '\texttt{loo}'  ;
           'osaat','\texttt{osaat}';
           'nocv', '\texttt{nocv}' ;};
    ho = hypdef_final;
    for i = 1:size(cvs,1)
      h{i}     = cv2hyp(ho,cvs{i,1});
      names{i} = cvs{i,2};
    end
    params = cvs;
  case 'ystd-full' % compare all different ystd methods (toy only)
    ystds = {'na',                 {},'\textbf{Raw}';
             'rm',  {[0.0001,0.9999]},'\textbf{RM1}';
             'rm',  {[0.001, 0.999 ]},'\textbf{RM2}';
             'rm',  {[0.01,  0.99  ]},'\textbf{RM3}';
             'ss',                 {},'\textbf{SS}';
             'he',{pmfdef('uniform')},'\textbf{HE}';
             'm1',{pmfdef('normal')} ,'\textbf{HM1}';
             'm2',{pmfdef('rskew')}  ,'\textbf{HM2}';
             'm3',{pmfdef('lskew')}  ,'\textbf{HM3}';
             'ny',{linspace(0,1,16)} ,'\textbf{NY}';};
    ho = hypdef_final;
    for i = 1:size(ystds,1)
      h{i}     = ystd2hyp(ho,ystds{i,1:2});
      names{i} = ystds{i,3};
    end
    params = ystds;
  case 'ystd' % compare different ystd methods
    ystds = {'ss',{},                 '\textbf{SS}';
             'he',{pmfdef('uniform')},'\textbf{HE}';
             'm1',{pmfdef('normal')}, '\textbf{HM1}';
             'm2',{pmfdef('rskew')},  '\textbf{HM2}';
             'm3',{pmfdef('lskew')},  '\textbf{HM3}';};
    ho = hypdef_final;
    for i = 1:size(ystds,1)
      h{i}     = ystd2hyp(ho,ystds{i,1:2});
      names{i} = ystds{i,3};
    end
    params = ystds;
  case 'lam' % compare different lambdas
    params = {'e[P1-L--Ab-Fg2]','$\lambda = 0$';
              'e[P1-L5-Ab-Fg2]','$\lambda = {10}^{-5}$';
              'e[P1-L4-Ab-Fg2]','$\lambda = {10}^{-4}$';
              'e[P1-L3-Ab-Fg2]','$\lambda = {10}^{-3}$';
              'e[P1-L2-Ab-Fg2]','$\lambda = {10}^{-2}$';
              'e[P1-L1-Ab-Fg2]','$\lambda = {10}^{-1}$';};
     ho = hypdef_final;
     for i = 1:size(params,1)
       h{i} = key2hyp(ho,params{i,1});
       names{i} = params{i,2};
     end
   case 'psu' % compare different V
    params = {'e[P--L3-Ab-Fg2]','$V = 0$';
              'e[P1-L3-Ab-Fg2]','$V = 1$';
              'e[P3-L3-Ab-Fg2]','$V = 3$';
              'e[P9-L3-Ab-Fg2]','$V = 9$';
              'e[P27L3-Ab-Fg2]','$V = 27$';};
     ho = hypdef_final;
     for i = 1:size(params,1)
       h{i} = key2hyp(ho,params{i,1});
       names{i} = params{i,2};
     end
   case 'beta' % compare different beta smoothing
    params = {'e[P1-L3-Ab-F--]','$(\cdot)$';
              'e[P1-L3-Ab-Fm3]','$\mathrm{Med}_{3\times3}$';
              'e[P1-L3-Ab-Fm5]','$\mathrm{Med}_{5\times5}$';
              'e[P1-L3-Ab-Fg1]','$\mathrm{G}_{\sigma=1}$';
              'e[P1-L3-Ab-Fg2]','$\mathrm{G}_{\sigma=2}$';
              'e[P1-L3-Ab-Fg3]','$\mathrm{G}_{\sigma=3}$';};
     ho = hypdef_final;
     for i = 1:size(params,1)
       h{i} = key2hyp(ho,params{i,1});
       h{i}.sam.resize = 1;
       h{i} = hypfill(h{i});
       names{i} = params{i,2};
     end
  otherwise
    error('Unrecognized hypset name: %s', hypset);
end


