// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AdvancedRobotFleet {

    address public admin;

    enum TaskState {
        Pending,
        Running,
        Completed
    }

    struct Robot {

        string name;

        bool authenticated;

        bool busy;

        uint capability;

        uint completedTasks;

    }

    struct Task {

        uint taskID;

        string description;

        uint requiredCapability;

        uint assignedRobot;

        TaskState status;

        uint priority;

    }

    mapping(uint => Robot) public robots;

    mapping(uint => Task) public tasks;

    uint public totalTasks;

    modifier onlyAdmin(){

        require(
            msg.sender == admin,
            "Admin only"
        );

        _;

    }

    event RobotRegistered(
        uint robotID,
        string name
    );

    event TaskCreated(
        uint taskID,
        string description
    );

    event TaskAssigned(
        uint taskID,
        uint robotID
    );

    event TaskCompleted(
        uint taskID,
        uint robotID
    );

    constructor(){

        admin = msg.sender;

        registerRobot(
            1,
            "Robot1",
            5
        );

        registerRobot(
            2,
            "Robot2",
            8
        );

        registerRobot(
            3,
            "Robot3",
            10
        );

    }

    function registerRobot(

        uint id,

        string memory name,

        uint capability

    )

    internal {

        robots[id] = Robot(

            name,

            true,

            false,

            capability,

            0

        );

        emit RobotRegistered(
            id,
            name
        );

    }

    function createTask(

        string memory desc,

        uint capability,

        uint priority

    )

    public

    onlyAdmin

    {

        totalTasks++;

        tasks[totalTasks] = Task(

            totalTasks,

            desc,

            capability,

            0,

            TaskState.Pending,

            priority

        );

        emit TaskCreated(
            totalTasks,
            desc
        );

    }

    function assignTask(

        uint taskID,

        uint robotID

    )

    public

    onlyAdmin

    {

        require(

            robots[robotID].authenticated,

            "Robot Invalid"

        );

        require(

            !robots[robotID].busy,

            "Robot Busy"

        );

        require(

            robots[robotID].capability

            >=

            tasks[taskID]
            .requiredCapability,

            "Capability Low"

        );

        tasks[taskID]
        .assignedRobot = robotID;

        tasks[taskID]
        .status = TaskState.Running;

        robots[robotID]
        .busy = true;

        emit TaskAssigned(
            taskID,
            robotID
        );

    }

    function completeTask(

        uint taskID

    )

    public

    {

        uint robotID =
        tasks[taskID]
        .assignedRobot;

        require(

            robotID != 0,

            "No Robot"

        );

        tasks[taskID]
        .status =
        TaskState.Completed;

        robots[robotID]
        .busy = false;

        robots[robotID]
        .completedTasks++;

        emit TaskCompleted(

            taskID,

            robotID

        );

    }

}