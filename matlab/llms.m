function [w, y, e] = llms(x, dn, mu, M, lambda)
    N = length(x);
    w = zeros(1, M); % Row vector
    y = zeros(1, N); % Initialize y
    e = zeros(1, N); % Initialize e
    for n = M:N
        x1 = x(n:-1:n-M+1); % Column vector
        y(n) = w * x1'; % Matrix multiplication
        e(n) = dn(n) - y(n);
        w = (1 - mu * lambda) * w + 2 * mu * e(n) * x1;
    end