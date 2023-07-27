// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.6;

import "remix_tests.sol"; // this import is automatically injected by Remix.
import "../contracts/User_register.sol";

contract TestUserRegister {
    User_register userRegister;
    address testUser1 = address(0x123);
    address testUser2 = address(0x456);
    string testName1 = 'Test User 1';
    string testName2 = 'Test User 2';
    
    struct TestUser {
        string name;
        uint WalletBalance;
    }

    function beforeAll() public {
        userRegister = new User_register();
    }
    function beforeEach() public {
        userRegister = new User_register();
    }

    // Test Case: Verify that the number of users is 0 after initialization.
    function checkInitialUserCount() public {
        uint numUsers = userRegister.numUsers();
        Assert.equal(numUsers, 0, "Initial number of users must be zero.");
    }
    
    // Test Case:  Verify that the user can be added successfully
    function checkAddUser() public {
        uint numUsersBefore = userRegister.numUsers();
        bool success = true;
        
        try userRegister.addUser(testUser1, testName1) {
            
        } catch Error(string memory /*reason*/) {
            // An error occurred, set success to false
            success = false;
        }
        
        Assert.equal(success, true, 'addUser call should be successful');
        
        uint numUsersAfter = userRegister.numUsers();
        Assert.equal(numUsersAfter, numUsersBefore + 1, 'Number of users should increase by 1');

        TestUser memory newUser;
        (newUser.name, newUser.WalletBalance) = userRegister.users(testUser1);
        Assert.equal(newUser.name, testName1, 'User name should match the input name');
    }

    // Test Case: Verify that the manager can register more than one user.
    function checkManagerCanRegisterMoreUsers() public {
        userRegister.addUser(testUser1, testName1);
        userRegister.addUser(testUser2, testName2);
        uint numUsers = userRegister.numUsers();
        Assert.equal(numUsers, 2, "Manager should be able to register more than one user.");
    }
    // Test Case: Verify that the same user can not be registered twice.
    function checkUserNotAddedTwice() public {
        bool success = true;
        
        userRegister.addUser(testUser1, testName1);
        
        try userRegister.addUser(testUser1, testName1) {
            success = false;
        } catch Error(string memory /*reason*/) {
            // An error occurred, set success to true
            success = true;
        }

        Assert.equal(success, true, 'Same user should not be able to register twice');
    }
        
    // Test Case: Verify that a user that does not exist has an empty name
    function checkNonExistentUserHasEmptyName() public {
        string memory userName;
        uint userWalletBalance;
        (userName, userWalletBalance) = userRegister.users(address(0x999));
        
        Assert.equal(userName, "", "Non-existent user should have an empty name");
    }
    // Test Case: Verify adding a user with an invalid address
    function checkAddingUserWithInvalidAddress() public {
        address invalidAddress = address(0x0);
        bool success = true;
        
        try userRegister.addUser(invalidAddress, testName1) {
            success = false;
        } catch Error(string memory /*reason*/) {
            // This is expected
            success = true;
        }
        
        Assert.equal(success, true, "Adding a user with an invalid address should fail");
    }
    // Test Case: Verify adding users with the same name
    function checkAddingUsersWithSameName() public {
        userRegister.addUser(testUser1, testName1);
        userRegister.addUser(testUser2, testName1);
        uint numUsers = userRegister.numUsers();
        Assert.equal(numUsers, 2, "Should be able to add users with the same name");
    }

}
