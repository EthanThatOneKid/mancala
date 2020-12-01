% mancala_group13.m
% Author: Ethan Davidson, Shawn Ta, and Benjamin Jones
% Date modified: 11/18/2020
% Description: Mancala game simulator.

main_menu();

function main_menu()

    close all;
    clear all;
    clc;

    fprintf("+----------------------------------------+\n");
    fprintf("|  __  __     Welcome to...     _        |\n");
    fprintf("| |  |/  |                     | |       |\n");
    fprintf("| | |  / | __ _ _ __   ___ __ _| | __ _  |\n");
    fprintf("| | ||/| |/ _` | '_ | / __/ _` | |/ _` | |\n");
    fprintf("| | |  | | (_| | | | | (_| (_| | | (_| | |\n");
    fprintf("| |_|  |_||__,_|_| |_||___|__,_|_||__,_| |\n");
    fprintf("|    --- Implementation by Ethan, ---    |\n");
    fprintf("|    ---    Benjamin, and Shawn   ---    |\n");
    fprintf("|              Game Modes:               |\n");
    fprintf("|    1. PVP: Two players take turns.     |\n");
    fprintf("|    2. EASY: One player VS an easy AI.  |\n");
    fprintf("|    3. HARD: One player VS an hard AI.  |\n");
    fprintf("+----------------------------------------+\n");
    is_valid_game_mode = 0;
    while ~is_valid_game_mode
        game_mode_id = input("Select a game mode... (1-3) > ");
        
        % Making sure that the selected game mode is between 1 and 3.
        if game_mode_id >= 1 && game_mode_id <= 3
            is_valid_game_mode = 1;
        else
            fprintf("Game mode #%d is invalid...\n", game_mode_id);
        end
    end
    play_mancala(game_mode_id);
end

function play_mancala(game_mode_id)
    pits = [
        4, 4, 4, 4, 4, 4;
        4, 4, 4, 4, 4, 4
    ];
    stores = [0, 0];
    current_player = floor(rand * 2) + 1;
    is_game_over = false;
    
    % Repeating until one row of pits is empty
    while ~is_game_over
        [pits, stores, current_player, is_game_over] = manage_turn(pits, stores, current_player, game_mode_id);
    end
    
    score_1 = stores(1) + sum(pits(1, 1:6));
    score_2 = stores(2) + sum(pits(2, 1:6));
    
    clc;
    fprintf("+-----------------------+\n");
    if game_mode_id == 1
        fprintf("| Player  1 | Player  2 |\n");
    elseif game_mode_id == 2
        fprintf("| Player  1 | AI (EASY) |\n");
    elseif game_mode_id == 3
        fprintf("| Player  1 | AI (HARD) |\n");
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
    response = input("Go to the main menu? (1 for yes, 0 for no) > ");
    if response == 0
        fprintf("Thank you for playing!!\n");
        return;
    end
    main_menu();
end

function [pits, stores, current_player, is_game_over] = manage_turn(pits, stores, current_player, game_mode_id)
    clc;
    fprintf("+---------------------------------------------------------------+\n");
    fprintf("|    | %02d (6) | %02d (5) | %02d (4) | %02d (3) | %02d (2) | %02d (1) |    | <- Player 2\n", pits(2, 6), pits(2, 5), pits(2, 4), pits(2, 3), pits(2, 2), pits(2, 1));
    fprintf("| %02d |--------|--------|--------|--------|--------|--------| %02d |\n", stores(2), stores(1));
    fprintf("|    | %02d (1) | %02d (2) | %02d (3) | %02d (4) | %02d (5) | %02d (6) |    | <- Player 1\n", pits(1, 1), pits(1, 2), pits(1, 3), pits(1, 4), pits(1, 5), pits(1, 6));
    fprintf("+---------------------------------------------------------------+\n");
    fprintf("--- Player %d's Turn ---\n", current_player);
    if current_player == 2 && game_mode_id == 1
        [pits, stores] = prompt_player(pits, stores, current_player, game_mode_id);
    elseif current_player == 2 && game_mode_id == 2
        [pits, stores] = take_easy_turn(pits, stores, current_player);
    elseif current_player == 2 && game_mode_id == 3
        [pits, stores] = take_hard_turn(pits, stores, current_player);
    else
        [pits, stores] = prompt_player(pits, stores, current_player, game_mode_id);
    end
    % Switching players at the end of the turn.
    current_player = mod(current_player, 2) + 1;
    % Checking if the game is over...
    % by checking if either row has no pebbles.
    is_game_over = sum(pits(1, 1:6)) == 0 ||...
       sum(pits(2, 1:6)) == 0;
end

function [pits, stores] = prompt_player(pits, stores, current_player, game_mode_id)
    % Allowing the player to choose a pit.
    pit_id = -1;
    is_valid_pit = 0;
    while ~is_valid_pit
        pit_id = input("Choose a pit... (1-6) > ");

        % Making sure that the selected pit is between 1 and 6.
        if pit_id >= 1 && pit_id <= 6

            % Making sure that the selected pit is not empty.
            if pits(current_player, pit_id) > 0
                is_valid_pit = 1;
            else
                fprintf("Pit #%d is empty; choose another...\n", pit_id);
            end
        else
            fprintf("Pit #%d is invalid...\n", pit_id);
        end
    end
    [pits, stores] = take_turn(pits, stores, current_player, pit_id, game_mode_id);
end

function [pits, stores] = take_turn(pits, stores, current_player, pit_id, game_mode_id)
    total_pebbles = pits(current_player, pit_id);
    current_row = current_player;
    pits(current_player, pit_id) = 0;
    for i=1:total_pebbles
        pit_id = pit_id + 1;
        if pit_id == 7
            if current_player == current_row
                % Only place pebble in current player's store.
                stores(current_row) = stores(current_row) + 1;
                if i == total_pebbles
                    % The last pebble of the turn was placed in the current
                    % player's store, so they get to take another turn.
                    [pits, stores] = manage_turn(pits, stores, current_player, game_mode_id);
                end
            end
            pit_id = 0;
            current_row = mod(current_player, 2) + 1;
        else
            pits(current_row, pit_id) = pits(current_row, pit_id) + 1;
            if pits(current_row, pit_id) == 1 && i == total_pebbles
                % Definition of opposite pit:
                % 1->6, 2->5, 3->4, 4->3, 5->2, 6->1
                opposite_pit_id = 7 - pit_id;
                pits(current_row, pit_id) = pits(current_row, pit_id) +...
                    pits(mod(current_row, 2) + 1, opposite_pit_id);
                pits(mod(current_row, 2) + 1, opposite_pit_id) = 0;
            end
        end
    end
end

function [pits, stores] = take_easy_turn(pits, stores, current_player)
    pit_id = -1;
    is_valid_pit = 0;
    while ~is_valid_pit
        pit_id = floor(rand * 6) + 1;
        if pits(current_player, pit_id) > 0
            is_valid_pit = 1;
        end
    end
    [pits, stores] = take_turn(pits, stores, current_player, pit_id, 2);
end

function [pits, stores] = take_hard_turn(pits, stores, current_player)
    % TODO: Implement a hard-level algorithm.
    [pits, stores] = take_easy_turn(pits, stores, current_player);
end
