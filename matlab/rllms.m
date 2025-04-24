function [w, y, e, stage] = rllms(x, dn, mu, M, lambda, threshold, clean)
    % rllms: Recursive Leaky LMS Algorithm with performance summary.
    % Inputs:
    % x        : Input signal (assumed to be a matrix where each row corresponds to a stage)
    % dn       : Desired signal
    % mu       : Step size
    % M        : Filter order
    % lambda   : Leakage factor
    % threshold: Correlation coefficient threshold to stop recursion
    % clean    : Clean signal for MSE and SNR calculation
    %
    % Outputs:
    % w     : Final filter coefficients for each stage
    % y     : Output signal for each stage
    % e     : Error signal for each stage
    % stage : Total number of stages executed

    % First stage
    [w(1,:), y(1,:), e(1,:)] = llms(x, dn, mu, M, lambda);
    corrcoefMatrix = corrcoef(e(1,:), x);
    corrcoefConstant = corrcoefMatrix(1,2);
    corrcoef_values(1) = corrcoefConstant;  % Store correlation coefficient for stage 1
    stage = 1;
    disp(['Stage: ', num2str(stage)]);
    disp(['corrcoefConstant: ', num2str(corrcoefConstant)]);
    [mse(stage), snr(stage)] = getmsesnr(clean, dn, e(1,:));
    fprintf('\n');
    
    % Recursive stages until correlation coefficient is below threshold
    while corrcoefConstant > threshold
        stage = stage + 1;
        % Update input signal for current stage
        x(stage,:) = x(stage-1,:) - y(stage-1,:);
        % Apply the leaky LMS to current stage
        [w(stage,:), y(stage,:), e(stage,:)] = llms(x(stage,:), e(stage-1,:), mu, M, lambda);
        % Compute correlation coefficient between current error and input
        corrcoefMatrix = corrcoef(e(stage,:), x(stage,:));
        corrcoefConstant = corrcoefMatrix(1,2);
        corrcoef_values(stage) = corrcoefConstant;
        disp(['Stage: ', num2str(stage)]);
        disp(['corrcoefConstant: ', num2str(corrcoefConstant)]);
        [mse(stage), snr(stage)] = getmsesnr(clean, e(stage-1,:), e(stage,:));
        fprintf('\n');
    end

    % Determine the optimal stage based on performance metrics:
    [max_snr, stage_max_snr] = max(snr);
    [min_mse, stage_min_mse] = min(mse);
    [min_corr, stage_min_corr] = min(corrcoef_values);

    % Display summary results
    fprintf('Summary:\n');
    fprintf('Stage with highest SNR: %d (SNR: %.2f dB)\n', stage_max_snr, max_snr);
    fprintf('Stage with lowest MSE: %d (MSE: %.4f)\n', stage_min_mse, min_mse);
    fprintf('Stage with lowest correlation coefficient: %d (CorrCoef: %.4f)\n', stage_min_corr, min_corr);
end
