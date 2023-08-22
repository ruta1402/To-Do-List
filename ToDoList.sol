// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract ToDoList{
    struct TodoItem {
        string task;
        bool isCompleted;
    }

    mapping (uint256 => TodoItem) public list;
    uint256 public count = 0;
    address public owner;
    event TaskCompleted(uint256 indexed id);

    constructor () {
        owner = msg.sender;
    }

    function addTask(string calldata ToDoTask) onlyOwner public {
        TodoItem memory item = TodoItem({ task: ToDoTask, isCompleted: false });
        list[count] = item;
        count++;
    }

    function completeTask(uint256 CompletedTaskId) onlyOwner public {
        if (!list[CompletedTaskId].isCompleted) {
            list[CompletedTaskId].isCompleted = true;
            emit TaskCompleted(CompletedTaskId);
        }
    }

    function listAllTasks() onlyOwner public view returns (string memory) {
        string memory result;
    
        for (uint256 i = 0; i < count; i++) {
            string memory status = list[i].isCompleted ? "Completed" : "Not Completed";
            string memory taskInfo = string(
                abi.encodePacked(
                    "Task ID: ", uint2str(i), ", Task: ", list[i].task, ", Status: ", status, "\n"
                )
            );
            result = string(abi.encodePacked(result, taskInfo));
        }
        
        return result;
    }
    function uint2str(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }

        uint256 temp = value;
        uint256 digits;

        while (temp != 0) {
            digits++;
            temp /= 10;
        }

        bytes memory buffer = new bytes(digits);
        temp = value;
        while (temp != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + temp % 10));
            temp /= 10;
        }

        return string(buffer);
    }



    modifier onlyOwner() {
        require(owner == msg.sender, "Only owner can call this");
        _;
    }
}

