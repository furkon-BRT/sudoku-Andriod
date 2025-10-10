int[][] grid = new int[9][9];
boolean[][] fixed = new boolean[9][9];
int[][] solution = new int[9][9]; 
int selectedRow = -1, selectedCol = -1;
boolean showCheck = false;
boolean[][] correct = new boolean[9][9];

int btnSize = 50;
int btnMargin = 10;
int padY;
int state = 0;

void setup() {
  size(600,760);
  textAlign(CENTER, CENTER);
  textSize(32);
  generatePuzzle();
  padY = 620;
}

void draw() {
  background(255);
  
  if (state == 0) {
    drawStartScreen();
  } else if (state == 1) {
    drawGameScreen();
  }
}

void drawStartScreen() {
  background(240);
  fill(0);
  textSize(50);
  text("SUDOKU", width/2, height/2 - 100);

  int w = 200, h = 70;
  int x = width/2 - w/2;
  int y = height/2 + 50;
  fill(240);
  rect(x, y, w, h, 20);
  fill(0);
  textSize(30);
  text("NEW GAME", width/2, y + h/2);
}

void drawGameScreen() {
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
  textSize(32);
  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      float cellX = c * 600 / 9;
      float cellY = r * 600 / 9;
      float cellSize = 600 / 9;
      if (fixed[r][c]) {
        fill(200, 220, 255);
        stroke(0);
        rect(cellX, cellY, cellSize, cellSize);
      }
      else if (grid[r][c] != 0) {
        if (showCheck) {
          if (correct[r][c]) fill(180, 255, 180);  
          else fill(255, 180, 180);
          noStroke();
          rect(cellX, cellY, cellSize, cellSize);
        }
      }
      if (grid[r][c] != 0) {
        if (fixed[r][c]) fill(0);   
        else fill(0);               
        text(grid[r][c], cellX + cellSize / 2, cellY + cellSize / 2);
      }
    }
  }
}


void highlightSelected() {
  if (selectedRow != -1 && selectedCol != -1) {
    fill(240,240,240,100);
    stroke(0);
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
  
  int delX = width / 2 - btnSize -10;
  int delY = padY + btnSize + 15;
  fill(255, 150, 150);
  rect(delX, delY, btnSize, btnSize, 10);
  fill(0);
  text("❌", delX + btnSize / 2, delY + btnSize / 2);
}

void mousePressed() {
  if (state == 0) {
    int w = 200, h = 70;
    int x = width/2 - w/2;
    int y = height/2 + 50;
    if (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
      state = 1;
    }
  } else if (state == 1) {
    if (mouseY < 600) {
      selectedRow = int(mouseY / (600 / 9));
      selectedCol = int(mouseX / (600 / 9));
    } else {
      checkButtonsClick();
    }
  }
}

void checkButtonsClick() {
  int startX = (width - (9 * btnSize + 8 * btnMargin)) / 2;
  int y = padY;
  for (int i = 0; i < 9; i++) {
    int x = startX + i * (btnSize + btnMargin);
    if (mouseX > x && mouseX < x + btnSize && mouseY > y && mouseY < y + btnSize) {
      handleNumberClick(i + 1);
      return;
    }
  }

  int delX = width / 2 - btnSize - 10;
  int delY = padY + btnSize + 15;
  if (mouseX > delX && mouseX < delX + btnSize && mouseY > delY && mouseY < delY + btnSize) {
    handleDelete();
    return;
  }
}

void handleNumberClick(int num) {
  if (selectedRow == -1 || selectedCol == -1) return;
  if (fixed[selectedRow][selectedCol]) return;
  grid[selectedRow][selectedCol] = num;
  showCheck = true;
  checkAnswers();
}

void handleDelete() {
  if (selectedRow == -1 || selectedCol == -1) return;
  if (fixed[selectedRow][selectedCol]) return;
  grid[selectedRow][selectedCol] = 0;
  showCheck = false;
}

void checkAnswers() {
  showCheck = true;
  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      if (!fixed[r][c] && grid[r][c] != 0) {
        correct[r][c] = (grid[r][c] == solution[r][c]);
      }
    }
  }
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

  int[][] solved = {
    {5,3,4, 6,7,8, 9,1,2},
    {6,7,2, 1,9,5, 3,4,8},
    {1,9,8, 3,4,2, 5,6,7},
    {8,5,9, 7,6,1, 4,2,3},
    {4,2,6, 8,5,3, 7,9,1},
    {7,1,3, 9,2,4, 8,5,6},
    {9,6,1, 5,3,7, 2,8,4},
    {2,8,7, 4,1,9, 6,3,5},
    {3,4,5, 2,8,6, 1,7,9}
  };

  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      grid[r][c] = sample[r][c];
      solution[r][c] = solved[r][c];
      if (grid[r][c] != 0) fixed[r][c] = true;
    }
  }
}
