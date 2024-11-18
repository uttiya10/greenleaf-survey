-- MySQL Script generated by MySQL Workbench
-- Sat Nov  9 23:26:30 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`AuthenticationLogs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`AuthenticationLogs` (
  `log_ID` INT NOT NULL,
  `login_time_timestamp` VARCHAR(255) NOT NULL,
  `success` INT NOT NULL,
  `User_User_ID` INT NOT NULL,
  PRIMARY KEY (`log_ID`),
  UNIQUE INDEX `log_ID_UNIQUE` (`log_ID` ASC) VISIBLE,
  UNIQUE INDEX `login_time_timestamp_UNIQUE` (`login_time_timestamp` ASC) VISIBLE,
  UNIQUE INDEX `success_UNIQUE` (`success` ASC) VISIBLE,
  INDEX `fk_AuthenticationLogs_User1_idx` (`User_User_ID` ASC) VISIBLE,
  CONSTRAINT `fk_AuthenticationLogs_User1`
    FOREIGN KEY (`User_User_ID`)
    REFERENCES `mydb`.`User` (`User_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `mydb`.`LoyaltyPoints`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`LoyaltyPoints` (
  `PointsID` INT NOT NULL,
  `Action` VARCHAR(300) NOT NULL,
  `LoyaltyRewards_RewardID` INT NOT NULL,
  PRIMARY KEY (`PointsID`),
  UNIQUE INDEX `PointsID_UNIQUE` (`PointsID` ASC) VISIBLE,
  INDEX `fk_LoyaltyPoints_LoyaltyRewards1_idx` (`LoyaltyRewards_RewardID` ASC) VISIBLE,
  CONSTRAINT `fk_LoyaltyPoints_LoyaltyRewards1`
    FOREIGN KEY (`LoyaltyRewards_RewardID`)
    REFERENCES `mydb`.`LoyaltyRewards` (`RewardID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`LoyaltyRewards`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`LoyaltyRewards` (
  `RewardID` INT NOT NULL,
  `RewardDescription` VARCHAR(255) NOT NULL,
  `PointsRequired` VARCHAR(255) NOT NULL,
  `RedemptionDate` DATE NOT NULL,
  `User_User_ID` INT NOT NULL,
  PRIMARY KEY (`RewardID`),
  UNIQUE INDEX `RewardID_UNIQUE` (`RewardID` ASC) VISIBLE,
  UNIQUE INDEX `RewardDescription_UNIQUE` (`RewardDescription` ASC) VISIBLE,
  UNIQUE INDEX `PointsRequired_UNIQUE` (`PointsRequired` ASC) VISIBLE,
  UNIQUE INDEX `RedemptionDate_UNIQUE` (`RedemptionDate` ASC) VISIBLE,
  INDEX `fk_LoyaltyRewards_User1_idx` (`User_User_ID` ASC) VISIBLE,
  CONSTRAINT `fk_LoyaltyRewards_User1`
    FOREIGN KEY (`User_User_ID`)
    REFERENCES `mydb`.`User` (`User_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

DROP TABLE MultipleChoiceOption;

-- -----------------------------------------------------
-- Table `mydb`.`MultipleChoiceOption`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`MultipleChoiceOption` (
  `Surveys_Survey_ID` INT NOT NULL,
  `OptionPosition` INT NOT NULL,
  `OptionText` VARCHAR(255) NOT NULL,
  `Question_SurveyPosition` INT NOT NULL,
  PRIMARY KEY (`Surveys_Survey_ID`, `Question_SurveyPosition`, `OptionPosition`),
  CONSTRAINT `fk_MultipleChoiceOption_Question1`
    FOREIGN KEY (`Surveys_Survey_ID`, `Question_SurveyPosition`)
    REFERENCES `mydb`.`MultipleChoiceQuestion` (`Surveys_Survey_ID`, `Question_SurveyPosition`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SELECT * FROM MultipleChoiceOption;
DROP TABLE MultipleChoiceQuestion;
-- -----------------------------------------------------
-- Table `mydb`.`MultipleChoiceQuestion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`MultipleChoiceQuestion` (
  `MaxSelectionNumber` INT NOT NULL,
  `Question_SurveyPosition` INT NOT NULL,
  `Surveys_Survey_ID` INT NOT NULL,
  PRIMARY KEY (`Surveys_Survey_ID`, `Question_SurveyPosition`),
  CONSTRAINT `fk_MultipleChoiceQuestion_Question1`
    FOREIGN KEY (`Surveys_Survey_ID`, `Question_SurveyPosition`)
    REFERENCES `mydb`.`Question` (`Surveys_Survey_ID`, `SurveyPosition`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SELECT * FROM MultipleChoiceQuestion;

-- -----------------------------------------------------
-- Table `mydb`.`MultipleChoiceResponse`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`MultipleChoiceResponse` (
  `SelectedOption` INT NOT NULL,
  `User_User_ID` INT NOT NULL,
  `Surveys_Survey_ID` INT NOT NULL,
  `Question_SurveyPosition` INT NOT NULL,
  PRIMARY KEY (`User_User_ID`, `Surveys_Survey_ID`, `Question_SurveyPosition`),
  CONSTRAINT `fk_MultipleChoiceResponse_User1`
    FOREIGN KEY (`User_User_ID`)
    REFERENCES `mydb`.`User` (`User_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MultipleChoiceResponse_Surveys1`
    FOREIGN KEY (`Surveys_Survey_ID`, `Question_SurveyPosition`, `SelectedOption`)
    REFERENCES `mydb`.`MultipleChoiceOption` (`Surveys_Survey_ID`, `Question_SurveyPosition`, `OptionPosition`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

DROP TABLE MultipleChoiceResponse;

-- -----------------------------------------------------
-- Table `mydb`.`Products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Products` (
  `ProductID` INT NOT NULL,
  `ProductName` VARCHAR(255) NOT NULL,
  `Tickets_Ticket_ID` INT NOT NULL,
  `User_User_ID` INT NOT NULL,
  PRIMARY KEY (`ProductID`),
  UNIQUE INDEX `ProductID_UNIQUE` (`ProductID` ASC) VISIBLE,
  UNIQUE INDEX `ProductName_UNIQUE` (`ProductName` ASC) VISIBLE,
  INDEX `fk_Products_Tickets1_idx` (`Tickets_Ticket_ID` ASC) VISIBLE,
  INDEX `fk_Products_User1_idx` (`User_User_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Products_Tickets1`
    FOREIGN KEY (`Tickets_Ticket_ID`)
    REFERENCES `mydb`.`Tickets` (`Ticket_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Products_User1`
    FOREIGN KEY (`User_User_ID`)
    REFERENCES `mydb`.`User` (`User_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `mydb`.`Question`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Question` (
  `SurveyPosition` INT NOT NULL,
  `QuestionText` VARCHAR(255) NOT NULL,
  `Surveys_Survey_ID` INT NOT NULL,
  PRIMARY KEY (`Surveys_Survey_ID`, `SurveyPosition`),
  CONSTRAINT `fk_Question_Surveys1`
    FOREIGN KEY (`Surveys_Survey_ID`)
    REFERENCES `mydb`.`Surveys` (`Survey_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SELECT * FROM question;
DROP TABLE question;

-- -----------------------------------------------------
-- Table `mydb`.`RewardRedemption`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`RewardRedemption` (
  `RedemptionID` INT NOT NULL,
  `RedemptionDate` DATE NOT NULL,
  `Rewards_reward_ID` INT NOT NULL,
  `LoyaltyRewards_RewardID` INT NOT NULL,
  `User_User_ID` INT NOT NULL,
  PRIMARY KEY (`RedemptionID`),
  UNIQUE INDEX `RedemptionID_UNIQUE` (`RedemptionID` ASC) VISIBLE,
  INDEX `fk_RewardRedemption_Rewards1_idx` (`Rewards_reward_ID` ASC) VISIBLE,
  INDEX `fk_RewardRedemption_LoyaltyRewards1_idx` (`LoyaltyRewards_RewardID` ASC) VISIBLE,
  INDEX `fk_RewardRedemption_User1_idx` (`User_User_ID` ASC) VISIBLE,
  CONSTRAINT `fk_RewardRedemption_Rewards1`
    FOREIGN KEY (`Rewards_reward_ID`)
    REFERENCES `mydb`.`Rewards` (`reward_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RewardRedemption_LoyaltyRewards1`
    FOREIGN KEY (`LoyaltyRewards_RewardID`)
    REFERENCES `mydb`.`LoyaltyRewards` (`RewardID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RewardRedemption_User1`
    FOREIGN KEY (`User_User_ID`)
    REFERENCES `mydb`.`User` (`User_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Rewards`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Rewards` (
  `reward_ID` INT NOT NULL,
  `Points` INT NOT NULL,
  `reward_Date_timestamp` VARCHAR(255) NOT NULL,
  `User_User_ID` INT NOT NULL,
  PRIMARY KEY (`reward_ID`),
  UNIQUE INDEX `reward_ID_UNIQUE` (`reward_ID` ASC) VISIBLE,
  UNIQUE INDEX `Points_UNIQUE` (`Points` ASC) VISIBLE,
  UNIQUE INDEX `reward_Date_timestamp_UNIQUE` (`reward_Date_timestamp` ASC) VISIBLE,
  INDEX `fk_Rewards_User1_idx` (`User_User_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Rewards_User1`
    FOREIGN KEY (`User_User_ID`)
    REFERENCES `mydb`.`User` (`User_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Role`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Role` (
  `Role_ID` INT UNSIGNED NOT NULL,
  `role_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Role_ID`),
  UNIQUE INDEX `role_name_UNIQUE` (`role_name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Survey_Response`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Survey_Response` (
  `Survey_Response_ID` INT NOT NULL,
  `Survery_ID` VARCHAR(255) NOT NULL,
  `User_ID` VARCHAR(255) NOT NULL,
  `Response_text` VARCHAR(1000) NOT NULL,
  PRIMARY KEY (`Survey_Response_ID`))
ENGINE = InnoDB;

DROP TABLE Survey_Response;

DROP TABLE Surveys;
-- -----------------------------------------------------
-- Table `mydb`.`Surveys`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Surveys` (
  `Survey_ID` INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(64),
  description VARCHAR(64),
  PRIMARY KEY (`Survey_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`TextualQuestion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`TextualQuestion` (
  `CharLimit` INT NOT NULL,
  `Question_SurveyPosition` INT NOT NULL,
  `Surveys_Survey_ID` INT NOT NULL,
  PRIMARY KEY (`Surveys_Survey_ID`, `Question_SurveyPosition`),
  CONSTRAINT `fk_TextualQuestion_Question1`
    FOREIGN KEY (`Surveys_Survey_ID`, `Question_SurveyPosition`)
    REFERENCES `mydb`.`Question` (`Surveys_Survey_ID`, `SurveyPosition`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SELECT * FROM TextualQuestion;
DROP TABLE TextualQuestion;

-- -----------------------------------------------------
-- Table `mydb`.`TextualResponse`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`TextualResponse` (
  `ResponseText` VARCHAR(2000) NOT NULL,
  `Question_SurveyPosition` INT NOT NULL,
  `Surveys_Survey_ID` INT NOT NULL,
  `User_User_ID` INT NOT NULL,
  PRIMARY KEY (`User_User_ID`, `Surveys_Survey_ID`, `Question_SurveyPosition`),
  CONSTRAINT `fk_TextualResponse_Question1`
    FOREIGN KEY (`Surveys_Survey_ID`, `Question_SurveyPosition`)
    REFERENCES `mydb`.`Question` (`Surveys_Survey_ID`, `SurveyPosition`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TextualResponse_User1`
    FOREIGN KEY (`User_User_ID`)
    REFERENCES `mydb`.`User` (`User_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

DROP TABLE TextualResponse;

-- -----------------------------------------------------
-- Table `mydb`.`Ticket_response`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Ticket_response` (
  `Ticket_Response_ID` INT NOT NULL,
  `User_ID` VARCHAR(255) NULL,
  `Response_text` VARCHAR(255) NULL,
  `Responded_at` VARCHAR(255) NULL,
  `Tickets_Ticket_ID` INT NOT NULL,
  PRIMARY KEY (`Ticket_Response_ID`),
  INDEX `fk_Ticket_response_Tickets1_idx` (`Tickets_Ticket_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Ticket_response_Tickets1`
    FOREIGN KEY (`Tickets_Ticket_ID`)
    REFERENCES `mydb`.`Tickets` (`Ticket_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Tickets`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Tickets` (
  `Ticket_ID` INT NOT NULL,
  `Ticket_status` VARCHAR(255) NOT NULL,
  `Priority` VARCHAR(255) NOT NULL,
  `Created_at` VARCHAR(255) NOT NULL,
  `Ticket_text` VARCHAR(1000) NOT NULL,
  `User_User_ID` INT NOT NULL,
  PRIMARY KEY (`Ticket_ID`),
  UNIQUE INDEX `Ticket_ID_UNIQUE` (`Ticket_ID` ASC) VISIBLE,
  UNIQUE INDEX `Ticket_status_UNIQUE` (`Ticket_status` ASC) VISIBLE,
  UNIQUE INDEX `Priority_UNIQUE` (`Priority` ASC) VISIBLE,
  INDEX `fk_Tickets_User1_idx` (`User_User_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Tickets_User1`
    FOREIGN KEY (`User_User_ID`)
    REFERENCES `mydb`.`User` (`User_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Transactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Transactions` (
  `TransactionID` INT NOT NULL,
  `User_User_ID` INT NOT NULL,
  `LoyaltyPoints_PointsID` INT NOT NULL,
  `Date` DATE NULL,
  PRIMARY KEY (`TransactionID`),
  INDEX `fk_Transactions_User1_idx` (`User_User_ID` ASC) VISIBLE,
  INDEX `fk_Transactions_LoyaltyPoints1_idx` (`LoyaltyPoints_PointsID` ASC) VISIBLE,
  CONSTRAINT `fk_Transactions_User1`
    FOREIGN KEY (`User_User_ID`)
    REFERENCES `mydb`.`User` (`User_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transactions_LoyaltyPoints1`
    FOREIGN KEY (`LoyaltyPoints_PointsID`)
    REFERENCES `mydb`.`LoyaltyPoints` (`PointsID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`User` (
  `User_ID` INT NOT NULL,
  `Username` VARCHAR(255) NOT NULL,
  `User_Password` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`User_ID`),
  UNIQUE INDEX `Username_UNIQUE` (`Username` ASC) VISIBLE,
  UNIQUE INDEX `User_ID_UNIQUE` (`User_ID` ASC) VISIBLE,
  UNIQUE INDEX `User_Password_UNIQUE` (`User_Password` ASC) VISIBLE)
ENGINE = InnoDB;

DROP TABLE User;
INSERT INTO `mydb`.`User` (`User_ID`, `Username`, `User_Password`)
VALUES (123, 'sampleUser', 'password123');

-- -----------------------------------------------------
-- Table `mydb`.`UserResourceAccess`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`UserResourceAccess` (
  `AccessID` INT NOT NULL,
  `AccessDate` VARCHAR(255) NOT NULL,
  `User_User_ID` INT NOT NULL,
  `EducationalResources_ResourceID` INT NOT NULL,
  PRIMARY KEY (`AccessID`),
  UNIQUE INDEX `AccessID_UNIQUE` (`AccessID` ASC) VISIBLE,
  UNIQUE INDEX `AccessDate_UNIQUE` (`AccessDate` ASC) VISIBLE,
  INDEX `fk_UserResourceAccess_User1_idx` (`User_User_ID` ASC) VISIBLE,
  INDEX `fk_UserResourceAccess_EducationalResources1_idx` (`EducationalResources_ResourceID` ASC) VISIBLE,
  CONSTRAINT `fk_UserResourceAccess_User1`
    FOREIGN KEY (`User_User_ID`)
    REFERENCES `mydb`.`User` (`User_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_UserResourceAccess_EducationalResources1`
    FOREIGN KEY (`EducationalResources_ResourceID`)
    REFERENCES `mydb`.`EducationalResources` (`ResourceID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`User_Roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`User_Roles` (
  `User_role_ID` INT NOT NULL,
  `User_ID` VARCHAR(255) NOT NULL,
  `Role_Role_ID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`User_role_ID`),
  UNIQUE INDEX `User_role_ID_UNIQUE` (`User_role_ID` ASC) VISIBLE,
  UNIQUE INDEX `User_ID_UNIQUE` (`User_ID` ASC) VISIBLE,
  INDEX `fk_User_Roles_Role1_idx` (`Role_Role_ID` ASC) VISIBLE,
  CONSTRAINT `fk_User_Roles_Role1`
    FOREIGN KEY (`Role_Role_ID`)
    REFERENCES `mydb`.`Role` (`Role_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
