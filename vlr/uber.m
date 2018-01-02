% UBER
% This function literally runs all scripts necessary to generate the thesis.
% It would probably take days to run and will almost certainly crash somewhere.
% Please explore for the desired set of results to re-create.
% [ ] not re-run
% [x] checked and re-run

function [] = uber()
def; % adjust some figure defaults

% ---------------------------------------------------------
% cross validation batches for parameter comparison
exp_hyp(defhypset('ovb'))   % [x]
exp_hyp(defhypset('cv'))    % [ ]
exp_hyp(defhypset('ystd'))  % [x]
exp_hyp(defhypset('lam'))   % [x]
exp_hyp(defhypset('psu'))   % [x]
exp_hyp(defhypset('beta'))  % [x]
% other computation
exp_ystd();                 % [ ]
exp_toyreg();               % [x]

% ---------------------------------------------------------
% summarizing the results
fig_hypcompare({'ovb'})     % [x]
fig_hypcompare({'cv'})      % [x]
fig_hypcompare({'ystd'})    % [x]
fig_hypcompare({'lam'})     % [x]
fig_hypcompare({'beta'})    % [x]
fig_final();                % [x]
fig_ystd();                 % [x]

% ---------------------------------------------------------
% stand-alone figures (mostly don't need the above to run)
plot_B_reparam();           % [x]
plot_basic_lr();            % [x]
plot_converge();            % [x]
plot_mle_challenges();      % [x]
plot_mri_decay_3d();        % [x]
plot_mri_spin_echo();       % [x]
plot_synthetic_histmatch(); % [x]
plot_y_sep_objectives();    % [x]
show_beta_r();              % [x]
show_bias();                % [x]
show_brain_mask();          % [x]
show_m08_revise_manuals();  % [x]
show_plot_simflair();       % [x]
show_registration();        % [x]
show_tikzfigs();            % [x]
show_tpfpfn_raw_thropt();   % [x]
show_tpms();                % [x]
show_wmhdist();             % [x]
kfcvidx(hypdef_final,true); % [x]

