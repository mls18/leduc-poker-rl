classdef LeducPokerTable < handle
    %LEDUCPOKERTABLE Implements game mechanics including shuffling the deck 
    % and dealing cards.
    
    properties
        CardDeck
        NumPotChips
        CurDeckIdx
        CommunityCard
        EmptyCard
    end
    
    methods
        function obj = LeducPokerTable(emptyCard)
            %LEDUCPOKERTABLE Construct an instance of this class    
            %   Detailed explanation goes here
            obj.CardDeck = utils.getShuffledCardDeck();
            obj.NumPotChips = 0;
            obj.CurDeckIdx = 1;
            obj.EmptyCard = emptyCard;
            obj.CommunityCard = struct(obj.EmptyCard);
        end

        function printCardDeck(obj)
            for idx = 1:length(obj.CardDeck)
                curCard = obj.CardDeck(idx);
                fprintf('%s %s, value=%d\n', ...
                    curCard.rank, curCard.suit, curCard.value)
            end
        end

        function card = dealTopCard(obj)
            if obj.CurDeckIdx <= length(obj.CardDeck)
                card = obj.CardDeck(obj.CurDeckIdx);
                obj.CurDeckIdx = obj.CurDeckIdx + 1;
            else
                disp("All cards have been dealt; deck is empty")
                card = struct(obj.EmptyCard);
            end
        end

        function resetForNewGame(obj)
            obj.CardDeck = utils.getShuffledCardDeck();
            obj.NumPotChips = 0;
            obj.CurDeckIdx = 1;
            obj.CommunityCard = struct(obj.EmptyCard);
        end

        function receiveBet(obj, betAmount)
            obj.modifyNumChips(betAmount)
        end

        function potAmount = resetPotToZero(obj)
            potAmount = obj.NumPotChips;
            obj.NumPotChips = 0;
        end
    end

    methods(Access=private)
        function modifyNumChips(obj, changeAmount)
            obj.NumPotChips = obj.NumPotChips + changeAmount;
        end

        function setCommunityCard(obj, communityCard)
            obj.CommunityCard = communityCard;
        end
    end
end

