clear all;
close all;
tic

% Load inputs
map = Map('map_image.bmp','resolution',200,'hieght',2000);

% map.show('border')
represent(map)

% encoding(map)
% GA config
gaConfig = Configuration();
gaConfig.MaximumIterations = 50;
gaConfig.PopulationSize = 50;
gaConfig.PopulationType = 'random';
gaConfig.CrossoverRate = 0.8;
gaConfig.MutationRate = 0.03;
gaConfig.TournamentSize=10;
gaConfig.mutationProbability=0.01;
gaConfig.numberOfReplications = 2;
% Generatue initial populations
number_of_spicies = 5;
for agent_number = 1:number_of_spicies
    population(agent_number)= InitializePopulation(map, gaConfig);
    Evaluating(population(agent_number),map,gaConfig)
end

% Evaluate 
Evaluate_all(population);
% Selection and Crossover
Selecting(population,gaConfig,0.5);

% Mutate
Mutating(population,map,gaConfig)
generation=5;
for i=1:generation
	Evaluating(population,map,gaConfig)
	Selecting(population,gaConfig,0.5)
	Mutating(population,map,gaConfig)
 	% pause(0.5)
end
Evaluating(population,map,gaConfig)
Ploting(population,map)
plot(map.mission_location(:,1),map.mission_location(:,2),'.')
toc
obj=population;