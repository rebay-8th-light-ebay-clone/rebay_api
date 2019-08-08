# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RebayApi.Repo.insert!(%RebayApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias RebayApi.Repo
alias RebayApi.Listings.Item
alias RebayApi.Accounts.User
alias RebayApi.UserItem.Bid

{:ok, date, _} = DateTime.from_iso8601("2019-08-17T06:59:59.000Z")
date = date |> DateTime.truncate(:second)

user = %User{
  avatar: "image-url.foo",
  email: "travis@foo.fake",
  first_name: "Travis",
  provider: "google",
  uuid: Ecto.UUID.generate(),
}
Repo.insert!(user)

user = Repo.get_by(User, uuid: user.uuid)

item1 = %Item{
  title: "42 inch Large PU Leather Ottoman Bench Storage Chest Footstool White",
  description: "Our storage ottoman bench is the best choice for your home. It can be put not only in front of your bed but also in your living room. This bed bench also features its multi use. It can be used as a bed bench because its lid is thick and soft enough for you to sit. When the lid is opened, the ottoman has large space for you to store anything you like. The lid is also flexible to be opened and close as the metal hinge can be adjusted well. At the same time, it can also prevent the lid from being closed suddenly. Four wood solid feet offers enough support to the whole bench. You can feel safe while sitting on it. Although it is sturdy, it is also easy to be moved. Because of the leather material, it is also convenient for you to keep it tidy

  Features:
  Practical and nice-looking
  Flexible and Strong Lid
  Safe metal hinge
  Easy to Keep Clean and Tidy
  Stable and Steady Construction
  Four solid wood feet
  Enough Storage Space
  Multi Use for working as a bench as well as storage ottoman

  Specifications：
  Main material:white PU leather, PE cloth, non-woven inner cloth, E1 density plate, sponge
  Overall size:43’’(L) x15.75’’ (W)x15.75’’(H)
  Lid size:33.5’’(L) x15.2’’(W) x2.75’’(T)
  Storage space size:32’’(L) x12.75’’(W) x8.5’’(H)
  Wood foot size:2’’ (L) x2’’(W) x3.75’’(H)
  Side panel size:15.2’’(L) x11’’(H) x3.5’’(W)
  Weight Capacity:287lbs
  Package included:
  1xWhite Ottoman Storage Bench
  ",
  end_date: date,
  image: "https://d3o372dlsg9lxo.cloudfront.net/catalog/products/d1525/images/enlarge/595fccf0bbddbd3afbd7d8f0/D1525_170511_106_D1525.jpg",
  price: 7500,
  category: "Home & Garden",
  uuid: Ecto.UUID.generate(),
  user_id: user.id
}

Repo.insert!(item1)
item1 = Repo.get_by(Item, uuid: item1.uuid)

item2 = %Item{
  title: "Sony DualShock 4 Wireless Controller - Jet Black",
  description: "Sony DualShock 4 Wireless Controller The DualShock 4 Wireless Controller for PlayStation 4 defines the next generation of play, combining revolutionary new features with intuitive, precision controls. Improved analog sticks and trigger buttons allow for unparalleled accuracy with every move while innovative new technologies such as the multi-touch, clickable touch pad, integrated light bar, and internal speaker offer exciting new ways to experience and interact with your games. And with the addition of the Share button, celebrate and upload your greatest gaming moments on PlayStation 4 with the touch of a button. Precision Control: The feel, shape, and sensitivity of the DualShock 4's analog sticks and trigger buttons have been enhanced to offer players absolute control for all games on PlayStation 4. Sharing at your Fingertips: The addition of the Share button makes sharing your greatest gaming moments as easy as a push of a button. Upload gameplay videos and screenshots directly from your system or live-stream your gameplay, all without disturbing the game in progress. New ways to Play: Revolutionary features like the touch pad, integrated light bar, and built-in speaker offer exciting new ways to experience and interact with your games and its 3.5mm audio jack offers a practical personal audio solution for gamers who want to listen to their games in private. Charge Efficiently: The DualShock 4 Wireless Controller can be easily be recharged by plugging it into your PlayStation 4 system, even when on standby, or with any standard charger with a micro-USB port.
  ",
  end_date: date,
  image: "https://i.ebayimg.com/images/g/ma8AAOSw4ZVcUzaV/s-l300.jpg",
  price: 4000,
  category: "Electronics",
  uuid: Ecto.UUID.generate(),
  user_id: user.id
}

Repo.insert!(item2)
item2 = Repo.get_by(Item, uuid: item2.uuid)

