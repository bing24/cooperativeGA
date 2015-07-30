classdef galayer < handle
    
    properties
        agent_number=5;
        charger_number=5;
        gene_length=20;
        fitness
        distance_working
        distance_charging
        charging_enough
        judger
        cover
        minimumFitness
        bestIndividualIndex
    end
    
    methods
        
        function  optimizor= galayer(sub, map, gaConfig)
            for nn= 1:gaConfig.NumberofChargers
                    chargers(nn).locationx=zeros(temp,gaConfig.PopulationSize);
                    chargers(nn).locationy=zeros(temp,gaConfig.PopulationSize);
                end
            for i=1:gaConfig.PopulationSize
                % Calculate the total distance for all working robots
                temp=[];
                for j=1:optimizor.agent_number
                    temp(j)=sub(j).cost_dis(i);
                    optimizor.distance_working(i)=sum(temp);
                end
                % Calculate the total distance for all charging robots
                
                
                
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
                
                
                 optimizor.distance_charging(i)=;
                
                
                
                % Calculate the coverage of all working robots
                count=0;
                
                for ii=1:size(map.mission_num,1)
                    cc=[];
                    for jj=1:optimizor.agent_number
                        cc=[cc; map.mission_num(ii)~=sub(jj).chromo_index(:,i)];
                    end
                    if sum(cc)~=optimizor.gene_length*optimizor.agent_number
                        count=count+1;
                    end
                end
                optimizor.cover(i)=count/size(map.mission_num,1);
                
                % optimizor.charging_enough(i)=1;
                % optimizor.judger(i)=[];
                optimizor.fitness(i)=(optimizor.distance_working(i)+0)/optimizor.cover(i);
                
                % optimizor.fitness(i)=(optimizor.distance_working(i)+optimizor.distance_charging(i))/optimizor.cover(i)/optimizor.charging_enough(i)*optimizor.judger(i);
            end
            [optimizor.minimumFitness, optimizor.bestIndividualIndex] = min(optimizor.fitness);
            fprintf('Minimum Fitness: %d\n',optimizor.minimumFitness);
            fprintf('Minimum Fitness index: %d\n',optimizor.bestIndividualIndex);
            
            
        end % function
        function gaEvaluate(obj,map,gaConfig)
            
        end
        
        function chargingEvaluate(a,chargers,obj,gaConfig)
            
            % Charging robots locations
            
            for ii=1:gaConfig.PopulationSize
                for j=1:gaConfig.NumberofWorkers
                    for i=1:length(obj(j).charging_locationx)
                        chargers(ceil(rand*gaConfig.NumberofChargers)).locationx(j,ii) = obj(i).charging_locationx(j,ii);
                        chargers(ceil(rand*gaConfig.NumberofChargers)).locationy(j,ii) = obj(i).charging_locationx(j,ii);
                    end
                end
            end
            obj.nodes_dis_charging=zeros(size(obj.charging_locationx,1)-1,gaConfig.PopulationSize);
            obj.cost_dis=[];
            % Calculate Euclidean between each nodes
            for j= 1: gaConfig.PopulationSize
                for i= 1: obj.chromo_number
                    if isempty(find(map.location_matrix(:,1)==obj.currentx(i,j) & map.location_matrix(:,2)==obj.currenty(i,j)))
                        obj.chromo_index(i,j)=0;
                    else
                        obj.chromo_index(i,j)=find(map.location_matrix(:,1)==obj.currentx(i,j) & map.location_matrix(:,2)==obj.currenty(i,j));
                    end
                    if obj.chromo(i,j)==0
                        obj.charging_index(i,j)=obj.chromo_index(i,j);
                    end
                end
                % chromo_charging=[chromo_charging;obj.chromo(end)];
                % Cost function (distance)
                
                obj.cost_dis(j)=length(nonzeros(obj.chromo(:,j)));
                
                % Calculate the travel distance of charging robots
                
                for i= 1: size(obj.charging_locationx,1)-1
                    if obj.charging_locationx(i+1,j)~= 0
                        obj.nodes_dis_charging(i,j)=norm([obj.charging_locationx(i,j),obj.charging_locationy(i,j)]-[obj.charging_locationx(i+1,j),obj.charging_locationy(i+1,j)]);
                    end
                    
                end
            end
        end
        function gaMutate(obj)
            
        end
        
    end % method
    
end % classdef