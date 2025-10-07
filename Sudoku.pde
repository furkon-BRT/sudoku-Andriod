int[][] grid = new int[9][9];
boolean[][] fixed = new boolean[9][9];
int selectedRow = -1, selectedCol = -1;

int btnSize = 50;
int btnMargin = 10;
int padY; 

void setup() {
  size(600, 760);
  textAlign(CENTER, CENTER);
  textSize(32);
  generatePuzzle();
  padY = 620; 
}

void draw() {
  background(255);
  draw_table();
  show_grid();
  highlightSelected();
  drawButtons();
}

void draw_table() {
  stroke(0);
  for (int i = 0; i <= 9; i++) {
    if (i % 3 == 0) strokeWeight(3);
    else strokeWeight(1);
    line(0, i * 600 / 9, 600, i * 600 / 9);
    line(i * 600 / 9, 0, i * 600 / 9, 600);
  }
}

void show_grid() {
  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      if (grid[r][c] != 0) {
        if (fixed[r][c]) fill(0);
        else fill(0, 0, 200);
        text(grid[r][c], c * 600 / 9 + 600 / 18, r * 600 / 9 + 600 / 18);
      }
    }
  }
}

void highlightSelected() {
  if (selectedRow != -1 && selectedCol != -1) {
    noFill();
    stroke(255, 0, 0);
    strokeWeight(3);
    rect(selectedCol * 600 / 9, selectedRow * 600 / 9, 600 / 9, 600 / 9);
  }
}

void drawButtons() {
  int startX = (width - (9 * btnSize + 8 * btnMargin)) / 2;
  for (int i = 0; i < 9; i++) {
    int x = startX + i * (btnSize + btnMargin);
    int y = padY;
    fill(230);
    stroke(0);
    rect(x, y, btnSize, btnSize, 10);
    fill(0);
    text(i + 1, x + btnSize / 2, y + btnSize / 2);
  }

  int delX = width / 2 - btnSize / 2;
  int delY = padY + btnSize + 15;
  fill(255, 150, 150);
  rect(delX, delY, btnSize, btnSize, 10);
  fill(0);
  text("❌", delX + btnSize / 2, delY + btnSize / 2);
}

void mousePressed() {
  if (mouseY < 600) {
    selectedRow = int(mouseY / (600 / 9));
    selectedCol = int(mouseX / (600 / 9));
  } else {
    int startX = (width - (9 * btnSize + 8 * btnMargin)) / 2;
    int y = padY;
    for (int i = 0; i < 9; i++) {
      int x = startX + i * (btnSize + btnMargin);
      if (mouseX > x && mouseX < x + btnSize && mouseY > y && mouseY < y + btnSize) {
        handleNumberClick(i + 1);
        return;
      }
    }

    int delX = width / 2 - btnSize / 2;
    int delY = padY + btnSize + 15;
    if (mouseX > delX && mouseX < delX + btnSize && mouseY > delY && mouseY < delY + btnSize) {
      handleDelete();
    }
  }
}

void handleNumberClick(int num) {
  if (selectedRow == -1 || selectedCol == -1) return;
  if (fixed[selectedRow][selectedCol]) return;

  if (check_rule(grid, selectedRow, selectedCol, num)) {
    grid[selectedRow][selectedCol] = num;
  } else {
    println("ผิดกฎ Sudoku");
  }
}

void handleDelete() {
  if (selectedRow == -1 || selectedCol == -1) return;
  if (fixed[selectedRow][selectedCol]) return;
  grid[selectedRow][selectedCol] = 0;
}

boolean check_rule(int[][] board, int row, int col, int number) {
  for (int i = 0; i < 9; i++) {
    if (board[row][i] == number && i != col) return false;
    if (board[i][col] == number && i != row) return false;
  }

  int box_start_row = (row / 3) * 3;
  int box_start_col = (col / 3) * 3;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      int r = box_start_row + i;
      int c = box_start_col + j;
      if (board[r][c] == number && (r != row || c != col)) return false;
    }
  }
  return true;
}

void generatePuzzle() {
  int[][] sample = {
    {5,3,0, 0,7,0, 0,0,0},
    {6,0,0, 1,9,5, 0,0,0},
    {0,9,8, 0,0,0, 0,6,0},
    {8,0,0, 0,6,0, 0,0,3},
    {4,0,0, 8,0,3, 0,0,1},
    {7,0,0, 0,2,0, 0,0,6},
    {0,6,0, 0,0,0, 2,8,0},
    {0,0,0, 4,1,9, 0,0,5},
    {0,0,0, 0,8,0, 0,7,9}
  };

  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      grid[r][c] = sample[r][c];
      if (grid[r][c] != 0) fixed[r][c] = true;
    }
  }
}
