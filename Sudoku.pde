int[][] grid = new int[9][9];
int[] num = new int[9];

boolean check_rule(int[][] board, int row, int col, int number) {
  // check row
  for (int i = 0; i < 9; i++) {
    if (number == board[row][i]) {
      return false;
    }
  }

  // check column
  for (int i = 0; i < 9; i++) {
    if (number == board[i][col]) {
      return false;
    }
  }

  // check box 3x3
  int box_start_row = (row / 3) * 3;
  int box_start_col = (col / 3) * 3;

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[box_start_row + i][box_start_col + j] == number) {
        return false;
      }
    }
  }

  return true;
}

int[] find_entry_cell(int[][] board) {
  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      if (board[i][j] == 0) {
        return new int[]{i, j}; // return row, col
      }
    }
  }
  return null;
}

boolean sudoku() {
  int[] pos = find_entry_cell(grid);
  if (pos != null) {
    int row = pos[0];
    int col = pos[1];
    for (int i = 0; i < num.length; i++) {
      if (check_rule(grid, row, col, num[i])) {
        grid[row][col] = num[i];
        if (sudoku()) {
          return true;
        }
        grid[row][col] = 0;
      }
    }
    return false;
  } else {
    return true;
  }
}

void draw_table() {
  strokeWeight(3);
  line(0, height/3, width, height/3);
  line(0, height/3*2, width, height/3*2);

  line(width/3, 0, width/3, height);
  line(width/3*2, 0, width/3*2, height);

  strokeWeight(1);
  line(0, height/9, width, height/9);
  line(0, height/9*2, width, height/9*2);
  line(0, height/9*4, width, height/9*4);
  line(0, height/9*5, width, height/9*5);
  line(0, height/9*7, width, height/9*7);
  line(0, height/9*8, width, height/9*8);

  line(width/9, 0, width/9, height);
  line(width/9*2, 0, width/9*2, height);
  line(width/9*4, 0, width/9*4, height);
  line(width/9*5, 0, width/9*5, height);
  line(width/9*7, 0, width/9*7, height);
  line(width/9*8, 0, width/9*8, height);
}

void show_grid() {
  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      fill(0);
      textSize(20);
      if (grid[i][j] != 0) {
        text(grid[i][j], width/18*2*j+(width/18), height/18*2*i+(height/18));
      }
    }
  }
}

void setup() {
  size(600,600);

  // สุ่มตัวเลข 1-9 ไม่ซ้ำ
  boolean[] used = new boolean[10];
  for (int i = 0; i < 9; i++) {
    int temp = (int)random(1, 10);
    while (used[temp]) {
      temp = (int)random(1, 10);
    }
    num[i] = temp;
    used[temp] = true;
  }

  sudoku();
}

void draw() {
  background(250);
  draw_table();
  show_grid();
}
