%% Voici un exemple de progamme pour la fonction *update* des robots.
% Ici, le robot se déplace aléatoirement. Lorsqu'il découvre la cible il communique
% l'information à tous ses voisins et va l'attaquer

if (robot.cible_detected==1)
    % Si le robot connait l'emplacement de la cible, il la communique à
        % tous ses voisins
    for i=1:INFO.nbVoisins
       voisin = INFO.voisins{i};
       voisin.set_info_cible(robot.cible_x, robot.cible_y);
    end
    
    %Vecteur gravitationnel
    vx = robot.cible_x-robot.x ; 
    vy = robot.cible_y-robot.y ;
    v_axis = [vx;vy];
    
    %Vecteur aléatoire
    randVel = [rand.*2 - 1 ; rand.*2 - 1 ] ;
    v_random = randVel; 
            
    %Vecteur répulsif


   v_repuls = [0;0] ;
   vvoisin = [0;0];
    for i=1:INFO.nbVoisins
        voisin = INFO.voisins{i};
        distance = norm ([robot.x; robot.y] - [voisin.x;voisin.y]);
        if (distance < robot.virtual_size)
            vvoisin = [(vvoisin(1)- robot.x ) ; (vvoisin(2)- robot.y) ] ;
            v_repuls(1) = v_repuls(1) - vvoisin(1) ;
            v_repuls(2) = v_repuls(2) - vvoisin(2) ;

        end

    end






    %Combinaison des trois vecteurs
    vi = v_axis + 0.6 *  v_random + 0.6 * v_repuls ;
    
    %Déplacement
    robot.move(vi);

end
        
        % Pour rappel : le robot attaque la cible automatiquement s'il
        % connait son emplacement et se trouve à distance d'attaque. Vous
        % n'avez pas à vous en soucier dans le code.

   

    
    