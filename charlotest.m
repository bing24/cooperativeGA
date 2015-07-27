clear all
close all

for i = 1: gaConfig.PopulationSize
	temp=[];
	for j = 1: gaConfig.NumberofWorkers
		lengthofchro(j)=length(nonzeros(population(j).charging_locationx(:,i)));
		temp=max(lengthofchro);
	end	
	for j = 1: temp
		for ii= 1: gaConfig.NumberofWorkers
			if isempty population(ii).charging_locationx(l,i)
				