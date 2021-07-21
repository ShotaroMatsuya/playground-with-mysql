DROP TRIGGER IF EXISTS prevent_self_follows;

DELIMITER $$

CREATE TRIGGER prevent_self_follows
    BEFORE INSERT ON follows FOR EACH ROW
    BEGIN
        IF NEW.follower_id = NEW.followee_id
        THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'You cannot follow yourself!';
        END IF;
    END;
$$

DELIMITER ;

CREATE TABLE unfollows(
    follower_id INTEGER NOT NULL,
    followee_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (follower_id) REFERENCES users(id),
    FOREIGN KEY (followee_id) REFERENCES users(id),
    PRIMARY KEY (follower_id,followee_id)
);

DROP TRIGGER IF EXISTS capture_unfollow;

DELIMITER $$

CREATE TRIGGER capture_unfollow
    AFTER DELETE ON follows FOR EACH ROW
    BEGIN 
        INSERT INTO unfollows
        SET follower_id = OLD.follower_id,
            followee_id = OLD.followee_id;
    END;
$$
DELIMITER ;
