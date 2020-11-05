pits = [
    4, 4, 0, 4, 4, 4;
    4, 4, 4, 4, 4, 4
];
store_1 = 0;
store_2 = 0;

is_player_1_turn = 1;

% Repeating until one row of pits is empty
while sum(pits(1)) > 0 && sum(pits(2)) > 0

    % Setting the current player
    if is_player_1_turn
        current_player = 1;
    else
        current_player = 2;
    end
    fprintf("\nPlayer %d's Turn...\n", current_player);
    
    % Allowing the player to choose a pit
    pit_id = -1;
    is_valid_pit = 0;
    while ~is_valid_pit
        pit_id = input("Choose a pit... (1-6)\n> ");

        % Making sure that the selected pit is between 1 and 6
        if pit_id >= 1 && pit_id <= 6

            % Making sure that the selected pit is not empty
            if pits(current_player, pit_id) > 0
                is_valid_pit = 1;
            else
                fprintf("Pit #%d is empty; choose another...\n", pit_id);
            end
        else
            fprintf("Pit #%d is invalid...\n", pit_id);
        end
    end
    fprintf("Player %d chose pit #%d.\n", current_player, pit_id);
    
    % Switching players at the end of the turn.
    is_player_1_turn = ~is_player_1_turn;

end
