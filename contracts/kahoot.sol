// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract kahoot {
    // Variables
    address payable public owner;
    string private nameOfGame;
    uint256 public currentQuestion;

    GameStatus isGameOpen;

    // Constructor
    constructor(string memory _gameName) {
        owner = payable(msg.sender);
        nameOfGame = _gameName;
        isGameOpen = GameStatus.CLOSED;
    }

    // Modifiers
    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    // Modifier checking if msg.sender is a student
    modifier isStudent() {
        require(isThisAddressStudent(msg.sender) == true);
        _;
    }

    // Modifier checking if the game is currently open
    modifier isOpen() {
        require(isGameOpen == GameStatus.OPEN);
        _;
    }

    // Structs

    // Struct of answers & the correct answer for a question, for mapping
    struct Questions {
        string[] Answers;
        uint256 correctAnswer;
    }

    // Struct for Students, their names & addresses, for mapping.
    struct Students {
        string Name;
        address StudentAddress;
    }

    // Enums

    // Enum for game to be open
    enum GameStatus {
        CLOSED,
        OPEN
    }

    // Mappings
    mapping(uint256 => mapping(string => address)) internal students;
    mapping(uint256 => address) internal studentsAddresses;
    mapping(address => uint256) internal studentsIds;
    mapping(uint256 => mapping(string => Questions)) internal questions;
    mapping(uint256 => string) internal idQuestions;
    mapping(uint256 => string[]) internal questionAnswers;
    mapping(uint256 => uint256) internal correctAnswerMapping;
    mapping(address => uint256[]) internal didStudentRespond;

    // Arrays
    address[] studentsArray;
    string[] questionsArray;

    /* Functions */

    // Deposit function
    function deposit() public payable isOwner {}

    // Open the game up
    function openGame() public isOwner {
        isGameOpen = GameStatus.OPEN;
    }

    // Add a student to be allowed to play the game
    function addStudent(address _studentAddress, string memory _studentName)
        public
    {
        uint256 id = studentsArray.length + 1;
        students[id][_studentName] = _studentAddress;
        studentsAddresses[id] = _studentAddress;
        studentsIds[_studentAddress] = id;
        studentsArray.push(_studentAddress);
    }

    // Adds a question/answers to the game
    function addQuestion(
        string memory _question,
        string memory _answerOne,
        string memory _answerTwo,
        string memory _answerThree,
        string memory _answerFour,
        uint256 _correctAnswer
    ) public isOwner {
        uint256 qid = questionsArray.length + 1;
        Questions storage _q = questions[qid][_question];
        _q.Answers = [_answerOne, _answerTwo, _answerThree, _answerFour];
        _q.correctAnswer = _correctAnswer;
        idQuestions[qid] = _question;
        questionAnswers[qid] = [
            _answerOne,
            _answerTwo,
            _answerThree,
            _answerFour
        ];
        correctAnswerMapping[qid] = _correctAnswer;
    }

    // Fetches Question String By It's ID in the 2nd Mapping
    function fetchQuestion(uint256 _qid) public view returns (string memory) {
        string memory veribeel;
        veribeel = idQuestions[_qid];
        return veribeel;
    }

    // Fetches All possible Answers of a certain question by ID
    function fetchAnswers(uint256 _id) public view returns (string[] memory) {
        string memory veribeel;
        string[] memory allAnswers;
        veribeel = idQuestions[_id];
        allAnswers = questionAnswers[_id];
        return allAnswers;
    }

    // Returns True/False based on string input if matches QuestionID's correctAnswer
    function answerQuestionInternal(uint256 _id, uint256 _studentAnswer)
        internal
        isOpen
        returns (bool)
    {
        require(_id == currentQuestion);
        uint256 studentAnswer = correctAnswerMapping[_id];
        didStudentRespond[msg.sender] = [_id];
        if (_studentAnswer == studentAnswer) {
            return true;
        } else {
            return false;
        }
    }

    function answerCurrentQuestion(uint256 _answer)
        public
        isStudent
        returns (bool)
    {
        return answerQuestionInternal(currentQuestion, _answer);
    }

    // Checks if a certain address is a student
    function isThisAddressStudent(address _studentAddress)
        public
        view
        returns (bool)
    {
        for (uint256 i = 0; i < studentsArray.length; i++) {
            if (studentsArray[i] == _studentAddress) {
                return true;
            }
        }
        return false;
    }

    // Checks what questions has been answered by a student
    function questionsAnsweredByStudent(address _address)
        public
        view
        returns (uint256[] memory)
    {
        uint256[] memory variable = didStudentRespond[_address];
        return variable;
    }

    function getCurrentQuestionId() public view returns (uint256) {
        return currentQuestion;
    }

    function getCurrentQuestion() public view returns (string memory) {
        uint256 currentId = getCurrentQuestionId();
        return idQuestions[currentId];
    }
}
