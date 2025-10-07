clc;
numGames = 3;
gameManager = LeducPokerManager();

for gameIdx = 1:numGames
    fprintf("\nGame %d\n", gameIdx)
    playOneGame(gameManager);
end

%%

function playOneGame(gameManager)
    gameManager.dealStartingCards()
    gameManager.addBlindBetsToPot()
    disp("***PRE-FLOP***")
    isPreFlop = true;
    winner = gameManager.playOneStage(isPreFlop);
    
    % check if there's a winner (i.e., other player has folded)
    if ~isempty(winner)
        fprintf("Winner: %s\n", winner.Name)
        gameManager.settlePotAfterFold(winner)
        return
    end
    
    disp("***FLOP***")
    gameManager.revealCommunityCard();
    isPreFlop = false;
    winner = gameManager.playOneStage(isPreFlop);
    
    disp(gameManager.GameState)
    
    if ~isempty(winner)
        fprintf("Winner: %s\n", winner.Name)
        gameManager.settlePotAfterFold(winner)
        return
    else
        disp("Both players to reveal their cards.")
        utils.dispPlayerAndCommunityCards(gameManager);
        winner = gameManager.determineWinnerAndSettlePot();
        
        if ~isempty(winner)
            fprintf("Winner: %s\n", winner.Name)
        else
            disp("Tie - split pot.")
        end
        
    % reset the table for new game
    gameManager.resetForNewGame();
    end
end

