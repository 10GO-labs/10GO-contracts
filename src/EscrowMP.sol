// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

interface IVerifier {
    function verifyProof(
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[81] memory input
    ) external view returns (bool);
}

contract EscrowMP {
    struct Escrow {
        address token;
        uint256 availableAmount;
        address user;
        bool status;
    }

    mapping(uint256 => Escrow) public escrows;       // Almacena los escrows Id -> {amount, CVU, status}
    uint256 public escrowIdCounter;    
    IVerifier public verifier;                    // Contador de IDs de escrow

    event EscrowCreated(uint256 indexed escrowId, uint256 amount, address indexed user);
    event WithdrawalMade(address indexed user, uint256 amount);

    constructor(address _verifier) {
      verifier = IVerifier(_verifier);
    }

    function createEscrow(address token, uint256 amount) external {
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "USDC transfer failed");
        escrowIdCounter++;
        escrows[escrowIdCounter] = Escrow({
            token: token,
            availableAmount: amount,
            user: msg.sender,
            status: false
        });

        emit EscrowCreated(escrowIdCounter, amount, msg.sender);
    }

    function withdraw(
        uint256 escrowId,
        uint256 amount,
        uint256[2] memory a,
        uint256[2][2] memory b,
        uint256[2] memory c,
        uint256[81] memory input
    ) external {
        require(verifier.verifyProof(a, b, c, input), "Invalid Proof");

        Escrow storage escrow = escrows[escrowId];
        escrow.availableAmount -= amount;  // Reverts on underflow >=0.8

        require(IERC20(escrow.token).transfer(msg.sender, amount), "USDC transfer failed");

        emit WithdrawalMade(msg.sender, amount);
    }
}
