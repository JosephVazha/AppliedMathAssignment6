function string_simulation_template01()
    num_masses = 3;
    total_mass = 1;
    tension_force = 10;
    string_length = 5;
    damping_coeff = .1;

    dx = string_length/(num_masses+1);

    amplitude_Uf = 0.5;
    omega_Uf = pi/2;

    %list of x points (including the two endpoints)
    xlist = linspace(0,string_length,num_masses+2);

    Uf_func = @(t_in) amplitude_Uf*cos(omega_Uf*t_in);
    dUfdt_func = @(t_in) -omega_Uf*amplitude_Uf*sin(omega_Uf*t_in);

    %generate the struct
    string_params = struct();
    string_params.n = num_masses;
    string_params.M = total_mass;
    string_params.Uf_func = Uf_func;
    string_params.dUfdt_func = dUfdt_func;
    string_params.Tf = tension_force;
    string_params.L = string_length;
    string_params.c = damping_coeff;
    string_params.dx = dx;

    %load string_params into rate function
    my_rate_func = @(t_in,V_in) string_rate_func01(t_in,V_in,string_params);

    %initial conditions
    U0 = zeros(num_masses, 1);
    dUdt0 = zeros(num_masses, 1);
    V0 = [U0;dUdt0];

    tspan = [0 20];

    %run the integration
    [tlist,Vlist] = ode45(my_rate_func,tspan,V0);

    figure();
    for k = 1:length((tlist))
        %your code to generate an animation of the system
        
        current_t = tlist(k);
        current_U = Vlist(k, 1:num_masses)';
    
        u_left = 0;
        u_right = Uf_func(current_t);
    
        u_full = [u_left, current_U, u_right];
    
        plot(xlist, u_full, '-o', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
        ylim([-amplitude_Uf*2, amplitude_Uf*2]); 
        xlim([0-string_length*1.25, string_length*1.25]);
        title(['Time: ', num2str(current_t, '%.2f')]);
        xlabel('Position x');
        ylabel('Displacement u');
        grid on;
        drawnow;
    end
end