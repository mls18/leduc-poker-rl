function dispPlayerAndCommunityCards(gameManager)
    disp("Community Card:")
    disp(gameManager.Table.CommunityCard)
    fprintf("%s Card:\n", gameManager.Player1.Name)
    disp(gameManager.Player1.Card)
    fprintf("%s Card:\n", gameManager.Player2.Name)
    disp(gameManager.Player2.Card)
end