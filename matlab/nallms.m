function [w, y, e, corrcoef_values, mse_values, snr_values] = nallms(x, dn, mu, M, init_lambda, n_stages, clean)
    % nallms: Recursive Leaky LMS Algorithm with internal Adaptive Leakage Factor
    % Inputs:
    % x           : Input signal
    % dn          : Desired signal
    % mu          : Initial step size
    % M           : Filter order
    % init_lambda : Initial leakage factor (e.g., 0.001)
    % n_stages    : Number of recursive stages to call the leaky LMS function
    % clean       : Clean signal for MSE and SNR calculation
    %
    % Outputs:
    % w                : Final filter coefficients
    % y                : Output signal
    % e                : Error signal
    % corrcoef_values  : Correlation coefficients for each stage
    % mse_values       : Mean Squared Error values for each stage
    % snr_values       : Signal-to-Noise Ratio values for each stage

    % Initialize variables
    N = length(x);                     % Length of the input signal
    w = zeros(n_stages, M);            % Initialize filter weights for each stage
    y = zeros(n_stages, N);            % Initialize output signal for each stage
    e = zeros(n_stages, N);            % Initialize error signal for each stage
    corrcoef_values = zeros(1, n_stages); % Initialize correlation coefficients
    mse_values = zeros(1, n_stages);   % Initialize MSE values
    snr_values = zeros(1, n_stages);   % Initialize SNR values
    
    % Parameters for adaptive leakage (kept internally)
    beta1 = 0.95;   % Smoothing factor for error power tracking
    beta2 = 0.01;   % Step size for lambda adaptation
    error_power = zeros(n_stages, N);  % For tracking error power
    
    % Recursive application of leaky LMS
    for stage = 1:n_stages
        % Initialize lambda for this stage
        lambda = init_lambda;
        
        % Apply the LMS algorithm for the current stage
        for n = M:N
            x1 = x(n:-1:n-M+1);          % Create the input window (column vector)
            y(stage, n) = w(stage, :) * x1'; % Compute the filter output
            e(stage, n) = dn(n) - y(stage, n); % Compute the error signal
            
            % Track error power with exponential smoothing
            if n > M
                error_power(stage, n) = beta1 * error_power(stage, n-1) + (1-beta1) * e(stage, n)^2;
            else
                error_power(stage, n) = e(stage, n)^2;
            end
            
            % Adapt leakage parameter based on error power
            if n > M+10  % Wait for some samples to get stable error estimates
                % Calculate recent average error power (last 10 samples)
                recent_avg_error = mean(error_power(stage, n-10:n-1));
                
                % Adjust lambda based on error trend
                % If current error is higher than recent average, decrease lambda to allow more adaptation
                % If current error is lower than recent average, increase lambda for more stability
                lambda = lambda - beta2 * (error_power(stage, n) - recent_avg_error);
                
                % Keep lambda within bounds [0.0001, 0.1]
                lambda = max(0.0001, min(0.1, lambda));
            end
            
            % Update filter weights with adaptive leakage
            w(stage, :) = (1 - mu * lambda) * w(stage, :) + 2 * mu * e(stage, n) * x1;
        end
        
        % Calculate correlation coefficient for the current stage
        corrcoef_matrix = corrcoef(e(stage, :), x);
        corrcoef_values(stage) = corrcoef_matrix(1, 2);
        
        % Calculate MSE and SNR for the current stage
        [mse_values(stage), snr_values(stage)] = getmsesnr(clean, dn, e(stage, :));
        
        % Display results like nllms2
        disp(['Stage: ', num2str(stage)]);
        disp(['Correlation Coefficient: ', num2str(corrcoef_values(stage))]);
        disp(['MSE: ', num2str(mse_values(stage))]);
        disp(['SNR: ', num2str(snr_values(stage)), ' dB']);
        fprintf('\n');
        
        % Update the input signal for the next stage
        if stage < n_stages
            x = x - y(stage, :); % Subtract the output from the input for the next stage
            dn = e(stage, :);    % Update the desired signal to the current error
        end
    end
end

function [mse, snr] = getmsesnr(s, orig, e)
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