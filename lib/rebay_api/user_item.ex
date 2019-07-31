defmodule RebayApi.UserItem do
  @moduledoc """
  The UserItem context.
  """

  import Ecto.Query, warn: false
  alias RebayApi.Repo

  alias RebayApi.UserItem.Bid
  alias RebayApi.Listings
  alias RebayApi.Accounts

  @doc """
  Returns the list of bids.

  ## Examples

      iex> list_bids()
      [%Bid{}, ...]

  """
  def list_bids do
    Repo.all(Bid)
  end

  def list_bids_by_item(item_uuid) do
    bidItem = Listings.get_item!(item_uuid)
    query = from bid in Bid, where: ^bidItem.uuid == ^item_uuid
    Repo.all(query, preload: [:item])
  end

  def list_bids_by_user(user_uuid) do
    bidUser = Accounts.get_user!(user_uuid)
    query = from bid in Bid, where: ^bidUser.uuid == ^user_uuid, select: bid.item_id, distinct: bid.item_id
    user_item_ids = Repo.all(query, preload: [:user, :item])

    Enum.reduce user_item_ids, [], fn (item_id, acc) ->
      bid_query = from bid in Bid, where: ^bidUser.uuid == ^user_uuid and ^item_id == bid.item_id, select: bid

      item_bid = %{}
      |> Map.put(:item, Listings.get_item_by_id!(item_id))
      |> Map.put(:bids, Repo.all(bid_query, preload: [:user, :item]))

      acc ++ [item_bid]
    end
  end

  @doc """
  Gets a single bid.

  Raises `Ecto.NoResultsError` if the Bid does not exist.

  ## Examples

      iex> get_bid!(123)
      %Bid{}

      iex> get_bid!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bid!(uuid), do: Repo.get_by!(Bid, uuid: uuid)

  @doc """
  Creates a bid.

  ## Examples

      iex> create_bid(%{field: value})
      {:ok, %Bid{}}

      iex> create_bid(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bid(attrs \\ %{}) do
    %Bid{}
    |> Bid.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bid.

  ## Examples

      iex> update_bid(bid, %{field: new_value})
      {:ok, %Bid{}}

      iex> update_bid(bid, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bid(%Bid{} = bid, attrs) do
    bid
    |> Bid.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Bid.

  ## Examples

      iex> delete_bid(bid)
      {:ok, %Bid{}}

      iex> delete_bid(bid)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bid(%Bid{} = bid) do
    Repo.delete(bid)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bid changes.

  ## Examples

      iex> change_bid(bid)
      %Ecto.Changeset{source: %Bid{}}

  """
  def change_bid(%Bid{} = bid) do
    Bid.changeset(bid, %{})
  end
end