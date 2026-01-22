CREATE DATABASE IF NOT EXISTS ipl_auction_2026;
USE ipl_auction_2026;

CREATE TABLE teams (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    purse INT DEFAULT 120,
    spent INT DEFAULT 0,
    total_points INT DEFAULT 0
);

CREATE TABLE players (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(30) NOT NULL,
    role VARCHAR(30) NOT NULL,
    nationality VARCHAR(30) NOT NULL,

    base_price INT NOT NULL,
    sold_price INT DEFAULT NULL,
    team_id INT DEFAULT NULL,

    matches INT DEFAULT 0,
    runs INT DEFAULT 0,
    wickets INT DEFAULT 0,
    strike_rate FLOAT DEFAULT 0,
    economy FLOAT DEFAULT 0,
    catches INT DEFAULT 0,

    form_rating INT DEFAULT 0,
    fitness_rating INT DEFAULT 0,
    consistency INT DEFAULT 0,

    strategy_points INT DEFAULT 0,

    FOREIGN KEY (team_id)
        REFERENCES teams(id)
        ON DELETE SET NULL
);

INSERT INTO teams (name) VALUES
('CSK'),('MI'),('RCB'),('KKR'),('SRH'),
('RR'),('DC'),('LSG'),('GT'),('PBKS');

INSERT INTO players
(name,category,role,nationality,base_price,matches,runs,wickets,strike_rate,economy,catches,form_rating,fitness_rating,consistency)
VALUES
('Virat Kohli','Batsman','Top Order','India',2,252,8004,0,131.9,0,96,9,9,10),
('Rohit Sharma','Batsman','Opener','India',2,243,6211,0,130.4,0,92,8,8,9),
('Shubman Gill','Batsman','Opener','India',2,91,2790,0,138.7,0,44,9,9,8),
('KL Rahul','Batsman','Opener','India',2,123,4683,0,134.6,0,58,7,8,8),
('Suryakumar Yadav','Batsman','Middle Order','India',2,150,3500,0,145.7,0,67,9,8,9),
('Shreyas Iyer','Batsman','Middle Order','India',1,115,3100,0,129.8,0,55,7,7,8),
('Ruturaj Gaikwad','Batsman','Opener','India',1,78,2380,0,136.4,0,41,8,9,8),
('Ishan Kishan','Batsman','Opener','India',1,105,2644,0,133.5,0,48,7,8,7),
('Tilak Varma','Batsman','Middle Order','India',1,43,1200,0,138.9,0,29,8,9,7),
('Rinku Singh','Batsman','Finisher','India',1,52,1400,0,149.6,0,31,9,9,8),

('David Warner','Batsman','Opener','Australia',2,176,6565,0,139.8,0,84,8,7,8),
('Jos Buttler','Batsman','Opener','England',2,100,3582,0,147.5,0,64,9,7,8),
('Kane Williamson','Batsman','Top Order','New Zealand',2,79,2101,0,126.2,0,45,6,7,7),
('Steve Smith','Batsman','Top Order','Australia',1,103,3090,0,128.1,0,61,6,7,7),
('Travis Head','Batsman','Top Order','Australia',1,28,870,0,141.2,0,18,8,8,7),
('Glenn Maxwell','Batsman','Middle Order','Australia',1,130,2771,0,156.7,0,76,8,7,8),
('Faf du Plessis','Batsman','Opener','South Africa',1,145,4133,0,131.4,0,88,8,7,8),
('Aiden Markram','Batsman','Top Order','South Africa',1,69,1800,0,135.3,0,39,7,8,7),
('Quinton de Kock','Batsman','Opener','South Africa',2,107,3157,0,134.2,0,72,8,7,8),
('Rilee Rossouw','Batsman','Middle Order','South Africa',1,56,1500,0,142.8,0,34,8,8,7),

('Devon Conway','Batsman','Top Order','New Zealand',1,47,1397,0,134.9,0,32,8,8,7),
('Daryl Mitchell','Batsman','Middle Order','New Zealand',1,41,1120,0,138.5,0,28,8,8,7),
('Nicholas Pooran','Batsman','Middle Order','West Indies',1,94,2300,0,146.2,0,57,8,7,8),
('Shimron Hetmyer','Batsman','Middle Order','West Indies',1,95,2400,0,138.4,0,49,7,7,7),
('Jason Roy','Batsman','Opener','England',1,64,1535,0,139.9,0,36,7,7,7),
('Harry Brook','Batsman','Top Order','England',1,21,650,0,148.1,0,14,8,8,6),
('Liam Livingstone','Batsman','Middle Order','England',1,83,2100,0,155.8,0,53,8,7,8),
('Rahul Tripathi','Batsman','Middle Order','India',1,95,2650,0,140.5,0,51,7,8,7),
('Manish Pandey','Batsman','Top Order','India',1,171,3800,0,121.6,0,83,6,7,6),
('Mayank Agarwal','Batsman','Opener','India',1,123,2660,0,134.1,0,47,6,7,7);


