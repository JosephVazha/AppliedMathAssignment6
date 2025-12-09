function discrete_modal_analysis(string_params)
    num_masses = string_params.n;
    string_length = string_params.L;
    amplitude = string_params.au;
    tspan = 0:0.01:30;

    %compute mode shapes
    [mode_shapes, natural_freqs] = compute_string_modes(string_params);
    mode_index = 5;

    target_freq = natural_freqs(mode_index);
    target_shape = mode_shapes(:, mode_index);

    string_params.Uf_func = @(t) amplitude * cos(target_freq * t);
    string_params.dUfdt_func = @(t) -target_freq * amplitude * sin(target_freq * t);

    Uf_func = string_params.Uf_func;

    %perform integration
    U0 = zeros(num_masses, 1);
    dUdt0 = zeros(num_masses, 1);
    V0 = [U0; dUdt0];

    my_rate_func = @(t, V) string_rate_func01(t, V, string_params);
    [tlist, Vlist] = ode45(my_rate_func, tspan, V0);

    %animation

    xlist = linspace(0, string_length, num_masses + 2);
    
    figure()
    subplot(2, 1, 1);
    mode_shape_plot = plot(nan, nan, '-or', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
    title(sprintf('Mode Shape #%d', mode_index));
    ylabel('Shape');
    grid on;
    ylim([-amplitude*3, amplitude*3]);
    xlim([-string_length*0.1, string_length*1.1]);

    subplot(2, 1, 2);
    string_plot = plot(nan, nan, '-ob', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
    title(sprintf('String Response at (t = %.2f s)', 0));
    xlabel('Position x');
    ylabel('Displacement u');
    grid on;
    ylim([-amplitude*5, amplitude*5]); 
    xlim([-string_length*0.1, string_length*1.1]);

    for k = 1:length(tlist)
        current_t = tlist(k);

        %mode shape
        mode_plot_data = [0; target_shape; 0]; %padding with zeros to match xlist
    
        %normalize
        mode_plot_data = mode_plot_data / max(abs(mode_plot_data)) * amplitude * 2;
        set(mode_shape_plot, 'YData', mode_plot_data, 'XData', xlist);

        %string sim
        current_U = Vlist(k, 1:num_masses);
    
        %boundry pos
        u_left = 0;
        u_right = Uf_func(current_t);
    
        %assemble full vector
        u_full = [u_left, current_U, u_right];
        set(string_plot, 'YData', u_full, 'XData', xlist);
        
        title(sprintf('String Response at (t = %.2f s)', current_t));
        drawnow;
    end
end