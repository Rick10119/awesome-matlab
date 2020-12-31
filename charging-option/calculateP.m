% to calculate p_g and p_e
for i = 1:numberOfL
    p_g_a(i) = link.p_g(Link(i));
    p_e_a(i) = link.p_e(Link(i));
end


%%  find Delta_G and Delta_E for each O-D pair 
r=1; s = numberOfL;% only one O-D pair

%The variables
I_rs = zeros(numberOfN,1);
I_rs(r) = 1;
I_rs(s) = -1;


v_g = binvar(numberOfL,1,'full');
v_e = binvar(numberOfL,1,'full');


% The objective function of gv
u_rs_gc = p_g_a' * v_g;
u_rs_ec = p_e_a' * v_e;

% The Constraints
Constraints_gv = [];
Constraints_ev = [];

% gama and d
for i = 1 : numberOfN
    Constraints_gv = [Constraints_gv; Gama(i,:)*v_g==I_rs(i)];
    Constraints_ev = [Constraints_ev; Gama(i,:)*v_e==I_rs(i)];
end


    


Constraints_ev = [];



% solve the optimization
% ops = sdpsettings('debug',1,'solver','cplex','savesolveroutput',1,'savesolverinput',1);
optimize(Constraints,u_rs_gc,ops);

optimize(Constraints,u_rs_ec,ops);





