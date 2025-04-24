function [w, y, e, corrcoef_values, mse_values, snr_values] = nllms_m(x, dn, mu, M, lambda, n_stages, clean)
    % nllms_m: Recursive Leaky LMS Algorithm with sparse stage logging
    % Inputs/outputs unchanged from nllms2.

    % ---- User-adjustable logging interval ----
    LOG_INTERVAL = 10;  % Change this constant to alter which stages are logged

    N = length(x);
    w = zeros(n_stages, M);
    y = zeros(n_stages, N);
    e = zeros(n_stages, N);
    corrcoef_values = zeros(1, n_stages);
    mse_values      = zeros(1, n_stages);
    snr_values      = zeros(1, n_stages);

    shownCount = 0;
    for stage = 1:n_stages
        %--- leaky LMS update ---
        for n = M:N
            x1         = x(n:-1:n-M+1);
            y(stage,n) = w(stage,:) * x1';
            e(stage,n) = dn(n) - y(stage,n);
            w(stage,:) = (1 - mu*lambda)*w(stage,:) + 2*mu*e(stage,n)*x1;
        end

        %--- compute metrics ---
        R = corrcoef(e(stage,:), x);
        corrcoef_values(stage) = R(1,2);
        [mse_values(stage), snr_values(stage)] = getmsesnr(clean, dn, e(stage,:));

        %--- sparse logging: only stage 1 and every LOG_INTERVAL stage ---
        if stage == 1 || mod(stage, LOG_INTERVAL) == 0
            shownCount = shownCount + 1;
            fprintf('Stage: %d\n', shownCount);
            fprintf('  CorrCoef: %.4f\n', corrcoef_values(stage));
            fprintf('  MSE:      %.4g\n', mse_values(stage));
            fprintf('  SNR:      %.2f dB\n\n', snr_values(stage));
        end

        %--- prepare for next stage ---
        if stage < n_stages
            x  = x  - y(stage,:);
            dn = e(stage,:);
        end
    end

    %--- Summary over logged multiples only ---
    finalStage = stage;
    maxMultiple = floor(finalStage/LOG_INTERVAL) * LOG_INTERVAL;
    if maxMultiple >= LOG_INTERVAL
        idxs = [1, LOG_INTERVAL:LOG_INTERVAL:maxMultiple];
    else
        idxs = 1;
    end

    % Determine actual best stages within idxs
    [~, i_peak] = max(snr_values(idxs));
    stage_peak  = idxs(i_peak);
    [~, i_mse]  = min(mse_values(idxs));
    stage_mse   = idxs(i_mse);
    [~, i_corr] = min(corrcoef_values(idxs));
    stage_corr  = idxs(i_corr);

    % Map to display stage index (multiple count)
    disp_peak = max(1, round(stage_peak / LOG_INTERVAL));
    disp_mse  = max(1, round(stage_mse  / LOG_INTERVAL));
    disp_corr = max(1, round(stage_corr / LOG_INTERVAL));

    fprintf('Summary:\n');
    fprintf('  Stage with peak SNR:    %d (%.2f dB)\n', disp_peak, snr_values(stage_peak));
    fprintf('  Stage with lowest MSE:   %d (%.4g)\n',    disp_mse,  mse_values(stage_mse));
    fprintf('  Stage with lowest Corr:  %d (%.4f)\n',    disp_corr, corrcoef_values(stage_corr));
end

function [mse, snr] = getmsesnr(s, orig, e)
    % getmsesnr: Compute MSE and SNR between clean and error signals
    if size(e,1)    ~= size(s,1),    e    = e';    end
    if size(orig,1) ~= size(s,1), orig = orig'; end
    mse = immse(s, orig);
    rms_s1         = rms(s);
    rms_difference = rms(s - e);
    snr = 20 * log10(rms_s1 / rms_difference);
end
