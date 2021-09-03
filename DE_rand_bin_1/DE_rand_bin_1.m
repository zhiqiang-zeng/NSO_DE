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
% bais=100*problem_num;

Position=[];
Cost=[];

IBest_Cost=zeros(300000,1);
its=1;


GlobalBest_Cost=inf;


for i=1:nPop
    
    % Initialize Position
    Position(:,i)=unifrnd(VarMin,VarMax,VarSize);
    % Evaluation
    Cost(i)=CostFunction(Position(:,i));
    

    % Update Global Best
    if Cost(i)<GlobalBest_Cost 
        GlobalBest_Cost=Cost(i);   
    end
     IBest_Cost(its)=GlobalBest_Cost-bais;
    its=its+1;
    
end

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


        
       
        if pop_cost(i)<Cost(i)
            

            
            Position(:,i)=pop_position(:,i);
            Cost(i)=pop_cost(i);
            
        end
        
        % Update Global Best
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

result=[result;GlobalBest_Cost-bais];
    end
% str1=strcat('Sheet',num2str(problem_num));
% xlswrite('result\de_rand_bin_1.xlsx',result,str1);    
end


