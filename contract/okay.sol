// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RockPaperScissors
 * @dev A simple commit–reveal Rock–Paper–Scissors game that ensures fairness.
 * Players first commit a hashed move, then later reveal it.
 * The winner is determined automatically and stored on-chain.
 */
contract RockPaperScissors {
    enum Move { None, Rock, Paper, Scissors }
    enum Result { None, Player1Wins, Player2Wins, Draw }

    struct Game {
        address player1;
        address player2;
        bytes32 commit1;
        bytes32 commit2;
        Move move1;
        Move move2;
        Result result;
        bool revealed1;
        bool revealed2;
    }

    uint256 public gameCount;
    mapping(uint256 => Game) public games;

    event GameCreated(uint256 indexed gameId, address indexed player1, address indexed player2);
    event MoveCommitted(uint256 indexed gameId, address indexed player);
    event MoveRevealed(uint256 indexed gameId, address indexed player, Move move);
    event GameResolved(uint256 indexed gameId, Result result);

    /**
     * @dev Create a new game between two players.
     */
    function createGame(address _opponent) external returns (uint256 gameId) {
        require(_opponent != msg.sender, "Can't play against yourself");
        require(_opponent != address(0), "Invalid opponent");

        gameCount++;
        gameId = gameCount;

        games[gameId] = Game({
            player1: msg.sender,
            player2: _opponent,
            commit1: bytes32(0),
            commit2: bytes32(0),
            move1: Move.None,
            move2: Move.None,
            result: Result.None,
            revealed1: false,
            revealed2: false
        });

        emit GameCreated(gameId, msg.sender, _opponent);
    }

    /**
     * @dev Commit a hashed move. 
     * The hash should be keccak256(abi.encodePacked(move, secret)).
     */
    function commitMove(uint256 gameId, bytes32 moveHash) external {
        Game storage game = games[gameId];
        require(game.player1 != address(0), "Game does not exist");
        require(game.result == Result.None, "Game finished");

        if (msg.sender == game.player1) {
            require(game.commit1 == bytes32(0), "Already committed");
            game.commit1 = moveHash;
        } else if (msg.sender == game.player2) {
            require(game.commit2 == bytes32(0), "Already committed");
            game.commit2 = moveHash;
        } else {
            revert("Not a player in this game");
        }

        emit MoveCommitted(gameId, msg.sender);
    }

    /**
     * @dev Reveal the move along with the secret used in the commit.
     */
    function revealMove(uint256 gameId, Move move, string calldata secret) external {
        Game storage game = games[gameId];
        require(game.player1 != address(0), "Game does not exist");
        require(game.result == Result.None, "Game already finished");
        require(move == Move.Rock || move == Move.Paper || move == Move.Scissors, "Invalid move");

        bytes32 checkHash = keccak256(abi.encodePacked(move, secret));

        if (msg.sender == game.player1) {
            require(game.commit1 == checkHash, "Invalid reveal");
            require(!game.revealed1, "Already revealed");
            game.move1 = move;
            game.revealed1 = true;
        } else if (msg.sender == game.player2) {
            require(game.commit2 == checkHash, "Invalid reveal");
            require(!game.revealed2, "Already revealed");
            game.move2 = move;
            game.revealed2 = true;
        } else {
            revert("Not a player in this game");
        }

        emit MoveRevealed(gameId, msg.sender, move);

        if (game.revealed1 && game.revealed2) {
            _resolveGame(gameId);
        }
    }

    /**
     * @dev Internal function to determine winner and store result.
     */
    function _resolveGame(uint256 gameId) internal {
        Game storage game = games[gameId];

        if (game.move1 == game.move2) {
            game.result = Result.Draw;
        } else if (
            (game.move1 == Move.Rock && game.move2 == Move.Scissors) ||
            (game.move1 == Move.Scissors && game.move2 == Move.Paper) ||
            (game.move1 == Move.Paper && game.move2 == Move.Rock)
        ) {
            game.result = Result.Player1Wins;
        } else {
            game.result = Result.Player2Wins;
        }

        emit GameResolved(gameId, game.result);
    }
}
