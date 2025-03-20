import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Map<String, List<String>> wordModel = {
  "finance": [
    "money", "loans", "banks", "coins", "stock", "funds", "trade", "bills", "taxes", "spend",
    "asset", "audit", "bonds", "check", "credit", "debit", "deals", "dollar", "equity", "euros",
    "fines", "float", "gross", "grant", "inbox", "input", "lease", "limit", "lumps", "merge",
    "offer", "order", "penny", "price", "prize", "quote", "ratio", "rates", "rents", "reval",
    "sales", "share", "stock", "spike", "stake", "tarif", "token", "trade", "trust", "value",
    "yield", "zeros", "worth", "wealth", "money", "notes", "inbox", "budget", "spend", "worth",
    "banks", "coins", "penny", "bonds", "audit", "offer", "funds", "price", "stake", "token",
    "dolar", "input", "value", "rents", "gross", "quote", "merge", "rates", "lease", "worth",
    "taxes", "order", "grant", "spike", "zeros", "limit", "trust", "yield", "reval", "credit"
  ],
  "entertainment": [
    "songs", "dance", "films", "shows", "actor", "drama", "music", "comedy", "theft", "party",
    "award", "stage", "event", "scene", "group", "night", "voice", "stand", "trend", "prank",
    "piano", "light", "sound", "theme", "blend", "laugh", "video", "theft", "skits", "crown",
    "chant", "story", "shout", "clown", "giggs", "plays", "paint", "color", "flick", "swipe",
    "joker", "gamer", "photo", "drama", "movie", "stunt", "magic", "trick", "lobby", "bravo",
    "cards", "shoes", "claps", "cheer", "dance", "gloss", "tweet", "smile", "emoji", "award",
    "event", "party", "prize", "queen", "vibes", "reels", "tunes", "glow", "fancy", "spice",
    "trump", "twist", "quest", "blend", "flame", "blush", "craze", "video", "voice", "theme"
  ],
  "bollywood": [
    "khan", "stars", "scene", "drama", "songs", "dance", "movie", "actor", "award", "block",
    "track", "crown", "swipe", "shadi", "spice", "group", "event", "stage", "photo", "story",
    "plays", "joker", "color", "trick", "shoes", "lobby", "cards", "vibes", "cheer", "piano",
    "laugh", "theft", "trend", "claps", "shout", "drama", "magic", "trump", "quest", "blush",
    "spice", "blend", "flick", "queen", "tweet", "reels", "clown", "video", "movie", "theme",
    "award", "bravo", "party", "stand", "prize", "skits", "light", "joker", "gamer", "photo",
    "voice", "craze", "blend", "tunes", "smile", "emoji", "cards", "scene", "glow", "swipe",
    "giggs", "chant", "story", "magic", "theft", "joker", "track", "blend", "gloss", "flame"
  ],
  "technology": [
    "bytes", "cloud", "mouse", "apple", "debug", "logic", "codes", "laptop", "error", "robot",
    "admin", "block", "cache", "click", "crash", "crypt", "dumps", "email", "fetch", "fibre",
    "frame", "input", "login", "macro", "media", "modal", "noise", "notch", "nudge", "panel",
    "patch", "pixel", "proxy", "query", "risky", "scope", "shell", "slash", "spark", "stack",
    "state", "stubs", "swipe", "table", "theme", "token", "topic", "track", "tweet", "unity",
    "vibes", "video", "virus", "vlogs", "voter", "watch", "wires", "world", "yahoo", "youth",
    "zoomy", "zones", "badge", "blink", "block", "boots", "cable", "cache", "check", "chips",
    "crash", "cloud", "click", "codes", "error", "fetch", "fibre", "macro", "media", "nudge"
  ],
  "socialmedia": [
    "share", "tweet", "story", "video", "reels", "vlogs", "vibes", "posts", "viral", "trend",
    "likes", "views", "party", "emoji", "click", "swipe", "links", "boost", "block", "faves",
    "photo", "spams", "prank", "panel", "media", "group", "guest", "frame", "stand", "blend",
    "music", "comic", "clown", "promo", "boost", "skits", "laugh", "light", "chant", "tunes",
    "bravo", "joker", "theme", "event", "cards", "queue", "event", "piano", "audio", "boost",
    "email", "group", "faves", "trend", "wires", "voter", "world", "watch", "smile", "prize",
    "gamer", "blink", "stage", "virus", "modal", "scope", "query", "risky", "slash", "track"
  ],
  "sports": [
    "goals", "score", "pitch", "racer", "stick", "medal", "track", "match", "round", "chase",
    "field", "teams", "catch", "spike", "serve", "swipe", "jumps", "swing", "guard", "punch",
    "rally", "baton", "block", "shoot", "tossy", "chess", "tenis", "wrest", "cycle", "pedal",
    "dodge", "boxer", "arena", "glove", "coach", "draft", "eject", "javel", "leaps", "pacer",
    "pucks", "refly", "rugby", "snipe", "squad", "tiger", "umpir", "vault", "whack", "yacht"
  ],
  "plants": [
    "basil", "birch", "cactus", "cedar", "daisy", "elmus", "firry", "flora", "grass", "herbs",
    "ivyss", "jelly", "kudzu", "lilac", "maple", "necta", "olive", "pansy", "petal", "plume",
    "poppy", "roots", "roses", "spike", "stems", "thorn", "tulip", "venus", "vines", "wheat",
    "zinni", "acorn", "apple", "bloom", "bloss", "bramb", "bulbs", "bunch", "bushy", "crown",
    "dahli", "darts", "dotes", "ferns", "flora", "fruit", "glaze", "grape", "hedge", "leafy",
    "lemon", "melon", "mossy", "mushs", "nutty", "onion", "orchd", "peach", "pears", "plums",
    "radis", "rosin", "seeds", "shrub", "spore", "straw", "trunk", "twigs", "weeds", "yewss",
    "yucca", "zephy"
  ],
  "places": [
    "beach", "broad", "canal", "caves", "desks", "docks", "fjord", "foyer", "glass", "grove",
    "hills", "homes", "hotel", "house", "islet", "kiosk", "lakes", "lanes", "lofts", "motel",
    "parks", "paths", "plaza", "pools", "pubss", "ranch", "resrt", "ridge", "river", "roads",
    "salon", "shore", "shops", "shrub", "slums", "spurs", "stair", "stall", "stoop", "swamp",
    "taver", "tents", "tubes", "tunds", "villa", "walls", "wharf", "zones", "abbey", "aisle",
    "baker", "banks", "barns", "basin", "baths", "cafes", "chaps", "cliff", "creek", "damss",
    "depot", "dunes", "entry", "farms", "ferry", "forts", "gully", "haven", "inlet", "jetty"
  ],
  "food": [
    "apple", "bacon", "bagel", "beans", "berry", "bread", "bunch", "cakes", "candy", "carbs",
    "chefs", "chili", "chips", "cider", "clams", "cocoa", "creme", "crisp", "curry", "dates",
    "diner", "donut", "drips", "drink", "eggsr", "flour", "fries", "fruit", "gravy", "grill",
    "guava", "honey", "jelly", "juice", "kebab", "liver", "loafs", "lumps", "meats", "milks",
    "mocha", "noods", "olive", "onion", "pasta", "peach", "pears", "pesto", "pizza", "plums",
    "poppy", "ramen", "ranch", "relish", "risks", "salad", "salsa", "sauce", "saute", "seeds",
    "shank", "shrug", "spice", "spoon", "squab", "steak", "sushi", "sweet", "tacos", "toast",
    "treat", "tripe", "tuber", "turns", "wafer", "wheat", "whisk", "wings", "yeast", "yogur"
  ]
};


