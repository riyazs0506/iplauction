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


/* =========================
   ALL ROUNDERS (CLEANED)
========================= */
INSERT IGNORE INTO players
(name, category, role, nationality, base_price,
 matches, runs, wickets, strike_rate, economy, catches,
 form_rating, fitness_rating, consistency)
VALUES
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

('Ben Stokes','All-rounder','Fast Bowling All-rounder','England',2,43,920,28,135.4,8.4,41,7,6,7),
('Sam Curran','All-rounder','Fast Bowling All-rounder','England',2,49,820,39,131.6,8.1,32,8,8,8),
('Marcus Stoinis','All-rounder','Fast Bowling All-rounder','Australia',2,95,2300,39,142.8,8.5,72,8,7,8),
('Cameron Green','All-rounder','Fast Bowling All-rounder','Australia',2,35,1020,12,155.2,8.7,27,8,8,7),
('Matheesha Pathirana','All-rounder','Fast Bowling All-rounder','Sri Lanka',1,25,180,32,135.0,8.6,12,8,8,7),
('Mitchell Marsh','All-rounder','Fast Bowling All-rounder','Australia',2,42,665,20,134.3,8.9,34,7,7,7),
('Jason Holder','All-rounder','Fast Bowling All-rounder','West Indies',2,38,260,49,123.1,8.2,29,7,7,7),
('Andre Russell','All-rounder','Power All-rounder','West Indies',2,112,2262,98,174.0,9.2,89,8,6,8),
('Chris Woakes','All-rounder','Fast Bowling All-rounder','England',1,21,200,30,122.0,7.6,14,6,7,6),
('Kyle Jamieson','All-rounder','Fast Bowling All-rounder','New Zealand',1,9,65,9,144.4,9.4,6,6,6,6),

('Romario Shepherd','All-rounder','Power All-rounder','West Indies',1,21,390,26,160.3,9.1,17,7,7,7),
('Daniel Sams','All-rounder','Fast Bowling All-rounder','Australia',1,32,450,33,141.0,8.6,21,7,7,7),
('Fabian Allen','All-rounder','Spin All-rounder','West Indies',1,27,360,19,139.4,7.5,22,7,7,6),
('Moeen Ali','All-rounder','Spin All-rounder','England',2,67,1200,32,137.9,7.9,51,7,7,7),
('Glenn Phillips','All-rounder','Batting All-rounder','New Zealand',1,27,680,7,148.6,8.8,24,8,8,7),
('Sikandar Raza','All-rounder','Spin All-rounder','Zimbabwe',1,36,650,22,135.5,7.8,26,8,8,7),
('Shahbaz Ahmed','All-rounder','Spin All-rounder','India',1,55,620,18,124.6,7.6,31,7,7,7),
('Vijay Shankar','All-rounder','Batting All-rounder','India',1,72,1050,9,129.3,8.4,42,6,7,6),
('Rahul Tewatia','All-rounder','Spin All-rounder','India',1,83,960,32,140.2,7.9,48,7,8,7);


/* =========================
   WICKET KEEPERS
========================= */
INSERT IGNORE INTO players
(name, category, role, nationality, base_price,
 matches, runs, wickets, strike_rate, economy, catches,
 form_rating, fitness_rating, consistency)
VALUES
('MS Dhoni','Wicket-Keeper','WK-Batsman','India',2,250,5082,0,135.9,0,190,7,6,10),
('Rishabh Pant','Wicket-Keeper','WK-Batsman','India',2,98,2838,0,147.9,0,97,8,7,8),
('Sanju Samson','Wicket-Keeper','WK-Batsman','India',2,152,3888,0,137.2,0,92,8,8,8),
('Jitesh Sharma','Wicket-Keeper','WK-Batsman','India',1,38,850,0,147.1,0,35,8,8,7),
('Dinesh Karthik','Wicket-Keeper','WK-Batsman','India',1,242,4516,0,132.7,0,164,6,7,8),
('Wriddhiman Saha','Wicket-Keeper','WK-Batsman','India',1,153,2798,0,127.4,0,128,6,7,7),
('KS Bharat','Wicket-Keeper','WK-Batsman','India',1,24,520,0,121.3,0,29,6,7,6),
('Prabhsimran Singh','Wicket-Keeper','WK-Batsman','India',1,33,760,0,146.2,0,41,7,8,6),

('Jonny Bairstow','Wicket-Keeper','WK-Batsman','England',2,95,2770,0,141.5,0,78,8,7,8),
('Heinrich Klaasen','Wicket-Keeper','WK-Batsman','South Africa',2,54,1400,0,151.8,0,63,9,8,7),
('Alex Carey','Wicket-Keeper','WK-Batsman','Australia',1,32,420,0,125.4,0,41,6,7,6),
('Sam Billings','Wicket-Keeper','WK-Batsman','England',1,49,1040,0,134.7,0,59,6,7,7),
('Tom Banton','Wicket-Keeper','WK-Batsman','England',1,38,790,0,145.6,0,46,7,7,6),
('Tim Seifert','Wicket-Keeper','WK-Batsman','New Zealand',1,24,480,0,141.2,0,31,6,7,6),
('Matthew Wade','Wicket-Keeper','WK-Batsman','Australia',1,15,320,0,137.5,0,22,6,6,6),

