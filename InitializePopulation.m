classdef InitializePopulation < handle
    
    properties
        color
        cover
        charging_index
        charging_locationx
        charging_locationy
        chromo
        chromo_index
        currentx
        currenty
        % chromo_locationx
        % chromo_locationy
        chromo_number
        xbordermax=14;
        xbordermin=1;
        ybordermax=11;
        ybordermin=1;
        fitness
        minimumFitness
        bestIndividualIndex
        newPopulation
        gene_length=20;
        start_point=14;
        end_point=124;
        initialx
        initialy
        charging_ratio=0.5;
        charging_enough
        nodes_dis_charging;
        max_speed_charging=8;
        judger;
        agent_number=5;
        cost_dis;
        cost_dis_charging;
    end
    
    methods
        
        function population = InitializePopulation(map, gaConfig)
            population.chromo_number=population.gene_length;
            
            % population.chromo=round(4*rand(population.gene_length,gaConfig.PopulationSize));
            
            
            for j= 1: gaConfig.PopulationSize
                for i = 1: population.gene_length
                    if population.charging_ratio <= rand
                        population.chromo(i,j)=0;
                    else
                        population.chromo(i,j)=ceil(4*rand);
                    end
                end
            end
           
        end % function
        function  Evaluating (obj,map,gaConfig)

            % Clear memory from last iteration
            obj.charging_index=zeros(obj.gene_length,gaConfig.PopulationSize);
            obj.charging_locationx=[];
            obj.charging_locationy=[];
            obj.nodes_dis_charging=[];
            obj.judger=[];
            obj.cover=[];
            obj.charging_enough=[];
            % Generate locations for working robots and charging robots
            for j=1:gaConfig.PopulationSize
                for i=1:obj.gene_length
                    if i==1
                        obj.currentx(i,j)=obj.initialx;
                        obj.currenty(i,j)=obj.initialy;
                    elseif obj.chromo(i,j)==1
                        if obj.currenty(i-1,j)==obj.ybordermax
                            obj.currentx(i,j)=obj.currentx(i-1,j);
                            obj.currenty(i,j)=obj.currenty(i-1,j);
                        else
                            obj.currentx(i,j)=obj.currentx(i-1,j);
                            obj.currenty(i,j)=obj.currenty(i-1,j)+1;
                        end
                    elseif obj.chromo(i,j)==2
                        if obj.currentx(i-1,j)==obj.xbordermin
                            obj.currentx(i,j)=obj.currentx(i-1,j);
                            obj.currenty(i,j)=obj.currenty(i-1,j);
                        else
                            obj.currentx(i,j)=obj.currentx(i-1,j)-1;
                            obj.currenty(i,j)=obj.currenty(i-1,j);
                        end
                    elseif obj.chromo(i,j)==3
                        if obj.currenty(i-1,j)==obj.ybordermin
                            obj.currentx(i,j)=obj.currentx(i-1,j);
                            obj.currenty(i,j)=obj.currenty(i-1,j);
                        else
                            obj.currentx(i,j)=obj.currentx(i-1,j);
                            obj.currenty(i,j)=obj.currenty(i-1,j)-1;
                        end
                    elseif obj.chromo(i,j)==4
                        if obj.currentx(i-1,j)==obj.xbordermax
                            obj.currentx(i,j)=obj.currentx(i-1,j);
                            obj.currenty(i,j)=obj.currenty(i-1,j);
                        else
                            obj.currentx(i,j)=obj.currentx(i-1,j)+1;
                            obj.currenty(i,j)=obj.currenty(i-1,j);
                        end
                    elseif obj.chromo(i,j)==0
                        obj.currentx(i,j)=obj.currentx(i-1,j);
                        obj.currenty(i,j)=obj.currenty(i-1,j);
                    end
                end
            end
            
            % Charging robots locations
            for j=1:gaConfig.PopulationSize
                count=1;
                for i=1:obj.gene_length
                    
                    if obj.chromo(i,j)==0
                        obj.charging_locationx(count,j)=obj.currentx(i,j);
                        obj.charging_locationy(count,j)=obj.currenty(i,j);
                        count=count+1;
                    end
                end
            end
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
                
                obj.cost_dis(1,j)=length(nonzeros(obj.chromo(:,j)));
                
                % Calculate the travel distance of charging robots
                
                % for i= 1: size(obj.charging_locationx,1)-1
                %     if obj.charging_locationx(i+1,j)~= 0
                %         obj.nodes_dis_charging(i,j)=norm([obj.charging_locationx(i,j),obj.charging_locationy(i,j)]-[obj.charging_locationx(i+1,j),obj.charging_locationy(i+1,j)]);
                %     end
                % end
                % obj.cost_dis_charging(1,j)=sum(obj.nodes_dis_charging(:,j));
                
                % Calculate path coverage
                % count=0;
                % for ii=1:size(map.mission_num,1)
                %     cc=map.mission_num(ii)~=obj.chromo_index(:,j);
                %     if sum(cc)~=size(obj.chromo,1)
                %         count=count+1;
                %     end
                % end
                % obj.cover(1,j)=count/size(map.mission_num,1);
                
                % calculate charging time and operating time
                
                % count=1;
                % ii=1;
                % gg=1;
                % temp=[];
                % tempp=[];
                % while count < obj.gene_length
                    
                %     if obj.chromo(count,j) == 0
                %         cc=1;
                        
                %         while obj.chromo(count,j)==0 & count < obj.gene_length
                %             temp(ii)=cc;
                %             cc=cc+1;
                %             count=count+1;
                            
                %         end
                %         ii=ii+1;
                %     else
                %         dd=1;
                %         while obj.chromo(count,j)~=0 & count < obj.gene_length
                %             tempp(gg)=dd;
                %             dd=dd+1;
                %             count=count+1;
                %         end
                %         gg=gg+1;
                %     end
                % end
                
                % if length(temp)>length (tempp)
                %     temp=temp(1:end-1);
                % elseif length(temp)<length(tempp)
                %     tempp=tempp(1:end-1);
                % end
                
                % obj.charging_enough(1,j)=sum(temp>tempp)/length(temp);
                
                % Consider the maximum speed constraint
                
                % if sum(obj.nodes_dis_charging(:,j)>10)==0
                %     obj.judger(j)=1;
                % else
                %     obj.judger(j)=100;
                % end
                
                % Calculate the fitness
                % obj.fitness(1,j)=(obj.cost_dis(1,j)+obj.cost_dis_charging(1,j))/obj.cover(1,j)/obj.charging_enough(1,j)*obj.judger(j);
                
                % % obj.fitness(1,j)=obj.cost_dis(1,j);
                % [obj.minimumFitness, obj.bestIndividualIndex] = min(obj.fitness);
                
            end
            % fprintf('Minimum Fitness: %d\n',obj.minimumFitness);
            % fprintf('Minimum Fitness index: %d\n',obj.bestIndividualIndex);
        end % function

        function Evaluate_all(obj)
             % Calculate the fitness
            working_dis=sum(obj)
            obj
            obj.fitness(1,j)=(obj.cost_dis(1,j)+obj.cost_dis_charging(1,j))/obj.cover(1,j)/obj.charging_enough(1,j)*obj.judger(j);
              
            [obj.minimumFitness, obj.bestIndividualIndex] = min(obj.fitness);
            fprintf('Minimum Fitness: %d\n',obj.minimumFitness);
            fprintf('Minimum Fitness index: %d\n',obj.bestIndividualIndex);
                



        end %end function
        function Selecting (obj,gaConfig,tournamentSelectionParameter)
            obj.newPopulation=obj.chromo;
            for i = 1:gaConfig.TournamentSize:gaConfig.PopulationSize
                
                % iSelected = TournamentSelect( fitnessValues, tournamentSelectionParameter, tournamentSize)
                %select 'tournamentSize' candidates for tournament
                candidates = 1 + fix(rand(1,gaConfig.TournamentSize)*gaConfig.PopulationSize);
                candidateFitnesses = obj.fitness(candidates);
                [~, sortedIndexes] = sort(candidateFitnesses,1,'descend');
                selectionProbabilityMatrix = tournamentSelectionParameter*((1-tournamentSelectionParameter).^(0:gaConfig.TournamentSize-2)');
                r = rand;
                iSelected = candidates(sortedIndexes(r>selectionProbabilityMatrix));
                if isempty(iSelected)
                    iSelected = candidates(sortedIndexes(end));
                else
                    iSelected = iSelected(1);
                end
                
                %% TOURNAMENT SELECTION
                
                chromosome1 = obj.chromo(:,iSelected);
                candidates = 1 + fix(rand(1,gaConfig.TournamentSize)*gaConfig.PopulationSize);
                candidateFitnesses = obj.fitness(candidates);
                [~, sortedIndexes] = sort(candidateFitnesses,1,'descend');
                selectionProbabilityMatrix = tournamentSelectionParameter*((1-tournamentSelectionParameter).^(0:gaConfig.TournamentSize-2)');
                r = rand;
                iSelected = candidates(sortedIndexes(r>selectionProbabilityMatrix));
                if isempty(iSelected)
                    iSelected = candidates(sortedIndexes(end));
                else
                    iSelected = iSelected(1);
                end
                chromosome2 = obj.chromo(:,iSelected);
                
                %% CROSS-OVER
                r = rand;
                if ( r < gaConfig.CrossoverRate)
                    
                    n=ceil(rand(size(obj.chromo,1)));
                    newChromosomePair=zeros(size(obj.chromo,1),2);
                    newChromosomePair(1:n,1)=chromosome1(1:n);
                    newChromosomePair(n:end,1)=chromosome2(n:end);
                    newChromosomePair(1:n,2)=chromosome2(1:n);
                    newChromosomePair(n:end,2)=chromosome1(n:end);
                    
                    obj.newPopulation(:,i) = newChromosomePair(:,1);
                    obj.newPopulation(:,i+1) = newChromosomePair(:,2);
                else
                    obj.newPopulation(:,i) = chromosome1;
                    obj.newPopulation(:,i+1) = chromosome2;
                end
                
            end
        end
        
        function Ploting(obj,map)
            % hold off
            plot(obj.currentx(:,obj.bestIndividualIndex),obj.currenty(:,obj.bestIndividualIndex),'Color',obj.color,'linewidth',3)
            % hold on
            contour(map.matrix,1,'black','linewidth',5)
            title(obj.minimumFitness)
            chargingx=nonzeros(obj.charging_locationx(:,obj.bestIndividualIndex));
            chargingy=nonzeros(obj.charging_locationy(:,obj.bestIndividualIndex));
            plot(chargingx,chargingy,'-.k')
            
        end
        
        function Mutating(obj,map,gaConfig)
            indexes = rand(size(obj.chromo))<gaConfig.mutationProbability  ;               % Index for Mutations
            
            temp=round(4*rand(obj.gene_length,gaConfig.PopulationSize));
            
            %fix the starting point finishing point and best chromosome
            % indexes(1,:)=0;
            % indexes(end,:)=0;
            indexes(:,obj.bestIndividualIndex)=0;
            obj.newPopulation(indexes) =temp(indexes);
            
            % = tempPopulation(indexes)*-1+1;                     % Bit Flip Occurs
            %% PRESERVATION OF PREVIOUS BEST SOLUTION
            bestChromosome =obj.chromo(:,obj.bestIndividualIndex);
            
            randIndexes = ceil(rand(1,gaConfig.numberOfReplications).*size(obj.chromo,2));
            obj.newPopulation(:,randIndexes) = repmat(bestChromosome,1,gaConfig.numberOfReplications);
            obj.chromo=obj.newPopulation;
            
        end %end function

        function SetColor(obj,color)
            obj.color=color;
        end
        
        function SetInitial(obj,xy)
            obj.initialx=xy(1);
            obj.initialy=xy(2);
        end
    end % method
    
end % classdef