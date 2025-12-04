%build the mass and stiffness matrices that describe the 2nd order system.

%INPUTS
%string_params: a struct containing the system parameters describing the string
% string_params.n: number of masses
% string_params.M: total mass attached to the string
% string_params.Uf_func: function describing motion of end point
% string_params.dUfdt_func: time derivative of Uf
% string_params.Tf: %tension in string
% string_params.L: %length of string
% string_params.c: %damping coefficient
% string_params.dx: %horizontal spacing between masses

%OUTPUTS
%M_mat: the n x n mass (inertia) matrix
%K_mat: the n x n stiffness matrix

function [M_mat,K_mat] = construct_2nd_order_matrices(string_params)

    %construct the nxn discrete laplacian matrix
    n = string_params.n;
    I_n = eye(n); % build the nxn identity matrix
    my_Laplacian = circshift(I_n,[0,1]);
    my_Laplacian(end,1) = 0;

    I_n = eye(n);
    my_Laplacian_temp = circshift(I_n,[1,0]);
    my_Laplacian_temp(1,end) = 0;

    I_n = -2*eye(n);

    my_Laplacian = my_Laplacian+my_Laplacian_temp+I_n;

    %setup the mass and stiffness matrices

    M_total = string_params.M;
    Tf = string_params.Tf;
    dx = string_params.dx;

    M_mat = (M_total / n) * eye(n);

    K_mat = -(Tf / dx) * my_Laplacian;
end