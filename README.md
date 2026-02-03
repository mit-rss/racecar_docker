| Deliverable                                                                                            | Due Date                              |
|--------------------------------------------------------------------------------------------------------|---------------------------------------|
| Base Installation (nothing to submit)                                                                  | Wednesday, February 4th at 1:00PM EST |
| Intro to Linux [Gradescope Submission](https://www.gradescope.com/courses/1227626/assignments/7471274) | Monday,    February 9th at 1:00PM EST |
| Intro to Git [Gradescope Submission](https://www.gradescope.com/courses/1227626/assignments/7471275)   | Monday,    February 9th at 1:00PM EST |

# Intro to RSS

## Table of Contents

* [Introduction](https://github.com/mit-rss/racecar_docker#introduction)
* [Lab Overview](https://github.com/mit-rss/racecar_docker#lab-overview)
* [Grading](https://github.com/mit-rss/racecar_docker#grading)
* [Installation](https://github.com/mit-rss/racecar_docker#installation)
* [Using the Docker Container](https://github.com/mit-rss/racecar_docker#using-the-docker-container)
    * [Starting Up](https://github.com/mit-rss/racecar_docker#starting-up)
    * [Example Usage](https://github.com/mit-rss/racecar_docker#example-usage)
    * [Shutting Down](https://github.com/mit-rss/racecar_docker#shutting-down)
    * [Local Storage](https://github.com/mit-rss/racecar_docker#local-storage)
    * [Tips](https://github.com/mit-rss/racecar_docker#tips)
 * [Lab 1A: Intro to Linux](https://github.com/mit-rss/intro_to_linux/tree/master)
 * [Lab 1B: Intro to Git](https://github.com/mit-rss/intro_to_git/tree/master)

## Introduction

Welcome to RSS! In this lab, we will set up the MIT Racecar Docker image which we will use throughout this class, and get familiar with
Linux and Git, which are essential tools for working in robotics.

## Lab Overview

This lab is split into 3 parts:

- **Base Installation:** Go through the [Installation](https://github.com/mit-rss/racecar_docker#installation) and
    [Using the Docker Container](https://github.com/mit-rss/racecar_docker#using-the-docker-container) sections of this README.
    Setting up the MIT Racecar Docker image is essential for this class, and is a prerequisite to completing the subsequent sections of this lab.
- **[Lab 1A](https://github.com/mit-rss/intro_to_linux/tree/master):** Introduction to Linux, as it is the operating system we will be using
    in the docker container and on the racecars.
- **[Lab 1B](https://github.com/mit-rss/intro_to_git/tree/master):** Introduction to Git for version control and working on code as a team.

We will also have a **TA check-in** on Monday, February 9th during lab time. This is not graded; the purpose is to make sure you're all set up
for future labs and have a solid understanding of Linux and Git.

## Grading

| Problem                  | Weight (total: 6.0) |
|--------------------------|---------------------|
| Intro to Linux Problem 1 | 0.8                 |
| Intro to Linux Problem 2 | 0.7                 |
| Intro to Linux Problem 3 | 0.4                 |
| Intro to Linux Problem 4 | 0.8                 |
| Intro to Linux Problem 5 | 0.3                 |
| Intro to Git Problem 1   | 1.0                 |
| Intro to Git Problem 2   | 1.2                 |
| Intro to Git Problem 3   | 0.8                 |

## Installation

First install `git` and Docker according to your OS:

- macOS: Make sure command line tools are installed by running `xcode-select --install` in a terminal and then
    [install and launch Docker Desktop](https://docs.docker.com/desktop/mac/install/).
- Windows: [Install git](https://git-scm.com/download/win) and then
    [install and launch Docker Desktop](https://docs.docker.com/desktop/windows/install/).
- Linux: Make sure you have [git installed](https://git-scm.com/download/linux) and then
    [install Docker Engine for your distro](https://docs.docker.com/engine/install).

Once everything is installed and running, if you're on macOS or Linux open a terminal and if you're on Windows open a PowerShell.
Then clone and pull the image:

> **IMPORTANT NOTE:** If you are using a Mac with Apple silicon, after cloning the repository, you must go into `docker-compose.yml`
> and change the image from "staffmitrss/racecar-sim:amd", to "staffmitrss/racecar-sim:arm"

```
git clone https://github.com/mit-rss/racecar_docker.git
cd racecar_docker
docker compose pull
```

Linux users may need to use `sudo` to run `docker compose`. The image is about 1GB compressed so this can take a couple minutes.
Fortunately, you only need to do it once.

## Using the Docker Container

### Starting Up

Once the image is pulled you can start it by running the following in your `racecar_docker` directory:

```
docker compose up
```

Follow the instructions in the command prompt to connect via either a terminal or your browser.
If you're using the browser interface, click "Connect" then right click anywhere on the black background to launch a terminal.

### Example Usage

First, connect via the graphical interface, right click on the background and select `RViz`.

> **Note:** RViz can also be launched by typing `rviz2` in the terminal. 

Next, right click on the background and select `Terminal`, then enter:

```
ros2 launch racecar_simulator simulate.launch.xml
```

A graphical interface should pop up that shows a blue car on a monochrome background (a map) and some colorful dots (simulated LiDAR).
If you click the green "2D Pose Estimate" arrow on the top and then drag on the map you can change the position of the car.

> **Note:** When launching most scripts to be visualized, make sure that you launch RViz first, otherwise certain features might not appear. 

Close RViz and type `Ctrl+c` in the terminal running the simulator (in your graphical interface that is on the browser) to stop it.
Now we're going to try to install some software. In any terminal run:

```
sudo apt update
sudo apt install cmatrix
```

To use `sudo` you will need to enter the user password which is `racecar@mit`.
Once the software is installed, run

```
cmatrix
```

You're in!

### Shutting Down

To stop the image, run the following in your `racecar_docker` directory **outside of your docker container**:

```
docker compose down
```

**Do NOT use** `Ctrl+c` **to stop the docker container!** Always use the `docker compose down` command.
If you try to rerun `docker compose up` without first running `docker compose down` the image may not launch properly.
If you find that noVNC does not launch properly, try running `docker compose down` and then `docker compose up`.

### Local Storage

Any changes made to the your home folder in the docker image (`/home/racecar`) will be saved to the `racecar_docker/home` directory on your
local machine, but **ANY OTHER CHANGES WILL BE DELETED WHEN YOU RESTART THE DOCKER IMAGE**.
The only changes you will ever need to make for your labs will be in your home folder, so ideally this should never be a
problem. *Just be careful* not to keep any important files outside of that folder.

### Tips

- In the graphical interface, you can move windows around by holding `Alt` or `Command` (depending on your OS) then clicking
    and dragging *anywhere* on a window. Use this to recover your windows if the title bar at the top of a window goes off screen.
- You can copy and paste into the graphical interface by using the `Clipboard` button on the left hand side. First, copy the text
    into `Clipboard`. Then, `Ctrl+v` should paste that text inside the graphical interface.
