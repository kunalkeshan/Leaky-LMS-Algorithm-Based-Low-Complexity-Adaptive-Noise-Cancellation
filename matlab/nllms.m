function [w, y, e] = nllms(x, dn, mu, M, lambda, n_stages)
    % nllms: Recursive Leaky LMS Algorithm
    % Inputs:
    % x        : Input signal
    % dn       : Desired signal
    % mu       : Initial step size
    % M        : Filter order
    % lambda   : Leakage factor
    % n_stages : Number of recursive stages to call the leaky LMS function (default = 1)
    %
    % Outputs:
    % w        : Final filter coefficients
    % y        : Output signal
    % e        : Error signal

    % Initialize variables
    N = length(x); % Length of the input signal
    w = zeros(1, M); % Initialize filter weights
    y = zeros(1, N); % Initialize output signal
    e = zeros(1, N); % Initialize error signal

    % Recursive application of leaky LMS
    for stage = 1:n_stages
        % Apply the LMS algorithm for the current stage
        for n = M:N
            x1 = x(n:-1:n-M+1);  % Create the input window (column vector)
            y(n) = w * x1';      % Compute the filter output
            e(n) = dn(n) - y(n); % Compute the error signal

            % Update filter weights
            w = (1 - mu * lambda) * w + 2 * mu * e(n) * x1;
        end

        % Update the input signal for the next stage
        if stage < n_stages
            x = x - y; % Subtract the output from the input for the next stage
            dn = e;    % Update the desired signal to the current error
        end
    end
end
