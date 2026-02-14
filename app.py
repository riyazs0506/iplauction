import eventlet
eventlet.monkey_patch()

import os

import mysql.connector
from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_socketio import SocketIO
from functools import wraps
from datetime import datetime



app = Flask(__name__)
app.secret_key = "ipl_secure_login_2026"


socketio = SocketIO(app, cors_allowed_origins=os.environ.get("SOCKET_CORS"))
# ================= GLOBAL CURRENT PLAYER =================
current_player_id = None


# ================= DATABASE CONNECTION =================
# ================= DATABASE CONFIG =================
MYSQL_CONFIG = {
    "host": os.environ.get("DB_HOST"),
    "user": os.environ.get("DB_USER"),
    "password": os.environ.get("DB_PASSWORD"),
    "database": os.environ.get("DB_NAME"),
    "port": int(os.environ.get("DB_PORT", 3306)),
}


db = mysql.connector.connect(**MYSQL_CONFIG)
cursor = db.cursor(dictionary=True)

# ================= STRATEGY POINT CALCULATION =================
def calculate_strategy(p, price):
    base_score = (
        (p["matches"] * 2) +
        (p["form_rating"] * 5) +
        (p["consistency"] * 4)
    )

    value_for_money = 20 if price <= p["base_price"] else 10
    indian_bonus = 15 if p["nationality"] == "India" else 5

    role_weight = {
        "Batsman": 1.2,
        "Bowler": 1.3,
        "All-rounder": 1.5,
        "Wicket-Keeper": 1.1
    }

    return int((base_score + value_for_money + indian_bonus)
               * role_weight.get(p["category"], 1))

from datetime import datetime

def make_json_safe(data):
    if not data:
        return {}

    safe_data = {}

    for key, value in data.items():
        if isinstance(value, datetime):
            safe_data[key] = value.strftime("%Y-%m-%d %H:%M:%S")
        else:
            safe_data[key] = value

    return safe_data

# ================= ADMIN LOGIN REQUIRED =================
def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if "admin" not in session:
            return redirect(url_for("admin_login"))
        return f(*args, **kwargs)
    return decorated_function


# ================= TEAM LOGIN REQUIRED =================
def team_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if "team_id" not in session:
            return redirect(url_for("team_login"))
        return f(*args, **kwargs)
    return decorated_function

from functools import wraps

def login_required(role=None):
    def wrapper(f):
        @wraps(f)
        def decorated_function(*args, **kwargs):
            if "role" not in session:
                return redirect(url_for("index"))

            if role and session.get("role") != role:
                return redirect(url_for("index"))

            return f(*args, **kwargs)
        return decorated_function
    return wrapper


# ================= HOME =================
@app.route("/")
def index():
    return render_template("index.html")


@app.route("/admin-login", methods=["GET", "POST"])
def admin_login():

    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]

        if username == "admin" and password == "admin12345678":
            session.clear()
            session["admin"] = True
            return redirect(url_for("auction"))
        else:
            flash("Invalid Admin Credentials")

    return render_template("admin_login.html")


@app.route("/team-login", methods=["GET", "POST"])
def team_login():

    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]

        cursor.execute("""
            SELECT * FROM teams
            WHERE username=%s AND password=%s
        """, (username, password))

        team = cursor.fetchone()

        if team:
            session.clear()
            session["team_id"] = team["id"]
            session["team_name"] = team["name"]
            return redirect(url_for("team_dashboard"))
        else:
            flash("Invalid Team Login")

    return render_template("team_login.html")

@app.route("/logout")
def logout():

    role = session.get("role")

    session.clear()

    if role == "team":
        return redirect(url_for("team_login"))

    elif role == "admin":
        return redirect(url_for("admin_login"))

    else:
        return redirect(url_for("index"))



