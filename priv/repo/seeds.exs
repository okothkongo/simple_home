# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
alias SimpleHome.Repo
alias SimpleHome.Accounts.User
alias SimpleHome.Accounts.Credential
alias SimpleHome.Accounts.Password
#
import Faker.Commerce
import Faker.Person, only: [first_name: 0, last_name: 0]
import Faker.Internet, only: [email: 0, image_url: 0]

# %User{
#   id: id
# }

user_ids =
  1..100
  |> Enum.map(fn _x ->
    Repo.insert!(
      %User{
        first_name: first_name(),
        last_name: last_name()
      },
      returning: true
    )
  end)
  |> Enum.map(fn %User{id: id} -> id end)

IO.inspect("user successfully created")

user_ids
|> Enum.each(fn user_id ->
  Repo.insert!(%Credential{
    email: email(),
    hashed_password: Password.hash_password("Strong@!23"),
    user_id: user_id
  })
end)

IO.inspect("credentials successfully created")

user_ids
|> Enum.each(fn user_id ->
  Repo.insert!(%SimpleHome.Products.Product{
    name: product_name(),
    price: Enum.random(1..999_999),
    user_id: user_id,
    images: image_url(),
    description: product_name_adjective()
  })
end)

IO.inspect("productes successfully created")
IO.inspect("seeding succeeded")

# #
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
