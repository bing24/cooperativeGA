close all 
clear all

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

population = InitializePopulation(map, gaConfig);

% Evaluate 
Evaluating(population,map,gaConfig)

obj=population;

for j= 1: gaConfig.PopulationSize
for i= 1: size(obj.charging_locationx,1)-1
nodes_dis(i)=norm([obj.charging_locationx(i,j),obj.charging_locationy(i,j)]-[obj.charging_locationx(i+1,j),obj.charging_locationy(i+1,j)]);

end

cost_dis(1,j)=sum(nodes_dis);

end