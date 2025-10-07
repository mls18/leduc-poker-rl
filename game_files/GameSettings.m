classdef GameSettings
    %GAMESETTINGS Summary of this class goes here
    %   Detailed explanation goes here

    properties
        NumStartingChips
        EmptyCard
        PreFlopRaiseSize
        FlopRaiseSize
        BlindBetSize
        MaxNumRaisesPerStage
    end

    methods
        function obj = GameSettings(numStartingChips, emptyCard, ...
                preFlopRaiseSize, flopRaiseSize, blindBetSize, maxNumRaisesPerStage)

            % default values for arguments
            arguments
                numStartingChips int32 = 20;
                emptyCard struct = struct('Suit', "", 'Rank', "", 'Value', 0);
                preFlopRaiseSize int32 = 2;
                flopRaiseSize int32 = 4;
                blindBetSize int32 = 1;
                maxNumRaisesPerStage int32 = 2;
            end
           
            obj.NumStartingChips = numStartingChips;
            obj.EmptyCard = emptyCard;
            obj.PreFlopRaiseSize = preFlopRaiseSize;
            obj.FlopRaiseSize = flopRaiseSize;
            obj.BlindBetSize = blindBetSize;
            obj.MaxNumRaisesPerStage = maxNumRaisesPerStage;
        end

        function emptyCard = getEmptyCard(obj)
            emptyCard = struct(obj.EmptyCard);
        end
    end
end