DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `withdraw`(
    IN id_customer BIGINT, 
    IN amount DECIMAL(12,0)
)
BEGIN
	DECLARE success BOOLEAN;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
    BEGIN
        ROLLBACK;
        SET success = FALSE;
    END;

    START TRANSACTION;

    UPDATE `customers` SET balance = balance - amount WHERE id = id_customer;
     IF ROW_COUNT() > 0 THEN
		INSERT INTO `withdraws` (createdAt, transactionAmount, customer_id)
        VALUES (CURDATE(), amount, id_customer);
		IF ROW_COUNT() > 0 THEN
			SET success = TRUE;
		ELSE
			SET success = FALSE;
		END IF;
    ELSE
        SET success = FALSE;
    END IF;

    IF success THEN
        COMMIT;
    ELSE
        ROLLBACK;
    END IF;

    SELECT success;
END

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `deposit`(
    IN id_customer BIGINT, 
    IN amount DECIMAL(12,0)
)
BEGIN
	DECLARE success BOOLEAN;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
    BEGIN
        ROLLBACK;
        SET success = FALSE;
    END;

    START TRANSACTION;

    UPDATE `customers` SET balance = balance + amount WHERE id = id_customer;
    IF ROW_COUNT() > 0 THEN
		INSERT INTO `deposits` (createdAt, transactionAmount, customer_id)
        VALUES (CURDATE(), amount, id_customer);
		IF ROW_COUNT() > 0 THEN
			SET success = TRUE;
		ELSE
			SET success = FALSE;
		END IF;
    ELSE
        SET success = FALSE;
    END IF;
    
    IF success THEN
        COMMIT;
    ELSE
        ROLLBACK;
    END IF;

    SELECT success;
END
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `transfer`(
	IN fees BIGINT,
	IN sender_id BIGINT, 
	IN recipient_id BIGINT, 
	IN amount DECIMAL(12,0)
)
BEGIN
	DECLARE success BOOLEAN DEFAULT TRUE;
	DECLARE fees DECIMAL(12,2);
    DECLARE fees_amount DECIMAL(12,0);
    DECLARE transaction_amount DECIMAL(12,0);
	START TRANSACTION;
		SET fees_amount = (fees/100) * amount;
		SET transaction_amount = amount + fees_amount;
		SET @balance_sender = (SELECT balance FROM customers WHERE id = sender_id) - transaction_amount;
		SET @balance_recipient = (SELECT balance FROM customers WHERE id = recipient_id) + amount;
		IF transaction_amount < (SELECT balance FROM customers WHERE id = sender_id) THEN
        
			UPDATE customers SET balance =  @balance_sender WHERE id = sender_id;
			UPDATE customers SET balance = @balance_recipient WHERE id = recipient_id;
			INSERT INTO transfers (createdAt, fees, feesAmount, transactionAmount, transferAmount, recipient_id, sender_id)
			VALUES (CURDATE(),fees, fees_amount, transaction_amount , amount, recipient_id, sender_id);
            
			COMMIT;
			SET success = TRUE;
		ELSE
			ROLLBACK;
			SET success = FALSE;
		END IF;

    SELECT success;
END