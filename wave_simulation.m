function wave_simulation(string_params)
    %load param struct
    total_mass = string_params.M;
    num_masses = string_params.n;
    Uf_func = string_params.Uf_func;
    dUfdt_func = string_params.dUfdt_func;
    tension_force = string_params.Tf;
    string_length = string_params.L;
    damping_coeff = string_params.c;
    dx = string_params.dx;

    %init conditions
    U0 = zeros(num_masses, 1);
    dUdt0 = zeros(num_masses, 1);
    V0 = [U0; dUdt0];

    %calculate wave speed
    c = sqrt(tension_force/(total_mass/string_length));

    pulse_width = 1.0;
    pulse_height = 1.0;

    my_rate_func = @(t_in, V_in) string_rate_func01(t_in, V_in, string_params);

    time = 300 * (string_length/num_masses);
    tspan = 0:0.01:time;

    [tlist, Vlist] = ode45(my_rate_func, tspan, V0);

    %animation

    xlist = 0:dx:string_length;

    figure('Color', 'w', 'Name', 'Traveling Wave Simulation');
    for k = 1:length(tlist)
        current_t = tlist(k);
        current_U = Vlist(k, 1:num_masses);
        
        % Boundaries
        u_left = 0; %wall at 0
        u_right = Uf_func(current_t); %pulse input
        
        u_full = [u_left, current_U, u_right];
        
        dist_traveled = c * current_t - 0.5 * pulse_width * c;
        
        x_track_raw = string_length - dist_traveled; 
        
        %this makes sure the animation repeats and doesn't fold on itself
        path_pos = mod(dist_traveled, 2 * string_length);
        
        if path_pos < string_length
            %left
            x_track = string_length - path_pos;
        else
            %right
            x_track = path_pos - string_length;
        end
        
        clf;
        hold on;
        
        plot(xlist, u_full, 'b-', 'LineWidth', 1.5);
        
        xline(x_track, 'r--', 'LineWidth', 1.5);
        
        %formatting
        ylim([-pulse_height*1.5, pulse_height*1.5]); 
        xlim([0, string_length]);
        title(sprintf('Traveling Wave (N=%d, c=%.2f m/s)\nTime: %.2fs', num_masses, c, current_t));
        xlabel('Position x (m)');
        ylabel('Displacement u (m)');
        grid on;
        
        legend('String Displacement', 'Theoretical Wave Speed', 'Location', 'NorthWest');
        
        drawnow; 
    end

end