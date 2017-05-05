# baxter
baxter_block_planner installation/Configuration script

https://github.com/sabasallath/baxter_block_planner

- In ubuntu 14.04 (**<- and only in 14.04**) run
   ```
   install/installation_baxter.sh
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

    
- Install MoveIt package

    http://sdk.rethinkrobotics.com/wiki/MoveIt_Tutorial
    
    **/!\ REBOOT after MoveIt installation**
    
    If still in trouble :
    
    ```
    cd ~/ros_ws/
    rm -rf build/
    rm -rf devel/
    catkin_make
    catkin_make install
    ```
    
- Clone sabasallath/baxter_block_planner.git in ~/ros_ws/src/ 
    and in ~ros_ws directory :
    
    ```
    catkin_make
    catkin_make install
    ```

- Launch it

    In separate terminal do
    
    ```
    cd ~/ros_ws/
    ./baxter.sh sim
    roslaunch baxter_block_planner block_planner.launch
    ```
    ```
    cd ~/ros_ws/
    ./baxter.sh sim
    rosrun baxter_tools enable_robot.py -e
    rosrun baxter_interface joint_trajectory_action_server.py
    ```
    ```
    cd ~/ros_ws/
    ./baxter.sh sim
    rosrun baxter_block_planner block_planner.py
    ```

- Your Done !

    Install visual-studio-code and pycharm with :
    
       install/post_install_utils.sh


    
    
    