enum Category {finance, plants, sports, food, places, socialmedia, technology, bollywood, entertainment}

final Map<Category, CategoryStyle> categoryStyles = {
  Category.finance: CategoryStyle(
    color: Color(0xFFFFF9E6),
    image: SvgPicture.asset("assets/category/finance/finance.svg"),
    name: "Finance",
  ),
  Category.plants: CategoryStyle(
    color: Color(0xFFF2F9ED),
    image: SvgPicture.asset("assets/category/plants/plants.svg"),
    name: "Plants",
  ),
  Category.sports: CategoryStyle(
    color: Color(0xFFFFF0F0),
    image: SvgPicture.asset("assets/category/sports/sports.svg"),
    name: "Sports",
  ),

  Category.food: CategoryStyle(
    color: Color(0xFFFFF0F6),
    image: SvgPicture.asset("assets/category/food/food.svg"),
    name: "Food",
  ),
  Category.places: CategoryStyle(
    color: Color(0xFFF0F7FF),
    image: SvgPicture.asset("assets/category/places/places.svg"),
    name: "Places",
  ),
  Category.socialmedia: CategoryStyle(
    color: Color(0xFFF6F0FF),
    image: SvgPicture.asset("assets/category/socialmedia/socialmedia.svg"),
    name: "Social Media",
  ),
  Category.technology: CategoryStyle(
    color: Color(0xFFF0FCFF),
    image: SvgPicture.asset("assets/category/technology/technology.svg"),
    name: "Technology",
  ),
  Category.bollywood: CategoryStyle(
    color: Color(0xFFFFF1F0),
    image: SvgPicture.asset("assets/category/bollywood/bollywood.svg"),
    name: "Bollywood",
  ),
  Category.entertainment: CategoryStyle(
    color: Color(0xFFF5F0FF),
    image: SvgPicture.asset("assets/category/entertainment/entertainment.svg"),
    name: "Entertainment",
  ),
};

class CategoryStyle {
  final Color color;
  final Widget image;
  final String name;

  CategoryStyle({required this.color, required this.image, required this.name});
}
