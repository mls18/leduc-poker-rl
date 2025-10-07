function shuffledDeck = getShuffledCardDeck()
    idx = 1;
    deck = struct('Suit', {}, 'Rank', {}, 'Value', {});
    suits = ["clubs", "diamonds"];
    ranks = ['J', 'Q', 'K'];

    for s = suits
        for r = ranks
            deck(idx).Suit = s;
            deck(idx).Rank = r;
            deck(idx).Value = strfind(ranks, r);
            idx = idx + 1;
        end
    end
    shuffledDeck = deck(randperm(length(deck)));
end