# Part I: Setting Up Your Computer

## Windows Subsystem for Linux 
We will be handling all of the sequencing data locally on windows. However, due to much of bioinformatic analysis favoring Linux systems, (and the fact that this is how I learned it, therefore making it the fastest way for me to teach you and actually be able to help you) you will need to make some additions to your computer's arsenal before we get into the ooey gooey good stuff we call frickin' science. You can download the WSL [here](https://ubuntu.com/desktop/wsl).

Once you have this downloaded, we will prepare the conda environment. 

## Miniconda & Conda Environments

> **SIDE BAR:**
> What the hell is a conda environment? A conda environment is an isolated directory that stores a specific set of software packages and their dependencies. It allows you to manage different project requirements in their specific folders. Now, this is very useful to us. Because maybe in the future, we will do even more analyses that maybe all require different versions of certain packages. Do you want to be updating our package versions every time we want to do something different? I don't!

Now, I could provide you with the conda environment. However, if I did that, you would not learn. This is just some extra knowledge that could help you! Just be happy I am not writing this tutorial when I was obsessed with virtual machines! (that's a whole different beast of crazy I do not want to deal with)

Okay, back to the actual tutorial.

## Initializing your environment
Alright, now go ahead and fire up Windows Powershell because we are about to get hella started (on the set up process LOL).

>Side Note: All of these comments are purely for my own enjoyment, so you can choose to enjoy them or not (I know I am).

Anyways, you are going to want to run the following commands in your terminal (I suggest actually typing them out rather than copy and paste):
```
#Getting WSL for Windows installed:
wsl --install

#Set up the environment
sudo apt update
sudo apt upgrade

#Downloading miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

#Install miniconda
bash Miniconda3-latest-Linux-x86_64.sh

#Initilize
source ~/.bashrc

#Verify that conda exists
conda --version

#Create a conda environment with Python 3.8
conda create --name (whatever_you_want_to_name_it) python=3.8

#Activate your environment
conda activate (whatever_you_want_to_name_it)

#Install the necessary packages
conda install -c conda-forge libgcc-ng xopen
conda install -c bioconda cutadapt=4.0
conda install -c bioconda fastqc trim-galore kallisto
conda install -c conda-forge gzip

#verify installation
Fastqc --version
Trim_galore --version
kallisto --version
gunzip --version
```

Yay! You made a conda environment! Pat yourself on the back. That is not sarcastic, I am genuinely proud of you :)

## Additional Downloads
Unfortunately, life is not easy-peasy-lemon-squeezy. We still have more stuff to install and play with.

### Notepad++ (Or really any text editor, this is just what I use, but I stg do not use notepad I will stab you)
So, all of the scripts I provided are set up with my file directory, so it won't work for yours. Some of these scripts, you have to edit so that it will work on your computer. That's okay because soon you will want to write your own, and this will be good practice.

Anyways, I use notepad++ to write and edit scripts. You can download this [here](https://notepad-plus-plus.org/downloads/).

After you have that downloaded, let's run a script together. I want you to download the following script and save it to whatever directory you plan doing this tutorial in:
* [test.sh]()

After you have this downloaded, I want you to open it with notepad++. Now, unfortunately for you, you will have to interact with every script I give you. The reason for that is the scripts get downloaded in windows format (because you're downloading it to a Windows device (if you have a mac, I am sorry you are not in the clear)). Anyways, open this script and look over the code if you want. It is a very simple script that will print out a message. Feel free to change the message, but I think it is pretty good as is. 

Our next step is we are going to have to convert this file so it is comaptible with our WSL. To do this, you will want to select the tab ```Edit``` and then ```EOL Conversion``` and choose ```Unix(LF)```. There, you have successfully converted it. Don't forget to save your changes!

Now, you will want to activate your wsl and ensure your working directory is the same directory that has this ```test.sh``` file. (Tip: of you go to the directory in your file explorer and type wsl in the directory tab it will open up wsl in that directory, as shown [here]()). 

Anyways, how do we run a script in wsl? It's quite simple. You will simply type ```./NameOfScript.sh``` into your terminal:
```
#how to run test.sh
./test.sh
```
the ```./``` in the command simply represents every directory before your current directory, or the path to get to your current directory. We love shortcuts that allows us to not type our directory path out every single time we want to do somehting in it. Anyways, you did it! You printed ```strawberry milk```!

You are porbably wondering why we couldn't just type those small and short commands in the terminal itself. Well, we could have, but as the tutorial goes on, and you further your interest in bioinformatics, scripts will get longer and more complicated. Or, we may want to use them multiple times. To help us out and keep track of everything we write, we use ```.sh``` files to run jobs.

Now you know how to open, edit, and prepare scripts for jobs. We just have one more step until we start the science!

### RStudio
The very last parts of our analyses will be done through RStudio, which you can download [here](https://posit.co/download/rstudio-desktop/)!

Once you have that downloaded and installed, we can officially start getting some data and analyzing it!

Now that you have WSL set up and have all of our downloaded applications, we can move on to [Part II](https://github.com/jtm077/Pressure-Project/blob/main/RNA-Seq%20Tutorial/Part%20II.md)!
