function [w, y, e, corrcoef_values, mse_values, snr_values] = nlms(x, dn, mu, M, n_stages, clean)
    % multi_stage_lms: Multi-Stage LMS Algorithm
    % Inputs:
    % x        : Input signal
    % dn       : Desired signal
    % mu       : Step size
    % M        : Filter order
    % n_stages : Number of recursive stages
    % clean    : Clean signal for MSE and SNR calculation
    %
    % Outputs:
    % w                : Final filter coefficients for each stage
    % y                : Output signal for each stage
    % e                : Error signal for each stage
    % corrcoef_values  : Correlation coefficients for each stage
    % mse_values       : Mean Squared Error values for each stage
    % snr_values       : Signal-to-Noise Ratio values for each stage

    % Initialize variables
    N = length(x); % Length of the input signal
    w = zeros(n_stages, M); % Initialize filter weights for each stage
    y = zeros(n_stages, N); % Initialize output signal for each stage
    e = zeros(n_stages, N); % Initialize error signal for each stage
    corrcoef_values = zeros(1, n_stages); % Initialize correlation coefficients
    mse_values = zeros(1, n_stages); % Initialize MSE values
    snr_values = zeros(1, n_stages); % Initialize SNR values

    % Recursive application of LMS
    for stage = 1:n_stages
        % Apply the LMS algorithm for the current stage
        for n = M:N
            x1 = x(n:-1:n-M+1);  % Create the input window
            y(stage, n) = w(stage, :) * x1'; % Compute the filter output
            e(stage, n) = dn(n) - y(stage, n); % Compute the error signal
            
            % Update filter weights
            w(stage, :) = w(stage, :) + 2 * mu * e(stage, n) * x1;
        end

        % Calculate correlation coefficient for the current stage
        corrcoef_matrix = corrcoef(e(stage, :), x);
        corrcoef_values(stage) = corrcoef_matrix(1, 2);
        disp(['Stage: ', num2str(stage)]);
        disp(['Correlation Coefficient: ', num2str(corrcoef_values(stage))]);
        
        % Calculate MSE and SNR for the current stage
        [mse_values(stage), snr_values(stage)] = get_mse_snr(clean, dn, e(stage, :));
        disp(['MSE: ', num2str(mse_values(stage))]);
        disp(['SNR: ', num2str(snr_values(stage)), ' dB']);
        fprintf('\n');
        
        % Update the input signal for the next stage
        if stage < n_stages
            x = x - y(stage, :); % Subtract the output from the input for the next stage
            dn = e(stage, :);    % Update the desired signal to the current error
        end
    end

    % After processing all stages, determine the best stage metrics:
    [peakSNR, stage_peakSNR] = max(snr_values);
    [lowestMSE, stage_lowestMSE] = min(mse_values);
    [lowestCorr, stage_lowestCorr] = min(corrcoef_values);
    
    fprintf('Summary:\n');
    fprintf('Stage with peak SNR: %d (SNR: %.2f dB)\n', stage_peakSNR, peakSNR);
    fprintf('Stage with lowest MSE: %d (MSE: %.4f)\n', stage_lowestMSE, lowestMSE);
    fprintf('Stage with lowest correlation coefficient: %d (CorrCoef: %.4f)\n', stage_lowestCorr, lowestCorr);
end

function [mse, snr] = get_mse_snr(s, orig, e)
    % Ensure 'e' matches the dimensions of 's'
    if size(e, 1) ~= size(s, 1)
        e = e'; % Transpose e if necessary
    end
    % Ensure 'orig' matches the dimensions of 's'
    if size(orig, 1) ~= size(s, 1)
        orig = orig'; % Transpose orig if necessary
    end
    % Calculate Mean Squared Error (MSE)
    mse = immse(s, orig);
    
    % Calculate RMS values
    rms_s1 = rms(s);
    rms_difference = rms(s - e);
    
    % Calculate Signal-to-Noise Ratio (SNR)
    snr = 20 * log10(rms_s1 / rms_difference);
end
