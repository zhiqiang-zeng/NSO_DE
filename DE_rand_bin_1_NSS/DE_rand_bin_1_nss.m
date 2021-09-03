% Developer: Zhiqiang Zeng
% 
% Contact Info: zhiqiang.zeng@outlook.com

clc;
clear;
close all;

MaxIt=2999;      % Maximum Number of Iterations
nVar=30;            % Number of Decision Variables



VarMin=-100;         % Lower Bound of Variables
VarMax= 100;         % Upper Bound of Variable
VarSize=[nVar 1];   % Size of Decision Variables Matrix
nPop=100;        % Population Size (Swarm Size)

optimal=[-1400,-1300,-1200,-1100,-1000,-900,-800,-700,-600,-500,-400,-300,-200,-100,100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400];
for problem_num=23:23
    result=[];
    for jj=1:1
CostFunction=@(x) cec13_func(x,problem_num); 
bais=optimal(problem_num);
IBest_Cost=zeros(300000,1);
its=1;

Position=[];
Cost=[];
Count=[];
particle_best_Cost=[];
particle_best_Position=[];
Best_Cost=[];
Best_Position=[];
SecondBest_Cost=[];
SecondBest_Position=[];



GlobalBest_Cost=inf;

particle_used_flag=zeros(nPop,1);
for i=1:nPop
    
    % Initialize Position
    Position(:,i)=unifrnd(VarMin,VarMax,VarSize);
    Count(i)=0;
    % Evaluation
    Cost(i)=CostFunction(Position(:,i));
    
     Best_Cost(i)=Cost(i);
     Best_Position(:,i)=Position(:,i);
     
     SecondBest_Cost(i)=inf;
     SecondBest_Position(:,i)=Position(:,i);
    

     particle_best_Cost(i)=Cost(i);
     particle_best_Position(:,i)=Position(:,i);

    % Update Global Best
    if Cost(i)<GlobalBest_Cost 
        GlobalBest_Cost=Cost(i);   
    end
     IBest_Cost(its)=GlobalBest_Cost-bais;
    its=its+1;
    
end


A=[];
A_Cost=[];

pop_position=zeros(nVar,nPop);

for it=1:MaxIt
        
   
    
    for i=1:nPop
         
      
        
         
         r1_index=unidrnd(nPop);
         while r1_index==i
             r1_index=unidrnd(nPop);
         end

         r2_index=unidrnd(nPop);
         while r2_index==r1_index  || r2_index==i
             r2_index=unidrnd(nPop);
         end
         
         r3_index=unidrnd(nPop);
         while r3_index==r1_index  ||r3_index==r2_index|| r3_index==i
             r3_index=unidrnd(nPop);
         end 
        xu=Position(:,r1_index)+0.7*(Position(:,r2_index)-Position(:,r3_index));

       
      
        xc=cross(xu,Position(:,i),0.5);


        less_cost=find(xc<VarMin);
        xc(less_cost,1)=(Position(less_cost,i)+VarMin)/2;
        larger_cost=find(xc>VarMax);
        xc(larger_cost,1)=(Position(larger_cost,i)+VarMax)/2;

        pop_position(:,i)=xc;

          
    end
    
    pop_cost=CostFunction(pop_position);

    for i=1:nPop

        if pop_cost(i)<particle_best_Cost(i)
            particle_best_Cost(i)=pop_cost(i);
            particle_best_Position(:,i)=pop_position(:,i);
        end
        
       
        if pop_cost(i)<Cost(i)
            
            Position(:,i)=pop_position(:,i);
            Cost(i)=pop_cost(i);
            if length(A_Cost)==nPop
                de_n=unidrnd(nPop);
                A(:,de_n)=[];
                A_Cost(de_n)=[];
            end
            A=[A,Position(:,i)];
            A_Cost=[A_Cost,Cost(i)];
            
            particle_used_flag(i)=0;
            Count(i)=0;
        else
            
             Count(i)=Count(i)+1;
            
            if pop_cost(i)<Best_Cost(i)
                Best_Cost(i)=pop_cost(i);
                Best_Position(:,i)=pop_position(:,i);
            end
            if pop_cost(i)<SecondBest_Cost(i) && pop_cost(i)>Best_Cost(i)
                SecondBest_Cost(i)=pop_cost(i);
                SecondBest_Position(:,i)=pop_position(:,i);
            end
            
switch particle_used_flag(i)
    case 0
        if Count(i)>32
            Position(:,i)=Best_Position(:,i);
            Cost(i)=Best_Cost(i);
            
            Count(i)=0;
            particle_used_flag(i)=1;

       end
        
    case 1 
       
        if Count(i)>16
            Position(:,i)=SecondBest_Position(:,i);
            Cost(i)=SecondBest_Cost(i);
            Count(i)=0;
            particle_used_flag(i)=2;
        end
    case 2
         if  Count(i)>16
             a1_index=unidrnd(nPop);
             Position(:,i)=A(:,a1_index);
             Cost(i)=A_Cost(a1_index);
            Count(i)=0;
            particle_used_flag(i)=3;
        end
        
    case 3
        if Count(i)>16
            Position(:,i)=particle_best_Position(:,i);
            Cost(i)=particle_best_Cost(i);
            Count(i)=0;
            particle_used_flag(i)=0;
        end
        
end
            
            
        end
        
        %             Update Global Best
        if Cost(i)<GlobalBest_Cost
            
            GlobalBest_Cost=Cost(i);
            
        end
         IBest_Cost(its)=GlobalBest_Cost-bais;
    its=its+1;
    end
    
   
    

    
   

    
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(GlobalBest_Cost-bais)]);
    
    

    if GlobalBest_Cost-bais<10^(-8)
        GlobalBest_Cost=bais;
        break;
    end
%     IBest_Cost=[IBest_Cost;GlobalBest_Cost-bais];
end
% if GlobalBest_Cost-bais>0.1
%     break;
% end
% BestSol = GlobalBest;
result=[result;GlobalBest_Cost-bais];
    end
% str1=strcat('Sheet',num2str(problem_num));
% xlswrite('result\de_rand_bin_1_dc_64_64_64_64.xlsx',result,str1);    
end


