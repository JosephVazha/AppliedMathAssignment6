function string_simulation(string_params, U0, dUdt0, tspan)

    num_masses = string_params.n;
    total_mass = string_params.M;
    tension_force = string_params.Tf;
    string_length = string_params.L;
    damping_coeff = string_params.c;

    dx = string_length/(num_masses+1);

    amplitude_Uf = string_params.au;
    omega_Uf = string_params.ou;
    
    %list of x points (including the two endpoints)
    xlist = linspace(0,string_length,num_masses+2);

    Uf_func = @(t_in) amplitude_Uf*cos(omega_Uf*t_in);
    dUfdt_func = @(t_in) -omega_Uf*amplitude_Uf*sin(omega_Uf*t_in);

    %load string_params into rate function
    my_rate_func = @(t_in,V_in) string_rate_func01(t_in,V_in,string_params);

    V0 = [U0;dUdt0];

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