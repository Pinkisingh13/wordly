import 'dart:math';

class GenerateRandomTip {
  static final List<String> quickTips = [
    "🔡 Start Smart: Try words with A, E, O, T, R, N, S first!",
    "🧩 Mix It Up: Use a blend of vowels and consonants for better guesses",

    "🔍 Spot the Patterns: Look for pairs like TH, CH, or common endings like -ING.",

    "🚫 Rule Them Out: Eliminate letters that aren’t in the word — fewer choices, better chances!",

    "📍 Yellow Means Move It: Found a yellow letter? Try placing it in a different spot.",

    "🎯 Start with ‘STARE’ or ‘CRANE’: These are strong starter words!",

    "🧠 Think Like a Word Wizard: Words often have vowels in the middle — test that theory",

    "❌ Don’t Repeat Misses: Avoid reusing letters that already turned gray.",

    "🎨 Color Clues Matter: Green = Correct spot, Yellow = Wrong spot, Gray = Not in the word",

    "💬 Guess Smartly: After finding 2-3 letters, try forming words around them.",
  ];

  static final String quickTip = quickTips[Random().nextInt(quickTips.length)];
}
