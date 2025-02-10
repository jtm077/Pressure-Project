# Part I: Setting Up Windows Powershell

## Windows Subsystem for Linux
We will be handling all of the sequencing data locally on windows. However, due to much of bioinformatic analysis favoring Linux systems, (and the fact that this is how I learned it, therefore making it the fastest way for me to teach you and actually be able to help you) you will need to make some additions to your computer's arsonal before we get into the ooey gooey good stuff we call frickin' science.You can download the WSL [here](https://ubuntu.com/desktop/wsl).

Once you have this downloaded, we will prepare the conda environment. 

## Miniconda & Conda Environments

> **SIDE BAR:** 

> _What the hell is a conda environment?_ A conda environment is an isolated directory that stores a specific set of software packages and their dependencies. It allows you to manage different project requirements in their specific folders. Now, this is very useful to us. Because maybe in the future, we will do even more analyses that maybe all require different versions of certain packages. Do you want to be updating our package versions every time we want to do something different? I don't!


Now, I could provide you with the conda environment. However, if I did that, you would not learn. This is just some extra knowledge that could help you! Just be happy I am not writing this tutorial when I was obsessed with virtual machines! (that's a whole different beast of crazy I do not want to deal with)

Okay, back to the actual tutorial.

## Initializing your environment
Alright, now go ahead and fire up Windows Powershell because we are about to get hella started (on the set up process LOL).

Side Note: All of these comments are purely for my own enjoyment, so you can choose to enjoy them or not (I know I am).

Anyways, you are going to want to run the following commands in your terminal (I suggest actually typing them our rather than copy and paste):
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

Now that you have WSL set up, we can move on to Part II!
