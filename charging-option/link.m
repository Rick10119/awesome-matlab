classdef link
    
    properties
        t0 % basic time, min
        c % capacity of the link
        x % traffic demand
        type % 1 road, 2 cstation, 3 bypass
        lamda % LMP($/MWh)
        
    end
    
    properties(Constant)
        w = 10;% unit time cost
        E_B = 50;% energy to charge, kWh
        J = 0.05;% param of the queue
        
    end
    
    % constructor
    methods
        function obj = link(t0, c, x, type, lamda)
            obj.t0 = t0;
            obj.c = c;
            obj.x = x;
            obj.type = type;
            obj.lamda = lamda;
            
        end
    end
    
    
    methods(Static)
        % the time comsumption (min)
        function t = t_a(obj)
            if obj.type == 1 % road
                t = obj.t0 * (1 + 0.15*(obj.x/obj.c)^4);
            end
            
            if obj.type == 2 % charging station
                t = obj.t0 * (1 + link.J*(obj.x / (obj.c-obj.x)));
            end
            
            if obj.type == 3 % bypass
                t = 0;
            end
        end
        
        % the cost of gvs ($)
        function p = p_g(obj)
            p = link.w * link.t_a(obj)/60;% t0 in min
        end
        
        % the cost of evs
        function p = p_e(obj)
            p = link.w * link.t_a(obj)/60 + link.f_a_e(obj); % to speed up, you can store t_a
            
        end
        
        % the charging fee
        function p = f_a_e(obj)
            p = 0;
            if obj.type == 2
                p = link.E_B * obj.lamda * 0.001;% lamda in MWh
            end
        end
        
        
        % THE F_TAP
        function p = f_TAP(obj, x)

            p = 0;% bypass
            
            if obj.type == 2 % charging station
                p = link.w * obj.t0/60 *((1-link.J)*x + obj.c*link.J*log(obj.c/(obj.c-x))) + link.f_a_e(obj)*x;
                % where x is smaller than c, otherwise infeasible
            end

            if obj.type == 1 %road
                p = link.w * obj.t0 * (x + 0.03*(x^5)/(obj.c^4));
            end
        end
        
%         % for a given x, the time t_a_x
%         function t = t_a_x(obj, x)
%             if obj.type == 1 % road
%                 t = obj.t0 * (1 + 0.15*(x/obj.c)^4);
%             end
%             
%             if obj.type == 2 % charging station
%                 t = obj.t0 * (1 + link.J*(x / (obj.c-x)));
%             end
%             
%             if obj.type == 3 % bypass
%                 t = 0;
%             end
%         end
        
    end
    
end
