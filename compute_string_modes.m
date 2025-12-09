function [mode_shapes, natural_freqs] = compute_string_modes(string_params)
    %obtain M and K matrices
    [M_mat, K_mat] = construct_2nd_order_matrices(string_params);

    %solve for eigenvalues
    [Ur_mat, lambda_mat] = eig(K_mat, M_mat);

    omega = sqrt(abs(diag(lambda_mat)));

    [natural_freqs, sort_indices] = sort(omega);

    mode_shapes = Ur_mat(:, sort_indices);

end