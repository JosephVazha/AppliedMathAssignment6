function string_params = stringparams1()
    num_masses = 5;
    total_mass = 4;
    tension_force = 10;
    string_length = 5;
    damping_coeff = .05;

    dx = string_length/(num_masses+1);
    amplitude_Uf = 1;
    omega_Uf = pi/2;

    Uf_func = @(t_in) amplitude_Uf*cos(omega_Uf*t_in);
    dUfdt_func = @(t_in) -omega_Uf*amplitude_Uf*sin(omega_Uf*t_in);


    string_params = struct();
    string_params.n = num_masses;
    string_params.M = total_mass;
    string_params.Uf_func = Uf_func;
    string_params.dUfdt_func = dUfdt_func;
    string_params.Tf = tension_force;
    string_params.L = string_length;
    string_params.c = damping_coeff;
    string_params.dx = dx;
    string_params.au = amplitude_Uf;
    string_params.ou = omega_Uf;
 
end