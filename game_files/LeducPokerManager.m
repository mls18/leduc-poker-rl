classdef LeducPokerManager < handle
    %LEDUCPOKERMANAGER Summary of this class goes here
    %   Detailed explanation goes here

    properties
        Table
        Player1
        Player2
        StartWithPlayer1
        GameState
        GameSettings
    end

    methods(Access=public)
        function obj = LeducPokerManager()
            %LEDUCPOKERMANAGER initialize poker table and players
            obj.GameSettings = GameSettings();
            obj.Table = LeducPokerTable(obj.GameSettings.getEmptyCard());

            obj.Player1 = Player('player1', ...
                obj.GameSettings.NumStartingChips, ...
                obj.GameSettings.getEmptyCard(), ...
                false);
            obj.Player2 = Player('player2', ...
                obj.GameSettings.NumStartingChips, ...
                obj.GameSettings.getEmptyCard(), ...
                false);

            obj.StartWithPlayer1 = true;           
        end

        function resetForNewGame(obj)
            obj.Table.resetForNewGame()
            obj.Player1.resetForNewGame()
            obj.Player2.resetForNewGame()
            obj.StartWithPlayer1 = ~obj.StartWithPlayer1;
        end

        function dealStartingCards(obj)
            card1 = obj.Table.dealTopCard();
            card2 = obj.Table.dealTopCard();
            obj.Player1.Card = card1;
            obj.Player2.Card = card2;
        end

        function addBlindBetsToPot(obj)
            % each player starts with 1 chip in the pot
            blindBet = obj.GameSettings.BlindBetSize;
            obj.transferBetFromPlayerToPot(blindBet, obj.Player1)
            obj.transferBetFromPlayerToPot(blindBet, obj.Player2)
        end 

        function winner = playOneStage(obj, isPreFlop)
            % play one stage of the game (PreFlop or Flop)
            curPlayer = obj.Player2;
            oppPlayer = obj.Player1;
            if obj.StartWithPlayer1
                curPlayer = obj.Player1;
                oppPlayer = obj.Player2;                
            end
            
            % play the first betting round
            obj.GameState.IsPreFlop = isPreFlop;
            obj.GameState.NumRaisesThisStage = 0;

            winner = obj.playOneBettingRound(curPlayer, oppPlayer);
            if ~isempty(winner)
                return;
            end

            % check if players put in same amount of chips in the pot
            if obj.GameState.SelfBetAmount ~= obj.GameState.OppBetAmount
                winner = obj.playOneBettingRound(curPlayer, oppPlayer);
            end
        end

        function communityCard = revealCommunityCard(obj)
            communityCard = obj.Table.dealTopCard();
            obj.Table.CommunityCard = communityCard;
        end

        function settlePotAfterFold(obj, winner)
            potAmount = obj.Table.resetPotToZero();
            winner.addWinnings(potAmount);
        end

        function winner = determineWinnerAndSettlePot(obj)
            winner = utils.determineWinner(obj);
            potAmount = obj.Table.resetPotToZero();
            if ~isempty(winner)
                winner.addWinnings(potAmount);
            else
                % split pot
                numPlayers = 2;
                if obj.StartWithPlayer1
                    obj.Player1.addWinnings(idivide(potAmount, numPlayers, "ceil"))
                    obj.Player2.addWinnings(idivide(potAmount, numPlayers, "floor"))
                else
                    obj.Player1.addWinnings(idivide(potAmount, numPlayers, "floor"))
                    obj.Player2.addWinnings(idivide(potAmount, numPlayers, "ceil"))
                end
            end
        end
    end

    methods(Access=private)
        function winner = playOneBettingRound(obj, curPlayer, oppPlayer)
            obj.GameState.IsStartingPlayer = true;

            winner = obj.processOnePlayerAction(curPlayer, oppPlayer);
            if ~isempty(winner)
                return;
            end
            
            reachedNumRaisesLimit = (obj.GameState.NumRaisesThisStage >= obj.GameSettings.MaxNumRaisesPerStage);
            betAmountsEqual = (obj.GameState.SelfBetAmount == obj.GameState.OppBetAmount);
            if ~(reachedNumRaisesLimit && betAmountsEqual)
                % switch references to prompt 2nd player for action
                tempRef = curPlayer;
                curPlayer = oppPlayer;
                oppPlayer = tempRef;
    
                obj.GameState.IsStartingPlayer = false;
                winner = obj.processOnePlayerAction(curPlayer, oppPlayer);
            end
        end

        function winner = processOnePlayerAction(obj, curPlayer, oppPlayer)
            winner = struct([]);

            utils.updateGameState(obj, curPlayer, oppPlayer)
            fprintf("Current Player: %s\n", curPlayer.Name)
            disp(obj.GameState)

            gameStateEnc = utils.encodeGameStateAsVec(obj.GameState);
            action = curPlayer.takeAction(gameStateEnc);

            switch action
                case 'C' % check/call
                    discrepancy = obj.GameState.OppBetAmount - obj.GameState.SelfBetAmount;
                    obj.transferBetFromPlayerToPot(discrepancy, curPlayer)

                case 'B' % bet (raise)
                    discrepancy = obj.GameState.OppBetAmount - obj.GameState.SelfBetAmount;
                    obj.transferBetFromPlayerToPot(discrepancy, curPlayer)
                    % when max no. of re-raises that round are reached, player
                    % trying to re-raise just calls instead.
                    if obj.GameState.NumRaisesThisStage < obj.GameSettings.MaxNumRaisesPerStage
                        betAmount = obj.GameSettings.PreFlopRaiseSize;
                        obj.transferBetFromPlayerToPot(betAmount, curPlayer)
                        obj.GameState.NumRaisesThisStage = obj.GameState.NumRaisesThisStage + 1;
                    end

                case 'F' % fold
                    winner = oppPlayer;

                otherwise
                    fprintf("Invalid action '%s'\n", action);
            end
            utils.updateGameState(obj, curPlayer, oppPlayer)
        end

        function transferBetFromPlayerToPot(obj, betSize, player)
            player.placeBet(betSize);
            obj.Table.receiveBet(betSize)
        end
    end
end