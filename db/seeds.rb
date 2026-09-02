puts "Deleting old seeds..."
Citizen.destroy_all
Note.destroy_all
Category.destroy_all
User.destroy_all

puts "Creating a new user..."
user = User.create!(
  name: "user",
  email: "email@email.com",
  password: "111111",
  map_size: "small"
)

user.tile_map = [
  ["grass", "grass", "grass", "grass", "grass", "grass"],
  ["grass", "base", "grass", "grass", "grass", "grass"],
  ["grass", "grass", "grass", "grass", "grass", "grass"],
  ["grass", "grass", "grass", "base", "grass", "grass"],
  ["grass", "base", "grass", "grass", "grass", "grass"],
  ["grass", "grass", "grass", "grass", "grass", "grass"],

]
user.save!

# Seed the Cozy Room
puts "Seeding Category 1: Cozy Study..."
cozy_study = user.categories.create!(
  name: "Cozy Study",
  sprite_image: "blue-house.png",                   # Grid Map Sprite
  room_image: "rooms/cozy_study.jpeg",              # Static Modal Background
  room_video: "rooms/Cat_waking_up_on_couch.mp4",   # Intro Video Asset
  building_animation_type: "occasional",
  x: 1,
  y: 1
)

# 1. Notice Board / Corkboard Hotspot
cozy_study.notes.create!(
  title: "Community Board Announcement",
  content: "Don't forget the team demo presentation at 5 PM!",
  hotspot_type: "notice_board"
)

# 2. Bookcase Hotspot
cozy_study.notes.create!(
  title: "Recommended Reading List",
  content: "1. Neuromancer\n2. Snow Crash\n3. Winnie the Pooh",
  hotspot_type: "bookcase"
)

# 3. Laptop Hotspot
cozy_study.notes.create!(
  title: "Terminal Workspace Logs",
  content: "Worked on room modals and stuff. Also drank coffee...",
  hotspot_type: "laptop"
)

# 4. Posters Hotspot
cozy_study.notes.create!(
  title: "Inspirational Quote",
  content: "'Coding is really hard to be hardly average at' -Anonymous Bootcamp Student",
  hotspot_type: "posters"
)

# Seed the Gothic Library
gothic_library = user.categories.create!(
  name: "Gothic Library",
  sprite_image: "red-roof.png",
  room_image: "rooms/gothic_library.jpeg",
  room_video: "rooms/Gargoyle_cat_licking_paw.mp4",
  building_animation_type: "occasional",
  x: 3,
  y: 3
)

# 1. Notice Board / Parchment Scroll Hotspot
gothic_library.notes.create!(
  title: "Decree from the High Council",
  content: "Hark! Ye shall present thy sacred code to the High Instructors at the 17th hour. Failure to compile shall result in eternal damnation via polite Slack message.",
  hotspot_type: "notice_board"
)

# 2. Grimoire Shelf Hotspot
gothic_library.notes.create!(
  title: "Forbidden Tomes of the Ancient Coders",
  content: "1. The Necronomicon of Ruby Metaprogramming\n2. Curses & Recursion in C++\n3. Winnie the Pooh: A Study in Existential Horror",
  hotspot_type: "bookcase"
)

# 3. Dragon Book / Alchemist Desk Hotspot
gothic_library.notes.create!(
  title: "Alchemical Lab Notes: Experiment #404",
  content: "Attempted to transmute asset pipeline errors into dark magic. Successfully created a split-second black flash and severe exhaustion. Consumed three cauldrons of black coffee.",
  hotspot_type: "laptop"
)

# 4. Star Chart / Constellation Wall Hotspot
gothic_library.notes.create!(
  title: "Astral Prophecy of the Bootcamp Initiate",
  content: "'Beware the red console error in the dead of night, for it gazes also into thee.' — Anonymous Novice, Circa 2026",
  hotspot_type: "posters"
)

# Seed the Hackercat Room
hackercat_room = user.categories.create!(
  name: "Hackercat Room",
  sprite_image: "blue-house.png",
  room_image: "rooms/hackercat_room.jpeg",
  room_video: "rooms/Cat_paws_at_laptop_keyboard.mp4",
  building_animation_type: "occasional",
  x: 1,
  y: 4
)

# 1. Futuristic Notice Board
hackercat_room.notes.create!(
  title: "PRIORITY_DECREE // Mainframe_Notice.log",
  content: "CRITICAL: All units must push working code to production before the Demo. Any unhandled rejections will result in immediate demotion to sandbox environment.",
  hotspot_type: "notice_board"
)

# 2. Server Stack / Neural Core Racks
hackercat_room.notes.create!(
  title: "Encrypted_Archives // Root_Directory",
  content: "1. Ghost in the Shell Scripting\n2. Do Androids Dream of Electric Rubies?\n3. 100 Ways to KnocK Objects Off High Ledges (v2.0)",
  hotspot_type: "bookcase"
)

# 3. Quantum Laptop / Hacking Workstation
hackercat_room.notes.create!(
  title: "Kernel_Panic_Log_0x8F.txt",
  content: "Bypassed firewall by aggressively stepping on the keyboard. Mainframe compromised. Reward demanded: 400 cans of premium cyber-tuna.",
  hotspot_type: "laptop"
)

# 4. Spinning Hologram / Neon HUD Grid
hackercat_room.notes.create!(
  title: "Cyberpunk_Mantra.exe",
  content: "'There are 10 types of cats in the world: those who understand binary, and those who intentionally step on the power button.' — Cyber-Meow 2077",
  hotspot_type: "posters"
)

puts "Successfully seeded user, 3 categories, map tiles and 12 hotspot notes!"
