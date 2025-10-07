classdef RLPlayer < Player
    % RLPlayer - A player that uses Q-learning to make decisions
    
    properties
        QTable          % Q-table for storing state-action values
        LearningRate    % Alpha parameter for Q-learning
        DiscountFactor  % Gamma parameter for Q-learning
        ExplorationRate % Epsilon parameter for epsilon-greedy policy
        StateHistory    % History of states visited in this game
        ActionHistory   % History of actions taken in this game
        RewardHistory   % History of rewards received in this game
        ActionSpace     % Possible actions: 'C' (check/call), 'B' (bet/raise), 'F' (fold)
    end
    
    methods
        function obj = RLPlayer(name, numStartingChips, emptyCard)
            % Constructor for RLPlayer
            obj@Player(name, numStartingChips, emptyCard, true);

            % Initialize RL parameters
            obj.LearningRate = 0.1;
            obj.DiscountFactor = 0.9;
            obj.ExplorationRate = 0.1;
            obj.ActionSpace = ['C', 'B', 'F'];

            % Initialize Q-table as a containers.Map
            obj.QTable = containers.Map('KeyType', 'char', 'ValueType', 'any');

            % Initialize histories
            obj.StateHistory = {};
            obj.ActionHistory = {};
            obj.RewardHistory = [];
        end

        function action = takeAction(obj, gameStateEnc)
            stateKey = obj.getStateKey(gameStateEnc);

            % Initialize Q-values with small random values instead of zeros
            if ~obj.QTable.isKey(stateKey)
                obj.QTable(stateKey) = (rand(1, length(obj.ActionSpace)) - 0.5) * 0.1;
            end

            % Rest of the method remains the same
            if rand() < obj.ExplorationRate
                actionIdx = randi(length(obj.ActionSpace));
            else
                [~, actionIdx] = max(obj.QTable(stateKey));
            end

            action = obj.ActionSpace(actionIdx);
            obj.StateHistory{end+1} = stateKey;
            obj.ActionHistory{end+1} = actionIdx;

            fprintf('AI Q-values for state %s: [%.3f, %.3f, %.3f] -> chose %s\n', ...
                stateKey, obj.QTable(stateKey), action);
        end

        function updateQValues(obj, finalReward)
            fprintf('Updating Q-values for %s with final reward: %.2f\n', obj.Name, finalReward);

            obj.RewardHistory(end+1) = finalReward;

            for t = length(obj.StateHistory):-1:1
                stateKey = obj.StateHistory{t};
                actionIdx = obj.ActionHistory{t};

                if t == length(obj.StateHistory)
                    reward = finalReward;
                    nextStateMaxQ = 0;
                else
                    reward = 0;
                    nextStateKey = obj.StateHistory{t+1};
                    nextStateQ = obj.QTable(nextStateKey);
                    nextStateMaxQ = max(nextStateQ);
                end

                qValues = obj.QTable(stateKey);
                oldQ = qValues(actionIdx);
                newQ = oldQ + obj.LearningRate * (reward + obj.DiscountFactor * nextStateMaxQ - oldQ);

                % Debug output
                fprintf('State: %s, Action: %d, OldQ: %.3f, NewQ: %.3f\n', ...
                    stateKey, actionIdx, oldQ, newQ);

                qValues(actionIdx) = newQ;
                obj.QTable(stateKey) = qValues;
            end

            obj.resetHistory();
        end

        function resetHistory(obj)
            % Reset the history for a new game
            obj.StateHistory = {};
            obj.ActionHistory = {};
            obj.RewardHistory = [];
        end

        function resetForNewGame(obj)
            % Reset player for a new game
            resetForNewGame@Player(obj);
            obj.resetHistory();
        end

        function saveQTable(obj, filename)
            % Save the Q-table to a file
            QTable = obj.QTable;  % Create a copy for saving
            save(filename, 'QTable');
        end

        function loadQTable(obj, filename)
            % Load the Q-table from a file
            data = load(filename);
            obj.QTable = data.QTable;
        end
        
        function setExplorationRate(obj, rate)
            % Set the exploration rate
            obj.ExplorationRate = rate;
        end
        
        function stateKey = getStateKey(obj, gameStateEnc)
            stateKey = sprintf('%d,%d,%d,%d,%d', ...
                round(gameStateEnc(1)), round(gameStateEnc(2)), round(gameStateEnc(3)), ...
                round(gameStateEnc(4)), round(gameStateEnc(5)));
        end
    end
end