@app.route("/team-dashboard")
@team_required  # if you are using login protection
def team_dashboard():

    team_id = session.get("team_id")

    # Get team info
    cursor.execute("SELECT * FROM teams WHERE id=%s", (team_id,))
    team = cursor.fetchone()

    # Get bought players
    cursor.execute("""
        SELECT name, category, nationality, sold_price
        FROM players
        WHERE team_id=%s
    """, (team_id,))
    players = cursor.fetchall()

    # ================= CATEGORY COUNT =================
    cursor.execute("""
        SELECT category, COUNT(*) as c
        FROM players
        WHERE team_id=%s
        GROUP BY category
    """, (team_id,))
    category_data = cursor.fetchall()

    category_map = {row["category"]: row["c"] for row in category_data}

    # Overseas count
    cursor.execute("""
        SELECT COUNT(*) as c
        FROM players
        WHERE team_id=%s AND nationality!='India'
    """, (team_id,))
    overseas_count = cursor.fetchone()["c"]

    # ================= REMAINING LIMITS =================
    limits = {
        "batsman": 4 - category_map.get("Batsman", 0),
        "bowler": 3 - category_map.get("Bowler", 0),
        "allrounder": 3 - category_map.get("All-rounder", 0),
        "overseas": 4 - overseas_count
    }

    # Prevent negative numbers
    for key in limits:
        if limits[key] < 0:
            limits[key] = 0

    # ================= TEAM COLOR =================
    # ================= TEAM IPL OFFICIAL COLORS =================
    theme_map = {
        "CSK": "#FFD700",                # Yellow
        "MI": "#004BA0",                 # Blue
        "RCB": "#EC1C24",                # Red
        "KKR": "#3A225D",                # Purple
        "SRH": "#FF822A",                # Orange
        "DC": "#17449B",                 # Blue
        "RR": "#FF69B4",                 # Pink
        "LSG": "#00AEEF",                # Sky Blue
        "PBKS": "#ED1B24",               # Red
        "GT": "#0C2340"                  # Navy
    }

    theme_color = theme_map.get(team["name"], "#ffffff")


    return render_template(
        "team_dashboard.html",
        team=team,
        players=players,
        limits=limits,      # ✅ THIS WAS MISSING
        theme_color=theme_color
    )


@app.route("/broadcast")
def broadcast():
    return render_template("broadcast.html")



# ================= AUCTION =================
@app.route("/auction")
@admin_required
def auction():

    global current_player_id

    category = request.args.get("category")
    reauction = request.args.get("reauction")

    if not category:
        return render_template("auction.html", players=[], category=None)

    # Fetch players by category
    if reauction:
        cursor.execute("""
            SELECT * FROM players
            WHERE category=%s AND status='UNSOLD'
            ORDER BY id ASC
        """, (category,))
    else:
        cursor.execute("""
            SELECT * FROM players
            WHERE category=%s AND status='AVAILABLE'
            ORDER BY id ASC
        """, (category,))

    players = cursor.fetchall()
    current = players[0] if players else None

    # 🔥 SEND FULL PLAYER JSON TO BROADCAST
    if current:
        current_player_id = current["id"]
        safe_player = make_json_safe(current)
        socketio.emit("player_update", safe_player)

    else:
        current_player_id = None
        socketio.emit("player_update", {})

    # Unsold count
    cursor.execute("""
        SELECT COUNT(*) AS c FROM players
        WHERE category=%s AND status='UNSOLD'
    """, (category,))
    unsold_count = cursor.fetchone()["c"]

    # Teams
    cursor.execute("SELECT * FROM teams")
    teams = cursor.fetchall()

    # Team validation logic
    limits = {
        "Batsman": 4,
        "Bowler": 3,
        "All-rounder": 3,
        "Wicket-Keeper": 1
    }

    for t in teams:
        tid = t["id"]

        cursor.execute("SELECT COUNT(*) c FROM players WHERE team_id=%s", (tid,))
        total = cursor.fetchone()["c"]

        cursor.execute("""
            SELECT category, COUNT(*) c
            FROM players
            WHERE team_id=%s
            GROUP BY category
        """, (tid,))
        cat_map = {r["category"]: r["c"] for r in cursor.fetchall()}

        cursor.execute("""
            SELECT COUNT(*) c FROM players
            WHERE team_id=%s AND nationality!='India'
        """, (tid,))
        overseas = cursor.fetchone()["c"]

        disabled = False
        reason = ""

        if total >= 11:
            disabled = True
            reason = "Maximum 11 players reached"

        elif overseas >= 4 and current and current["nationality"] != "India":
            disabled = True
            reason = "Overseas player limit (4) reached"

        elif current and cat_map.get(current["category"], 0) >= limits.get(current["category"], 0):
            disabled = True
            reason = f"{current['category']} limit reached"

        elif t["spent"] >= t["purse"]:
            disabled = True
            reason = "Purse limit exceeded"

        t["disabled"] = disabled
        t["reason"] = reason

    return render_template(
        "auction.html",
        players=players,
        current=current,
        teams=teams,
        category=category,
        unsold_count=unsold_count
    )


