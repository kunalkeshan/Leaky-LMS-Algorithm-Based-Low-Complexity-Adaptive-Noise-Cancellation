function [w, y, e, stage] = rllms_m(x, dn, mu, M, lambda, threshold, clean)
    % rllms_m: Recursive Leaky LMS Algorithm with sparse stage logging

    % ---- User-adjustable logging interval ----
    LOG_INTERVAL = 10;  % change to log every N stages

    % initialize storage arrays
    corrcoef_values = [];
    mse = [];
    snr = [];

    % ---- Stage 1 via llms ----
    [w(1,:), y(1,:), e(1,:)] = llms(x, dn, mu, M, lambda);
    R = corrcoef(e(1,:), x);
    corrcoef_values(1) = R(1,2);
    [mse(1), snr(1)]   = getmsesnr(clean, dn, e(1,:));
    stage = 1;

    shownCount = 1;
    fprintf('Stage: %d\n', shownCount);
    fprintf('  CorrCoef: %.4f\n', corrcoef_values(1));
    fprintf('  MSE:      %.4g\n', mse(1));
    fprintf('  SNR:      %.2f dB\n\n', snr(1));

    % ---- Recursive stages until threshold ----
    while corrcoef_values(stage) > threshold
        stage = stage + 1;
        x(stage,:) = x(stage-1,:) - y(stage-1,:);
        [w(stage,:), y(stage,:), e(stage,:)] = llms(x(stage,:), e(stage-1,:), mu, M, lambda);

        R = corrcoef(e(stage,:), x(stage,:));
        corrcoef_values(stage) = R(1,2);
        [mse(stage), snr(stage)] = getmsesnr(clean, e(stage-1,:), e(stage,:));

        if mod(stage, LOG_INTERVAL) == 0
            shownCount = shownCount + 1;
            fprintf('Stage: %d\n', shownCount);
            fprintf('  CorrCoef: %.4f\n', corrcoef_values(stage));
            fprintf('  MSE:      %.4g\n', mse(stage));
            fprintf('  SNR:      %.2f dB\n\n', snr(stage));
        end
    end

    % ---- Summary over logged multiples only ----
    finalStage = stage;
    maxMultiple = floor(finalStage/LOG_INTERVAL) * LOG_INTERVAL;
    if maxMultiple >= LOG_INTERVAL
        idxs = [1, LOG_INTERVAL:LOG_INTERVAL:maxMultiple];
    else
        idxs = 1;
    end

    % Determine actual best stages
    [~, i_peak] = max(snr(idxs));
    stage_peak = idxs(i_peak);
    [~, i_mse]  = min(mse(idxs));
    stage_mse  = idxs(i_mse);
    [~, i_corr] = min(corrcoef_values(idxs));
    stage_corr = idxs(i_corr);

    % Map to display stage: 1 stays 1; else divide by LOG_INTERVAL
    disp_peak = max(1, round(stage_peak / LOG_INTERVAL));
    disp_mse  = max(1, round(stage_mse  / LOG_INTERVAL));
    disp_corr = max(1, round(stage_corr / LOG_INTERVAL));

    fprintf('Summary:\n');
    fprintf('  Stage with highest SNR: %d (%.2f dB)\n',   disp_peak, snr(idxs(i_peak)));
    fprintf('  Stage with lowest MSE:  %d (%.4g)\n',      disp_mse,  mse(idxs(i_mse)));
    fprintf('  Stage with lowest Corr: %d (%.4f)\n',      disp_corr, corrcoef_values(idxs(i_corr)));
end

function [mse, snr] = getmsesnr(s, orig, e)
    if size(e,1)    ~= size(s,1), e    = e';    end
    if size(orig,1) ~= size(s,1), orig = orig'; end
    mse = immse(s, orig);
    rms_s1         = rms(s);
    rms_difference = rms(s - e);
    snr = 20 * log10(rms_s1 / rms_difference);
end
