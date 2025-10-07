function gameStateEnc = encodeGameStateAsVec(gameState)
    gameStateEnc = zeros(10, 1);
    gameStateEnc(1) = gameState.NumPotChips;
    gameStateEnc(2) = gameState.NumSelfChips;
    gameStateEnc(3) = gameState.NumOppChips;
    gameStateEnc(4) = gameState.IsPreFlop;
    gameStateEnc(5) = gameState.NumRaisesThisStage;
    gameStateEnc(6) = gameState.SelfBetAmount;
    gameStateEnc(7) = gameState.OppBetAmount;
    gameStateEnc(8) = gameState.IsStartingPlayer;
    gameStateEnc(9) = gameState.CommunityCardValue;
end