('Rahmanullah Gurbaz','Wicket-Keeper','WK-Batsman','Afghanistan',1,27,720,0,148.9,0,38,8,8,7),
('Phil Salt','Wicket-Keeper','WK-Batsman','England',1,21,650,0,153.4,0,29,8,8,6),
('Kusal Mendis','Wicket-Keeper','WK-Batsman','Sri Lanka',1,19,510,0,138.7,0,26,7,7,6),
('Devon Thomas','Wicket-Keeper','WK-Batsman','West Indies',1,14,290,0,132.6,0,17,6,6,6),
('Niroshan Dickwella','Wicket-Keeper','WK-Batsman','Sri Lanka',1,18,410,0,134.9,0,21,6,6,6),
('Andre Fletcher','Wicket-Keeper','WK-Batsman','West Indies',1,26,560,0,139.2,0,33,6,6,6),
('Ben McDermott','Wicket-Keeper','WK-Batsman','Australia',1,12,280,0,146.8,0,16,7,7,6),
('Josh Inglis','Wicket-Keeper','WK-Batsman','Australia',1,15,390,0,149.5,0,23,7,7,6),
('Donovan Ferreira','Wicket-Keeper','WK-Batsman','South Africa',1,10,240,0,152.6,0,14,7,7,6),
('Anuj Rawat','Wicket-Keeper','WK-Batsman','India',1,23,510,0,131.7,0,34,6,7,6),
('Abhishek Porel','Wicket-Keeper','WK-Batsman','India',1,18,420,0,129.4,0,27,7,7,6),
('Vishnu Vinod','Wicket-Keeper','WK-Batsman','India',1,22,460,0,133.8,0,31,7,7,6),
('Liton Das','Wicket-Keeper','WK-Batsman','Bangladesh',1,65,1450,0,136.9,0,54,7,7,7),
('Ryan Rickelton','Wicket-Keeper','WK-Batsman','South Africa',1,19,510,0,142.6,0,28,7,7,6),
('Dhruv Jurel','Wicket-Keeper','WK-Batsman','India',1,12,320,0,138.6,0,18,8,8,7);

INSERT IGNORE INTO players
(name, category, role, nationality, base_price,
 matches, runs, wickets, strike_rate, economy, catches,
 form_rating, fitness_rating, consistency)
VALUES

-- 🇮🇳 INDIAN PLAYERS (55)
('Yashasvi Jaiswal','Batsman','Opener','India',2,52,1600,0,158.2,0,28,9,9,8),
('Sai Sudharsan','Batsman','Top Order','India',1,35,1100,0,138.4,0,21,8,9,7),
('Prithvi Shaw','Batsman','Opener','India',1,79,1890,0,146.1,0,34,6,7,6),
('Abhinav Manohar','Batsman','Middle Order','India',1,28,540,0,140.7,0,15,7,7,6),
('Sameer Rizvi','Batsman','Middle Order','India',1,12,260,0,151.4,0,9,7,8,6),
('Nehal Wadhera','Batsman','Middle Order','India',1,27,620,0,142.9,0,18,8,8,7),
('Ayush Badoni','Batsman','Middle Order','India',1,42,980,0,137.5,0,22,7,8,7),
('Nitish Rana','Batsman','Middle Order','India',1,107,2650,0,135.2,0,46,7,7,7),
('Sarfaraz Khan','Batsman','Middle Order','India',1,50,1200,0,128.6,0,31,6,7,6),
('Shahrukh Khan','Batsman','Finisher','India',1,48,720,0,145.9,0,26,7,7,6),

('Dhruv Shorey','Batsman','Top Order','India',1,14,310,0,129.7,0,8,6,7,6),
('Rajat Patidar','Batsman','Top Order','India',1,35,920,0,139.6,0,19,8,8,7),
('Manan Vohra','Batsman','Opener','India',1,53,1040,0,128.4,0,23,6,6,6),
('Priyam Garg','Batsman','Middle Order','India',1,34,640,0,132.1,0,16,6,7,6),
('KS Rathore','Batsman','Top Order','India',1,10,220,0,134.0,0,7,6,7,6),

