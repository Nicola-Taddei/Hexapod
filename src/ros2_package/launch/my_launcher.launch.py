from launch import LaunchDescription
from launch_ros.actions import Node


def generate_launch_description():
    return LaunchDescription([
        Node(
            package='ros2_package',
            namespace='two_nodes',
            executable='talker',
            name='talker_name'
        ),
        Node(
            package='ros2_package',
            namespace='two_nodes',
            executable='listener',
            name='listener_name'
        ),
    ])