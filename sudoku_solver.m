function mat_solution = sudoku_solver(mat_input)
global mat_output;
global time_execution;
global nb_forwards;
global nb_backwards;
global states;
nb_forwards = 0;
nb_backwards = 0;
states = [];
tic
if solve(mat_input)
    mat_solution = mat_output;
    print ok
else
    mat_solution = mat_input;
    print ng
end
time_execution = toc;
dlmwrite('solution.csv', states)
end

function s = solve(grid)
global mat_output;
global nb_forwards;
global nb_backwards;
global states;
unassigned_location = find_ussigned_location(grid);
if isempty(unassigned_location)
    s = true;
    mat_output = grid;
    return;
else
    row = unassigned_location(1);
    col = unassigned_location(2);
end
for val = 1:9
    if has_no_conflicts(grid, row, col, val)
        grid(row, col) = val;
        nb_forwards = nb_forwards + 1;
        states = cat(1, states, grid);
        if solve(grid)
            s = true;
            return;
        end
        grid(row, col) = 0;
        nb_backwards = nb_backwards + 1;
        states = cat(1, states, grid);
    end
end
s = false;
end

function location = find_ussigned_location(grid)
for row = 1:9
    for col = 1:9
        if grid(row, col) == 0
            location = [row col];
            return
        end
    end
end
location = [];
end

function conflict = has_no_conflicts(grid, r, c, v)
conflict = ~ismember(v, grid(r,:)) && ~ismember(v, grid(:, c))...
    && ~ismember(v, find_containing_block(grid, r, c)) && grid(r, c) == 0;
end

function block = find_containing_block(grid, x, y)
start_x = ceil(x/3) * 3;
start_y = ceil(y/3) * 3;
block = grid(start_x-2:start_x, start_y-2:start_y);
end
