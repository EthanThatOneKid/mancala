% mancala_group13.m
% Author: Ethan Davidson, Shawn Ta, and Benjamin Jones
% Date modified: 12/3/2020
% Description: Mancala game simulator.

% Enhancements:
% 1. Playing against a CPU.
% 2. Longer board modification.
% 3. Random pebble placement modification.

main_menu();

function main_menu()

    close all;
    clear all;
    clc;

    fprintf("+----------------------------------------+\n");
    fprintf("|           Welcome to...       _        |\n");
    fprintf("|   /\\/\\   __ _ _ __   ___ __ _| | __ _  |\n");
    fprintf("|  /    \\ / _` | '_ \\ / __/ _` | |/ _` | |\n");
    fprintf("| / /\\/\\ \\ (_| | | | | (_| (_| | | (_| | |\n");
    fprintf("| \\/    \\/\\__,_|_| |_|\\___\\__,_|_|\\__,_| |\n");
    fprintf("|    --- Implementation by Ethan, ---    |\n");
    fprintf("|    ---    Benjamin, and Shawn   ---    |\n");
    fprintf("|              Game Modes:               |\n");
    fprintf("|    1. PVP: Two players take turns.     |\n");
    fprintf("|    2. CPU: One player VS a CPU.        |\n");
    fprintf("|                                        |\n");
    fprintf("+----------------------------------------+\n");
    is_valid_game_mode = 0;
    while ~is_valid_game_mode
        game_mode_id = input("[Select a game mode (1-2)] > ");
        
        % Making sure that the selected game mode is between 1 and 2.
        if game_mode_id >= 1 && game_mode_id <= 2
            is_valid_game_mode = 1;
        else
            fprintf("[Game mode #%d is invalid]\n", game_mode_id);
        end
    end
    
    clc;
    fprintf("+----------------------------------------+\n");
    fprintf("|           Welcome to...       _        |\n");
    fprintf("|   /\\/\\   __ _ _ __   ___ __ _| | __ _  |\n");
    fprintf("|  /    \\ / _` | '_ \\ / __/ _` | |/ _` | |\n");
    fprintf("| / /\\/\\ \\ (_| | | | | (_| (_| | | (_| | |\n");
    fprintf("| \\/    \\/\\__,_|_| |_|\\___\\__,_|_|\\__,_| |\n");
    fprintf("|    --- Implementation by Ethan, ---    |\n");
    fprintf("|    ---    Benjamin, and Shawn   ---    |\n");
    fprintf("|             Modifications:             |\n");
    fprintf("|    1. No modifications (normal).       |\n");
    fprintf("|    2. Longer board (12 pits per row).  |\n");
    fprintf("|    3. Randomized pebble placement.     |\n");
    fprintf("+----------------------------------------+\n");
    is_valid_modification = 0;
    while ~is_valid_modification
        modification_id = input("[Select a modification (1-3)] > ");
   
        % Making sure that the selected game mode is between 1 and 3.
        if modification_id >= 1 && modification_id <= 3
            is_valid_modification = 1;
        else
            fprintf("[Modification #%d is invalid]\n", is_valid_modification);
        end
    end
    
    play_mancala(game_mode_id, modification_id);
end

function play_mancala(game_mode_id, modification_id)
    
    if modification_id == 2
        % 12 pits per row, with 2 pebbles each.
        pits = 2 * ones(2, 12);
    elseif modification_id == 3
        % Randomize pebbles in pits, but start with 24 per row.
        pits = zeros(2, 6);
        for row=1:2
            total_pebble_amount = 24;
            while total_pebble_amount > 0
                random_pit_id = floor(rand * 6) + 1;
                pits(row, random_pit_id) = pits(row, random_pit_id) + 1;
                total_pebble_amount = total_pebble_amount - 1;
            end
        end
    else
        pits = 4 * ones(2, 6);
    end
    stores = [0, 0];
    current_player = floor(rand * 2) + 1;
    is_game_over = false;
    
    % Repeating until one row of pits is empty
    while ~is_game_over
        [pits, stores, current_player, is_game_over] = manage_turn(pits, stores, current_player, game_mode_id);
    end
    
    score_1 = stores(1) + sum(pits(1, 1:end));
    score_2 = stores(2) + sum(pits(2, 1:end));
    
    clc;
    fprintf("+-----------------------+\n");
    if game_mode_id == 1
        fprintf("| Player  1 | Player  2 |\n");
    elseif game_mode_id == 2
        fprintf("| Player  1 | AI (EASY) |\n");
    end
    fprintf("| score: %02d | score: %02d |\n", score_1, score_2);
    if score_1 > score_2
        fprintf("|   WINNER  |   LOSER   |\n");
    elseif score_1 < score_2
        fprintf("|   LOSER   |  WINNER   |\n");
    else
        fprintf("|     --- DRAW ---      |\n");
    end
    fprintf("+-----------------------+\n");
    response = input("[Go to the main menu? (1 for yes, 0 for no)] > ");
    if response == 0
        fprintf("[Thank you for playing!!]\n");
        return;
    end
    main_menu();
end

