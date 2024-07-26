ALTER TABLE provinces
PARTITION BY LIST(administrative_region_id) (
    PARTITION northEast VALUES IN (1),
    PARTITION northWest VALUES IN (2),
    PARTITION redRiver VALUES IN (3),
    PARTITION northCentral VALUES IN (4),
    PARTITION southCentral VALUES IN (5),
    PARTITION centralHighlands VALUES IN (6),
    PARTITION southEast VALUES IN (7),
    PARTITION mekongDelta VALUES IN (8)
);

-- Get all the information of Hanoi and HCM
SELECT *
FROM provinces
WHERE LOWER(name_en) = LOWER('Ho Chi Minh')
OR LOWER(name_en) = LOWER('Ha Noi');
