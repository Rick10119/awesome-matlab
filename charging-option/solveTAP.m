% solve the TAP problem
% number of routes
numberOfR_G = length(Delta_G(1,:));
numberOfR_E = length(Delta_E(1,:));
numberOfRS = 1;% ONLY one O-D pair now

% variables
x = sdpvar(numberOfL,1,'full');
f_g = sdpvar(numberOfRS,numberOfR_G,'full');
f_e = sdpvar(numberOfRS,numberOfR_E,'full');

%%
% Constraints
Constraints_x = [];
sumOfFlow = 0;

%general range for f
for j = 1:numberOfR_G
    Constraints_x = [Constraints_x;0<=f_g(1, j)];
end

for j = 1:numberOfR_E
    Constraints_x = [Constraints_x;0<=f_e(1, j)];
end

% constrains of x
for i = 1:numberOfL
    % capacity limit of charging stations
    if Link(i).type == 2 %charging station
        Constraints_x = [Constraints_x;x(i)<=Link(i).c];
    end
    sumOfFlow = 0;
    % more cycle if numberOfRS != 1
    for j = 1:numberOfR_G
        sumOfFlow = sumOfFlow + f_g(1, j) * Delta_G(i,j);
    end
    
    for j = 1:numberOfR_E
        sumOfFlow = sumOfFlow + f_e(1, j) * Delta_E(i,j);
    end
    % flow component
    Constraints_x = [Constraints_x;x(i)==sumOfFlow];
end

Constraints_x = [Constraints_x;sum(f_e)==q_rs_e];
Constraints_x = [Constraints_x;sum(f_g)==q_rs_g];

% F_TAP objective
F_TAP = 0;
for i = 1:numberOfL
    F_TAP = F_TAP + link.f_TAP(Link(i), x(i));
end

% optimize
ops = sdpsettings('debug',1,'savesolveroutput',1,'savesolverinput',1);

optimize(Constraints_x,F_TAP,ops)

xOut = value(x)
value(F_TAP)