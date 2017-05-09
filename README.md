# baxter
baxter_block_planner installation/Configuration script

- Install ubuntu 14.04

    For instance, on windows you can load Xubuntu 14.04 iso on USB key with rufus :

    - http://cdimage.ubuntu.com/xubuntu/releases/14.04/release/xubuntu-14.04-desktop-amd64.iso
    - https://rufus.akeo.ie/downloads/rufus-2.14.exe
    
    More details on installation procedure can be found here :
    
    - https://www.ubuntu.com/download/desktop/create-a-usb-stick-on-windows

- In ubuntu **14.04** (or 14.04.1, 14.04.2, 14.04.3 and derivative)

   Update
   
   ```
   sudo apt-get update
   sudo apt-get upgrade
   ```

   Clone this repository
   
   ```
   git clone https://github.com/sabasallath/baxter.git
   ```
   
   Run the installation_baxter.sh script
   
   ```
   ~/baxter/install/installation_baxter.sh
   ```
   
- Edit your ~/ros_ws/baxter.sh ip and hostname section

- If you get ```"Warning [gazebo.cc:215] Waited 1seconds for namespaces.``` error

    Update gazebo to the lastest version
    
    ```    
    sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu trusty main" > /etc/apt/sources.list.d/gazebo-latest.list'
    wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
    ```
    
    Don't forget to ugrade
    ```
    sudo apt-get update
    sudo apt-get upgrade
    ```
    
- Install baxter_block_planner

    - https://github.com/sabasallath/baxter_block_planner
    
- Your Done !


    
    
    