classdef Robot < handle
    
    %% Voici un robot. 
    % Cette classe determine le comportement du robot. 

    
    
    %% Propriétés du robot
    properties
        id              % L'identifiant du robot, compris entre 1 et 12.
        x               % La position x du robot dans l'arène   
        y               % La position y du robot dans l'arène
        orientation     % L'orientation du robot. C'est un angle exprimé en radian où 0 indique que le robot est orienté vers l'est.  
        
        
        vx              % Le mouvement que le robot essaye de produire, le long de l'axe x.
        vy              % Le mouvement que le robot essaye de produire, le long de l'axe y.
        
        
        
        cible_detected  % 1 si le robot connait l'emplacement de la cible, 0 sinon. 
        cible_x         % Position x de la cible dans l'environement (initialement inconnue)
        cible_y         % Position y de la cible dans l'environement (initialement inconnue)
        
        
        
        MAX_SPEED       % La vitesse de déplacement du robot. Vous ne pouvez pas modifier cette propriété.
        
        size_robot
        virtual_size
    end
    
    
    
    methods
        
        function robot = Robot(id, x,y,orientation , SPEED, size_robots)

            
            robot.id = id ;
            robot.x = x;
            robot.y = y;
            robot.orientation = orientation ;
            robot.vx = 0;
            robot.vy = 0;
            robot.MAX_SPEED = SPEED ;
            robot.cible_detected = 0 ;
            robot.cible_x = NaN ;
            robot.cible_y = NaN ;
            robot.size_robot = size_robots;
            if robot.size_robot == "small"
                robot.virtual_size = 0.20 ;
            else
                robot.virtual_size = 0.40 ;
            end
        end
        
        
        function robot = move2(robot, vx, vy)
            
            v = [vx ; vy];
            if (norm(v)>0)
                v =  robot.MAX_SPEED .* v ./ norm(v);
            end
            
            robot.vx = v(1) ;
            robot.vy = v(2) ;
        end
        
        function robot = move(robot, v)
            
            if (norm(v)>0)
                v =  robot.MAX_SPEED .* v ./ norm(v);
            end
            
            robot.vx = v(1) ;
            robot.vy = v(2) ;
        end

            
       
        
        function robot = set_info_cible(robot, cible_x, cible_y)
            % Cette fonction permet de renseigner les informations sur la 
            % cible.

            robot.cible_detected = 1 ;
            
            robot.cible_x = cible_x ;
            robot.cible_y = cible_y ;
        end   

        
        function robot = update(robot, INFO)
            update;
            

        end
        

    end
end

