# Mortol-Kombot

This project uses **SystemVerilog** and **C** to create a simplified version of the retro game **MORTAL KOMBAT** for running on an **FPGA** with USB Blaster as a **System-on-Chip** (SoC) based around **NIOS II/e**. The gameplay design is similar to the original Mortal Kombat and Street Fighter games. The project features two game modes for providing an interactive experience to users, a **single-player** mode against a computer-driven "AI" player, and a **multiplayer** mode for two users on the same keyboard. The project currently uses only about **13%** of the **On-Chip Memory** on the FPGA, and fully compiles in under **90 seconds**, leaving the project extremely scalable even without the usage of SDRAM or Flash Memory and easy to test because of the short compilation time.

The key components of the design are the System Bus, SDRAM, Video Display, and Keyboard, which have been implemented using hardware. The acquisition of inputs from the keyboard, generation of the AI entity actions, and the game states have been implemented by using the NIOS II CPU software and have been coded in C. The rendering of background and player graphics, processing multiple key inputs from the keyboard, action sequencing, player stats, and possibly other high-performance features such as collision have been implemented in the hardware directly using SystemVerilog.

To make gameplay smoother, several animations and game features from retro fighting games have been implemented. Furthermore, **multiple keystroke support** has been added for the acquisition of inputs from a compatible keyboard, which allows the multiplayer mode to be fair to both players at any point during a match. The generation of the "AI" player's moves is handled by a **custom IP core** that has been created to transfer gamemode functionality to NIOS II and specifically choose movements based on game conditions and the moves of Player 1 (user).

## Description of Project Folders/Files:
The top-level module for the Quartus project is **project.sv**
- **Folder** ```.sv code``` holds the functionality of the game and contains most of the SystemVerilog modules.
- **Folder** ```IP``` holds the file(s) for generating a custom IP core.
- **Folder** ```ROM_data``` holds the sprite and background ROM data acquired through PNG images converted to bit data along with the modules render that data as animations.
- **Folder** ```software``` holds the C code used by NIOS II and is directly accessed by Eclipse through Quartus.
- **Folder** ```tmp``` holds commented out code including additional approaches to various aspects of the game.
- The remaining folders contain system-generated files and should not be edited individually.

## Instructions for Running the project:
1. Connect the FPGA to the device running the project, a VGA monitor, and a USB keyboard.
2. Open the Project in Quartus using the ```Mortol_Kombot.qpf``` file.

_Individual SystemVerilog files can be edited at this stage._

3. Compile the project in Quartus, and program the FPGA with the recently compiled project files.
4. After this step, the title screen with a flashing **MORTOL KOMBOT** title and static gamemode instructions should be visible on the VGA monitor.

_User input wouldn't necessarily change the game state at this stage._

5. To start playing the game, open the software files included with this project in Eclipse.
6. Generate a **BSP**, build the project in Eclipse, and then run configurations.
7. After the FPGA is successfully loaded with NIOS II, users can start playing the game in single player mode ```Enter``` or two-player mode ```Spacebar``` using their USB keyboard.

## Instruction keys for playing:
1. ```R``` for restart/reset
2. ```W```, ```A```, ```S```, ```D``` for Player 1 movements
3. ```K``` for P1 kick, ```P``` for P1 punch
4. ```Arrow Keys``` for Player 2 movements
5. ```>``` for P2 kick, ```?``` for P2 punch 
6. ```SpaceBar``` for multiplayer
7. ```Enter``` for single player