function [pits, stores, current_player, is_game_over] = manage_turn(pits, stores, current_player, game_mode_id)
    clc;
    [~, last_pit_id] = size(pits);
    if last_pit_id == 6
        fprintf("+---------------------------------------------------------------------+\n");
    else
        fprintf("+---------------------------------------------------------------------------------------------------------------------------------+\n");
    end
    fprintf("|        ");
    for i=1:last_pit_id
        fprintf("<-        ");
    end
    fprintf(" |\n|    ");
    for i=1:last_pit_id
        current_pit_id = last_pit_id - i + 1;
        fprintf("| %02d (%02d) ", pits(2, current_pit_id), current_pit_id);
    end
    fprintf("|    | <- Player 2\n");
    fprintf("| %02d ", stores(2));
    for i=1:last_pit_id
        fprintf("|---------");
    end
    fprintf("| %02d |\n", stores(1));
    fprintf("|    ");
    for i=1:last_pit_id
        fprintf("| %02d (%02d) ", pits(1, i), i);
    end
    fprintf("|    | <- Player 1\n");
    fprintf("|        ");
    for i=1:last_pit_id
        fprintf("->        ");
    end
    fprintf(" |\n");
    if last_pit_id == 6
        fprintf("+---------------------------------------------------------------------+\n");
    else
        fprintf("+---------------------------------------------------------------------------------------------------------------------------------+\n");
    end
    fprintf("[Player %d's Turn]\n", current_player);
    if current_player == 2 && game_mode_id == 1 % Take player 2's turn.
        [pits, stores] = prompt_player(pits, stores, current_player, game_mode_id);
    elseif current_player == 2 && game_mode_id == 2 % Take the CPU's turn.
        [pits, stores] = take_cpu_turn(pits, stores, current_player);
    else
        [pits, stores] = prompt_player(pits, stores, current_player, game_mode_id);
    end
    % Switching players at the end of the turn.
    current_player = mod(current_player, 2) + 1; % 1 -> 2, 2 -> 1
    % Checking if the game is over...
    % by checking if either row has no pebbles.
    is_game_over = sum(pits(1, 1:end)) == 0 ||...
       sum(pits(2, 1:end)) == 0;
end

function [pits, stores] = prompt_player(pits, stores, current_player, game_mode_id)
    % Allowing the player to choose a pit.
    pit_id = -1;
    is_valid_pit = 0;
    [~, last_pit_id] = size(pits);
    while ~is_valid_pit
        fprintf("[Choose between (1-%d)]\n", last_pit_id);
        pit_id = input("[Choose a pit] ---> ");
        % Making sure that input was numerical.
        try
            % Making sure that the selected pit is between 1 and the last pit.
            if pit_id >= 1 && pit_id <= last_pit_id
                % Making sure that the selected pit is not empty.
                if pits(current_player, pit_id) > 0
                    is_valid_pit = 1;
                else
                    fprintf("[Pit #%d is empty; choose another]\n", pit_id);
                end
            else
                fprintf("[Pit #%d is invalid]\n", pit_id);
            end
        catch
        end
    end
    [pits, stores] = take_turn(pits, stores, current_player, pit_id, game_mode_id);
end

function [pits, stores] = take_turn(pits, stores, current_player, pit_id, game_mode_id)
    total_pebbles = pits(current_player, pit_id);
    current_row = current_player;
    pits(current_player, pit_id) = 0;
    [~, last_pit_id] = size(pits);
    while total_pebbles > 0
        pit_id = pit_id + 1;
        if pit_id == last_pit_id + 1
            if current_player == current_row
                % Only place pebble in current player's store.
                stores(current_row) = stores(current_row) + 1;
                if total_pebbles == 1
                    % The last pebble of the turn was placed in the current
                    % player's store, so they get to take another turn.
                    [pits, stores] = manage_turn(pits, stores, current_player, game_mode_id);
                    return;
                end
            else
                total_pebbles = total_pebbles + 1;
            end
            pit_id = 0;
            current_row = mod(current_row, 2) + 1;
        else
            pits(current_row, pit_id) = pits(current_row, pit_id) + 1;
            if pits(current_row, pit_id) == 1 && total_pebbles == 1
                % Definition of opposite pit:
                % 1->6, 2->5, 3->4, 4->3, 5->2, 6->1
                opposite_pit_id = last_pit_id - pit_id + 1;
                opposite_row = mod(current_row, 2) + 1; % 1 -> 2, 2 -> 1
                if pits(opposite_row, opposite_pit_id) > 0
                    stores(current_player) = stores(current_player) + pits(opposite_row, opposite_pit_id) + 1;
                    pits(opposite_row, opposite_pit_id) = 0;
                    pits(current_row, pit_id) = 0;
                end
            end
        end
        total_pebbles = total_pebbles - 1;
    end
end

function [pits, stores] = take_cpu_turn(pits, stores, current_player)
    pit_id = -1;
    is_valid_pit = 0;
    [~, last_pit_id] = size(pits);
    while ~is_valid_pit
        pit_id = floor(rand * last_pit_id) + 1;
        if pits(current_player, pit_id) > 0
            is_valid_pit = 1;
        end
    end
    [pits, stores] = take_turn(pits, stores, current_player, pit_id, 2);
end
