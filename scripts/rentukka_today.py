#!/usr/bin/env python3
"""Fetch today's lunch menu from Ravintola Rentukka.

Usage:
    rentukka_today.py            # show both veg and meat options (English)
    rentukka_today.py --veg      # show only the vegetarian option
    rentukka_today.py --meat     # show only the meat option
    rentukka_today.py --fi       # use the Finnish page and return Finnish names
"""

import argparse
import json
import re
import sys
from datetime import date
from urllib.request import Request, urlopen

URLS = {
    "en": "https://www.semma.fi/en/restaurants/other/restaurant-rentukka/",
    "fi": "https://www.semma.fi/ravintolat/muut/ravintola-rentukka/",
}


def fetch_menu_json(lang="en"):
    req = Request(URLS[lang], headers={"User-Agent": "Mozilla/5.0"})
    with urlopen(req, timeout=30) as resp:
        html = resp.read().decode("utf-8", errors="replace")

    match = re.search(r"window\.__INITIAL_MENU__\s*=\s*(\{.*?\});", html, re.DOTALL)
    if not match:
        sys.exit("Could not find menu data on the page.")
    return json.loads(match.group(1))


def get_today_menu(data):
    today = date.today().isoformat()
    week = data.get("weekMenu", {})
    for day in week.get("menus", []):
        if day.get("date", "").startswith(today):
            return day
    day_menu = data.get("dayMenu")
    if day_menu and day_menu.get("date", "").startswith(today):
        return day_menu
    return None


def is_veg(meal):
    return "Veg" in meal.get("diets", [])


def is_meat(meal):
    return not is_veg(meal)


def main():
    parser = argparse.ArgumentParser(
        description="Show Rentukka's lunch menu for today."
    )
    parser.add_argument(
        "--fi",
        action="store_true",
        help="Use the Finnish page and return Finnish names",
    )
    group = parser.add_mutually_exclusive_group()
    group.add_argument(
        "--veg", action="store_true", help="Show only the vegetarian option"
    )
    group.add_argument("--meat", action="store_true", help="Show only the meat option")
    args = parser.parse_args()

    lang = "fi" if args.fi else "en"
    data = fetch_menu_json(lang)
    today = get_today_menu(data)
    if not today:
        sys.exit("No menu found for today.")

    packages = today.get("menuPackages", [])
    seen = set()
    sections = []
    for pkg in packages:
        name = pkg.get("name", "")
        if not name:
            continue
        meals = pkg.get("meals", [])
        meal_names = tuple(sorted(m["name"] for m in meals))
        if not meal_names or meal_names in seen:
            continue
        seen.add(meal_names)
        veg_meals = [m["name"] for m in meals if is_veg(m)]
        meat_meals = [m["name"] for m in meals if is_meat(m)]
        sections.append((name, veg_meals, meat_meals))

    show_veg = not args.meat
    show_meat = not args.veg

    lines = []
    for name, veg_meals, meat_meals in sections:
        if show_veg and veg_meals:
            lines.append(f"{name} (veg):")
            for m in veg_meals:
                lines.append(f"  - {m}")
        if show_meat and meat_meals:
            lines.append(f"{name} (meat):")
            for m in meat_meals:
                lines.append(f"  - {m}")

    if not lines:
        print("No meals available today.")
    else:
        print("\n".join(lines))


if __name__ == "__main__":
    main()