# ================= TEAM CONSTRAINT CHECK =================
def check_team_constraints(team_id, player, price):
    errors = []

    limits = {
        "Batsman": 4,
        "Bowler": 3,
        "All-rounder": 3,
        "Wicket-Keeper": 1
    }

    cursor.execute("SELECT COUNT(*) c FROM players WHERE team_id=%s", (team_id,))
    total = cursor.fetchone()["c"]
    if total >= 11:
        errors.append("Maximum 11 players allowed")

    cursor.execute("""
        SELECT category, COUNT(*) c
        FROM players
        WHERE team_id=%s
        GROUP BY category
    """, (team_id,))
    cat_map = {r["category"]: r["c"] for r in cursor.fetchall()}

    if cat_map.get(player["category"], 0) >= limits[player["category"]]:
        errors.append(f"{player['category']} limit reached")

    cursor.execute("""
        SELECT COUNT(*) c FROM players
        WHERE team_id=%s AND nationality!='India'
    """, (team_id,))
    overseas = cursor.fetchone()["c"]

    if player["nationality"] != "India" and overseas >= 4:
        errors.append("Overseas limit reached")

    cursor.execute("SELECT spent FROM teams WHERE id=%s", (team_id,))
    spent = cursor.fetchone()["spent"]

    if spent + price > 120:
        errors.append("Purse limit exceeded")

    return errors


# ================= SELL PLAYER =================
@app.route("/sell", methods=["POST"])
def sell():

    pid = int(request.form["player_id"])
    tid = int(request.form["team_id"])
    price = int(request.form["price"])
    category = request.form["category"]

    cursor.execute("SELECT * FROM players WHERE id=%s", (pid,))
    player = cursor.fetchone()

    if not player:
        return redirect(f"/auction?category={category}")

    errors = check_team_constraints(tid, player, price)
    if errors:
        return redirect(f"/auction?category={category}")

    points = calculate_strategy(player, price)

    # Update player
    cursor.execute("""
        UPDATE players
        SET sold_price=%s,
            team_id=%s,
            strategy_points=%s,
            status='SOLD'
        WHERE id=%s
    """, (price, tid, points, pid))

    # Update team
    cursor.execute("""
        UPDATE teams
        SET spent=spent+%s,
            total_points=total_points+%s
        WHERE id=%s
    """, (price, points, tid))

    db.commit()

    # 🔥 SEND NEXT PLAYER TO BROADCAST
    send_next_player(category)

    return redirect(f"/auction?category={category}")


# ================= UNSOLD PLAYER =================
@app.route("/unsold", methods=["POST"])
def unsold_player():

    pid = request.form.get("player_id")
    category = request.form.get("category")

    cursor.execute("""
        UPDATE players
        SET status='UNSOLD',
            sold_price=NULL,
            team_id=NULL
        WHERE id=%s
    """, (pid,))

    db.commit()

    # 🔥 SEND NEXT PLAYER
    send_next_player(category)

    return redirect(url_for("auction", category=category))

# ================= SEND NEXT PLAYER =================
def send_next_player(category):

    cursor.execute("""
        SELECT * FROM players
        WHERE category=%s AND status='AVAILABLE'
        ORDER BY id ASC
        LIMIT 1
    """, (category,))

    next_player = cursor.fetchone()

    if next_player:
        socketio.emit("player_update", next_player)
    else:
        socketio.emit("player_update", {})

@app.route("/update-sold-details", methods=["POST"])
def update_sold_details():

    pid = int(request.form["player_id"])
    new_price = int(request.form["sold_price"])
    new_team_id = int(request.form["team_id"])

    # 🔹 Get existing player data
    cursor.execute("SELECT * FROM players WHERE id=%s", (pid,))
    player = cursor.fetchone()

    if not player:
        return redirect(url_for("all_players"))

    old_team_id = player["team_id"]
    old_price = player["sold_price"] or 0
    old_points = player["strategy_points"] or 0

    # ================= REMOVE OLD TEAM EFFECT =================
    if old_team_id:
        cursor.execute("""
            UPDATE teams
            SET spent = spent - %s,
                total_points = total_points - %s
            WHERE id = %s
        """, (old_price, old_points, old_team_id))

    # ================= CALCULATE NEW STRATEGY =================
    new_points = calculate_strategy(player, new_price)

    # ================= UPDATE PLAYER =================
    cursor.execute("""
        UPDATE players
        SET sold_price=%s,
            team_id=%s,
            strategy_points=%s,
            status='SOLD'
        WHERE id=%s
    """, (new_price, new_team_id, new_points, pid))

    # ================= ADD NEW TEAM EFFECT =================
    cursor.execute("""
        UPDATE teams
        SET spent = spent + %s,
            total_points = total_points + %s
        WHERE id = %s
    """, (new_price, new_points, new_team_id))

    db.commit()

    # 🔥 SEND UPDATED PLAYER TO BROADCAST
    cursor.execute("SELECT * FROM players WHERE id=%s", (pid,))
    updated_player = cursor.fetchone()

    socketio.emit("player_update", updated_player)

    return redirect(url_for("all_players"))

