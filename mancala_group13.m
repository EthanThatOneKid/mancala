pits = [
    4, 4, 0, 4, 4, 4;
    4, 4, 4, 4, 4, 4
];
store_1 = 0;
store_2 = 0;

current_player = 1;

% Repeating until one row of pits is empty
while sum(pits(1)) > 0 && sum(pits(2)) > 0
    
    fprintf("+---------------------------------------+\n");
    fprintf("|    | %02d | %02d | %02d | %02d | %02d | %02d |    |\n", pits(1, 1), pits(1, 2), pits(1, 3), pits(1, 4), pits(1, 5), pits(1, 6));
    fprintf("| %02d |----|----|----|----|----|----| %02d |\n", store_1, store_2);
    fprintf("|    | %02d | %02d | %02d | %02d | %02d | %02d |    |\n", pits(2, 1), pits(2, 2), pits(2, 3), pits(2, 4), pits(2, 5), pits(2, 6));
    fprintf("+---------------------------------------+\n");

    fprintf("--- Player %d's Turn ---\n", current_player);
    
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
    if current_player == 1
        current_player = 2;
    else
        current_player = 1;
    end

end
