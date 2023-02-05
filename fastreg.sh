#!/bin/bash


# Color variables
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
# Clear the color after that
clear='\033[0m'

#updating the system
sudo apt update
sudo apt upgrade -y

#installing dependencies 
sudo apt install snapd git -y
sudo snap install go

#checks if downloaded previously, then once located changes into the directory
if [ -d "fastreg" ]; then
  cd fastreg/
else
  echo "Cloning the repo from github."
  git clone https://github.com/deroholic/fastreg.git
  cd fastreg/
fi

#go commands to build the packages into an application
go mod tidy
go get
go build


#running the app with the specific arguements of our node and a language of english. running this command with the -h command will display more options.
clear
echo ""
printf "\033[0;33mWallet is being registered now. Please wait.\033[0m"
./fastreg --daemon-address=thewestiswild.com:10102 --language=english &> ../KEEP_SAFE.txt


#menu for what to do next
echo " "
printf "\033[0;32mRegistration Successful!\033[0m"
echo " "
printf "${red}'KEEP_SAFE.txt' ~ THIS IS IMPORTANT ~ \033[0m"
echo "Each wallet consists of 2 major aspects. There is a PUBLIC KEY & a PRIVATE KEY. One is used when you sign off on transactions or when you need to regain access to your account. You NEVER SHARE THIS ONE."
echo "However the other one is your public key. This key begins with the letters 'dero' and is also known as your wallet's address. This one you give someone who is sending you funds and is entirely safe to give to the public."
echo "These are your first set of key. Ensure that you keep this file safe. Ideally, you would put on a flash drive and keep it offline, copy down the information to store in a safe then delete this file. Print and delete. Etc. Storing on your PC is never good practice for your 'OpSec' aka Operation Security."
echo "We have created a 'Variable' of your public address in order to easily have access to it in the rest of this setup, however you can delte your 'KEEP_SAFE.txt' file as soon as you have a solid copy of AT LEAST THE 12 WORDS, IDEALLY THE 12 WORDS + YOUR PRIVATE KEY."
echo ""
echo "To make sure this hits home I'll say one more time: YOU MUST KEEP YOUR 25 WORDS VERY SAFE BECAUSE THIS IS HOW YOU'LL UNLOCK YOUR WALLET FOR USE... EVEN IF YOU LOSE A PASSWORD, THIS WILL OPEN A WALLET OF YOURS"
printf "\033[0;33m Now you simply put your PRIVATE KEY into any wallet of choice. \033[0m"
echo "Thank you and any donations to Derocious if this helped!"

#moving back to home working directory
cd ../

#printf "export DERO_ADDRESS=$(sed -n '2p' .KEEP_SAFE.txt)" >> variables.txt

