// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.8;

import "./kahoot.sol";

contract factory {
    kahoot[] public kahootArray;

    function deployKahootGame(string  memory _gameName) public {
        kahoot Kahoot = new kahoot(_gameName);

        kahootArray.push(Kahoot);
    }
}