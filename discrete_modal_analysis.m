function discrete_modal_analysis(string_params)
    num_masses = string_params.n;
    % total_mass = string_params.M;
    % tension_force = string_params.Tf;
    string_length = string_params.L;
    % damping_coeff = string_params.c;
    amplitude = string_params.au;
    Uf_func = string_params.Uf_func;
    tspan = 0:0.025:30;

    %compute mode shapes
    [mode_shapes, natural_freqs] = compute_string_modes(string_params);
    mode_index = 2;

    target_freq = natural_freqs(mode_index);
    target_shape = mode_shapes(:, mode_index);

    %perform integration
    U0 = zeros(num_masses, 1);
    dUdt0 = zeros(num_masses, 1);
    V0 = [U0; dUdt0];

    my_rate_func = @(t, V) string_rate_func01(t, V, string_params);
    [tlist, Vlist] = ode45(my_rate_func, tspan, V0);

    %animation

    xlist = linspace(0, string_length, num_masses + 2);
    
    figure('Name', 'Discrete Modal Analysis', 'Color', 'w');

    for k = 1:length(tlist)
        current_t = tlist(k);

        %mode shape
        subplot(2, 1, 1);
        mode_plot_data = [0; target_shape; 0]; %padding with zeros to match xlist
    
        %normalize data
        mode_plot_data = mode_plot_data / max(abs(mode_plot_data)) * amplitude * 2;
    
        plot(xlist, mode_plot_data, '-or', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
        title(sprintf('Theoretical Mode Shape #%d (Normalized)', mode_index));
        ylabel('Shape');
        grid on;
        ylim([-amplitude*3, amplitude*3]);
        xlim([-string_length*0.1, string_length*1.1]);
    
        %string sim
        subplot(2, 1, 2);
        current_U = Vlist(k, 1:num_masses);
    
        %boundry pos
        u_left = 0;
        u_right = Uf_func(current_t);
    
        %assemble full vector
        u_full = [u_left, current_U, u_right];
    
        plot(xlist, u_full, '-ob', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
            
        title(sprintf('Dynamic Response at Resonance (t = %.2f s)', current_t));
        xlabel('Position x');
        ylabel('Displacement u');
        grid on;
        
        ylim([-amplitude*5, amplitude*5]); 
        xlim([-string_length*0.1, string_length*1.1]);
        
        drawnow;
    end
end