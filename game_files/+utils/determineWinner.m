function winner = determineWinner(gameManager)
    %DETERMINEWINNER after all betting rounds have been completed, look at
    %both players' cards to determine who won
    cardValue1 = gameManager.Player1.Card.Value;
    cardValue2 = gameManager.Player2.Card.Value;
    communityCardValue = gameManager.Table.CommunityCard.Value;

    % check if any player paired with community card
    if cardValue1 == communityCardValue
        winner = gameManager.Player1;
    elseif cardValue2 == communityCardValue
        winner = gameManager.Player2;
    else
        % case where neither players' cards paired with community card
        % winner determined by high card.
        if cardValue1 > cardValue2
            winner = gameManager.Player1;
        elseif cardValue2 > cardValue1
            winner = gameManager.Player2;
        else
            % case where players are tied; split pot
            winner = struct([]);
        end
    end
end