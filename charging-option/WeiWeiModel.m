%% Graphic Model
clc; clear;
format short

% node-link incidence matrix
Gama = [
    1 0 0 0 1 0 0 0 1
    -1 1 1 0 0 0 0 0 0
    0 -1 -1 1 0 0 0 0 0
    0 0 0 0 -1 1 1 0 0
    0 0 0 0 0 -1 -1 1 0
    0 0 0 -1 0 0 0 -1 -1
    ];
% number of links and nodes
numberOfL = length(Gama);
numberOfN = length(Gama(:,1));



% t0(basic time) of the links
t0_a = [
    10
    20
    0
    10
    10
    20
    0
    10
    15
    ];

% c(capacity) of the links
c_a = [
    25
    3
    25
    25
    25
    3
    25
    25
    30
    ];

% initially no traffic demand
x_a = zeros(numberOfL, 1);

% type of the links
type_a = [
    1
    2
    3
    1
    1
    2
    3
    1
    1
    ];

% LMP ($/MWh)
lamda = [
    0
    100
    0
    0
    0
    200
    0
    0
    0
    ];

% link-path(route) incidence matrix
% for gasoline vehicles
Delta_G = [
    1 0 0
    0 0 0
    1 0 0
    1 0 0
    0 1 0
    0 0 0
    0 1 0
    0 1 0
    0 0 1
    ];
% for electric vehicles
Delta_E = [
    1 0
    1 0
    0 0
    1 0
    0 1
    0 1
    0 0
    0 1
    0 0
    ];

%% parameters
format long
% 这些参数改了以后要在link里面改
% w = 10; % cost of time ($/h)

% total flow of gv and ev (/hour)
q_rs_g = 95;
q_rs_e = 5;

E_B = 50;% amount of charging energy (kWh)

% t_c = 20;% fixed charging time (min)

% J = 0.05;% J of queueing at charging station


% create a struct array
Link = repmat(link(0,0,0,0,0),[numberOfL,1]);
% charging availability
D = zeros(numberOfL, 1);

for i = 1: numberOfL
    Link(i) = link(t0_a(i), c_a(i), x_a(i), type_a(i),lamda(i));
    if type_a(i)==2
        D(i) =1;
    end
end

