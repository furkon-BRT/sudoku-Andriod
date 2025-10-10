int[][] grid = new int[9][9];
boolean[][] fixed = new boolean[9][9];
int[][] solution = new int[9][9];
boolean[][] correct = new boolean[9][9];

int selectedRow = -1, selectedCol = -1;
boolean showCheck = false;
int btnSize = 50;
int btnMargin = 10;
int padY;
int state = 0;

void setup() {
    size(600, 780);
    textAlign(CENTER, CENTER);
    textSize(32);
    padY = 620;
    generateSudoku();
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
  
    drawButton(width/2 - 100, height/2, 200, 60, "NEW GAME", color(200, 220, 255));
    drawButton(width/2 - 100, height/2 + 80, 200, 60, "LOAD GAME", color(200, 255, 200));
}

void drawButton(int x, int y, int w, int h, String label, color col) {
    fill(col);
    stroke(0);
    rect(x, y, w, h, 15);
    fill(0);
    textSize(24);
    text(label, x + w/2, y + h/2);
}

void drawGameScreen() {
    drawGrid();
    drawCells();
    highlightSelected();
    drawButtons();
}

void drawGrid() {
    stroke(0);
    for (int i = 0; i <= 9; i++) {
      if (i % 3 == 0) strokeWeight(3);
      else strokeWeight(1);
      line(0, i * 600 / 9, 600, i * 600 / 9);
      line(i * 600 / 9, 0, i * 600 / 9, 600);
    }
}

void drawCells() {
    textSize(32);
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        float x = c * 600 / 9;
        float y = r * 600 / 9;
        float s = 600 / 9;
  
        if (fixed[r][c]) {
          fill(200, 220, 255);
          rect(x, y, s, s);
        } else if (showCheck && grid[r][c] != 0) {
          if (correct[r][c]) fill(180, 255, 180);
          else fill(255, 180, 180);
          rect(x, y, s, s);
        }
  
        if (grid[r][c] != 0) {
          fill(0);
          text(grid[r][c], x + s/2, y + s/2);
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
      fill(240);
      stroke(0);
      rect(x, y, btnSize, btnSize, 10);
      fill(0);
      text(i + 1, x + btnSize / 2, y + btnSize / 2);
    }
  
    int delX = width / 2 - btnSize - 60;
    int delY = padY + btnSize + 15;
    fill(255, 150, 150);
    rect(delX, delY, btnSize, btnSize, 10);
    fill(0);
    text("X", delX + btnSize / 2, delY + btnSize / 2);
  
    int saveX = width / 2 + 10;
    fill(200, 255, 200);
    rect(saveX, delY, btnSize, btnSize, 10);
    fill(0);
    text("S", saveX + btnSize / 2, delY + btnSize / 2);
}

void mousePressed() {
    if (state == 0) {
      if (mouseY > height/2 && mouseY < height/2 + 60) {
        state = 1;
        generateSudoku();
      } else if (mouseY > height/2 + 80 && mouseY < height/2 + 140) {
        loadGame();
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
  
    int delX = width / 2 - btnSize - 60;
    int delY = padY + btnSize + 15;
    int saveX = width / 2 + 10;
  
    if (mouseX > delX && mouseX < delX + btnSize && mouseY > delY && mouseY < delY + btnSize) {
      handleDelete();
    } else if (mouseX > saveX && mouseX < saveX + btnSize && mouseY > delY && mouseY < delY + btnSize) {
      saveGame();
    }
}

void handleNumberClick(int num) {
    if (selectedRow == -1 || selectedCol == -1) return;
    if (fixed[selectedRow][selectedCol]) return;
    grid[selectedRow][selectedCol] = num;
    checkAnswers();
}

void handleDelete() {
    if (selectedRow == -1 || selectedCol == -1) return;
    if (fixed[selectedRow][selectedCol]) return;
    grid[selectedRow][selectedCol] = 0;
    checkAnswers();
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

void generateSudoku() {
    int[][] board = new int[9][9];
    solveSudoku(board); 
    copyArray(board, solution);
    for (int i = 0; i < 40; i++) {
      int r = int(random(9));
      int c = int(random(9));
      board[r][c] = 0;
    }
  
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        grid[r][c] = board[r][c];
        fixed[r][c] = (board[r][c] != 0);
      }
    }
}

boolean solveSudoku(int[][] board) {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (board[r][c] == 0) {
          for (int n = 1; n <= 9; n++) {
            if (isSafe(board, r, c, n)) {
              board[r][c] = n;
              if (solveSudoku(board)) return true;
              board[r][c] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
}

boolean isSafe(int[][] board, int row, int col, int num) {
    for (int i = 0; i < 9; i++)
      if (board[row][i] == num || board[i][col] == num) return false;
    int boxR = row - row % 3, boxC = col - col % 3;
    for (int r = 0; r < 3; r++)
      for (int c = 0; c < 3; c++)
        if (board[boxR + r][boxC + c] == num) return false;
    return true;
}

void copyArray(int[][] src, int[][] dst) {
    for (int r = 0; r < 9; r++)
      for (int c = 0; c < 9; c++)
        dst[r][c] = src[r][c];
}

void saveGame() {
    String[] lines = new String[9];
    for (int r = 0; r < 9; r++) {
      String row = "";
      for (int c = 0; c < 9; c++) {
        row += grid[r][c] + ",";
      }
      lines[r] = row;
    }
    saveStrings("sudoku_save.txt", lines);
    println("Game Saved!");
}

void loadGame() {
    String[] lines = loadStrings("sudoku_save.txt");
    if (lines == null) return;
    for (int r = 0; r < 9; r++) {
      String[] nums = split(lines[r], ',');
      for (int c = 0; c < 9; c++) {
        if (c < nums.length && !nums[c].equals("")) {
          grid[r][c] = int(nums[c]);
          fixed[r][c] = (grid[r][c] != 0);
        }
      }
    }
    println(" Game Loaded!");
}
