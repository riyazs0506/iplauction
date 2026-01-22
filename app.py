from flask import Flask, render_template, request, redirect
import mysql.connector
from config import MYSQL_CONFIG

app = Flask(__name__)

# ================= DATABASE CONNECTION =================
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
               * role_weight[p["category"]])

# ================= HOME =================
@app.route("/")
def index():
    return render_template("index.html")

# ================= AUCTION =================
@app.route("/auction")
def auction():
    category = request.args.get("category")
    pid = request.args.get("player")

    players = []
    current = None

    if category:
        cursor.execute("""
            SELECT *,
            CASE
                WHEN sold_price IS NULL THEN 'Pending'
                ELSE 'Sold'
            END AS status
            FROM players
            WHERE category = %s
        """, (category,))
        players = cursor.fetchall()

        if pid:
            cursor.execute("SELECT * FROM players WHERE id=%s", (pid,))
            current = cursor.fetchone()
        else:
            current = next(
                (p for p in players if p["sold_price"] is None),
                None
            )

    cursor.execute("SELECT * FROM teams")
    teams = cursor.fetchall()

    return render_template(
        "auction.html",
        players=players,
        current=current,
        teams=teams,
        category=category
    )

# ================= SELL PLAYER =================
@app.route("/sell", methods=["POST"])
def sell():
    pid = int(request.form["player_id"])
    tid = int(request.form["team_id"])
    price = int(request.form["price"])
    category = request.form["category"]

    cursor.execute("SELECT * FROM players WHERE id=%s", (pid,))
    player = cursor.fetchone()

    points = calculate_strategy(player, price)

    cursor.execute("""
        UPDATE players
        SET sold_price=%s,
            team_id=%s,
            strategy_points=%s
        WHERE id=%s
    """, (price, tid, points, pid))

    cursor.execute("""
        UPDATE teams
        SET spent = spent + %s,
            total_points = total_points + %s
        WHERE id = %s
    """, (price, points, tid))

    db.commit()
    return redirect(f"/auction?category={category}")

# ================= RESULT =================
@app.route("/result")
def result():
    cursor.execute("SELECT * FROM teams ORDER BY total_points DESC")
    teams = cursor.fetchall()

    cursor.execute("""
        SELECT
            t.name AS team,
            p.name AS player,
            p.category,
            p.strategy_points
        FROM players p
        JOIN teams t ON p.team_id = t.id
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
def strategy():
    cursor.execute("""
        SELECT
            p.name,
            p.category,
            p.strategy_points,
            t.name AS team
        FROM players p
        JOIN teams t ON p.team_id = t.id
        ORDER BY p.strategy_points DESC
    """)
    players = cursor.fetchall()

    return render_template("strategy.html", players=players)

# ================= TEAM BALANCE =================
@app.route("/team-balance")
def team_balance():
    cursor.execute("""
        SELECT
            t.id,
            t.name,
            t.purse,
            t.spent,
            COUNT(p.id) AS player_count
        FROM teams t
        LEFT JOIN players p ON p.team_id = t.id
        GROUP BY t.id
    """)
    teams = cursor.fetchall()

    cursor.execute("""
        SELECT
            p.name AS player,
            p.category,
            p.sold_price AS price,
            t.name AS team
        FROM players p
        JOIN teams t ON p.team_id = t.id
        WHERE p.sold_price IS NOT NULL
        ORDER BY t.name
    """)
    players = cursor.fetchall()

    return render_template(
        "team_balance.html",
        teams=teams,
        players=players
    )

# ================= RUN =================
if __name__ == "__main__":
    app.run(debug=True)
