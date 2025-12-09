function string_simulation_template01()
    string_params = stringparams1;

    num_masses = string_params.n;
    total_mass = string_params.M;
    tension_force = string_params.Tf;
    string_length = string_params.L;
    damping_coeff = string_params.c;
    
    dx = string_params.dx;

    amplitude_Uf = string_params.au;
    omega_Uf = string_params.ou;

    %list of x points (including the two endpoints)
    xlist = linspace(0,string_length,num_masses+2);

    Uf_func = @(t_in) amplitude_Uf*cos(omega_Uf*t_in);
    dUfdt_func = @(t_in) -omega_Uf*amplitude_Uf*sin(omega_Uf*t_in);

    %generate the struct
    % string_params = struct();
    % string_params.n = num_masses;
    % string_params.M = total_mass;
    % string_params.Uf_func = Uf_func;
    % string_params.dUfdt_func = dUfdt_func;
    % string_params.Tf = tension_force;
    % string_params.L = string_length;
    % string_params.c = damping_coeff;
    % string_params.dx = dx;

    %load string_params into rate function
    my_rate_func = @(t_in,V_in) string_rate_func01(t_in,V_in,string_params);

    %initial conditions
    U0 = zeros(num_masses, 1);
    dUdt0 = zeros(num_masses, 1);
    V0 = [U0;dUdt0];

    tspan = [0 40];

    %run the integration
    disp('runner');
    [tlist,Vlist] = ode45(my_rate_func,tspan,V0);
    disp('run12ner');

    % figure();
    x = plot(0,0,'-o', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
    ylim([-amplitude_Uf*2, amplitude_Uf*2]); 
    xlim([0, string_length]);
    % title(['Time: ', num2str(current_t, '%.2f')]);
    xlabel('Position x');
    ylabel('Displacement u');
    grid on;

    % plot(xlist, u_full, '-o', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
    for k = 1:length((tlist))
        %animation of the system
        
        current_t = tlist(k);
        current_U = Vlist(k, 1:num_masses)';
    
        u_left = 0;
        u_right = Uf_func(current_t);
        
        u_full = [u_left; current_U; u_right];
        set(x,'xdata',xlist,'ydata',u_full)
        title(['Time: ', num2str(current_t, '%.2f')]);
        drawnow;

    end
end