INSERT INTO players
(name,category,role,nationality,base_price,matches,runs,wickets,strike_rate,economy,catches,form_rating,fitness_rating,consistency)
VALUES
-- 🇮🇳 INDIAN BOWLERS
('Jasprit Bumrah','Bowler','Fast','India',2,123,0,145,0,7.4,32,9,9,10),
('Mohammed Shami','Bowler','Fast','India',2,110,0,130,0,7.8,28,8,8,9),
('Yuzvendra Chahal','Bowler','Spinner','India',2,145,0,187,0,7.7,41,8,8,9),
('Ravichandran Ashwin','Bowler','Spinner','India',2,197,0,171,0,7.1,58,7,7,9),
('Kuldeep Yadav','Bowler','Spinner','India',1,92,0,95,0,7.6,29,8,8,8),
('Bhuvneshwar Kumar','Bowler','Swing','India',2,146,0,170,0,7.4,42,7,7,8),
('Mohit Sharma','Bowler','Medium','India',1,112,0,134,0,8.3,36,8,7,7),
('Deepak Chahar','Bowler','Swing','India',1,73,0,72,0,7.8,23,7,6,7),
('Arshdeep Singh','Bowler','Left-arm Fast','India',1,65,0,79,0,8.2,19,8,8,7),
('Avesh Khan','Bowler','Fast','India',1,63,0,74,0,8.6,21,7,7,7),

-- 🌍 OVERSEAS FAST BOWLERS
('Trent Boult','Bowler','Fast','New Zealand',2,95,0,105,0,8.1,25,7,7,8),
('Pat Cummins','Bowler','Fast','Australia',2,55,0,63,0,8.5,18,7,8,8),
('Mitchell Starc','Bowler','Fast','Australia',2,41,0,59,0,8.2,15,8,7,8),
('Kagiso Rabada','Bowler','Fast','South Africa',2,109,0,127,0,8.4,34,8,8,9),
('Anrich Nortje','Bowler','Fast','South Africa',1,56,0,63,0,8.9,17,7,7,7),
('Lungi Ngidi','Bowler','Fast','South Africa',1,42,0,51,0,8.6,14,7,7,7),
('Lockie Ferguson','Bowler','Fast','New Zealand',1,49,0,67,0,8.8,16,7,7,7),
('Mark Wood','Bowler','Fast','England',1,18,0,20,0,8.9,6,7,7,6),
('Jofra Archer','Bowler','Fast','England',2,40,0,48,0,7.9,19,7,6,7),
('Reece Topley','Bowler','Left-arm Fast','England',1,16,0,19,0,8.4,6,7,7,6),

-- 🌀 SPIN & VARIETY BOWLERS
('Rashid Khan','Bowler','Spinner','Afghanistan',2,109,0,139,0,6.6,39,9,8,9),
('Noor Ahmad','Bowler','Spinner','Afghanistan',1,24,0,29,0,7.9,8,8,8,7),
('Sunil Narine','Bowler','Spinner','West Indies',2,176,0,180,0,6.7,74,7,7,9),
('Varun Chakravarthy','Bowler','Spinner','India',1,71,0,83,0,7.4,22,8,8,8),
('Wanindu Hasaranga','Bowler','Spinner','Sri Lanka',2,26,0,35,0,7.3,11,8,7,7),
('Mujeeb Ur Rahman','Bowler','Spinner','Afghanistan',1,19,0,22,0,6.9,7,7,7,6),
('Adam Zampa','Bowler','Spinner','Australia',1,14,0,16,0,7.6,6,7,7,6),
('Mitchell Santner','Bowler','Spinner','New Zealand',1,80,0,67,0,7.2,33,7,8,8),
('Shakib Al Hasan','Bowler','Spinner','Bangladesh',2,71,0,63,0,7.4,37,7,7,8),
('Maheesh Theekshana','Bowler','Spinner','Sri Lanka',1,33,0,40,0,7.8,12,8,8,7);


