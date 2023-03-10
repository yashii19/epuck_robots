
%%  Ce code permet de parametrer et de lancer la simulation    %%
%                                                               %
%       Pour programmer les robots, utilisez Robot.m            %
%                                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Add path to subfolder
addpath(genpath('utilities'));
%addpath('./');


%% Set up Robotarium object

N = 20;
xi = [-0.15 0.15 -0.75 -0.45 -0.15 0.15 0.45 0.75 -0.75 -0.45 -0.15 0.15 0.45 0.75 -0.75 -0.45 -0.15 0.15 0.45 0.75];
yi = [0.6 0.6 0.3 0.3 0.3 0.3 0.3 0.3 0 0 0 0 0 0 -0.3 -0.3 -0.3 -0.3 -0.3 -0.3] ;
ai = rand(1,N).*2*  pi - pi ;



initial_conditions = [xi ; yi ; ai ] ;
 
r = Robotarium('NumberOfRobots', N, 'ShowFigure', true, 'InitialConditions', initial_conditions);


%% PARAMETERS 
SPEED = r.max_linear_velocity ; % Moving speed of the robots
DETECTION_RANGE = 1.0 ; % Distance to the target for detection
ATTACK_RANGE = 0.5 ; % Distance to the target for attacking 
ATTACK_STRENGTH = 0.01 ; % Reduction of target energy for robot attacking the target

PERCEPTION_RANGE = 0.35 ; % Perception range of the robots (for walls or neighbors)

[x_target, y_target] = getTargetPosition();
    
%% VARIABLES
target_energy = 100; % Experiment ends when target energy is down to 0
target_detected = zeros(1,N); % Which robots have detected the target

se = 0 ; % Segregation Error value
se_0 = 0; % 0 if SE > 0, 1 else
spatial_distribution_big = -1; % mean of the spatial distibution values for the big robots
spatial_distribution_small = -1; % mean of the spatial distribution values for the small robots



%% AFFICHAGE
d = plot(x_target,y_target,'ro');
target_caption = text(-1.5, -1.07, sprintf('Segregation Error : %0.1f%%', se), 'FontSize', 15, 'FontWeight', 'bold', 'Color','r');
time_caption = text(-1.5, -1.17, sprintf('Temps ?coul? : 0 s'), 'FontSize', 14, 'FontWeight', 'bold', 'Color','r');
sd_caption = text(-1.5, -1.27, sprintf("Distribution spatiale : { small =  %0.1f% , big = %0.1f%", spatial_distribution_small, spatial_distribution_big), 'FontSize', 14, 'FontWeight', 'bold', 'Color','r');
uistack(target_caption, 'top'); 
uistack(time_caption, 'top'); 
uistack(d, 'bottom');

% Initialize velocity vector for agents.  
v = zeros(2, N);

%% BARRIER CERTIFICATES
uni_barrier_cert = create_uni_barrier_certificate_with_boundary();
%si_to_uni_dyn = create_si_to_uni_dynamics('LinearVelocityGain', 0.5, 'AngularVelocityLimit', pi/2);
si_to_uni_dyn = create_si_to_uni_dynamics();

%% CREATE THE ROBOTS
clear allRobots
small_count = 0 ;
big_count = 0 ;
for i=1:N
    random = rand();
    if ((random > 0.5 && small_count < N/2) || big_count >= N/2)
        allRobots{i} = Robot(i , initial_conditions(1,i) , initial_conditions(2,i) , initial_conditions(3,i) , SPEED, "small");
        small_count = small_count + 1 ;
    elseif (random < 0.5 && big_count < N/2 || small_count >= N/2)
        allRobots{i} = Robot(i , initial_conditions(1,i) , initial_conditions(2,i) , initial_conditions(3,i) , SPEED, "big");
        big_count = big_count + 1 ;
    end

end


%% DATA COLLECTION
expectedDuration = 5000 ;
total_time = 0 ;

data_target = nan(expectedDuration,2);
data_X = nan(expectedDuration,N);
data_Y = nan(expectedDuration,N);
data_attack = nan(expectedDuration,N);
data_detect = nan(expectedDuration,N);



%% START OF SIMULATION
iteration = 0 ;


