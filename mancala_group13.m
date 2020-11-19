% mancala_group13.m
% Author: Ethan Davidson, Shawn Ta, and Benjamin Jones
% Date modified: 11/18/2020
% Description: Mancala game simulator.

pits = [
    4, 4, 0, 4, 4, 4;
    4, 4, 4, 4, 4, 4
];
stores = [0, 0];
current_player = 1;
is_game_over = false;

% Repeating until one row of pits is empty
while ~is_game_over
    
    fprintf("+---------------------------------------+\n");
    fprintf("|    | %02d | %02d | %02d | %02d | %02d | %02d |    | <- Player 2\n", pits(2, 6), pits(2, 5), pits(2, 4), pits(2, 3), pits(2, 2), pits(2, 1));
    fprintf("| %02d |----|----|----|----|----|----| %02d |\n", stores(2), stores(1));
    fprintf("|    | %02d | %02d | %02d | %02d | %02d | %02d |    | <- Player 1\n", pits(1, 1), pits(1, 2), pits(1, 3), pits(1, 4), pits(1, 5), pits(1, 6));
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

    [pits, stores] = take_turn(pits, stores, current_player, pit_id);
    
    % Switching players at the end of the turn.
    if current_player == 1
        current_player = 2;
    else
        current_player = 1;
    end
    is_game_over = sum(pits(1, 1:6)) == 0 ||...
       sum(pits(2, 1:6)) == 0;
end

function [pits, stores] = take_turn(pits, stores, current_player, pit_id)
    total_pebbles = pits(current_player, pit_id);
    current_row = current_player;
    pits(current_player, pit_id) = 0;
    % fprintf("Set pit %d to 0\n", pit_id);
    for i=1:total_pebbles
        pit_id = pit_id + 1;
        % fprintf("Moved to pit %d\n", pit_id);
        if pit_id == 7
            stores(current_row) = stores(current_row) + 1;
            pit_id = 0;
            if current_row == 1
                current_row = 2;
            else
                current_row = 1;
            end
        else
            pits(current_row, pit_id) = pits(current_row, pit_id) + 1;
            % fprintf("Set pit %d to %d\n", pit_id, pits(current_row, pit_id));
        end
    end
end
