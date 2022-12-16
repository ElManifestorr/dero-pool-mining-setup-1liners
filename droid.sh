#!/data/data/com.termux/files/usr/bin/bash

# Introduction & asks for wallet address
echo "Thank you for choosing to garden with us"
echo -n "The only thing you need to do is input your wallet address: "
read WALLET_ADDRESS
echo "You have chosen the address: $WALLET_ADDRESS"

# sets 'ANSWER' variable to N so that the test below can run
# the test asks if your address is correct and if you respond it isnt, then it gives you a chance to change it
ANSWER=N
while [[ $ANSWER != "Y" && $ANSWER != "y" && $ANSWER != "" ]]
do
        echo -n "If this is correct please type 'y' and press enter. Otherwise type 'n' and press enter."
        read ANSWER

        if [[ $ANSWER != "Y" && $ANSWER != "y" && $ANSWER != "" ]]
        then
               echo -n "Enter Your Miner Wallet Address: "
                read WALLET_ADDRESS
        fi
done

echo "You have chosen to mine using the Dero Community Garden Pool & with the address: ${WALLET_ADDRESS}."
echo "We wish you many bountiful harvests!"

# sets the port to the correct port for the pool, then makes a 'POOL_NODE' variable containing pool address + port number
PORT=10300
POOL_NODE=thewestiswild.com:$PORT

# Makes script work on it's own without any ability to be interacted with from here on. (You've done all you need to now)
export DEBIAN_FRONTEND='noninteractive'

# Makes a new directory where the miner will be & changes into said directory
echo "Gathering the seeds and rounding up the hoes..."
mkdir Mining
cd Mining

# updates & upgrades repositories
pkg update -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'
pkg upgrade  -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'

# installs two needed packages, wget which allows us to download files from the net and tmux which allows us to detach from miner & run in background
pkg install wget tmux -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'

# sets the environment to the correct one so we download the correct files for your device
ARCH=arm7
if [[ "$(uname -m)" == "aarch64" ]]
then
    export ARCH=arm64
fi

# removes any old downloads if there is any in order to avoid errors
rm dero_linux_${ARCH}.tar.gz
rm -rf dero_linux_$ARCH

echo "Downloading Dero files..."

# downloads the miner from the projects official repository hosted on github.com
wget -c https://github.com/deroproject/derohe/releases/latest/download/dero_linux_$ARCH.tar.gz

# ensures theres not already a directory where we plan to have one then unzips the package
[[ ! -d dero_linux_$ARCH ]] && tar -zxpvf dero_linux_${ARCH}.tar.gz

# deletes the downloaded file we just unzipped, because we no longer need it
rm *.tar.gz

echo "Setting up alias shortcuts for future usage!"

# creates a variable in your .bashrc file in order to always have easy access to it in the future
echo "WALLET_ADDRESS=${WALLET_ADDRESS}" >> $HOME/.bashrc

# creates a shell script to start the miner and adds in the lines of code needed for it to run properly 
echo "#!/data/data/com.termux/files/usr/bin/bash" > startminer.sh
echo "./dero_linux_${ARCH}/dero-miner-linux-$ARCH --wallet-address=$WALLET_ADDRESS --daemon-rpc-address=$NODE" >> startminer.sh

# changes the permissions on new script to make it executable
chmod u+x startminer.sh

# adds code that will repeat to you every time you launch termux and explain how to run the miner again, detach from miner, and also how to view a miner you detached from.
echo 'echo "To start mining again type in STARTMINER all caps followed by the enter key"' >> $HOME/.bashrc
echo 'echo "To detach from the miner you must press ctrl+b together, then press d to finish the detaching process"' >> $HOME/.bashrc
echo 'echo "After youve detached from the miner you can reattach and view its status by typing in VIEWMINER, all caps, followed by the ENTER key"' >> $HOME/.bashrc

# creates alias to start miner again in the future
echo "alias STARTMINER='cd $HOME/Mining && tmux new-session -s miner ./startminer.sh'" >> $HOME/.bashrc

#creates alias to view miner that you've detached from
echo "alias VIEWMINER='tmux attach-session -t miner'" >> $HOME/.bashrc

# tells you how to exit the miner if you so wish
echo "To exit the miner, you type in 'exit' and press enter."

# tells you how to detach from miner and allow it to run in the background, 'ctrl+b' must be pressed together, followed by pressing 'd'
echo "To detach from the miner you press 'ctrl + b', simultaneously followed by 'd'"

echo "Once again we at the Dero Community Garden would like to thank you & wish you many blocks + a heavy bag of DERO."

tmux new-session -s miner ./startminer.sh