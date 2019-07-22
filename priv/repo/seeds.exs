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

date = DateTime.utc_now() |> DateTime.truncate(:second)

Repo.insert!(
  %Item{
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
    category: "Home & Garden"
})

Repo.insert!(
  %Item{
    title: "Sony DualShock 4 Wireless Controller - Jet Black",
    description: "Sony DualShock 4 Wireless Controller The DualShock 4 Wireless Controller for PlayStation 4 defines the next generation of play, combining revolutionary new features with intuitive, precision controls. Improved analog sticks and trigger buttons allow for unparalleled accuracy with every move while innovative new technologies such as the multi-touch, clickable touch pad, integrated light bar, and internal speaker offer exciting new ways to experience and interact with your games. And with the addition of the Share button, celebrate and upload your greatest gaming moments on PlayStation 4 with the touch of a button. Precision Control: The feel, shape, and sensitivity of the DualShock 4's analog sticks and trigger buttons have been enhanced to offer players absolute control for all games on PlayStation 4. Sharing at your Fingertips: The addition of the Share button makes sharing your greatest gaming moments as easy as a push of a button. Upload gameplay videos and screenshots directly from your system or live-stream your gameplay, all without disturbing the game in progress. New ways to Play: Revolutionary features like the touch pad, integrated light bar, and built-in speaker offer exciting new ways to experience and interact with your games and its 3.5mm audio jack offers a practical personal audio solution for gamers who want to listen to their games in private. Charge Efficiently: The DualShock 4 Wireless Controller can be easily be recharged by plugging it into your PlayStation 4 system, even when on standby, or with any standard charger with a micro-USB port.
    ",
    end_date: date,
    image: "https://i.ebayimg.com/images/g/ma8AAOSw4ZVcUzaV/s-l300.jpg",
    price: 4000,
    category: "Electronics"
})

Repo.insert!(
  %Item{
    title: "adidas EQT Support ADV Primeknit Shoes Men's",
    description: "The Equipment series launched in the '90s with a technical, minimal design. These men's shoes capture the original spirit with a sleek, sock-like knit upper with a bold two-tone look. The shoes feature signature EQT details, including textile 3-Stripes that merge with molded 3-Stripes on the midsole.
    ",
    end_date: date,
    image: "https://i.ebayimg.com/images/g/zdEAAOSwAetdLkzO/s-l1600.jpg",
    price: 6000,
    category: "Fashion"
})

Repo.insert!(
  %User{
    avatar: "image-url.foo",
    email: "travis@foo.fake",
    first_name: "Travis",
    provider: "google",
    uuid: Ecto.UUID.generate(),
  }
)
