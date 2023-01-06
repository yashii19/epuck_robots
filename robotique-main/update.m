%% Voici un exemple de progamme pour la fonction *update* des robots.
% Ici, le robot se d�place al�atoirement. Lorsqu'il d�couvre la cible il communique
% l'information � tous ses voisins et va l'attaquer

if (robot.cible_detected==1)
    % Si le robot connait l'emplacement de la cible, il la communique �
        % tous ses voisins
    for i=1:INFO.nbVoisins
       voisin = INFO.voisins{i};
       voisin.set_info_cible(robot.cible_x, robot.cible_y);
    end
    
    %Vecteur gravitationnel
    vx = robot.cible_x-robot.x ; 
    vy = robot.cible_y-robot.y ;
    v_axis = [vx;vy];
    
    %Vecteur al�atoire
    randVel = [rand.*2 - 1 ; rand.*2 - 1 ] ;
    v_random = randVel; 
            
    %Vecteur r�pulsif
    if (robot.size_robots == small)
        VIRTUAL_SIZE = 0.05
    else
        VIRTUAL_SIZE = 0.10
    end

    if (INFO.nbVoisins > 0)
    end


    %Combinaison des trois vecteurs
    vi = v_axis + v_random;
    
    %D�placement
    robot.move(vi);

end
        
        % Pour rappel : le robot attaque la cible automatiquement s'il
        % connait son emplacement et se trouve � distance d'attaque. Vous
        % n'avez pas � vous en soucier dans le code.

   

    
    