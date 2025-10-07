classdef Player < handle
    %PLAYER Definition of player class

    properties
        Name
        NumChips
        Card
        IsAI
        BetAmount
        IsAggressor
        EmptyCard
    end

    methods
        function obj = Player(name, numStartingChips, emptyCard, isAI)
            obj.Name = name;
            obj.NumChips = numStartingChips;
            obj.IsAI = isAI;
            obj.BetAmount = 0;
            obj.EmptyCard = emptyCard;
            obj.Card = struct(obj.EmptyCard);
        end

        function action = takeAction(obj, gameStateEnc)
            % Takes in game state (opponent's bet amount; whether it's
            % first or second round of betting.
            % Also takes in the table state (amount of money each player has,
            % community card. Community card is an empty struct if it has
            % not been revealed.
            action = input("Enter desired action: C (check/call), B (bet/raise), or F (fold)", "s");
        end

        function betSize = placeBet(obj, betSize)
            obj.BetAmount = obj.BetAmount + betSize;
            obj.modifyNumChips(-betSize)
        end

        function addWinnings(obj, potAmount)
            obj.modifyNumChips(potAmount);
        end

        function resetForNewGame(obj)
            obj.BetAmount = 0;
            obj.Card = struct(obj.EmptyCard);
        end
    end

    methods(Access=private)
        function modifyNumChips(obj, changeAmount)
            obj.NumChips = obj.NumChips + changeAmount;
        end
    end
end
