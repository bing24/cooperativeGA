classdef galayer < handle
    
    properties
    	agent_number=5;
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
        	for i=1:gaConfig.PopulationSize
        		% Calculate the total distance for all working robots
        		temp=[];
        		for j=1:optimizor.agent_number
	        		temp(j)=sub(j).cost_dis(i);
	        		optimizor.distance_working(i)=sum(temp);
	        	end
        		% optimizor.distance_charging(i)=[];
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
        		optimizor.fitness(i)=optimizor.distance_working(i)/optimizor.cover(i);
	            % optimizor.fitness(i)=(optimizor.distance_working(i)+optimizor.distance_charging(i))/optimizor.cover(i)/optimizor.charging_enough(i)*optimizor.judger(i);
            end  
            [optimizor.minimumFitness, optimizor.bestIndividualIndex] = min(optimizor.fitness);
            fprintf('Minimum Fitness: %d\n',optimizor.minimumFitness);
            fprintf('Minimum Fitness index: %d\n',optimizor.bestIndividualIndex);
            
	            
        end % function
        function gaEvaluate(obj,map,gaConfig)

        end
        
    end % method
    
end % classdef 