('Harshal Patel','Bowler','Medium','India',2,105,0,139,0,8.6,37,7,7,8),
('T Natarajan','Bowler','Left-arm Fast','India',1,62,0,70,0,8.4,19,8,7,7),
('Umran Malik','Bowler','Fast','India',1,33,0,41,0,9.1,11,7,7,6),
('Chetan Sakariya','Bowler','Left-arm Fast','India',1,34,0,38,0,8.7,14,7,7,6),
('Navdeep Saini','Bowler','Fast','India',1,48,0,45,0,8.9,16,6,7,6),
('Siddarth Kaul','Bowler','Medium','India',1,55,0,57,0,8.5,21,6,6,6),
('Akash Madhwal','Bowler','Fast','India',1,15,0,19,0,8.2,6,8,8,7),
('Yash Dayal','Bowler','Left-arm Fast','India',1,24,0,27,0,8.6,9,7,7,6),
('Mukesh Kumar','Bowler','Medium','India',1,22,0,21,0,8.1,8,7,7,6),
('Prasidh Krishna','Bowler','Fast','India',2,51,0,49,0,8.7,17,7,7,7),

('K Gowtham','All-rounder','Spin All-rounder','India',1,66,540,35,131.2,7.9,29,6,7,6),
('Ripal Patel','All-rounder','Batting All-rounder','India',1,18,290,7,138.4,8.3,11,6,7,6),
('Shivam Mavi','All-rounder','Fast Bowling All-rounder','India',1,32,220,29,124.0,8.8,13,6,7,6),
('Rajvardhan Hangargekar','All-rounder','Fast Bowling All-rounder','India',1,14,180,11,136.2,8.1,7,7,8,6),
('Lalit Yadav','All-rounder','Batting All-rounder','India',1,48,760,18,134.7,8.0,26,7,7,7),
('Kartik Tyagi','All-rounder','Fast Bowling All-rounder','India',1,22,95,18,110.2,8.9,9,6,7,6),
('Abdul Samad','All-rounder','Batting All-rounder','India',1,47,680,6,150.6,9.2,22,7,7,6),

('Narayan Jagadeesan','Wicket-Keeper','WK-Batsman','India',1,25,610,0,134.8,0,21,7,8,7),
('Kumar Kushagra','Wicket-Keeper','WK-Batsman','India',1,16,340,0,136.5,0,13,7,8,6),
('Luvnith Sisodia','Wicket-Keeper','WK-Batsman','India',1,14,280,0,139.2,0,10,6,7,6),
('Sheldon Jackson','Wicket-Keeper','WK-Batsman','India',1,49,820,0,129.6,0,24,6,7,6),
('Upendra Yadav','Wicket-Keeper','WK-Batsman','India',1,19,360,0,132.4,0,12,6,7,6),

-- 🌍 OVERSEAS PLAYERS (25)
('Tim David','Batsman','Finisher','Australia',2,48,1100,0,165.2,0,29,8,8,7),
('Finn Allen','Batsman','Opener','New Zealand',1,34,960,0,157.8,0,18,8,8,7),
('Dawid Malan','Batsman','Top Order','England',1,22,720,0,137.9,0,16,7,7,7),
('Paul Stirling','Batsman','Opener','Ireland',1,19,510,0,145.6,0,12,7,7,6),
('Reeza Hendricks','Batsman','Top Order','South Africa',1,26,640,0,136.1,0,15,7,7,6),

('Alzarri Joseph','Bowler','Fast','West Indies',2,43,0,53,0,8.8,13,8,7,7),
('Obed McCoy','Bowler','Left-arm Fast','West Indies',1,28,0,31,0,8.6,9,7,7,6),
('Gerald Coetzee','Bowler','Fast','South Africa',1,21,0,28,0,9.1,7,8,8,7),
('Mustafizur Rahman','Bowler','Left-arm Fast','Bangladesh',2,57,0,61,0,7.9,18,7,7,7),
('Sean Abbott','Bowler','Fast','Australia',1,18,0,22,0,8.4,6,7,7,6),

('Josh Hazlewood','Bowler','Fast','Australia',2,67, 120, 92, 95.4, 7.6, 26,8, 8, 9),
('David Wiese','All-rounder','Power All-rounder','Namibia',1,29,430,21,146.8,8.2,17,7,7,6),
('Jimmy Neesham','All-rounder','Fast Bowling All-rounder','New Zealand',1,67,950,27,140.9,8.6,41,7,6,7),
('Carlos Brathwaite','All-rounder','Power All-rounder','West Indies',1,44,780,25,151.2,9.0,28,6,6,6),
('Mitchell Bracewell','All-rounder','Spin All-rounder','New Zealand',1,19,260,14,132.5,7.6,11,7,7,6),

('Tom Latham','Wicket-Keeper','WK-Batsman','New Zealand',1,21,540,0,131.7,0,19,7,7,6),
('Kusal Perera','Wicket-Keeper','WK-Batsman','Sri Lanka',1,36,880,0,140.4,0,27,7,6,6),
('Lorcan Tucker','Wicket-Keeper','WK-Batsman','Ireland',1,17,390,0,145.2,0,14,7,7,6),
('Shai Hope','Wicket-Keeper','WK-Batsman','West Indies',1,29,720,0,128.9,0,23,6,7,6);