INSERT INTO players
(name,category,role,nationality,base_price,matches,runs,wickets,strike_rate,economy,catches,form_rating,fitness_rating,consistency)
VALUES
-- 🇮🇳 INDIAN ALL-ROUNDERS
('Hardik Pandya','All-rounder','Fast Bowling All-rounder','India',2,123,2309,53,145.7,8.2,54,8,7,8),
('Ravindra Jadeja','All-rounder','Spin All-rounder','India',2,226,2692,152,127.3,7.6,102,8,8,9),
('Axar Patel','All-rounder','Spin All-rounder','India',2,150,1600,123,132.1,7.4,61,8,8,8),
('Washington Sundar','All-rounder','Spin All-rounder','India',1,104,1020,73,121.4,7.3,39,7,7,7),
('Krunal Pandya','All-rounder','Spin All-rounder','India',1,112,1700,76,132.7,7.5,58,7,7,7),
('Shivam Dube','All-rounder','Batting All-rounder','India',1,95,1880,20,145.8,8.9,44,8,8,7),
('Venkatesh Iyer','All-rounder','Batting All-rounder','India',1,51,1250,10,137.6,8.5,28,7,8,7),
('Deepak Hooda','All-rounder','Batting All-rounder','India',1,110,1700,15,130.9,8.8,49,7,7,7),
('Abhishek Sharma','All-rounder','Batting All-rounder','India',1,63,1500,18,139.2,8.4,36,8,8,7),
('Riyan Parag','All-rounder','Batting All-rounder','India',1,54,1100,7,133.8,9.1,29,7,8,6),

-- 🌍 OVERSEAS SEAM ALL-ROUNDERS
('Ben Stokes','All-rounder','Fast Bowling All-rounder','England',2,43,920,28,135.4,8.4,41,7,6,7),
('Sam Curran','All-rounder','Fast Bowling All-rounder','England',2,49,820,39,131.6,8.1,32,8,8,8),
('Marcus Stoinis','All-rounder','Fast Bowling All-rounder','Australia',2,95,2300,39,142.8,8.5,72,8,7,8),
('Cameron Green','All-rounder','Fast Bowling All-rounder','Australia',2,35,1020,12,155.2,8.7,27,8,8,7),
('Daryl Mitchell','All-rounder','Batting All-rounder','New Zealand',1,41,1120,6,138.5,8.1,28,8,8,7),
('Mitchell Marsh','All-rounder','Fast Bowling All-rounder','Australia',2,42,665,20,134.3,8.9,34,7,7,7),
('Jason Holder','All-rounder','Fast Bowling All-rounder','West Indies',2,38,260,49,123.1,8.2,29,7,7,7),
('Andre Russell','All-rounder','Power All-rounder','West Indies',2,112,2262,98,174.0,9.2,89,8,6,8),
('Chris Woakes','All-rounder','Fast Bowling All-rounder','England',1,21,200,30,122.0,7.6,14,6,7,6),
('Kyle Jamieson','All-rounder','Fast Bowling All-rounder','New Zealand',1,9,65,9,144.4,9.4,6,6,6,6),

-- 🌀 SPIN / VARIETY ALL-ROUNDERS
('Sunil Narine','All-rounder','Spin All-rounder','West Indies',2,176,1100,180,165.4,6.7,74,8,7,9),
('Shakib Al Hasan','All-rounder','Spin All-rounder','Bangladesh',2,71,793,63,124.8,7.4,37,7,7,8),
('Wanindu Hasaranga','All-rounder','Spin All-rounder','Sri Lanka',2,26,310,35,143.1,7.3,11,8,7,7),
('Moeen Ali','All-rounder','Spin All-rounder','England',2,67,1200,32,137.9,7.9,51,7,7,7),
('Glenn Phillips','All-rounder','Batting All-rounder','New Zealand',1,27,680,7,148.6,8.8,24,8,8,7),
('Sikandar Raza','All-rounder','Spin All-rounder','Zimbabwe',1,36,650,22,135.5,7.8,26,8,8,7),
('Daniel Sams','All-rounder','Fast Bowling All-rounder','Australia',1,32,450,33,141.0,8.6,21,7,7,7),
('Fabian Allen','All-rounder','Spin All-rounder','West Indies',1,27,360,19,139.4,7.5,22,7,7,6),
('George Garton','All-rounder','Fast Bowling All-rounder','England',1,9,70,6,145.2,8.7,5,6,6,6),
('Romario Shepherd','All-rounder','Power All-rounder','West Indies',1,21,390,26,160.3,9.1,17,7,7,7);


