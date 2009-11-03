function compare_case(mpc1, mpc2)
%COMPARE_CASE  Compares the bus, gen, branch matrices of 2 MATPOWER cases.
%   compare_case(mpc1, mpc2)
%   Compares the bus, branch and gen matrices of two MATPOWER cases and
%   prints a summary of the differences.

%   MATPOWER
%   $Id$
%   by Ray Zimmerman, PSERC Cornell
%   Copyright (c) 1996-2009 by Power System Engineering Research Center (PSERC)
%   See http://www.pserc.cornell.edu/matpower/ for more info.

%% define named indices into bus, gen, branch matrices
[PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
    VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;
[GEN_BUS, PG, QG, QMAX, QMIN, VG, MBASE, GEN_STATUS, PMAX, PMIN, ...
    MU_PMAX, MU_PMIN, MU_QMAX, MU_QMIN, PC1, PC2, QC1MIN, QC1MAX, ...
    QC2MIN, QC2MAX, RAMP_AGC, RAMP_10, RAMP_30, RAMP_Q, APF] = idx_gen;
[F_BUS, T_BUS, BR_R, BR_X, BR_B, RATE_A, RATE_B, RATE_C, ...
    TAP, SHIFT, BR_STATUS, PF, QF, PT, QT, MU_SF, MU_ST, ...
    ANGMIN, ANGMAX, MU_ANGMIN, MU_ANGMAX] = idx_brch;

%% read data & convert to internal bus numbering
[baseMVA1, bus1, gen1, branch1] = loadcase(mpc1);
[baseMVA2, bus2, gen2, branch2] = loadcase(mpc2);

%% check for OPF results
if size(bus1, 2) >= LAM_P && size(bus2, 2) >= LAM_P
    solvedPF = 1;
else
    solvedPF = 0;
end

%% check for OPF results
if size(bus1, 2) >= LAM_P && size(bus2, 2) >= LAM_P
    solvedOPF = 1;
else
    solvedOPF = 0;
end

%% set up index name matrices
    buscols = char( 'BUS_I', ...
                    'BUS_TYPE', ...
                    'PD', ...
                    'QD', ...
                    'GS', ...
                    'BS', ...
                    'BUS_AREA', ...
                    'VM', ...
                    'VA', ...
                    'BASE_KV', ...
                    'ZONE', ...
                    'VMAX', ...
                    'VMIN'  );
    gencols = char( 'GEN_BUS', ...
                    'PG', ...
                    'QG', ...
                    'QMAX', ...
                    'QMIN', ...
                    'VG', ...
                    'MBASE', ...
                    'GEN_STATUS', ...
                    'PMAX', ...
                    'PMIN', ...
                    'PC1', ...
                    'PC2', ...
                    'QC1MIN', ...
                    'QC1MAX', ...
                    'QC2MIN', ...
                    'QC2MAX', ...
                    'RAMP_AGC', ...
                    'RAMP_10', ...
                    'RAMP_30', ...
                    'RAMP_Q', ...
                    'APF'   );
    brcols = char(  'F_BUS', ...
                    'T_BUS', ...
                    'BR_R', ...
                    'BR_X', ...
                    'BR_B', ...
                    'RATE_A', ...
                    'RATE_B', ...
                    'RATE_C', ...
                    'TAP', ...
                    'SHIFT', ...
                    'BR_STATUS' );
if solvedPF
    brcols = char(  brcols, ...
                    'PF', ...
                    'QF', ...
                    'PT', ...
                    'QT'    );
    if solvedOPF
        buscols = char( buscols, ...
                        'LAM_P', ...
                        'LAM_Q', ...
                        'MU_VMAX', ...
                        'MU_VMIN'   );
        gencols = char( gencols, ...
                        'MU_PMAX', ...
                        'MU_PMIN', ...
                        'MU_QMAX', ...
                        'MU_QMIN'   );
        brcols = char(  brcols, ...
                        'MU_SF', ...
                        'MU_ST' );
    end
end

%% print results
fprintf('----------------  --------------  --------------  --------------  -----\n');
fprintf(' matrix / col         case 1          case 2        difference     row \n');
fprintf('----------------  --------------  --------------  --------------  -----\n');

%% bus comparison
[temp, i] = max(abs(bus1 - bus2));
[v, gmax] = max(temp);
i = i(gmax);
fprintf('bus');
nodiff = ' : no differences found';
for j = 1:size(buscols, 1)
    [v, i] = max(abs(bus1(:, j) - bus2(:, j)));
    if v
        nodiff = '';
        if j == gmax, s = ' *'; else, s = ''; end
        fprintf('\n  %-12s%16g%16g%16g%7d%s', buscols(j, :), bus1(i, j), bus2(i, j), v, i, s );
    end
end
fprintf('%s\n', nodiff);

%% gen comparison
[temp, i] = max(abs(gen1 - gen2));
[v, gmax] = max(temp);
i = i(gmax);
fprintf('\ngen');
nodiff = ' : no differences found';
for j = 1:size(gencols, 1)
    [v, i] = max(abs(gen1(:, j) - gen2(:, j)));
    if v
        nodiff = '';
        if j == gmax, s = ' *'; else, s = ''; end
        fprintf('\n  %-12s%16g%16g%16g%7d%s', gencols(j, :), gen1(i, j), gen2(i, j), v, i, s );
    end
end
fprintf('%s\n', nodiff);

%% branch comparison
[temp, i] = max(abs(branch1 - branch2));
[v, gmax] = max(temp);
i = i(gmax);
fprintf('\nbranch');
nodiff = ' : no differences found';
for j = 1:size(brcols, 1)
    [v, i] = max(abs(branch1(:, j) - branch2(:, j)));
    if v
        nodiff = '';
        if j == gmax, s = ' *'; else, s = ''; end
        fprintf('\n  %-12s%16g%16g%16g%7d%s', brcols(j, :), branch1(i, j), branch2(i, j), v, i, s );
    end
end
fprintf('%s\n', nodiff);

return;