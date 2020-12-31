clc;clear;

constraints = [];
opt = 0;

n = 10001;

x = sdpvar(n, 1, 'full');
for i = 1 : n
    
    constraints = [constraints; x(i) <= i];
    opt = opt +  x(i);
end

ops = sdpsettings('debug', 1, 'solver', 'cplex');
optimize(constraints, opt, ops);

disp("the optimum is: ");
disp(value(opt));
    