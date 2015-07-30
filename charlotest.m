% clear all
% close all
for nn= 1:gaConfig.NumberofChargers
    chargers(nn).locationx=zeros(temp,gaConfig.PopulationSize);
    chargers(nn).locationy=zeros(temp,gaConfig.PopulationSize);
end

for i = 1: gaConfig.PopulationSize
	temp=[];
	for j = 1: gaConfig.NumberofWorkers
		lengthofchro(j)=length(nonzeros(population(j).charging_locationx(:,i)));
		temp=max(lengthofchro);
    end
    for nn= 1:gaConfig.NumberofChargers
    chargers(nn).temppx=[];
    chargers(nn).temppy=[];
    
    end
	for j = 1: temp
		for ii= 1: gaConfig.NumberofWorkers
			if j <= lengthofchro(ii)
                pick=ceil(rand*gaConfig.NumberofChargers);
                chargers(pick).temppx=cat(1,chargers(pick).temppx,obj(ii).charging_locationx(j,i));
                chargers(pick).temppy=cat(1,chargers(pick).temppy,obj(ii).charging_locationy(j,i));
            end
        end
    end
    for jj = 1:gaConfig.NumberofChargers
        chargers(jj).locationx(1:length(chargers(jj).temppx),i) = chargers(jj).temppx;    
        chargers(jj).locationy(1:length(chargers(jj).temppy),i) = chargers(jj).temppy;
    end
end
                
                    
				