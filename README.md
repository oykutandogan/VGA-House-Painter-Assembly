# VGA House Painter in Assembly

This project is an Assembly language program that runs in VGA 320x200 256-color graphics mode (mode 13h). It draws a house with windows, door, and roof outlines, and allows the user to interactively paint different regions of the house using keyboard inputs with a flood fill (region fill) algorithm.

---

## Features

- **Graphics Mode 13h**: Uses VGA mode 13h (320x200 pixels, 256 colors) for graphics rendering.
- **House Drawing**: Draws a simple house outline including walls, roof, door, and windows.
- **Interactive Coloring**: Allows users to select colors and fill specific regions of the house using keyboard keys.
- **Flood Fill Algorithm**: Implements a stack-based flood fill to color connected areas bounded by outlines.
- **Keyboard Controls**:
  - Color selection with keys `1` (Red), `2` (Blue), `3` (Green), `4` (Pink)
  - Fill regions with keys:
    - `R/r` — Roof
    - `W/w` — Walls
    - `K/k` — Right window
    - `L/l` — Left window
    - `D/d` — Door
  - `ESC` key to exit the program.

---

## How It Works

1. Switches the system into VGA 320x200 graphics mode.
2. Draws the house outline pixel-by-pixel using BIOS interrupts.
3. Waits for user keyboard input.
4. According to the pressed key, selects a fill color or a house region to flood fill.
5. Uses a custom flood fill procedure based on stack operations to fill the selected area with the chosen color.
6. Repeats until user presses `ESC` to exit.

---

## Requirements

- An x86 emulator or real DOS environment with VGA support.
- Assembler supporting `.model small` and BIOS interrupts (e.g., MASM, TASM).
- Keyboard support for interrupt 16h.

---

## Usage

- Assemble and link the code with an x86 assembler.
- Run the executable in a DOS environment or emulator.
- Use keys `1`-`4` to choose colors.
- Use keys `R`, `W`, `K`, `L`, `D` to fill roof, walls, right window, left window, and door respectively.
- Press `ESC` to quit.

---

## Code Structure

- **Drawing routines**: Draw house outlines (walls, roof, windows, door) pixel-by-pixel.
- **Keyboard input loop**: Detects user key presses to change colors or paint regions.
- **Flood fill procedure**: Implements an efficient stack-based region fill to color inside areas bounded by outlines.
- **Color management**: Uses VGA palette indices for color selection.

---

## Notes

- The flood fill algorithm is optimized for the VGA mode 13h graphics buffer.
- Care is taken to avoid painting over boundary lines.
- The stack size is increased to safely handle recursive fills.
