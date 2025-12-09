function continuous_modal_analysis()

    string_params = stringparams1();

    mode_index = 3;

    L = string_params.L; %length of string
    n = mode_index;
    A = string_params.au;

    xlist = linspace(0,L,200+1);
    mode_shape = A*sin(((pi*n)/L)*xlist);

    plot(xlist,mode_shape);
end