# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Todo.Repo.insert!(%Todo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Todo.Repo
alias Todo.Tasks.List
alias Todo.Tasks.List.Item

lists = [
  %List{
    title: "Work",
    archived: false,
    items: [
      %Item{content: "Call the boss", completed: false},
      %Item{content: "Call colleagues", completed: true},
      %Item{content: "Play foosball", completed: true},
      %Item{content: "Finish the immediate task", completed: false}
    ]
  },
  %List{
    title: "Home",
    archived: false,
    items: [
      %Item{content: "Clean up", completed: false},
      %Item{content: "Buy milk", completed: false},
      %Item{content: "Watch Netfilx", completed: true},
      %Item{content: "Play PS", completed: true},
      %Item{content: "Water the cactus", completed: false}
    ]
  },
  %List{
    title: "Friends",
    archived: false,
    items: [
      %Item{content: "Go to DisneyLand", completed: false},
      %Item{content: "Buy birthday present", completed: true}
    ]
  },
  %List{
    title: "Holidays",
    archived: true,
    items: [
      %Item{content: "Plan the trip to Africa", completed: false},
      %Item{content: "Find flight tickets", completed: true},
      %Item{content: "Book the hotel", completed: false}
    ]
  }
]

Enum.each(lists, &Repo.insert/1)
