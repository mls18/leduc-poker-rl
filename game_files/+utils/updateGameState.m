function updateGameState(gameManager, curPlayer, oppPlayer)
    % get the current game state, which is a dictionary containing
    % information like number of chips, community card, etc.
    gameManager.GameState.NumPotChips = gameManager.Table.NumPotChips;
    gameManager.GameState.NumSelfChips = curPlayer.NumChips;
    gameManager.GameState.NumOppChips = oppPlayer.NumChips;
    gameManager.GameState.SelfBetAmount = curPlayer.BetAmount;
    gameManager.GameState.OppBetAmount = oppPlayer.BetAmount;
    gameManager.GameState.CommunityCardValue = gameManager.Table.CommunityCard.Value;
end