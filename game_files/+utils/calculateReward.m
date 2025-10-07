function reward = calculateReward(player, potAmount)
    % Calculate the reward for the RL agent
    % This is a simple reward function that rewards winning and penalizes losing
    % You may want to create a more sophisticated reward function
    
    if player.NumChips > player.NumStartingChips
        % Player won
        reward = potAmount;
    elseif player.NumChips < player.NumStartingChips
        % Player lost
        reward = -potAmount;
    else
        % Draw
        reward = 0;
    end
end