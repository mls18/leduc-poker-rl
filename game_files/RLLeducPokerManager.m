classdef RLLeducPokerManager < LeducPokerManager
    % RLLeducPokerManager - Manages the game with RL capabilities
    
    properties
        TrainingMode    % Whether the manager is in training mode
        TrainingGames   % Number of training games to play
        Player1IsAI     % Whether Player1 is an AI
        Player2IsAI     % Whether Player2 is an AI
        TrainingStats   % Statistics about training
    end
    
    methods
        function obj = RLLeducPokerManager()
            % Constructor that initializes the game with RL capabilities
            obj@LeducPokerManager();
            obj.TrainingMode = false;
            obj.TrainingGames = 0;
            obj.Player1IsAI = false;
            obj.Player2IsAI = false;
            obj.TrainingStats = struct('Player1Wins', 0, 'Player2Wins', 0, 'Ties', 0);
            
            % Initialize GameState
            obj.GameState = struct('IsPreFlop', true, ...
                'NumRaisesThisStage', 0, ...
                'SelfBetAmount', 0, ...
                'OppBetAmount', 0, ...
                'IsStartingPlayer', true);
        end
        
        function setupPlayers(obj, player1IsAI, player2IsAI)
            % Set up the players, determining which are AI
            obj.Player1IsAI = player1IsAI;
            obj.Player2IsAI = player2IsAI;
            
            % Create the appropriate player objects
            if player1IsAI
                obj.Player1 = RLPlayer('player1', ...
                    obj.GameSettings.NumStartingChips, ...
                    obj.GameSettings.getEmptyCard());
            else
                obj.Player1 = Player('player1', ...
                    obj.GameSettings.NumStartingChips, ...
                    obj.GameSettings.getEmptyCard(), ...
                    false);
            end
            
            if player2IsAI
                obj.Player2 = RLPlayer('player2', ...
                    obj.GameSettings.NumStartingChips, ...
                    obj.GameSettings.getEmptyCard());
            else
                obj.Player2 = Player('player2', ...
                    obj.GameSettings.NumStartingChips, ...
                    obj.GameSettings.getEmptyCard(), ...
                    false);
            end
        end
        
        function trainAgent(obj, numGames)
            % Train the RL agent by playing multiple games
            obj.TrainingMode = true;
            obj.TrainingGames = numGames;
            
            % Setup two AI players for training
            obj.setupPlayers(true, true);
            
            % Store the original exploration rates
            origExploreRate1 = obj.Player1.ExplorationRate;
            origExploreRate2 = obj.Player2.ExplorationRate;
            
            % Set higher exploration rates for training
            obj.Player1.setExplorationRate(0.3);
            obj.Player2.setExplorationRate(0.3);
            
            fprintf('Training AI players for %d games...\n', numGames);
            
            % Track progress
            progressStep = max(1, floor(numGames/10));
            
            % Play training games
            for i = 1:numGames
                if mod(i, progressStep) == 0
                    fprintf('Training game %d/%d (%.1f%%)\n', i, numGames, (i/numGames)*100);
                end
                
                % Play a game
                [winner, potAmount] = obj.playOneGame();
                
                % Update Q-values for both players
                if isempty(winner)
                    % Tie game
                    obj.Player1.updateQValues(0);
                    obj.Player2.updateQValues(0);
                    obj.TrainingStats.Ties = obj.TrainingStats.Ties + 1;
                elseif strcmp(winner.Name, obj.Player1.Name)
                    % Player 1 wins
                    obj.Player1.updateQValues(potAmount);
                    obj.Player2.updateQValues(-potAmount);
                    obj.TrainingStats.Player1Wins = obj.TrainingStats.Player1Wins + 1;
                else
                    % Player 2 wins
                    obj.Player1.updateQValues(-potAmount);
                    obj.Player2.updateQValues(potAmount);
                    obj.TrainingStats.Player2Wins = obj.TrainingStats.Player2Wins + 1;
                end
                
                % Gradually reduce exploration rate
                if mod(i, floor(numGames/10)) == 0
                    newRate1 = max(0.05, origExploreRate1 * (1 - i/numGames));
                    newRate2 = max(0.05, origExploreRate2 * (1 - i/numGames));
                    obj.Player1.setExplorationRate(newRate1);
                    obj.Player2.setExplorationRate(newRate2);
                end
                
                % Reset for the next game
                obj.resetForNewGame();
            end
            
            % Restore original exploration rates
            obj.Player1.setExplorationRate(origExploreRate1);
            obj.Player2.setExplorationRate(origExploreRate2);
            
            % Print training stats
            fprintf('Training complete.\n');
            fprintf('Player 1 wins: %d (%.1f%%)\n', obj.TrainingStats.Player1Wins, obj.TrainingStats.Player1Wins/numGames*100);
            fprintf('Player 2 wins: %d (%.1f%%)\n', obj.TrainingStats.Player2Wins,obj.TrainingStats.Player2Wins/numGames*100);
            fprintf('Ties: %d (%.1f%%)\n', obj.TrainingStats.Ties,obj.TrainingStats.Ties/numGames*100);
            
            obj.TrainingMode = false;
        end
        
        function saveAgentModel(obj, filename)
            % Save the trained agent's Q-table
            if obj.Player1IsAI
                obj.Player1.saveQTable([filename '_player1.mat']);
            end
            
            if obj.Player2IsAI
                obj.Player2.saveQTable([filename '_player2.mat']);
            end
            
            fprintf('Agent models saved to %s\n', filename);
        end
        
        function loadAgentModel(obj, filename)
            % Load the trained agent's Q-table
            if obj.Player1IsAI
                obj.Player1.loadQTable([filename '_player1.mat']);
            end
            
            if obj.Player2IsAI
                obj.Player2.loadQTable([filename '_player2.mat']);
            end
            
            fprintf('Agent models loaded from %s\n', filename);
        end
        
        function [winner, potAmount] = playOneGame(obj)
            % Play a single game and return the winner
            % This method is similar to the playOneGame function in playLeducPoker.m
            % But it returns the winner and the pot amount
            
            obj.dealStartingCards();
            obj.addBlindBetsToPot();
            
            if ~obj.TrainingMode
                disp("***PRE-FLOP***");
            end
            
            isPreFlop = true;
            winner = obj.playOneStage(isPreFlop);
            
            % Check if there's a winner (i.e., other player has folded)
            if ~isempty(winner)
                if ~obj.TrainingMode
                    fprintf("Winner: %s (opponent folded)\n", winner.Name);
                end
                potAmount = obj.Table.NumPotChips;
                obj.settlePotAfterFold(winner);
                return;
            end
            
            if ~obj.TrainingMode
                disp("***FLOP***");
            end
            
            obj.revealCommunityCard();
            isPreFlop = false;
            winner = obj.playOneStage(isPreFlop);
            
            if ~obj.TrainingMode
                disp(obj.GameState);
            end
            
            if ~isempty(winner)
                if ~obj.TrainingMode
                    fprintf("Winner: %s (opponent folded)\n", winner.Name);
                end
                potAmount = obj.Table.NumPotChips;
                obj.settlePotAfterFold(winner);
                return;
            else
                if ~obj.TrainingMode
                    disp("Both players to reveal their cards.");
                    utils.dispPlayerAndCommunityCards(obj);
                end
                
                winner = utils.determineWinner(obj);
                potAmount = obj.Table.NumPotChips;
                
                if ~isempty(winner)
                    if ~obj.TrainingMode
                        fprintf("Winner: %s\n", winner.Name);
                    end
                    winner.addWinnings(potAmount);
                    obj.Table.resetPotToZero();
                else
                    if ~obj.TrainingMode
                        disp("Tie - split pot.");
                    end
                    % Split pot
                    numPlayers = 2;
                    if obj.StartWithPlayer1
                        obj.Player1.addWinnings(idivide(potAmount, numPlayers, "ceil"));
                        obj.Player2.addWinnings(idivide(potAmount, numPlayers, "floor"));
                    else
                        obj.Player1.addWinnings(idivide(potAmount, numPlayers, "floor"));
                        obj.Player2.addWinnings(idivide(potAmount, numPlayers, "ceil"));
                    end
                    obj.Table.resetPotToZero();
                end
            end
        end
    end
end