while total_time<900
    
   % Update iteration
        iteration = iteration + 1 ;
        
   % UPdate total time
        total_time = total_time + r.time_step ;
        
    % Retrieve velocity and position of the robots
        x = r.get_poses();
        for i=1:N
            allRobots{i}.x = x(1,i);
            allRobots{i}.y = x(2,i);
            allRobots{i}.orientation = x(3,i);
        end
        
    % Distance to the target
        d_target = sqrt((x_target - x(1,:)).^2 + (y_target - x(2,:)).^2);
        
    % Walls detection
        dWalls.up = abs(1-x(2,:));
        dWalls.up(dWalls.up>PERCEPTION_RANGE) = NaN ;
        dWalls.down = abs(-1-x(2,:));
        dWalls.down(dWalls.down>PERCEPTION_RANGE) = NaN;
        dWalls.left = abs(-1.6-x(1,:));
        dWalls.left(dWalls.left>PERCEPTION_RANGE) = NaN;
        dWalls.right = abs(1.6-x(1,:));
        dWalls.right(dWalls.right>PERCEPTION_RANGE) = NaN;
    
     %% Behavioural algorithm for the robots

        % Compute distance between robots
        dm = squareform(pdist([x(1,:)' x(2,:)']));
        
        for i = 1:N

            % Detect the neighbors within the perception range
                %neighbors = delta_disk_neighbors(x, i, PERCEPTION_RANGE);
                neighbors = find(dm(i,:)<=PERCEPTION_RANGE & dm(i,:)>0);
                
            % Collect local information for robot i
                clear INFO
                
                % Walls information 
                    INFO.murs.dist_haut = dWalls.up(i);
                    INFO.murs.dist_bas = dWalls.down(i);
                    INFO.murs.dist_gauche = dWalls.left(i);
                    INFO.murs.dist_droite = dWalls.right(i);
                    
                % Neighbors information (when applicable)
                    INFO.nbVoisins = length(neighbors);
                    for v = 1:length(neighbors)
                        INFO.voisins{v} = allRobots{neighbors(v)};
                    end

                % Target information (when applicable)
                    if (d_target(i)<DETECTION_RANGE)
                        allRobots{i}.set_info_cible(x_target, y_target);
                    end                               
  
            % Update the states of the robot
                allRobots{i}.update(INFO) ;
        end 

    
        % Control LEDS
        for i=1:N
            % Green light when robot is small
            if (allRobots{i}.size_robot == "small")
                r.set_right_leds(i , [0 ; 255 ; 0]);
            end

            % Red light when target is attacked
            if (allRobots{i}.size_robot == "big")
                r.set_left_leds(i , [255 ; 0 ; 0]);
            end
        end


    %% Update robots speed and position  
        clear dx
        for i=1:N
            dx(1,i) = allRobots{i}.vx ;
            dx(2,i) = allRobots{i}.vy ;
        end
        v = dx ;

    % Avoid actuator errors : we need to threshold dx
        norms = arrayfun(@(x) norm(dx(:, x)), 1:N);
        threshold = 3/4*r.max_linear_velocity;
        to_thresh = find(norms > threshold);
        if ~isempty(to_thresh)
            dx(:, to_thresh) = threshold*dx(:, to_thresh)./norms(to_thresh);
        end
    
    % Transform the single-integrator dynamics to unicycle dynamics using a provided utility function
        dx = si_to_uni_dyn(dx, x);  
        dx = uni_barrier_cert(dx, x);
        
    % Set velocities of agents 1:N
        r.set_velocities(1:N, dx);
        
    % Save data

        tmpDet = zeros(1,N);
        for i=1:N
           
            if (allRobots{i}.cible_detected==1)
                tmpDet(i) = 1 ;
            end 
        end

        data_detect(iteration,:) = tmpDet ;
        data_X(iteration,:) = x(1,:);
        data_Y(iteration,:) = x(2,:);
        data_target(iteration,:) = [target_energy total_time] ;

        %Computation of the Segregation Error and the Spatial Distribution
        s_distrib_big = zeros(N/2, 1) ;
        s_distrib_small = zeros(N/2, 1);
        i_big = 1 ;
        i_small = 1 ;

        for i=1:N
            % compute the norm between i position and target position
            dist_i = norm([allRobots{i}.x ; allRobots{i}.y] - [x_target; y_target]) ;
            
            % store the value in a table to compute the Spatial Distribition 
            if (allRobots{i}.size_robot == "big")
                s_distrib_big(i_big) = dist_i ;
               
                i_big = i_big + 1 ;
                

            elseif (allRobots{i}.size_robot == "small")
                s_distrib_small(i_small) = dist_i;
                
                i_small = i_small + 1 ;
                
            end
            
            for j=1:N
                % if i and j are have different sizes
                if (allRobots{i}.size_robot ~= allRobots{j}.size_robot)
                    % compute the norm between j position and target
                    % position
                    dist_j = norm([allRobots{j}.x ; allRobots{j}.y] - [x_target; y_target]) ;
                    % if the small robot is behind the big robot, increment
                    % the SE value
                    if (allRobots{i}.size_robot == "small" && dist_i > dist_j)
                        se = se + 1 ;
                    elseif (allRobots{j}.size_robot == "small" && dist_j > dist_i)
                        se = se + 1;
                    end
                end
            end
        end
        % compute the SE value
        se = se / (N^2 / 2) ;
        % compute the spatial distributions values
        spatial_distribution_big = mean(s_distrib_big) ;
        spatial_distribution_small = mean(s_distrib_small) ;
       


        % Resultat
        if (se == 0 && se_0 == 0)
            disp(['Temps total pour que Erreur de Segregation  :  ' num2str(round(iteration*r.time_step)) ' secondes']);
            disp(['Distribution spatiale : small = ' num2str(spatial_distribution_small) " // big = " num2str(spatial_distribution_big)]);
            se_0 = 1 ;
            

        end
    % Send the previously set velocities to the agents.  This function must be called!
        r.step();   
    
    % Display
        target_caption.String = sprintf('Segregation Error %0.5f%', se);
        time_caption.String = sprintf('Temps ?coul? : %d s', round(iteration*r.time_step));
        sd_caption.String = sprintf("Distribution spatiale : small =  %0.2f / big = %0.2f%", spatial_distribution_small, spatial_distribution_big) ;


end

 
    
% Donn?es finales
    data_X = data_X(1:iteration,:);
    data_Y = data_Y(1:iteration,:);
    data_attack = data_attack(1:iteration,:);
    data_detect = data_detect(1:iteration,:);
    data_target = data_target(1:iteration,:);
    
    
    
    %r.debug();
