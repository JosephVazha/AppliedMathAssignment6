function string_params = stringparams2()
    num_masses = 300;
    total_mass = 2;
    tension_force = 15;
    string_length = 10;
    damping_coeff = .05;

    dx = string_length/(num_masses+1);
    amplitude_Uf = 1;
    omega_Uf = pi/2;

    pulse_width = 1.0;
    pulse_height = 1.0;

    Uf_func = @(t) b_spline_pulse(t, pulse_width, pulse_height);
    dUfdt_func = @(t) b_spline_pulse_derivative(t, pulse_width, pulse_height);


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