INSERT INTO players
(name,category,role,nationality,base_price,matches,runs,wickets,strike_rate,economy,catches,form_rating,fitness_rating,consistency)
VALUES
-- 🇮🇳 INDIAN WICKET-KEEPERS
('MS Dhoni','Wicket-Keeper','WK-Batsman','India',2,250,5082,0,135.9,0,190,7,6,10),
('Rishabh Pant','Wicket-Keeper','WK-Batsman','India',2,98,2838,0,147.9,0,97,8,7,8),
('KL Rahul','Wicket-Keeper','WK-Batsman','India',2,123,4683,0,134.6,0,58,7,8,8),
('Sanju Samson','Wicket-Keeper','WK-Batsman','India',2,152,3888,0,137.2,0,92,8,8,8),
('Ishan Kishan','Wicket-Keeper','WK-Batsman','India',1,105,2644,0,133.5,0,72,7,8,7),
('Dinesh Karthik','Wicket-Keeper','WK-Batsman','India',1,242,4516,0,132.7,0,164,6,7,8),
('Wriddhiman Saha','Wicket-Keeper','WK-Batsman','India',1,153,2798,0,127.4,0,128,6,7,7),
('Jitesh Sharma','Wicket-Keeper','WK-Batsman','India',1,38,850,0,147.1,0,35,8,8,7),
('KS Bharat','Wicket-Keeper','WK-Batsman','India',1,24,520,0,121.3,0,29,6,7,6),
('Prabhsimran Singh','Wicket-Keeper','WK-Batsman','India',1,33,760,0,146.2,0,41,7,8,6),

-- 🌍 OVERSEAS WICKET-KEEPERS
('Jos Buttler','Wicket-Keeper','WK-Batsman','England',2,100,3582,0,147.5,0,86,9,7,8),
('Quinton de Kock','Wicket-Keeper','WK-Batsman','South Africa',2,107,3157,0,134.2,0,101,8,7,8),
('Nicholas Pooran','Wicket-Keeper','WK-Batsman','West Indies',2,94,2300,0,146.2,0,82,8,7,8),
('Jonny Bairstow','Wicket-Keeper','WK-Batsman','England',2,95,2770,0,141.5,0,78,8,7,8),
('Heinrich Klaasen','Wicket-Keeper','WK-Batsman','South Africa',2,54,1400,0,151.8,0,63,9,8,7),
('Alex Carey','Wicket-Keeper','WK-Batsman','Australia',1,32,420,0,125.4,0,41,6,7,6),
('Sam Billings','Wicket-Keeper','WK-Batsman','England',1,49,1040,0,134.7,0,59,6,7,7),
('Tom Banton','Wicket-Keeper','WK-Batsman','England',1,38,790,0,145.6,0,46,7,7,6),
('Tim Seifert','Wicket-Keeper','WK-Batsman','New Zealand',1,24,480,0,141.2,0,31,6,7,6),
('Matthew Wade','Wicket-Keeper','WK-Batsman','Australia',1,15,320,0,137.5,0,22,6,6,6),

-- 🌏 EMERGING / ASSOCIATE / YOUNG KEEPERS
('Rahmanullah Gurbaz','Wicket-Keeper','WK-Batsman','Afghanistan',1,27,720,0,148.9,0,38,8,8,7),
('Phil Salt','Wicket-Keeper','WK-Batsman','England',1,21,650,0,153.4,0,29,8,8,6),
('Kusal Mendis','Wicket-Keeper','WK-Batsman','Sri Lanka',1,19,510,0,138.7,0,26,7,7,6),
('Devon Thomas','Wicket-Keeper','WK-Batsman','West Indies',1,14,290,0,132.6,0,17,6,6,6),
('Niroshan Dickwella','Wicket-Keeper','WK-Batsman','Sri Lanka',1,18,410,0,134.9,0,21,6,6,6),
('Andre Fletcher','Wicket-Keeper','WK-Batsman','West Indies',1,26,560,0,139.2,0,33,6,6,6),
('Ben McDermott','Wicket-Keeper','WK-Batsman','Australia',1,12,280,0,146.8,0,16,7,7,6),
('Josh Inglis','Wicket-Keeper','WK-Batsman','Australia',1,15,390,0,149.5,0,23,7,7,6),
('Donovan Ferreira','Wicket-Keeper','WK-Batsman','South Africa',1,10,240,0,152.6,0,14,7,7,6),
('Anuj Rawat','Wicket-Keeper','WK-Batsman','India',1,23,510,0,131.7,0,34,6,7,6);