@app.route("/update-player", methods=["POST"])
def update_player():

    pid = request.form["player_id"]
    name = request.form["name"]
    category = request.form["category"]
    base_price = request.form["base_price"]

    cursor.execute("""
        UPDATE players
        SET name=%s,
            category=%s,
            base_price=%s
        WHERE id=%s
    """, (name, category, base_price, pid))

    db.commit()

    # 🔥 Send updated player to broadcast
    cursor.execute("SELECT * FROM players WHERE id=%s", (pid,))
    updated_player = cursor.fetchone()

    socketio.emit("player_update", updated_player)

    return redirect(url_for("all_players"))

# ================= ALL PLAYERS PAGE =================
@app.route("/players")
@admin_required
def all_players():

    cursor.execute("""
        SELECT 
            p.id,
            p.name,
            p.category,
            p.nationality,
            p.base_price,
            p.sold_price,
            p.status,
            t.name AS team
        FROM players p
        LEFT JOIN teams t ON p.team_id = t.id
        ORDER BY p.id
    """)
    players = cursor.fetchall()

    cursor.execute("SELECT * FROM teams")
    teams = cursor.fetchall()

    return render_template("players.html",
                           players=players,
                           teams=teams)

# ================= RESULT =================
@app.route("/result")
@admin_required
def result():

    cursor.execute("""
        SELECT 
            t.id,
            t.name,
            t.purse,
            t.spent,
            (t.purse - t.spent) AS remaining,
            t.total_points,
            COUNT(p.id) AS total_players
        FROM teams t
        LEFT JOIN players p 
            ON p.team_id = t.id AND p.status='SOLD'
        GROUP BY t.id
        ORDER BY t.total_points DESC
    """)
    teams = cursor.fetchall()

    cursor.execute("""
        SELECT 
            t.name AS team,
            p.name AS player,
            p.category,
            p.strategy_points,
            p.sold_price
        FROM players p
        JOIN teams t ON p.team_id = t.id
        WHERE p.status='SOLD'
        ORDER BY p.strategy_points DESC
    """)
    players = cursor.fetchall()

    winner = teams[0] if teams else None

    return render_template(
        "result.html",
        teams=teams,
        players=players,
        winner=winner
    )

# ================= STRATEGY =================
@app.route("/strategy")
@admin_required
def strategy():

    cursor.execute("""
        SELECT 
            p.name,
            p.category,
            p.strategy_points,
            p.sold_price,
            t.name AS team
        FROM players p
        JOIN teams t ON p.team_id = t.id
        WHERE p.status='SOLD'
        ORDER BY p.strategy_points DESC
    """)
    players = cursor.fetchall()

    return render_template("strategy.html", players=players)

# ================= TEAM BALANCE =================
@app.route("/team-balance")
@admin_required
def team_balance():

    cursor.execute("""
        SELECT 
            t.id,
            t.name,
            t.purse,
            t.spent,
            (t.purse - t.spent) AS remaining,

            COUNT(CASE WHEN p.status='SOLD' THEN 1 END) AS total_players,

            SUM(CASE WHEN p.category='Batsman' AND p.status='SOLD' THEN 1 ELSE 0 END) AS batsman_count,
            SUM(CASE WHEN p.category='Bowler' AND p.status='SOLD' THEN 1 ELSE 0 END) AS bowler_count,
            SUM(CASE WHEN p.category='All-rounder' AND p.status='SOLD' THEN 1 ELSE 0 END) AS allrounder_count,
            SUM(CASE WHEN p.category='Wicket-Keeper' AND p.status='SOLD' THEN 1 ELSE 0 END) AS wk_count,

            SUM(CASE WHEN p.nationality!='India' AND p.status='SOLD' THEN 1 ELSE 0 END) AS overseas_count

        FROM teams t
        LEFT JOIN players p ON p.team_id = t.id
        GROUP BY t.id
        ORDER BY t.name
    """)
    teams = cursor.fetchall()

    return render_template("team_balance.html", teams=teams)


# ================= SOCKET CONNECT =================
@socketio.on("connect")
def handle_connect():
    print("Client connected")

# ================= RUN =================
if __name__ == "__main__":
    socketio.run(app, debug=True)