item3 = %Item{
  title: "adidas EQT Support ADV Primeknit Shoes Men's",
  description: "The Equipment series launched in the '90s with a technical, minimal design. These men's shoes capture the original spirit with a sleek, sock-like knit upper with a bold two-tone look. The shoes feature signature EQT details, including textile 3-Stripes that merge with molded 3-Stripes on the midsole.
  ",
  end_date: date,
  image: "https://i.ebayimg.com/images/g/zdEAAOSwAetdLkzO/s-l1600.jpg",
  price: 6000,
  category: "Fashion",
  uuid: Ecto.UUID.generate(),
  user_id: user.id,
}
Repo.insert!(item3)
item3 = Repo.get_by(Item, uuid: item3.uuid)


bid_1_for_item_1 = %Bid{
  bid_price: 1000,
  item_id: item1.id,
  user_id: user.id,
  uuid: Ecto.UUID.generate(),
  timestamp: date
}
Repo.insert!(bid_1_for_item_1)
bid_1_for_item_1 = Repo.get_by(Bid, uuid: bid_1_for_item_1.uuid)


bid_2_for_item_1 = %Bid{
  bid_price: 1500,
  item_id: item1.id,
  user_id: user.id,
  uuid: Ecto.UUID.generate(),
  timestamp: date
}
Repo.insert!(bid_2_for_item_1)
bid_2_for_item_1 = Repo.get_by(Bid, uuid: bid_2_for_item_1.uuid)


bid_1_for_item_2 = %Bid{
  bid_price: 1560,
  item_id: item2.id,
  user_id: user.id,
  uuid: Ecto.UUID.generate(),
  timestamp: date
}
Repo.insert!(bid_1_for_item_2)
bid_1_for_item_2 = Repo.get_by(Bid, uuid: bid_1_for_item_2.uuid)


bid_2_for_item_2 = %Bid{
  bid_price: 2675,
  item_id: item2.id,
  user_id: user.id,
  uuid: Ecto.UUID.generate(),
  timestamp: date
}
Repo.insert!(bid_2_for_item_2)
bid_2_for_item_2 = Repo.get_by(Bid, uuid: bid_2_for_item_2.uuid)

bid_3_for_item_2 = %Bid{
  bid_price: 3560,
  item_id: item2.id,
  user_id: user.id,
  uuid: Ecto.UUID.generate(),
  timestamp: date
}
Repo.insert!(bid_3_for_item_2)
bid_3_for_item_2 = Repo.get_by(Bid, uuid: bid_3_for_item_2.uuid)

user2 = %User{
  avatar: "image-url.foo",
  email: "travis@foo.fake",
  first_name: "Travis",
  provider: "google",
  uuid: Ecto.UUID.generate(),
}
Repo.insert!(user2)

user2 = Repo.get_by(User, uuid: user2.uuid)


{:ok, date, _} = DateTime.from_iso8601("2019-08-05T15:30:59.000Z")
past_date = date |> DateTime.truncate(:second)

item4 = %Item{
  title: "Raleigh 2018 Alysa 1 Urban Fitness Bike Orange",
  description: "If you love the idea of a lightweight, nimble road bike but prefer the sturdy, stable handling and upright position of a mountain bike, the Alysa 1 is for you. This step-thru, flat bar women’s fitness bike is made to put in miles along the bike path, ride through the city on your way to work, and go everywhere in between. The 700c wheels keep the ride quick and efficient while flat handlebars and sporty geometry make it stable and comfortable.

  The women’s specific frame is lightweight and durable with special geometry designed for your comfort. Plus the step thru design makes for easy on an off (and accepts bike clothes of the skirted variety). This all around fitness bike offers fast and smooth 35c tires that are wide enough to provide traction for an enjoyable path ride, organized ride, or your commute. With 21 speeds, rack and fender mounts, and strong double wall wheels you’ll always be equipped for your next two-wheel adventure.",
  end_date: past_date,
  image: "https://i.ebayimg.com/images/g/WfMAAOSwSVNcAZZE/s-l1600.jpg",
  price: 30000,
  category: "Sporting Goods",
  uuid: Ecto.UUID.generate(),
  user_id: user2.id,
}
Repo.insert!(item4)
_item4 = Repo.get_by(Item, uuid: item4.uuid)


item5 = %Item{
  title: "Zinus 8 Inch Spring Mattress with Quilted Cover, Twin",
  description: "Enjoy a restful night’s sleep with the Zinus 8 Inch Tight Top Spring Mattress. Made with exclusive iCoil springs for reduced motion transfer and uninterrupted sleep, this design also features a 1” top layer of comfort foam and microfiber quilting for added softness. Compressed and rolled into one box for easy shipping and unpacking, the 8 Inch Spring Mattress with Quilted Cover is made to be as convenient as it is comfortable.",
  end_date: past_date,
  image: "https://i.ebayimg.com/images/g/QxEAAOSwRLRdG9Tj/s-l1600.jpg",
  price: 8900,
  category: "Home & Garden",
  uuid: Ecto.UUID.generate(),
  user_id: user2.id,
}
Repo.insert!(item5)
_item5 = Repo.get_by(Item, uuid: item5.uuid)
